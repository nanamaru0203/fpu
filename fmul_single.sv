module fmul(input wire [31:0] x1,
           input wire [31:0] x2,
            input wire clk,
            output wire [31:0] y
    );
   wire s1;
   wire [7:0] e1;
   wire  [22:0] m1;
   wire s2;
   wire [7:0] e2;
   wire [22:0] m2;
   assign {s1,e1,m1}=x1;
   assign {s2,e2,m2}=x2;
   wire [8:0] e1a;
   wire [8:0] e2a;
   assign e1a={1'b0,e1};
   assign e2a={1'b0,e2};
   wire s3;
   wire [8:0] e3a;
   wire [12:0] m1h;
   wire [10:0] m1l;
   wire [12:0] m2h;
   wire [10:0] m2l;
   assign m1h={1'b1,m1[22:11]};
   assign m1l=m1[10:0];
   assign m2h={1'b1,m2[22:11]};
   assign m2l=m2[10:0];
   wire [25:0] hh;
   wire [23:0] hl;
   wire [23:0] lh;
   wire [25:0] sum;
   wire [8:0] e3b;
   wire [7:0] e3;
   assign e3=(~e3a[8])? 8'd0 : ((sum[25])? e3b[7:0] : e3a[7:0]);
   wire [22:0] m3;
   assign m3=(sum[25])? sum[24:2] : sum[23:1];
   wire [31:0] tmp;
   assign tmp=(e3==8'd0)? 31'd0 : {s3,e3,m3};

   assign hh=m1h*m2h;
   assign hl=m1h*m2l;
   assign lh=m1l*m2h;
   //指数 
   assign e3a=e1a+e2a+9'd129;
    //符号
    assign s3=s1^s2;
    //stage2
    assign sum=hh+(hl>>11)+(lh>>11)+26'd2;
    assign e3b=e3a+9'b1;
    //stage3
    assign y=tmp;
    
endmodule

module test;
    logic [31:0] x1;
    logic [31:0] x2;
    logic clk;
    wire [31:0] y;
    fmul uut(.x1(x1),.x2(x2),.clk(clk),.y(y));

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
      #200;
      //3*3
      x1=32'b01000000010000000000000000000000;
      x2=32'b01000000010000000000000000000000;
      #10;
      x1=32'd0;
      x2=32'd0;
      #10;
      //255*(-255)
      x1=32'h437f0000;
      x2=32'hc37f0000;
   end

endmodule





