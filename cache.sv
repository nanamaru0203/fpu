module cache(input logic [26:0] addr,
             input logic [31:0] write_data.
             input logic write,
             output logic [31:0] read_data,
             output logic hit,
             output logic [26:0] ddr2_addr);

    parameter block_size =10;
    
    logic [31:0] ram_data [(1<<block_size)-1:0];
    //バイトアドレッシングなのでオフセット2
    logic [(24-block_size):0] ram_tag [(1<<block_size)-1:0];
    logic [(bloock_size-1):0] index;
    assign index = addr[(block_size+1):2];
    always@(posedge clk) begin
        if(ram_tag[index] == addr[26:(block_size+1)]) begin
            read_data<=ram_data[key];
            hit=1'b1;
            ddr2_addr<=addr;
            if(write) begin     
        end
    end
endmodule

