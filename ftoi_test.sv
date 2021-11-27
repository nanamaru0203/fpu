module test;
    logic [31:0] x;
    logic [31:0] y;
    logic clk;
    ftoi uut(.clk(clk),.x(x),.y(y));

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
      #100;
      //3
      x=32'b01000000010000000000000000000000;
      #10;
      //0
      x=32'd0;
      #10;
      //-3.14
      x=32'hc048f5c3;
      //2.5
      #10;
      x=32'h40200000;
      //1000000001.5
      #10;
      x=32'h4e6e6b28;
      //0.01
      #10;
      x=32'h3c23d70a;
   end
endmodule