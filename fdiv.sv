module fdiv(input logic clk,
            input logic [31:0] x1,
            input logic [31:0] x2,
            output logic [31:0] y);
    //y=x1/x2
    logic [7:0] e_diff1;
    assign e_diff1=(x2[30:23]>=253)? 8'd4 : 8'd0;
    logic [31:0] modified_x2;
    assign modified_x2={x2[31],x2[30:23]-e_diff1,x2[22:0]};
    logic [31:0] inv_x2;
    logic [31:0] tmp;
    logic [31:0] x1_4;
    finv uut1(.clk(clk),.x(modified_x2),.y(inv_x2));
    fmul uut2(.x1(x1_4),.x2(inv_x2),.clk(clk),.y(tmp));
    logic [7:0] e_diff2;
    logic [7:0] e_diff3;
    logic [7:0] e_diff4;
    logic [7:0] e_diff5;
    logic [7:0] e_diff6;
    logic [31:0] x1_2;
    logic [31:0] x1_3;
    always@(posedge clk) begin
        //stage1
        e_diff2<=e_diff1;
        x1_2<=x1;
        //stage2
        e_diff3<=e_diff2;
        x1_3<=x1_2;
        //stage3 ここまでfinv
        e_diff4<=e_diff3;
        x1_4<=x1_3;
        //stage4
        e_diff5<=e_diff4;
        //stage5
        e_diff6<=e_diff5;
        //stage6
        y<=(tmp[30:23]>e_diff6)? {tmp[31],tmp[30:23]-e_diff6,tmp[22:0]} : 32'd0;
    end
endmodule



