`timescale 1ns/1ps

module testbench_sobel (mem_bus_in,mem_bus_out,mem_data_strobe,mem_bus_rw,bus_in,bus_out,data_strobe,bus_rw,clk, reset);

output reg [7:0] mem_bus_in;
input [71:0] mem_bus_out;
output reg [71:0] bus_in;
input [7:0] bus_out;
output reg mem_data_strobe;
output reg data_strobe;
output reg reset;
output reg clk;
output reg mem_bus_rw;
output reg bus_rw;
reg [9:0] col;
reg [18:0] Count1;
reg [18:0] Count2;
reg clk2;
reg [8:0] row;
reg tmp;
integer datafile,result;

//clk
initial begin
	clk=0;
	forever #5 clk=~clk;
end
	
//Initial values
initial begin
	reset=1;
	mem_data_strobe=1;
	mem_bus_rw=0;
	bus_rw = 0;
	data_strobe=1;
	Count1 = 19'b0;
	Count2 = 19'b0;
	row=9'b0;
	col=10'b0;
	#5 reset=0;
	#20 reset=1;
	
end
	
//make a new file to read data and save results
	initial begin
	result=$fopen ("results.txt","w");
	datafile=$fopen ("img.txt", "r");
	end

//Load data	To Mem
	always @ ( clk)
		begin
			if(reset)
				begin
					if(!mem_bus_rw)
						begin
							if(clk)
								begin
									mem_data_strobe <= 1;
									if(row != 480)
										begin
											if(col != 640)
												begin
													col <= col+1;
												end
											else if (col == 640)
												begin
													tmp=$fscanf(datafile,"%d\n",mem_bus_in);
													col <= 1;
													row <= row+1;
												end
										end
									else
										begin
											mem_bus_rw <= 1;
											row <= 0;
											col <= 0;
										end
								end
							else
								mem_data_strobe <= 0;
						end
				end
		end

//Load data	
	always @ ( clk)
		begin
			if(mem_bus_rw)
				if(!bus_rw)
					begin
						if(clk)
							begin
								
								if(Count1 != 304964)
									begin
										bus_in <= mem_bus_out;
										Count1 <= Count1+1;
										bus_rw <= 1;
									end
								else 
									begin
										Count1 <= 0;
										bus_rw <= 1;
									end
								mem_data_strobe <= 1;
								data_strobe <= 1;
							end
						else
							begin
								data_strobe <= 0;
							end
					end
		end
		
//read from FPGA and write results to file
	always @ ( clk)
		begin
			if(mem_bus_rw)
				if(bus_rw)
					begin
						if(clk)
							begin
								if(Count2 != 304964)
									begin
										$fwrite (result,"%d\n",bus_out);
										Count2 <= Count2+1;
										bus_rw <= 0;
									end
								else
									begin
										mem_bus_rw <= 0;
										bus_rw <= 0;
										Count2 <= 0;
									end
							end
						else
							begin
								mem_data_strobe <= 0;
								data_strobe <= 0;
							end
					end
		end


				
endmodule


	
