module cache(input logic [26:0] addr,
             input logic [31:0] write_data.
             input logic write,
             output logic [31:0] read_data,
             output logic hit,
             output logic [26:0] ddr2_addr);


    logic [127:0] ram_data [1023:0];
    logic [1023:0] valid;
    logic [17:0] tag [1023:0];
    logic [9:0] index;
    assign index = addr[13:4];
    always@(posedge clk) begin
        if(ram_tag[index] == addr[26:(block_size+1)]) begin
            read_data<=ram_data[key];
            hit=1'b1;
            ddr2_addr<=addr;
            if(write) begin     
        end
    end
endmodule

