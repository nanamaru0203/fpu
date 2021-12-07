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
      #10;
      //3.14*2
      x1=32'h4048f5c3;
      x2=32'h40000000;
      #10;
      //1*1.1
      x1=32'h3f800000;
      x2=32'h3f8ccccd;
      //2.5*2
      #10;
      x1=32'h40200000;
      x2=32'h40000000;
      #10;
      x1=32'h42c80000;
      x2=32'h00000000;
      
   end

endmodule