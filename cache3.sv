module ram_data(
    input logic clk,
    input logic we,
    input logic [127:0] din,
    input logic [9:0] addr,
    output logic [127:0] dout                
);
    logic [127:0] ram_data [1023:0];
    always @(posedge clk) begin
        if(we) begin
            ram_data[addr] <= din;
        end
        dout <= ram_data[addr];
    end
endmodule

module cache(input logic clk,
            input logic [26:0] addr,
             input logic [31:0] write_data,
             input logic write,
             input logic enable,
             input logic ddr2_available,
             input logic [127:0] ddr2_data,
             output logic [31:0] read_data,
             output logic available,
             output logic [26:0] ddr2_addr,
             output logic [127:0] to_ddr2_data,
             output logic ddr2_enable,
             output logic ddr2_read);

    logic [2:0] state;
    integer i;
    logic [1023:0] valid;
    logic [1023:0] dirty;
    initial begin
        state=3'b000;
        valid=1024'd0;
        dirty=1024'd0;
    end
    //logic [127:0] ram_data [1023:0];
    logic we;
    logic [9:0] addr_ram;
    logic [127:0] din;
    logic [127:0] dout;
    ram_data uut(.clk(clk),.we(we),.din(din),.addr(addr_ram),.dout(dout));
    logic [17:0] tag [1023:0];
    logic [9:0] index;
    logic [9:0] index_save;
    logic [26:0] addr_save;
    logic [31:0] write_data_save;
    logic write_save;
    assign index = addr[13:4];
    assign index_save=addr_save[13:4];
    always_comb begin
        we = 1'b0;
        addr_ram = 10'b0;
        din =128'b0;
        if(state == 3'b000) begin
            if(enable == 1'b1) begin
                if(tag[index] == addr[26:14] & valid[index]==1'b1) begin
                    addr_ram = index;
                end
                else begin
                    if(dirty[index]==1'b1) begin
                        addr_ram = index;  
                    end 
                end
            end
        end
        else if(state == 3'b011) begin
            if(write_save==1'b1) begin
                we = 1'b1;
                addr_ram = index_save;
               if(addr_save[3:2]==2'b00) begin
                    din = {dout[127:32],write_data_save};
                end else if(addr_save[3:2]==2'b01) begin
                    din = {dout[127:64],write_data_save,dout[31:0]};
                end else if (addr_save[3:2]==2'b10) begin
                    din = {dout[127:96],write_data_save,dout[63:0]};
                end else begin
                    din = {write_data_save,dout[95:0]};
                end 
            end
        end
        else if(state==3'b010) begin
            if(ddr2_available==1'b1) begin
                we = 1'b1;
                addr_ram = index_save;
                if(write_save==1'b1) begin
                    if(addr_save[3:2]==2'b00) begin
                        din = {ddr2_data[127:32],write_data_save};
                    end else if(addr_save[3:2]==2'b01) begin
                        din = {ddr2_data[127:64],write_data_save,ddr2_data[31:0]};
                    end else if (addr_save[3:2]==2'b10) begin
                        din = {ddr2_data[127:96],write_data_save,ddr2_data[63:0]};
                    end else begin
                        din = {write_data_save,ddr2_data[95:0]};
                    end  
                end
                else begin
                    din = ddr2_data;
                end
            end      
        end
    end


    always@(posedge clk) begin
        if(state==3'b000) begin
            //???????????????????????????????????????
            if(enable==1'b1) begin
                //?????????????????????
                if(tag[index] == addr[26:14] & valid[index]==1'b1) begin
                    state <= 3'b011;
                end
                //??????????????????
                else begin
                    //dirty bit???????????????
                    if(dirty[index]==1'b1) begin
                        //ddr2???????????????
                        ddr2_addr<={tag[index],index,4'd0};
                        //ddr2_enable<=1'b1;
                        ddr2_read<=1'b0; 
                        //to_ddr2_data<=ram_data[index];
                        state<=3'b100;   
                    end 
                    else begin
                        ddr2_addr<={addr[26:4],4'd0};
                        ddr2_enable<=1'b1;
                        ddr2_read<=1'b1;
                        state<=3'b010;
                    end 
                end
                addr_save<=addr;
                write_data_save<=write_data;
                write_save<=write;
            end
            available<=1'b0;
        end
        else if(state==3'b100) begin
            ddr2_enable <= 1'b1;
            to_ddr2_data <= dout;
            state <= 3'b001;
        end
        //?????????????????????
        else if(state == 3'b011) begin
            if(write_save==1'b1) begin
                dirty[index_save]<=1'b1;
            end
            else begin
                if(addr_save[3:2]==2'b00) begin
                    read_data<=dout[31:0];
                end else if(addr_save[3:2]==2'b01) begin
                    read_data<=dout[63:32];
                end else if (addr_save[3:2]==2'b10) begin
                    read_data<=dout[95:64];
                end else begin
                    read_data<=dout[127:96];
                end
            end     
            available<=1'b1;
            ddr2_enable<=1'b0;
            state<=3'b000;
        end
        //?????????????????????????????????????????????
        else if(state==3'b001) begin
            ddr2_addr<={addr_save[26:4],4'd0};
            ddr2_enable<=1'b1;
            ddr2_read<=1'b1;
            state<=3'b010;
            available<=1'b0;   
        end
        //ddr2????????????????????????????????????????????????
        else if(state==3'b010) begin
            ddr2_enable<=1'b0;
            if(ddr2_available==1'b1) begin
                state<=3'b000;   
                available<=1'b1;
                valid[index_save]<=1'b1;
                tag[index_save] <= addr_save[26:14];
                if(write_save==1'b1) begin
                    dirty[index_save] <= 1'b1;  
                end
                else begin
                    //ram_data[index_save] <= ddr2_data;
                    dirty[index_save] <= 1'b0;
                    if(addr_save[3:2]==2'b00) begin
                        read_data<=ddr2_data[31:0];
                    end else if(addr_save[3:2]==2'b01) begin
                        read_data<=ddr2_data[63:32];
                    end else if (addr_save[3:2]==2'b10) begin
                        read_data<=ddr2_data[95:64];
                    end else begin
                        read_data<=ddr2_data[127:96];
                    end
                    
                end
            end      
        end
    end
endmodule