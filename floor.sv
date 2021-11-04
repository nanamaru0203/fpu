module floor(input logic clk,
            input logic [31:0] x,
            output logic [31:0] y);
    logic s2;
    logic s3;
    logic [7:0] e1;
    logic [7:0] e2;
    logic [7:0] e3;
    logic [22:0] m1;
    logic [23:0] m2;
    logic [24:0] m3;
    //繰り上げ
    logic [23:0] over;
    logic [31:0] tmp;
    assign e1=x[30:23];
    assign m1=x[22:0];
    assign m3=m2+over;
    assign s3=(e2<8'd126)? 1'b0 : s2;
    assign e3=(e2<8'd126)? 8'd0 : (m3[24]==1'b1)? e2+1 : e2;
    assign tmp=(m3[24]==1'b1)? {s3,e3,m3[23:1]} : {s3,e3,m3[22:0]};
    always@(posedge clk) begin
        //stage1
        s2<=x[31];
        e2<=e1;
        if(e1==8'd127) begin
            m2<={1'b1,m1&23'b00000000000000000000000};
            over<=(m1[22]<<23);
        end else if(e1==8'd128) begin
            m2<={1'b1,m1&23'b10000000000000000000000};
            over<=(m1[21]<<22);
        end else if(e1==8'd129) begin
            m2<={1'b1,m1&23'b11000000000000000000000};
            over<=(m1[20]<<21);
        end else if(e1==8'd130) begin
            m2<={1'b1,m1&23'b11100000000000000000000};
            over<=(m1[19]<<20);
        end else if(e1==8'd131) begin
            m2<={1'b1,m1&23'b11110000000000000000000};
            over<=(m1[18]<<19);
        end else if(e1==8'd132) begin
            m2<={1'b1,m1&23'b11111000000000000000000};
            over<=(m1[17]<<18);
        end else if(e1==8'd133) begin
            m2<={1'b1,m1&23'b11111100000000000000000};
            over<=(m1[16]<<17);
        end else if(e1==8'd134) begin
            m2<={1'b1,m1&23'b11111110000000000000000};
            over<=(m1[15]<<16);
        end else if(e1==8'd135) begin
            m2<={1'b1,m1&23'b11111111000000000000000};
            over<=(m1[14]<<15);
        end else if(e1==8'd136) begin
            m2<={1'b1,m1&23'b11111111100000000000000};
            over<=(m1[13]<<14);
        end else if(e1==8'd137) begin
            m2<={1'b1,m1&23'b11111111110000000000000};
            over<=(m1[12]<<13);
        end else if(e1==8'd138) begin
            m2<={1'b1,m1&23'b11111111111000000000000};
            over<=(m1[11]<<12);
        end else if(e1==8'd139) begin
            m2<={1'b1,m1&23'b11111111111100000000000};
            over<=(m1[10]<<11);
        end else if(e1==8'd140) begin
            m2<={1'b1,m1&23'b11111111111110000000000};
            over<=(m1[9]<<10);
        end else if(e1==8'd141) begin
            m2<={1'b1,m1&23'b11111111111111000000000};
            over<=(m1[8]<<9);
        end else if(e1==8'd142) begin
            m2<={1'b1,m1&23'b11111111111111100000000};
            over<=(m1[7]<<8);
        end else if(e1==8'd143) begin
            m2<={1'b1,m1&23'b11111111111111110000000};
            over<=(m1[6]<<7);
        end else if(e1==8'd144) begin
            m2<={1'b1,m1&23'b11111111111111111000000};
            over<=(m1[5]<<6);
        end else if(e1==8'd145) begin
            m2<={1'b1,m1&23'b11111111111111111100000};
            over<=(m1[4]<<5);
        end else if(e1==8'd146) begin
            m2<={1'b1,m1&23'b11111111111111111110000};
            over<=(m1[3]<<4);
        end else if(e1==8'd147) begin
            m2<={1'b1,m1&23'b11111111111111111111000};
            over<=(m1[2]<<3);
        end else if(e1==8'd148) begin
            m2<={1'b1,m1&23'b11111111111111111111100};
            over<=(m1[1]<<2);
        end else if(e1==8'd149) begin
            m2<={1'b1,m1&23'b11111111111111111111110};
            over<=(m1[0]<<1);
        end else if(e1>8'd149) begin
            m2<={1'b1,m1};
            over<=24'd0;
        end else if(e1==8'd126) begin
            m2<={1'b1,m1&23'd0};
            over<=24'b100000000000000000000000;
        end else begin
            m2<=24'd0;
            over<=24'd0;
        end
        //stage2
        y<=tmp;
    end
endmodule

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
      x=32'd0;
      #10;
      //255
      x=32'h437f0000;
      #10;
      //-12.5
      x=32'hC1480000;
   end

endmodule