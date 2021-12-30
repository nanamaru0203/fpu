module ddr2(input logic clk,
            input logic [26:0] ddr2_addr,
            input logic ddr2_enable,
            input logic ddr2_read,
            input logic [127:0] to_ddr2_data,
            output logic [127:0] ddr2_data,
            output logic ddr2_available);
    logic [127:0] ram [(1<<23)-1:0];
    logic state;
    logic [26:0] addr_save;
    initial begin
      state = 1'b0;
    end
    always@(posedge clk) begin
      if(state == 1'b0) begin
        if(ddr2_enable==1'b1) begin
            if(ddr2_read==1'b1) begin
              state <= 1'b1;
              addr_save <= ddr2_addr;
            end else begin
                ram[ddr2_addr[26:4]]<=to_ddr2_data;
                state<=1'b0;
            end
        end
      end else begin
        ddr2_data<=ram[addr_save[26:4]];
        ddr2_available<=1'b1;
        state <= 1'b0;
      end
    end
endmodule

module test;
    logic clk;
    logic [26:0] addr;
    logic [31:0] write_data;
    logic write;
    logic enable;
    logic [1:0] state;
    logic ddr2_available;
    logic [127:0] ddr2_data;
    logic [31:0] read_data;
    logic available;
    logic [26:0] ddr2_addr;
    logic [127:0] to_ddr2_data;
    logic ddr2_enable;
    logic ddr2_read;
    cache uut1(.clk,.addr,.write_data,.write,.enable,.ddr2_available,.ddr2_data,.read_data,.available,.ddr2_addr,.to_ddr2_data,.ddr2_enable,.ddr2_read);
    ddr2 uut2(.clk,.ddr2_addr,.ddr2_enable,.ddr2_read,.to_ddr2_data,.ddr2_data,.ddr2_available);
    assign state = uut1.state;
    initial begin
      $dumpfile("uut.vcd");
      $dumpvars(0,clk,read_data,available,state,to_ddr2_data,ddr2_enable);
    end

    initial begin
      clk=0;
      enable=1'b0;
      forever begin
	 #5 clk= !clk;
      end
    end

    initial begin
     #1000;
      $finish;
    end

   initial begin
      #100;
      addr=27'd0;
      write_data=32'd100;
      write=1'b1;
      enable=1'b1;
      #10;
      enable=1'b0;
      #50;
      addr=27'b1000000000000000000;
      write_data=32'd200;
      write=1'b1;
      enable=1'b1;
      #10;
      enable=1'b0;
      #50;
      addr=27'b1000000000100000000;
      write_data=32'd300;
      write=1'b1;
      enable=1'b1;
      #10;
      enable=1'b0;
      #50;
      addr=27'b100000000;
      write_data=32'd400;
      write=1'b1;
      enable=1'b1;
      #10;
      enable=1'b0;
      #50;
      addr=27'd0;
      write=1'b0;
      enable=1'b1;
      #10;
      enable=1'b0;
      #50;
      addr=27'b1000000000000000000;
      write=1'b0;
      enable=1'b1;
      #10;
      enable=1'b0;
      #50;
      addr=27'b1000000000100000000;
      write=1'b0;
      enable=1'b1;
      #10;
      enable=1'b0;
      #50;
      addr=27'b100000000;
      write=1'b0;
      enable=1'b1;
      #10;
      enable=1'b0;
   end
endmodule