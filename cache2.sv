module ram_data(
    input logic clk,
    input logic we,
    input logic [31:0] din,
    input logic [11:0] addr,
    output logic [31:0] dout                
);
    logic [31:0] ram_data [4095:0];
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
    logic [1:0] state2;
    integer i;
    logic [1023:0] valid;
    logic [1023:0] dirty;
    initial begin
        state=3'b00;
        state2=2'b00;
        valid=1024'd0;
        dirty=1024'd0;
    end
    //logic [127:0] ram_data [1023:0];
    logic we;
    logic [11:0] addr_ram;
    logic [31:0] din;
    ram_data uut(.clk(clk),.we(we),.din(din),.addr(addr_ram),.dout(read_data));
    logic [17:0] tag [1023:0];
    logic [9:0] index;
    logic [9:0] index_save;
    logic [26:0] addr_save;
    logic [31:0] write_data_save;
    logic [127:0] ddr2_data_save;
    logic write_save;
    assign index = addr[13:4];
    assign index_save=addr_save[13:4];
    always_comb begin
        we = 1'b0;
        addr_ram = 12'b0;
        din =32'b0;
        if(state==3'b000) begin
            //有効な信号がコアから来たか
            if(enable==1'b1) begin
                //ヒットした場合
                if(tag[index] == addr[26:14] & valid[index]==1'b1) begin
                    if(write==1'b1) begin
                        we = 1'b1;
                        din = write_data;
                        if(addr[3:2]==2'b00) begin
                            addr_ram = (index << 2);
                        end else if(addr[3:2]==2'b01) begin
                            addr_ram = (index << 2) + 1;
                        end else if (addr[3:2]==2'b10) begin
                            addr_ram = (index << 2) +2;
                        end else begin
                            addr_ram = (index << 2) + 3;
                        end
                    end
                    else begin
                        we = 1'b0;
                        if(addr[3:2]==2'b00) begin
                            addr_ram = (index << 2);
                        end else if(addr[3:2]==2'b01) begin
                            addr_ram = (index << 2)+1;
                        end else if (addr[3:2]==2'b10) begin
                            addr_ram = (index << 2)+2;
                        end else begin
                            addr_ram = (index << 2)+3;
                        end
                    end     
                end
                else begin
                    if(dirty[index]==1'b1) begin
                        we=1'b1;
                        addr_ram = (index<<2);
                    end
                end
            end
        end  
        else if(state==3'b011) begin
            we = 1'b1;
            if(state2==2'b00) begin
                din = ddr2_data_save[31:0];
                addr_ram = (index_save<<2);
            end else if(state2==2'b01) begin
                din = ddr2_data_save[63:32];
                addr_ram = (index_save<<2)+1;
            end else if(state2==2'b10) begin
                din = ddr2_data_save[95:64];
                addr_ram = (index_save<<2)+2;
            end else if(state2==2'b11) begin
                din = ddr2_data_save[127:96];
                addr_ram = (index_save<<2)+3;
            end
        end
        else if(state==3'b100) begin
           if(write==1'b1) begin
                we = 1'b1;
                din = write_data_save;
                if(addr_save[3:2]==2'b00) begin
                    addr_ram = (index_save << 2);
                end else if(addr_save[3:2]==2'b01) begin
                    addr_ram = (index_save << 2) + 1;
                end else if (addr_save[3:2]==2'b10) begin
                    addr_ram = (index_save << 2) +2;
                end else begin
                    addr_ram = (index_save << 2) + 3;
                end
            end
            else begin
                we = 1'b0;
                if(addr_save[3:2]==2'b00) begin
                    addr_ram = (index_save << 2);
                end else if(addr_save[3:2]==2'b01) begin
                    addr_ram = (index_save << 2)+1;
                end else if (addr_save[3:2]==2'b10) begin
                    addr_ram = (index_save << 2)+2;
                end else begin
                    addr_ram = (index_save << 2)+3;
                end
            end    
        end
        else if(state==3'b101) begin
            we = 1'b0;
            if(stete2==2'b00) begin
                addr_ram = (index_save << 2) + 1;
            end else if(state2==2'b01) begin
                addr_ram = (index_save << 2) + 2;
            end else if(state2==2'b10) begin
                addr_ram = (index_save << 2) + 3;
            end 
        end
    end
    always@(posedge clk) begin
        if(state==3'b000) begin
            //有効な信号がコアから来たか
            if(enable==1'b1) begin
                //ヒットした場合
                if(tag[index] == addr[26:14] & valid[index]==1'b1) begin
                    if(write==1'b1) begin
                        dirty[index]<=1'b1;
                    end   
                    available<=1'b1;
                    ddr2_enable<=1'b0;
                end
                //ミスした場合
                else begin
                    //dirty bitで場合分け
                    if(dirty[index]==1'b1) begin
                        //ddr2に書き込む
                        ddr2_addr<={tag[index],index,4'd0};
                        //ddr2_enable<=1'b1;
                        ddr2_read<=1'b0; 
                        //to_ddr2_data<=ram_data[index];
                        state<=3'b101;   
                        state2<=2'b00;
                    end 
                    else begin
                        ddr2_addr<={addr[26:4],4'd0};
                        ddr2_enable<=1'b1;
                        ddr2_read<=1'b1;
                        state<=3'b010;
                    end 
                    available<=1'b0;
                    addr_save<=addr;
                    write_data_save<=write_data;
                    write_save<=write;
                end
            end
            else begin
                available<=1'b0;
            end
        end
        //ミスした場合の読み込み命令送信
        else if(state==3'b001) begin
            ddr2_addr<={addr_save[26:4],4'd0};
            ddr2_enable<=1'b1;
            ddr2_read<=1'b1;
            state<=3'b010;
            available<=1'b0;   
        end
        //ddr2からデータが送られてくるまで待つ
        else if(state==3'b010) begin
            ddr2_enable<=1'b0;
            if(ddr2_available==1'b1) begin
                state<=3'b011; 
                state2<=2'b00;  
                //available<=1'b1;
                valid[index_save]<=1'b1;
                tag[index_save] <= addr_save[26:14];
                ddr2_data_save <= ddr2_data;
                if(write_save==1'b1) begin
                    dirty[index_save] <= 1'b1;
                end else begin
                    dirty[index_save] <= 1'b0;
                end
            end      
        end
        else if(state == 3'b011) begin
            state2<=state2+2'b01;
            if(state2 == 2'b11)  begin
                state<=3'b100;
            end
        end
        else if(state == 3'b100) begin
            state <= 3'b000;
            available <= 1'b1;
        end
        else if(state == 3'b101) begin
            state2<=state2+2'b01;
            if(stete2 == 2'b00) begin
                to_ddr2_data[31:0]<= read_data;
            end else if(state2==2'b01) begin
                to_ddr2_data[63:32]<=read_data;
            end else if(state2==2'b10) begin
                to_ddr2_data[95:64]<=read_data;
            end else if(state2==2'b11) begin
                to_ddr2_data[127:96]<=read_data;
                ddr2_enable <= 1'b1;
                state <= 3'b001;
            end
        end
    end
endmodule

