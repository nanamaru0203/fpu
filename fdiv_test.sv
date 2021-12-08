module test;
    logic [31:0] x1;
    logic [31:0] x2;
    logic clk;
    wire [31:0] y;
    fdiv uut(.clk(clk),.x1(x1),.x2(x2),.y(y));
    logic [31:0] inv_x2;
    assign inv_x2=uut.inv_x2;
    initial begin
      $dumpfile("uut.vcd");
      $dumpvars(0,clk,x1,x2,y,inv_x2);
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
      #10;
      x1=32'b00001101111011000000000010111110;
      x2=32'b01111110101111100110111111110001;
      //1/2
      #10;
      x1=32'hbf94a370;
      x2=32'hfef91673;
   end

endmodule