module test;
    logic [31:0] x;
    logic clk;
    logic [31:0] y;
    logic [23:0] a;
    logic [48:0] m2;
    logic [48:0] m3;
    fsqrt uut(.clk(clk),.x(x),.y(y));
    assign a=uut.a;
    assign m2=uut.m2;
    assign m3=uut.m3;

    initial begin
      $dumpfile("uut.vcd");
      $dumpvars(0,clk,x,y,a,m2,m3);
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
      //3
      x=32'b01000000010000000000000000000000;
      #10;
      x=32'd0;
      #10;
      //255
      x=32'h437f0000;
      #10;
      //2
      x=32'h40000000;
   end

endmodule