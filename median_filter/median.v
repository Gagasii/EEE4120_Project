`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09.05.2023 10:09:11
// Design Name: 
// Module Name: median
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

module median_pipeline (
  input clk,
  input rst,
  input [7:0] pixel_in,
  output reg[7:0] pixel_out
);

  parameter WIDTH = 3;
  parameter HEIGHT = 3;

  reg [7:0] buffer [0:WIDTH-1][0:HEIGHT-1];
  reg [7:0] sorted [0:WIDTH*HEIGHT-1];

  integer i, j, k, l;

  reg [7:0] buffer_shifted[0:WIDTH-1][0:HEIGHT-1];
  reg [7:0] sorted_stage1[0:WIDTH*HEIGHT-1];
  reg [7:0] sorted_stage2[0:WIDTH*HEIGHT-1];

  always @(posedge clk) begin
    if (rst) begin
      for (i = 0; i < WIDTH; i = i + 1) begin
        for (j = 0; j < HEIGHT; j = j + 1) begin
          buffer[i][j] <= 0;
        end
      end
    end else begin
      // Pipeline Stage 1: Shift buffer and update first row
      for (i = 0; i < WIDTH; i = i + 1) begin
        for (j = HEIGHT-1; j > 0; j = j - 1) begin
          buffer_shifted[i][j] <= buffer_shifted[i][j-1];
        end
        buffer_shifted[i][0] <= pixel_in;
      end

      // Pipeline Stage 2: Sort pixels in buffer
      k = 0;
      for (i = 0; i < WIDTH; i = i + 1) begin
        for (j = 0; j < HEIGHT; j = j + 1) begin
          sorted_stage1[k] = buffer_shifted[i][j];
          k = k + 1;
        end
      end

      // Pipeline Stage 3: Perform bubble sort on sorted_stage1
      for (i = 0; i < WIDTH*HEIGHT; i = i + 1) begin
        for (j = i + 1; j < WIDTH*HEIGHT; j = j + 1) begin
          if (sorted_stage1[i] > sorted_stage1[j]) begin
            l = sorted_stage1[i];
            sorted_stage1[i] = sorted_stage1[j];
            sorted_stage1[j] = l;
          end
        end
      end

      // Pipeline Stage 4: Store the sorted result in sorted_stage2
      sorted_stage2 <= sorted_stage1;

      // Set output to median pixel
      pixel_out = sorted_stage2[WIDTH*HEIGHT/2];
    end
  end

endmodule

