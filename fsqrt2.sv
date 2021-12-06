module ram_fsqrt(input logic clk,
           input logic [9:0] addr,
           input logic even,
           output logic [23:0] a,
           output logic [23:0] b);
    (* ram_style = "block" *)
    logic [23:0] mem_a [1023:0];
    (* ram_style = "block" *)
    logic [23:0] mem_b [1023:0];
    (* ram_style = "block" *)
    logic [23:0] mem_c [1023:0];
    (* ram_style = "block" *)
    logic [23:0] mem_d [1023:0];
    always@(posedge clk) begin
        if(even==1'b1) begin
            a<=mem_a[addr];
            b<=mem_b[addr];
        end else begin
            a<=mem_c[addr];
            b<=mem_d[addr];
        end
    end

    longint i;
    longint x0;
    initial begin
        for(i=0;i<1024;i=i+1) begin
            x0=(($sqrt((64'd1024+i)<<20))+($sqrt((64'd1025+i)<<20)))/64'd2;
            mem_a[i]=x0<<8;
            mem_b[i]=(64'd1<<46)/(x0<<8);
            mem_c[i]=(x0*64'd47453133)>>17;
            mem_d[i]=(64'd47453132<<21)/(x0<<8);
        end
    end
endmodule

module fsqrt(input logic clk,
            input logic [31:0] x,
            output logic [31:0] y);

    logic [9:0] addr;
    logic [7:0] e1;
    logic [7:0] e2;
    logic [22:0] m1;
    logic [23:0] m2;
    logic [23:0] x_2;
    logic [25:0] a_x;
    logic [25:0] hh;
    logic [25:0] hl;
    logic [25:0] lh;
    logic [25:0] hh2;
    logic [25:0] hllh;
    assign  addr=x[22:13];
    logic [23:0] a;
    logic [23:0] b;
    logic zero;
    ram_fsqrt ram_fsqrt(.clk(clk),.addr(addr),.even(x[23]),.a(a),.b(b));
    logic [31:0] tmp;
    assign hh={1'b1,m1[22:11]}*b[23:11];
    assign hl={1'b1,m1[22:11]}*b[10:0];
    assign lh=m1[10:0]*b[23:11];
    assign a_x=hh2+hllh;
    assign m2= x_2+a_x[25:2];
    assign tmp=(zero)? 32'd0 : {1'b0,e2,m2[22:0]};
    always@(posedge clk)begin
        //stage1
        e1<=x[30:23];
        m1<=x[22:0];
        //stage2
        e2<=((e1-127)>>1)+127;
        zero<=(e1==8'd0)? 1'b1 : 1'b0;
        x_2<=a>>1;
        hh2<=hh+26'd2;
        hllh<=(hl>>11)+(lh>>11);
        //stage3
        y<=tmp;
    end
endmodule