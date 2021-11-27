module ram_finv(input logic clk,
           input logic load,
           input logic [9:0] addr,
           input logic [23:0] in_a,
           input logic [23:0] in_b,
           output logic [23:0] a,
           output logic [23:0] b);
    logic [23:0] mem_a [1023:0];
    logic [23:0] mem_b [1023:0];
    always@(posedge clk) begin
        if(load) begin
            mem_a[addr]<=in_a;
            mem_b[addr]<=in_b;
        end
        a<=mem_a[addr];
        b<=mem_b[addr];
    end

    integer i;
    initial begin
        for(i=0;i<1024;i=i+1) begin
            longint x0;
            longint x1;
            x0=(((1<<46)/((1024+i)*4096))+((1<<46)/((1025+i)*4096)))/2;
            x1=x0*x0;
            mem_a[i]=(x1>>24);
            mem_b[i]=x0;
        end
    end
endmodule

module finv(input logic clk,
            input logic [31:0] x,
            output logic [31:0] y);
    logic [9:0] addr;
    logic [7:0] e1;
    logic [7:0] e2;
    logic [7:0] e3;
    logic s1;
    logic s2;
    logic s3;
    assign e1=x[30:23];
    assign s1=x[31];
    //stage1
    //RAMに渡すアドレス
    assign  addr=x[22:13];
    logic [23:0] a;
    logic [23:0] b;
    logic [48:0] b2;
    ram ram_finv(.clk(clk),.load(1'b0),.addr(addr),.in_a(24'd0),.in_b(24'd0),.a(a),.b(b));
    logic [24:0] m1;
    logic [48:0] m2;
    logic [48:0] m3;
    logic [48:0] m4;
    assign m4=m2>>23;
    assign m3=b2-m4;
    logic [31:0] tmp;
    assign tmp={s3,e3,m3[22:0]};
    always@(posedge clk) begin
        ///stage1
        e2<=e1;
        s2<=s1;
        m1<={2'b01,x[22:0]};
        //stage2
        //ここだけ変更
        e3<=(e2>253)? 8'd0 : 253-e2;
        s3<=s2;
        m2<=m1*a;
        b2<=(b<<1);
        //stage3
        y<=tmp;
    end
endmodule
