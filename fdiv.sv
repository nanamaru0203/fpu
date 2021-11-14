module ram(input logic clk,
           input logic load,
           input logic [9:0] addr,
           input logic [23:0] in_a,
           input logic [23:0] in_b,
           output logic [23:0] a,
           output logic [23:0] b);
    logic [23:0] mem_a [1023:0];
    logic [23:0] mem_b [1023:0];
    always@(posedge clk) begin
        if(load) begin
            mem_a[addr]<=in_a;
            mem_b[addr]<=in_b;
        end
        a<=mem_a[addr];
        b<=mem_b[addr];
    end

    integer i;
    initial begin
        for(i=0;i<1024;i=i+1) begin
            longint x0;
            longint x1;
            x0=(((1<<46)/((1024+i)*4096))+((1<<46)/((1025+i)*4096)))/2;
            x1=x0*x0;
            mem_a[i]=(x1>>24);
            mem_b[i]=x0;
        end
    end
endmodule

module finv(input logic clk,
            input logic [31:0] x,
            output logic [31:0] y);
    logic [9:0] addr;
    logic [7:0] e1;
    logic [7:0] e2;
    logic [7:0] e3;
    logic s1;
    logic s2;
    logic s3;
    assign e1=x[30:23];
    assign s1=x[31];
    //stage1
    //RAMに渡すアドレス
    assign  addr=x[22:13];
    logic [23:0] a;
    logic [23:0] b;
    logic [48:0] b2;
    ram ram(.clk(clk),.load(1'b0),.addr(addr),.in_a(24'd0),.in_b(24'd0),.a(a),.b(b));
    logic [24:0] m1;
    logic [48:0] m2;
    logic [48:0] m3;
    logic [48:0] m4;
    assign m4=m2>>23;
    assign m3=b2-m4;
    logic [31:0] tmp;
    assign tmp={s3,e3,m3[22:0]};
    always@(posedge clk) begin
        ///stage1
        e2<=e1;
        s2<=s1;
        m1<={2'b01,x[22:0]};
        //stage2
        e3<=(e2>253)? 8'd0 : 253-e2;
        s3<=s2;
        m2<=m1*a;
        b2<=(b<<1);
        //stage3
        y<=tmp;
    end
endmodule

module fmul(input logic [31:0] x1,
           input logic [31:0] x2,
            input logic clk,
            output logic [31:0] y
    );
   logic s1;
   logic [7:0] e1;
   logic [22:0] m1;
   logic s2;
   logic [7:0] e2;
   logic [22:0] m2;
   assign {s1,e1,m1}=x1;
   assign {s2,e2,m2}=x2;
   logic [8:0] e1a;
   logic [8:0] e2a;
   assign e1a={1'b0,e1};
   assign e2a={1'b0,e2};
   logic s3;
   logic s3_2;
   logic [8:0] e3a;
   logic [8:0] e3a_2;
   logic [12:0] m1h;
   logic [10:0] m1l;
   logic [12:0] m2h;
   logic [10:0] m2l;
   assign m1h={1'b1,m1[22:11]};
   assign m1l=m1[10:0];
   assign m2h={1'b1,m2[22:11]};
   assign m2l=m2[10:0];
   logic [25:0] hh;
   logic [23:0] hl;
   logic [23:0] lh;
   logic [25:0] sum;
   logic [8:0] e3b;
   logic [7:0] e3;
   assign e3=(~e3a_2[8])? 8'd0 : ((sum[25])? e3b[7:0] : e3a_2[7:0]);
   logic [22:0] m3;
   assign m3=(sum[25])? sum[24:2] : sum[23:1];
   logic [31:0] tmp;
   assign tmp=(e3==8'd0)? 32'd0 : {s3_2,e3,m3};
   always@(posedge clk) begin
      //stage1
      //仮数
      hh<=m1h*m2h;
      hl<=m1h*m2l;
      lh<=m1l*m2h;
      //指数
      e3a<=e1a+e2a+9'd129;
      //符号
      s3<=s1^s2;
      //stage2
      sum<=hh+(hl>>11)+(lh>>11)+26'd2;
      e3b<=e3a+9'b1;
      e3a_2<=e3a;
      s3_2<=s3;
      //stage3
      y<=tmp;
    end
endmodule

module fdiv(input logic clk,
            input logic [31:0] x1,
            input logic [31:0] x2,
            output logic [31:0] y);
    //y=x1/x2
    logic [7:0] e_diff1;
    assign e_diff1=(x2[30:23]>=253)? 8'd4 : 8'd0;
    logic [31:0] modified_x2;
    assign modified_x2={x2[31],x2[30:23]-e_diff1,x2[22:0]};
    logic [31:0] inv_x2;
    logic [31:0] tmp;
    finv uut1(.clk(clk),.x(modified_x2),.y(inv_x2));
    fmul uut2(.x1(x1_4),.x2(inv_x2),.clk(clk),.y(tmp));
    logic [7:0] e_diff2;
    logic [7:0] e_diff3;
    logic [7:0] e_diff4;
    logic [7:0] e_diff5;
    logic [7:0] e_diff6;
    logic [7:0] e_diff7;
    logic [31:0] x1_2;
    logic [31:0] x1_3;
    logic [31:0] x1_4;
    always@(posedge clk) begin
        //stage1
        e_diff2<=e_diff1;
        x1_2<=x1;
        //stage2
        e_diff3<=e_diff2;
        x1_3<=x1_2;
        //stage3 ここまでfinv
        e_diff4<=e_diff3;
        x1_4<=x1_3;
        //stage4
        e_diff5<=e_diff4;
        //stage5
        e_diff6<=e_diff5;
        //stage6
        e_diff7<=e_diff6;
        //stage7
        y<={tmp[31],tmp[30:23]-e_diff7,tmp[22:0]};
    end
endmodule

module test;
    logic [31:0] x1;
    logic [31:0] x2;
    logic clk;
    wire [31:0] y;
    fdiv uut(.clk(clk),.x1(x1),.x2(x2),.y(y));

    initial begin
      $dumpfile("uut.vcd");
      $dumpvars(0,clk,x1,x2,y);
    end

    initial begin
      clk=0;
      forever begin
	 #5 clk= !clk;
      end
    end

    initial begin
     #300;
      $finish;
   end

   initial begin
      #100;
      //3/2
      x1=32'b01000000010000000000000000000000;
      x2=32'h40000000;
      #10;
      x1=32'd0;
      x2=32'd0;
      #10;
      //255/(-255)
      x1=32'h437f0000;
      x2=32'hc37f0000;
      #10;
      //3.14/2
      x1=32'h4048f5c3;
      x2=32'h40000000;
      #10;
      //1/1.1
      x1=32'h3f800000;
      x2=32'h3f8ccccd;
      //2.5/2
      #10;
      x1=32'h40200000;
      x2=32'h40000000;
      #10;
      //1.1*2^127/ 1.2*2^126 =1.83333333333
      x1=32'h7f0ccccd;
      x2=32'h7e99999a;
   end

endmodule

