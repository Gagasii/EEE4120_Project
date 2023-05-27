`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Muzerengwa VI
// 
// Create Date: 09.05.2023 10:06:20
// Design Name: 
// Module Name: median_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module median_tb;

  // Parameters
  parameter WIDTH = 3;
  parameter HEIGHT = 3;
  
  // Inputs and outputs
  reg clk;
  reg rst;
  reg [7:0] pixel_in;
  wire [7:0] pixel_out;
  
  // Instantiate median filter
  median dut(
    .clk(clk),
    .rst(rst),
    .pixel_in(pixel_in),
    .pixel_out(pixel_out)
  );
  
  // Testbench variables
  integer file_in;
  integer file_out;
  reg [7:0] img [0:WIDTH*HEIGHT-1];
  integer i;
  reg [7:0] pixel_denoised;
  
  // Initialize testbench
  initial begin
    // Open input and output files
    file_in = $fopen("img.txt", "r");
    file_out = $fopen("denoised.txt", "wb");
    
    // Initialize inputs
    clk = 0;
    rst = 1;
    pixel_in = 0;
    
    // Wait for reset to complete
    #10;
    rst = 0;
    
    // Read input file and apply to filter
    i = 0;
    while (!$feof(file_in)) begin
      img[i] = $fgetc(file_in);
      if (i == WIDTH*HEIGHT-1) begin
        // Apply pixel to filter
        pixel_in = img[4]; // Center pixel
        #10;
        
        // Read output pixel and write to file
        pixel_denoised = pixel_out;
        $fwrite(file_out, "%b\n", pixel_denoised);
        
        // Shift input image
        for (i = 0; i < WIDTH*HEIGHT-1; i = i + 1) begin
          img[i] = img[i+1];
        end
        img[WIDTH*HEIGHT-1] = $fgetc(file_in);
        
        // Reset index
        i = 0;
      end else begin
        i = i + 1;
      end
    end
    
    // Close files and finish simulation
    $fclose(file_in);
    $fclose(file_out);
    $finish;
  end
  
  // Toggle clock
  always #5 clk = ~clk;

endmodule


