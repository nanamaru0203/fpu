module fsub(input logic clk,
            input logic [31:0] x1,
            input logic [31:0] x2,
            output logic [31:0] y);
    logic [31:0] x2_sub;
    assign x2_sub={~x2[31],x2[30:0]};
    fadd uut(.clk(clk),.x1(x1),.x2(x2_sub),.y(y));
endmodule