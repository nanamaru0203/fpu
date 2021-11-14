module ftoi(input logic clk,
            input logic [31:0] x,
            output logic [31:0] y);
    logic s1;
    logic s2;
    assign s1=x[31];
    logic [7:0] e1;
    assign e1=x[30:23];
    logic [31:0] m1;
    logic [31:0] y1;
    assign m1={9'd1,x[22:0]};
    always@(posedge clk) begin
        //stage1
        s2<=s1;
        if(e1>=8'd150 & e1<=8'd158) begin
            y1<=(m1<<(e1-8'd150));
        end else if(e1==8'd149) begin
            y1<=(m1[0])? ((m1>>1)+32'd1) : (m1>>1);
        end else if(e1==8'd148) begin
            y1<=(m1[1])? ((m1>>2)+32'd1) : (m1>>2);
        end else if(e1==8'd147) begin
            y1<=(m1[2])? ((m1>>3)+32'd1) : (m1>>3);
        end else if(e1==8'd146) begin
            y1<=(m1[3])? ((m1>>4)+32'd1) : (m1>>4);
        end else if(e1==8'd145) begin
            y1<=(m1[4])? ((m1>>5)+32'd1) : (m1>>5);
        end else if(e1==8'd144) begin
            y1<=(m1[5])? ((m1>>6)+32'd1) : (m1>>6);
        end else if(e1==8'd143) begin
            y1<=(m1[6])? ((m1>>7)+32'd1) : (m1>>7);
        end else if(e1==8'd142) begin
            y1<=(m1[7])? ((m1>>8)+32'd1) : (m1>>8);
        end else if(e1==8'd141) begin
            y1<=(m1[8])? ((m1>>9)+32'd1) : (m1>>9);
        end else if(e1==8'd140) begin
            y1<=(m1[9])? ((m1>>10)+32'd1) : (m1>>10);
        end else if(e1==8'd139) begin
            y1<=(m1[10])? ((m1>>11)+32'd1) : (m1>>11);
        end else if(e1==8'd138) begin
            y1<=(m1[11])? ((m1>>12)+32'd1) : (m1>>12);
        end else if(e1==8'd137) begin
            y1<=(m1[12])? ((m1>>13)+32'd1) : (m1>>13);
        end else if(e1==8'd136) begin
            y1<=(m1[13])? ((m1>>14)+32'd1) : (m1>>14);
        end else if(e1==8'd135) begin
            y1<=(m1[14])? ((m1>>15)+32'd1) : (m1>>15);
        end else if(e1==8'd134) begin
            y1<=(m1[15])? ((m1>>16)+32'd1) : (m1>>16);
        end else if(e1==8'd133) begin
            y1<=(m1[16])? ((m1>>17)+32'd1) : (m1>>17);
        end else if(e1==8'd132) begin
            y1<=(m1[17])? ((m1>>18)+32'd1) : (m1>>18);
        end else if(e1==8'd131) begin
            y1<=(m1[18])? ((m1>>19)+32'd1) : (m1>>19);
        end else if(e1==8'd130) begin
            y1<=(m1[19])? ((m1>>20)+32'd1) : (m1>>20);
        end else if(e1==8'd129) begin
            y1<=(m1[20])? ((m1>>21)+32'd1) : (m1>>21);
        end else if(e1==8'd128) begin
            y1<=(m1[21])? ((m1>>22)+32'd1) : (m1>>22);
        end else if(e1==8'd127) begin
            y1<=(m1[22])? ((m1>>23)+32'd1) : (m1>>23);
        end else if(e1==8'd126) begin
            y1<=32'd1;
        end else begin
            y1<=32'd0;
        end
        //stage2
        y<=(s2)? (~y1+32'd1) : y1;
    end
endmodule

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