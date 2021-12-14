module cache(input logic [26:0] addr,
             input logic [31:0] write_data,
             input logic write,
             input logic enable,
             input logic ddr2_available,
             input logic [127:0] ddr2_data;
             output logic [31:0] read_data,
             output logic available,
             output logic [26:0] ddr2_addr,
             output logic ddr2_enable,
             output logic ddr2_read);

    logic [1:0] state;
    integer i;
    initial begin
        state=2'b00
        for(i=0;i<1024;i=i+1) begin
            valid[i]=1'b0;
            dirty[i]=1'b0;
        end
    end
    logic [127:0] ram_data [1023:0];
    logic [1023:0] valid;
    logic [1023:0] dirty;
    logic [17:0] tag [1023:0];
    logic [9:0] index;
    logic [9:0] index_save;
    logic [26:0] addr_save;
    logic [31:0] write_data_save;
    logic write_save;
    assign index = addr[13:4];
    assign index_save=addr_save[13:4];
    always@(posedge clk) begin
        if(state==2'b00) begin
            //有効な信号がコアから来たか
            if(enable==1'b1) begin
                //ヒットした場合
                if(tag[index] == addr[26:14] & valid[index]==1'b1) begin
                    if(write==1'b1) begin
                        if(addr[3:2]==2'b00) begin
                            ram_data[index][31:0]<=write_data;
                        end else if(addr[3:2]==2'b01) begin
                            ram_data[index][63:32]<=write_data;
                        end else if (addr[3:2]==2'b10) begin
                            ram_data[index][95:64]<=write_data;
                        end else begin
                            ram_data[index][127:96]<=write_data;
                        end
                        dirty[index]<=1'b1;
                    end
                    else begin
                        if(addr[3:2]==2'b00) begin
                            read_data<=ram_data[index][31:0];
                        end else if(addr[3:2]==2'b01) begin
                            read_data<=ram_data[index][63:32];
                        end else if (addr[3:2]==2'b10) begin
                            read_data<=ram_data[index][95:64];
                        end else begin
                            read_data<=ram_data[index][127:96];
                        end
                    end     
                    available<=1'b1;
                    ddr2_enable<=1'b0;
                end
                //ミスした場合
                else begin
                    //dirty bitで場合分け
                    if(dirty==1'b1) begin
                        //ddr2に書き込む
                        ddr2_addr<=addr;
                        ddr2_enable<=1'b1;
                        ddr2_read<=1'b0; 
                        state<=2'b01;   
                    end 
                    else begin
                        ddr2_addr<=addr;
                        ddr2_enable<=1'b1;
                        ddr2_read<=1'b1;
                        state<=2'b10;
                    end 
                    available<=1'b0;
                    addr_save<=addr;
                    write_data_save<=write_data;
                    write_save<=write;
                end
            end
        end
        //ミスした場合の読み込み命令送信
        else if(state==2'b01) begin
            ddr2_addr<=addr_save;
            ddr2_enable<=1'b1;
            ddr2_read<=1'b1;
            state<=2'b10;
            available<=1'b0;   
        end
        //ddr2からデータが送られてくるまで待つ
        else if(state==2'b10) begin
            if(ddr2_available==1'b1) begin
                state<=2'b00;   
                available<=1'b1;
                ddr2_enable<=1'b0;
                valid[index_save]<=1'b1;
                dirty[index_save]<=1'b0;
                tag[index_save] <= addr_save[26:14]
                if(write_save==1'b1) begin
                    if(addr_save[3:2]==2'b00) begin
                        ram_data[index_save]<={ddr2_data[127:32],write_data_save};
                    end else if(addr_save[3:2]==2'b01) begin
                        ram_data[index_save]<={ddr2_data[127:64],write_data_save,ddr2_data[31:0]};
                    end else if (addr_save[3:2]==2'b10) begin
                        ram_data[index_save]<={ddr2_data[127:96],write_data_save,ddr2_data[63:0]};
                    end else begin
                        ram_data[index_save]<={write_data_save,ddr2_data[95:0]};
                    end      
                end
                else begin
                    ram_data[index_save] <= ddr2_data;
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

