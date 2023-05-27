`timescale 1ns/1ps
module Top;
wire [7:0] Bus_out,Mem_bus_in;
wire [71:0] Bus_in,Mem_bus_out;
wire Clk,Reset,Data_strobe,Bus_rw,Mem_data_strobe,Mem_bus_rw;

testbench_sobel testbench_sobel_ins(.mem_bus_in(Mem_bus_in),.mem_bus_out(Mem_bus_out),.mem_data_strobe(Mem_data_strobe),.mem_bus_rw(Mem_bus_rw),.bus_in(Bus_in),.bus_out(Bus_out),.bus_rw(Bus_rw),.data_strobe(Data_strobe),.clk(Clk),.reset(Reset));

mem_sobel mem_sobel_ins(.mem_bus_in(Mem_bus_in),.mem_bus_out(Mem_bus_out),.mem_data_strobe(Mem_data_strobe),.mem_bus_rw(Mem_bus_rw),.clk(Clk),.reset(Reset));

main_sobel main_sobel_ins(.bus_in(Bus_in),.bus_out(Bus_out),.bus_rw(Bus_rw),.data_strobe(Data_strobe),.clk(Clk),.reset(Reset));
endmodule
