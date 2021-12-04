module ram_fsqrt(input logic clk,
           input logic [9:0] addr,
           output logic [23:0] a
           output logic [23:0] b);
    logic [23:0] mem_a [1023:0];
    logic [23:0] mem_b [1023:0];
    always@(posedge clk) begin
        a<=mem_a[addr];
        b<=mem_b[addr];
    end

    integer i;
    initial begin
        for(i=0;i<1024;i=i+1) begin
            longint x0;
            longint x1;
            x0=(($sqrt((1024+i)<<20))+($sqrt((1025+i)<<20)))/2;
            mem_a[i]=(x0<<8);
        end
    end
endmodule

module fsqrt(input logic clk,
            input logic [31:0] x,
            output logic [31:0] y);

    logic [9:0] addr;
    logic [7:0] e1;
    logic [7:0] e2;
    logic [23:0] x_2;
    logic [23:0] a_x;
    logic [23:0] m;
    assign  addr=x[22:13];
    logic [23:0] a;
    logic [23:0] b;
    ram ram_fsqrt(.clk(clk),.addr(addr),.a(a),.b(b));
    logic [31:0] tmp;
    assign m=(e2[0]==1'b1)? x_2+a_x : ((x_2+a_x)*24'hb504f3)>>23;
    assign e2=((e2-127)>>1)+127;
    assign tmp=(e2==8'd0)? 32'd0 : {1'b0,e2,m[22:0]};
    always@(posedge clk) begin
        //stage1
        e1<=x[30:23];
        x_2<=a>>1;
        a_x<=({1'b1,x[22:0]}*b)>>23;
        //stage2
        y<=tmp;
    end
endmodule