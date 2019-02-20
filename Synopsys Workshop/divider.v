`timescale 1ns/1ps

module divider(clk,rst,clk_out);

	input clk,rst;
	output reg clk_out;
	reg [25:0] counter;

	always @(posedge clk or negedge rst) begin
			if(!rst) begin 
				counter = 26'd0;
				clk_out = 1;
			end else if(counter==26'd10) begin
				counter = 26'd0;
				clk_out = 1;
			end else clk_out = 0;
		
			counter = counter + 26'd1;
	end

endmodule
