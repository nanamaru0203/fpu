module ram_fsqrt(input logic clk,
           input logic load,
           input logic [9:0] addr,
           input logic [23:0] in_a,
           output logic [23:0] a);
    logic [23:0] mem_a [1023:0];
    always@(posedge clk) begin
        if(load) begin
            mem_a[addr]<=in_a;
        end
        a<=mem_a[addr];
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
    logic [7:0] e3;
    logic [46:0] m1;
    logic [46:0] m2;
    logic [46:0] m3;
    logic [46:0] x0_2;
    assign  addr=x[22:13];
    logic [23:0] a;
    ram ram_fsqrt(.clk(clk),.load(1'b0),.addr(addr),.in_a(24'd0),.a(a));
    logic [31:0] tmp;
    assign m3=(e2[0]==1'b1)? x0_2+m2 : ((x0_2+m2)*24'hb504f3)>>23;
    assign e3=((e2-127)>>1)+127;
    assign tmp=(e2==8'd0)? 32'd0 : {1'b0,e3,m3[22:0]};
    always@(posedge clk) begin
        //stage1
        e1<=x[30:23];
        m1<={1'b1,x[22:0],23'd0};
        //stage2
        e2<=e1;
        x0_2<=a>>1;
        m2<=m1/(a<<1);
        //stage3
        y<=tmp;
    end
endmodule