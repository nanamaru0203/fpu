module itof(input logic clk,
            input logic [31:0] x,
            output logic [31:0] y);
    logic s1;
    logic s2;
    logic [31:0] abs_x;
    logic [31:0] tmp;
    logic [7:0] e1;
    logic [7:0] e2;
    logic [22:0] m1;
    logic [22:0] m2;
    //どちらに丸めるか
    logic up;
    assign e2=(up==1'b0)? e1 : (&m1==1'b0)? e1 : e1+1;
    assign m2=(up==1'b0)? m1 : (&m1==1'b0)? m1+1 : 23'd0;
    assign tmp={s1,e2,m2};
    assign s1=(x[31])? 1'b1 : 1'b0;
    assign abs_x=(x[31])? ~x+1 : x;

    always_comb begin
        casex(abs_x)
            32'b00000000000000000000000000000000 : begin  
                e1=8'd0;
                m1=23'd0;
                up=1'b0;
            end
            32'b00000000000000000000000000000001 : begin  
                e1=8'd127;
                m1=23'd0;
                up=1'b0;
            end
            32'b0000000000000000000000000000001x : begin  
                e1=8'd128;
                m1=(abs_x[0]<<22);
                up=1'b0;
            end
            32'b000000000000000000000000000001xx : begin  
                e1=8'd129;
                m1=(abs_x[1:0]<<21);
                up=1'b0;
            end
            32'b00000000000000000000000000001xxx : begin  
                e1=8'd130;
                m1=(abs_x[2:0]<<20);
                up=1'b0;
            end
            32'b0000000000000000000000000001xxxx : begin  
                e1=8'd131;
                m1=(abs_x[3:0]<<19);
                up=1'b0;
            end
            32'b000000000000000000000000001xxxxx : begin  
                e1=8'd132;
                m1=(abs_x[4:0]<<18);
                up=1'b0;
            end
            32'b00000000000000000000000001xxxxxx : begin  
                e1=8'd133;
                m1=(abs_x[5:0]<<17);
                up=1'b0;
            end
            32'b0000000000000000000000001xxxxxxx : begin  
                e1=8'd134;
                m1=(abs_x[6:0]<<16);
                up=1'b0;
            end
            32'b000000000000000000000001xxxxxxxx : begin  
                e1=8'd135;
                m1=(abs_x[7:0]<<15);
                up=1'b0;
            end
            32'b00000000000000000000001xxxxxxxxx : begin  
                e1=8'd136;
                m1=(abs_x[8:0]<<14);
                up=1'b0;
            end
            32'b0000000000000000000001xxxxxxxxxx : begin  
                e1=8'd137;
                m1=(abs_x[9:0]<<13);
                up=1'b0;
            end
            32'b000000000000000000001xxxxxxxxxxx : begin  
                e1=8'd138;
                m1=(abs_x[10:0]<<12);
                up=1'b0;
            end
            32'b00000000000000000001xxxxxxxxxxxx : begin  
                e1=8'd139;
                m1=(abs_x[11:0]<<11);
                up=1'b0;
            end
            32'b0000000000000000001xxxxxxxxxxxxx : begin  
                e1=8'd140;
                m1=(abs_x[12:0]<<10);
                up=1'b0;
            end
            32'b000000000000000001xxxxxxxxxxxxxx : begin  
                e1=8'd141;
                m1=(abs_x[13:0]<<9);
                up=1'b0;
            end
            32'b00000000000000001xxxxxxxxxxxxxxx : begin  
                e1=8'd142;
                m1=(abs_x[14:0]<<8);
                up=1'b0;
            end
            32'b0000000000000001xxxxxxxxxxxxxxxx : begin  
                e1=8'd143;
                m1=(abs_x[15:0]<<7);
                up=1'b0;
            end
            32'b000000000000001xxxxxxxxxxxxxxxxx : begin  
                e1=8'd144;
                m1=(abs_x[16:0]<<6);
                up=1'b0;
            end
            32'b00000000000001xxxxxxxxxxxxxxxxxx : begin  
                e1=8'd145;
                m1=(abs_x[17:0]<<5);
                up=1'b0;
            end
            32'b0000000000001xxxxxxxxxxxxxxxxxxx : begin  
                e1=8'd146;
                m1=(abs_x[18:0]<<4);
                up=1'b0;
            end
            32'b000000000001xxxxxxxxxxxxxxxxxxxx : begin  
                e1=8'd147;
                m1=(abs_x[19:0]<<3);
                up=1'b0;
            end
            32'b00000000001xxxxxxxxxxxxxxxxxxxxx : begin  
                e1=8'd148;
                m1=(abs_x[20:0]<<2);
                up=1'b0;
            end
            32'b0000000001xxxxxxxxxxxxxxxxxxxxxx : begin  
                e1=8'd149;
                m1=(abs_x[21:0]<<1);
                up=1'b0;
            end
            32'b000000001xxxxxxxxxxxxxxxxxxxxxxx : begin  
                e1=8'd150;
                m1=abs_x[22:0];
                up=1'b0;
            end
            32'b00000001xxxxxxxxxxxxxxxxxxxxxxxx : begin  
                e1=8'd151;
                m1=abs_x[23:1];
                up=abs_x[0];
            end
            32'b0000001xxxxxxxxxxxxxxxxxxxxxxxxx : begin  
                e1=8'd152;
                m1=abs_x[24:2];
                up=abs_x[1];
            end
            32'b000001xxxxxxxxxxxxxxxxxxxxxxxxxx : begin  
                e1=8'd153;
                m1=abs_x[25:3];
                up=abs_x[2];
            end
            32'b00001xxxxxxxxxxxxxxxxxxxxxxxxxxx : begin  
                e1=8'd154;
                m1=abs_x[26:4];
                up=abs_x[3];
            end
            32'b0001xxxxxxxxxxxxxxxxxxxxxxxxxxxx : begin  
                e1=8'd155;
                m1=abs_x[27:5];
                up=abs_x[4];
            end
            32'b001xxxxxxxxxxxxxxxxxxxxxxxxxxxxx : begin  
                e1=8'd156;
                m1=abs_x[28:6];
                up=abs_x[5];
            end
            32'b01xxxxxxxxxxxxxxxxxxxxxxxxxxxxxx : begin  
                e1=8'd157;
                m1=abs_x[29:7];
                up=abs_x[6];
            end
            default : begin  
                e1=8'd0;
                m1=23'd0;
                up=1'd0;
            end
        endcase
    end

    always@(posedge clk) begin
        //stage1
        y<=tmp;
    end
endmodule