module floor(input logic clk,
            input logic [31:0] x,
            output logic [31:0] y);
    logic s2;
    logic s3;
    logic [7:0] e1;
    logic [7:0] e2;
    //logic [7:0] e3;
    logic [22:0] m1;
    logic [23:0] m2;
    logic [24:0] m3;
    //四捨五入と勘違いしていて繰り上げに用いていたoverを負の数の際に絶対値を1大きくするのに用いればうまくいきそうということでそうします
    logic [23:0] over;
    //新しく追加した変数
    logic all_zero;
    logic [31:0] tmp;
    assign e1=x[30:23];
    assign m1=x[22:0];
    assign m3=(all_zero)? m2 : m2+over;
    assign s3=(e2<8'd126)? 1'b0 : s2;
    //assign e3=(e2<8'd126)? 8'd0 : (m3[24]==1'b1)? e2+1 : e2;
    //assign e3=(e2<8'd126)? 8'd0 : 
    assign tmp=(e2<=8'd126)? ((s2==1'b0)? 32'd0 : 32'hbf800000) : ((m3[24]==1'b1)? {s3,e2+8'd1,m3[23:1]} : {s3,e2,m3[22:0]});
    always@(posedge clk) begin
        //stage1
        s2<=x[31];
        e2<=e1;
        if(e1==8'd127) begin
            m2<={1'b1,m1&23'b00000000000000000000000};
            over<=(x[31]<<23);
            all_zero<=~|m1[22:0];
        end else if(e1==8'd128) begin
            m2<={1'b1,m1&23'b10000000000000000000000};
            over<=(x[31]<<22);
            all_zero<=~|m1[21:0];
        end else if(e1==8'd129) begin
            m2<={1'b1,m1&23'b11000000000000000000000};
            over<=(x[31]<<21);
            all_zero<=~|m1[20:0];
        end else if(e1==8'd130) begin
            m2<={1'b1,m1&23'b11100000000000000000000};
            over<=(x[31]<<20);
            all_zero<=~|m1[19:0];
        end else if(e1==8'd131) begin
            m2<={1'b1,m1&23'b11110000000000000000000};
            over<=(x[31]<<19);
            all_zero<=~|m1[18:0];
        end else if(e1==8'd132) begin
            m2<={1'b1,m1&23'b11111000000000000000000};
            over<=(x[31]<<18);
            all_zero<=~|m1[17:0];
        end else if(e1==8'd133) begin
            m2<={1'b1,m1&23'b11111100000000000000000};
            over<=(x[31]<<17);
            all_zero<=~|m1[16:0];
        end else if(e1==8'd134) begin
            m2<={1'b1,m1&23'b11111110000000000000000};
            over<=(x[31]<<16);
            all_zero<=~|m1[15:0];
        end else if(e1==8'd135) begin
            m2<={1'b1,m1&23'b11111111000000000000000};
            over<=(x[31]<<15);
            all_zero<=~|m1[14:0];
        end else if(e1==8'd136) begin
            m2<={1'b1,m1&23'b11111111100000000000000};
            over<=(x[31]<<14);
            all_zero<=~|m1[13:0];
        end else if(e1==8'd137) begin
            m2<={1'b1,m1&23'b11111111110000000000000};
            over<=(x[31]<<13);
            all_zero<=~|m1[12:0];
        end else if(e1==8'd138) begin
            m2<={1'b1,m1&23'b11111111111000000000000};
            over<=(x[31]<<12);
            all_zero<=~|m1[11:0];
        end else if(e1==8'd139) begin
            m2<={1'b1,m1&23'b11111111111100000000000};
            over<=(x[31]<<11);
            all_zero<=~|m1[10:0];
        end else if(e1==8'd140) begin
            m2<={1'b1,m1&23'b11111111111110000000000};
            over<=(x[31]<<10);
            all_zero<=~|m1[9:0];
        end else if(e1==8'd141) begin
            m2<={1'b1,m1&23'b11111111111111000000000};
            over<=(x[31]<<9);
            all_zero<=~|m1[8:0];
        end else if(e1==8'd142) begin
            m2<={1'b1,m1&23'b11111111111111100000000};
            over<=(x[31]<<8);
            all_zero<=~|m1[7:0];
        end else if(e1==8'd143) begin
            m2<={1'b1,m1&23'b11111111111111110000000};
            over<=(x[31]<<7);
            all_zero<=~|m1[6:0];
        end else if(e1==8'd144) begin
            m2<={1'b1,m1&23'b11111111111111111000000};
            over<=(x[31]<<6);
            all_zero<=~|m1[5:0];
        end else if(e1==8'd145) begin
            m2<={1'b1,m1&23'b11111111111111111100000};
            over<=(x[31]<<5);
            all_zero<=~|m1[4:0];
        end else if(e1==8'd146) begin
            m2<={1'b1,m1&23'b11111111111111111110000};
            over<=(x[31]<<4);
            all_zero<=~|m1[3:0];
        end else if(e1==8'd147) begin
            m2<={1'b1,m1&23'b11111111111111111111000};
            over<=(x[31]<<3);
            all_zero<=~|m1[2:0];
        end else if(e1==8'd148) begin
            m2<={1'b1,m1&23'b11111111111111111111100};
            over<=(x[31]<<2);
            all_zero<=~|m1[1:0];
        end else if(e1==8'd149) begin
            m2<={1'b1,m1&23'b11111111111111111111110};
            over<=(x[31]<<1);
            all_zero<=~m1[0];
        end else if(e1>8'd149) begin
            m2<=m1;
            over<=24'd0;
            all_zero<=1'b0;
        end 
        //この場合分けは不要になった
        /*else if(e1==8'd126) begin
            m2<={1'b1,m1&23'd0};
            //over<=24'b100000000000000000000000;
        end*/ /*小さければ0か-1へ*/else begin
            m2<=24'd0;
            over<=24'd0;
            all_zero<=1'b0;
            //over<=24'd0;
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

   end

endmodule