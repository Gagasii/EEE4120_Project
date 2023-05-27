`timescale 1ns/1ps
module main_sobel (bus_in,bus_out,data_strobe, bus_rw,clk, reset);

input [71:0] bus_in;
output reg [7:0] bus_out;

input data_strobe;	// Signal to control reading and writing
input bus_rw;		// Signal to control bus READ=1 WRITE = 0
input reset;
input clk;

reg [7:0] row3 [2:0];	//3x3 RAM to store data and transfer them to sobel core
reg [7:0] row2 [2:0];
reg [7:0] row1 [2:0];
reg write_en,read_en;	// internal registers for correct read/write operations.

wire [7:0] out1;					
core_sobel s1(row1[0],row1[1],row1[2],
 row2[0],row2[2],
 row3[0],row3[1],row3[2],out1);
 
always @( clk, negedge reset)
begin
	if(!reset)						
	begin
		read_en = 1'b0;				// Enables reading from FPGA	
		write_en = 1'b0;				// Enables writing to FPGA 			
		bus_out = 8'hff;			// Set bus_out reg value to FF
	end

	else if(!data_strobe & !bus_rw & !write_en)	// condition for writing data to 3x3 RAM block
	begin
		{row1[0],row2[0],row3[0],row1[1],row2[1],row3[1],row1[2],row2[2],row3[2]} = bus_in;		// writes the data at bus_in to RAM location pointed by WAddr
		write_en = 1'b1;			// Ensures correct write operation
	end

	else if(!data_strobe & bus_rw & !read_en)	// condition for reading from 3x3 RAM block 
	begin
		bus_out = out1;		// Send data to sobel core
		read_en = 1'b1;		// Ensure correct read operation
	end

	else if(data_strobe)
	begin
		write_en = 1'b0;
		read_en = 1'b0;			
	end
	else
	begin
		bus_out = bus_out;
	end
end



endmodule
