`timescale 1ns/1ps

module mem_sobel (mem_bus_in,mem_bus_out,mem_data_strobe,mem_bus_rw,clk, reset);

input [7:0] mem_bus_in;		
output reg [71:0] mem_bus_out;	

input mem_data_strobe;	// Signal to control reading and writing
input mem_bus_rw;		// Signal to control bus READ=1 WRITE = 0
input reset;		
input clk;			

reg [7:0] mem [479:0][639:0];	// 307200 byte RAM

reg [8:0] row1;	
reg [9:0] col1;
reg [8:0] row;
reg [9:0] col;		
reg write_en,read_en;	// internal registers for correct read/write operations.
reg [8:0] index;
reg [9:0] index2;

always @( clk,negedge reset)
begin
	if(!reset)						
	begin
		row1 = 9'b0;
		col1 = 10'b0;
		row = 9'b0;
		col = 10'b0;
		read_en = 1'b0;				//  Enable reading from FPGA	
		write_en = 1'b0;				//  Enables writing to FPGA 			
		for(index=0;index<480;index=index+1)		// fill entire memory with zero
			for(index2=0;index2<640;index2=index2+1)
				mem [index][index2] = 8'b00000000;
		mem_bus_out = 72'b0;
		index2 = 10'b0;
	end
	
	else if(!mem_data_strobe & !mem_bus_rw & !write_en)	// condition for writing data to RAM
	begin
		mem[row][col] = mem_bus_in;		// writes the data at bus_in to RAM
		if (row != 480)
			begin
				if (col != 639)
					col = col + 1;
				else
					begin
						row = row + 1;
						col = 0;
					end
			end
		else
			begin
				row = 0;
				col = 0;
			end	            
		write_en = 1'b1;	
	end

	else if(!mem_data_strobe & mem_bus_rw & !read_en)	// condition for reading from RAM
	begin	// Make 3x3 valid blocks of data and sweep the memory
		if(row != 478 )	
			begin	
				if(col != 638 )	
					begin
						mem_bus_out = {mem[row][col],mem[row+1][col],mem[row+2][col],mem[row][col+1],mem[row+1][col+1],mem[row+2][col+1],mem[row][col+2],mem[row+1][col+2],mem[row+2][col+2]};
						read_en = 1'b1;
						col = col + 1;
					end
				else
					begin
						mem_bus_out = {mem[row+1][0],mem[row+2][0],mem[row+3][0],mem[row+1][1],mem[row+2][1],mem[row+3][1],mem[row+1][2],mem[row+2][2],mem[row+3][2]};
						col = 1;
						read_en = 1'b1;
						row = row + 1;
					end	
			end	
	end		
	
	else if(mem_data_strobe)
		begin
			write_en = 1'b0;
			read_en = 1'b0;			
		end
	else
		begin
			mem_bus_out = mem_bus_out;
		end

end

endmodule
	
	
	
	
	
	
	
	
	
