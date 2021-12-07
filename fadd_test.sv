module test;
    logic [31:0] x1;
    logic [31:0] x2;
    logic clk;
    logic [31:0] y;
    logic big;
    assign big=uut.big;
    fadd uut(.clk(clk),.x1(x1),.x2(x2),.y(y));

    initial begin
      $dumpfile("uut.vcd");
      $dumpvars(0,clk,x1,x2,y,big);
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
      //3+(-3)
      x1=32'b01000000010000000000000000000000;
      x2=32'b11000000010000000000000000000000;
      #10;
      //0+0
      x1=32'd0;
      x2=32'd0;
      #10;
      //3+(-255)
      x1=32'b01000000010000000000000000000000;
      x2=32'hc37f0000;
      #10;
      //3.14+2
      x1=32'h4048f5c3;
      x2=32'h40000000;
      #10;
      //1+1.1
      x1=32'h3f800000;
      x2=32'h3f8ccccd;
      //2.5*2
      #10;
      x1=32'h40200000;
      x2=32'h40000000;
      #10;
      //-12345.678+32.4
      x1=32'hc640e6b6;
      x2=32'h4201999a;
      #10;
      //1.313200119e-05+8.651562659e+19
      x1=32'h375c5184;
      x2=32'h609614a8;
      //test2
      #10;
      x1=32'b10000010010010000100100100000001;
      x2=32'b10110010000101001011000110111100;
      #10;
      x1=32'h818bc4f5;
      x2=32'h01966e5f;

   end

endmodule