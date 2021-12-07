module test;
    logic [31:0] x;
    logic clk;
    logic [31:0] y;
    itof uut(.clk(clk),.x(x),.y(y));

    initial begin
      $dumpfile("uut.vcd");
      $dumpvars(0,clk,x,y);
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
      //2
      x=32'd2;
      #10;
      //0
      x=32'd0;
      #10;
      //255
      x=32'd255;
      #10;
      //-1
      x=32'hffffffff;
      //1234567
      #10;
      x=32'd1234567890;
      #10;
      x=32'b00000110010100111001101100010100;
   end

endmodule
    