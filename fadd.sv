module fadd(input logic clk,
            input logic [31:0] x1,
            input logic [31:0] x2,
            output logic [31:0] y
    );
    //x1の方が絶対値が大きければ1
    logic big;
    assign big=(x1[30:23]==x2[30:23])? ((x1[22:0]>=x2[22:0])? 1'b1 : 1'b0) : ((x1[30:23]>x2[30:23])? 1'b1 : 1'b0);
    //足し算するなら0
    logic calc;
    logic s1;
    logic s2;
    logic [7:0] e1;
    logic [7:0] e2;
    logic [24:0] x1_m;
    logic [24:0] x2_m;
    assign x1_m={2'b01,x1[22:0]};
    assign x2_m={2'b01,x2[22:0]};
    logic [24:0] big_x;
    logic [24:0] small_x;
    logic [24:0] m2;

    always_comb begin
        //stage3
        if(m2[24]==1'b1) begin
                y={s2,e2+8'd1,m2[23:1]};
        end else if(m2[23]==1'b1) begin
                y={s2,e2,m2[22:0]};
        end else if(m2[22]==1'b1) begin
                y=(e2>8'd1)? {s2,e2-8'd1,m2[21:0],1'd0} : 32'd0;
        end else if(m2[21]==1'b1) begin
                y=(e2>8'd2)? {s2,e2-8'd2,m2[20:0],2'd0} : 32'd0;
        end else if(m2[20]==1'b1) begin
                y=(e2>8'd3)? {s2,e2-8'd3,m2[19:0],3'd0} : 32'd0;
        end else if(m2[19]==1'b1) begin
                y=(e2>8'd4)? {s2,e2-8'd4,m2[18:0],4'd0} : 32'd0;
        end else if(m2[18]==1'b1) begin
                y=(e2>8'd5)? {s2,e2-8'd5,m2[17:0],5'd0} : 32'd0;
        end else if(m2[17]==1'b1) begin
                y=(e2>8'd6)? {s2,e2-8'd6,m2[16:0],6'd0} : 32'd0;
        end else if(m2[16]==1'b1) begin
                y=(e2>8'd7)? {s2,e2-8'd7,m2[15:0],7'd0} : 32'd0;
        end else if(m2[15]==1'b1) begin
                y=(e2>8'd8)? {s2,e2-8'd8,m2[14:0],8'd0} : 32'd0;
        end else if(m2[14]==1'b1) begin
                y=(e2>8'd9)? {s2,e2-8'd9,m2[13:0],9'd0} : 32'd0;
        end else if(m2[13]==1'b1) begin
                y=(e2>8'd10)? {s2,e2-8'd10,m2[12:0],10'd0} : 32'd0;
        end else if(m2[12]==1'b1) begin
                y=(e2>8'd11)? {s2,e2-8'd11,m2[11:0],11'd0} : 32'd0;
        end else if(m2[11]==1'b1) begin
                y=(e2>8'd12)? {s2,e2-8'd12,m2[10:0],12'd0} : 32'd0;
        end else if(m2[10]==1'b1) begin
                y=(e2>8'd13)? {s2,e2-8'd13,m2[9:0],13'd0} : 32'd0;
        end else if(m2[9]==1'b1) begin
                y=(e2>8'd14)? {s2,e2-8'd14,m2[8:0],14'd0} : 32'd0;
        end else if(m2[8]==1'b1) begin
                y=(e2>8'd15)? {s2,e2-8'd15,m2[7:0],15'd0} : 32'd0;
        end else if(m2[7]==1'b1) begin
                y=(e2>8'd16)? {s2,e2-8'd16,m2[6:0],16'd0} : 32'd0;
        end else if(m2[6]==1'b1) begin
                y=(e2>8'd17)? {s2,e2-8'd17,m2[5:0],17'd0} : 32'd0;
        end else if(m2[5]==1'b1) begin
                y=(e2>8'd18)? {s2,e2-8'd18,m2[4:0],18'd0} : 32'd0;
        end else if(m2[4]==1'b1) begin
                y=(e2>8'd19)? {s2,e2-8'd19,m2[3:0],19'd0} : 32'd0;
        end else if(m2[3]==1'b1) begin
                y=(e2>8'd20)? {s2,e2-8'd20,m2[2:0],20'd0} : 32'd0;
        end else if(m2[2]==1'b1) begin
                y=(e2>8'd21)? {s2,e2-8'd21,m2[1:0],21'd0} : 32'd0;
        end else if(m2[1]==1'b1) begin
                y=(e2>8'd22)? {s2,e2-8'd22,m2[0],22'd0} : 32'd0;
        end else if(m2[0]==1'b1) begin
                y=(e2>8'd23)? {s2,e2-8'd23,23'd0} : 32'd0;
        end else begin
                y=32'd0;
        end    
    end

    always@(posedge clk) begin
        //stage1
        s1<=(big)? x1[31] : x2[31];
        e1<=(big)? x1[30:23] : x2[30:23];
        calc<=x1[31]^x2[31];
        big_x<=(big)? ((x1[30:23]==8'd0)? 24'd0 : x1_m) : ((x2[30:23]==8'd0)? 24'd0 : x2_m);
        small_x<=(big)? ((x2[30:23]==8'd0)? 24'd0 : x2_m>>(x1[30:23]-x2[30:23])) : ((x1[30:23]==8'd0)? 24'd0 : x1_m>>(x2[30:23]-x1[30:23]));
        //stage2
        s2<=s1;
        e2<=e1;
        m2<=(calc)? (big_x-small_x) : (big_x+small_x);
    end
endmodule


    