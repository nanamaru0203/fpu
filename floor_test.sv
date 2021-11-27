module test;
    logic [31:0] x;
    logic clk;
    logic [31:0] y;
    floor uut(.clk(clk),.x(x),.y(y));

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
      //3
      x=32'b01000000010000000000000000000000;
      #10;
      //-0.1
      x=32'hbdcccccd;
      #10;
      //0.1
      x=32'h3dcccccd;
      #10;
      //-12.5
      x=32'hc1480000;
      //-3
      #10;
      x=32'hc0400000;
      //-123.4
      #10;
      x=32'hc2f6cccd;
      #10;
      x=32'b10111001100111101010110000110000;

   end

endmodule