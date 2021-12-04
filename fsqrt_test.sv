module test;
    logic [31:0] x;
    logic clk;
    logic [31:0] y;
    fsqrt uut(.clk(clk),.x(x),.y(y));
    logic [23:0] a;
    logic [23:0] b;
    logic [23:0] x_2;
    logic [23:0] a_x;
    assign a=uut.a;
    assign b=uut.b;
    assign x_2=uut.x_2;
    assign a_x=uut.a_x;
    initial begin
      $dumpfile("uut.vcd");
      $dumpvars(0,clk,x,y,a,b,x_2,a_x);
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
      #10;
      x=32'h40800000;
   end

endmodule