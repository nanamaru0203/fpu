module fmul(input logic clk,
            input logic [31:0] x1,
           input logic [31:0] x2,
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
   logic zero1;
   logic zero2;
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
   assign y=(e3==8'd0 | zero2==1'b1)? 32'd0 : {s3_2,e3,m3};
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
      zero1<=(e1==8'd0 | e2==8'd0)? 1'b1 : 1'b0;
      //stage2
      sum<=hh+(hl>>11)+(lh>>11)+26'd2;
      e3b<=e3a+9'b1;
      e3a_2<=e3a;
      s3_2<=s3;
      zero2<=zero1;
    end
endmodule






