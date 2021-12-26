module ddr2(input logic clk,
            input logic [26:0] ddr2_addr,
            input logic ddr2_enable,
            input logic ddr2_read,
            input logic [127:0] to_ddr2_data,
            output logic [127:0] ddr2_data,
            output logic ddr2_available);
    logic [127:0] ram [(1<<23)-1:0];
    always@(posedge clk) begin
        if(ddr2_enable==1'b1) begin
            if(ddr2_read==1'b1) begin
                ddr2_data<=ram[ddr2_addr[26:4]];
                ddr2_available<=1'b1;
            end
            else begin
                ram[ddr2_addr[26:4]]<=to_ddr2_data;
            end
        end
    end
endmodule

module test;
    logic clk;
    logic [26:0] addr;
    logic [31:0] write_data;
    logic write;
    logic enable;
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
    initial begin
      $dumpfile("uut.vcd");
      $dumpvars(0,clk,read_data,available);
    end

    initial begin
      clk=0;
      enable=1'b0;
      forever begin
	 #5 clk= !clk;
      end
    end

    initial begin
     #500;
      $finish;
    end

   initial begin
      #100;
      addr=27'd100;
      write_data=32'd100;
      write=1'b1;
      enable=1'b1;
      #10;
      enable=1'b0;
      #30;
      addr=27'd104;
      write_data=32'd104;
      write=1'b1;
      enable=1'b1;
      #10;
      enable=1'b0;
      #30;
      addr=27'd100;
      write=1'b0;
      enable=1'b1;
      #10;
      enable=1'b0;
      #30;
      addr=27'd104;
      write=1'b0;
      enable=1'b1;
      #10;
      enable=1'b0;
      #30;
      addr=27'd16484;
      write_data=32'd16484;
      write=1'b1;
      enable=1'b1;
      #10;
      enable=1'b0;
      #30;
      addr=27'd100;
      write=1'b0;
      enable=1'b1;
      #10;
      enable=1'b0;
   end
endmodule