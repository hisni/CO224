`timescale 1ns/1ps

module time_param(clk,g_reset,prog_sync,param_selector,time_value,interval,value);

	input clk,g_reset,prog_sync;
	input [1:0] param_selector;
	input [3:0] time_value;
	input [1:0] interval;
	
	output reg [3:0] value;
	
	parameter [3:0] tBase   = 4'd6;
	parameter [3:0] tExt    = 4'd3;
	parameter [3:0] tYel    = 4'd2;
    parameter [3:0] tZero   = 4'd0;
	
	reg [3:0] tBaset;
	reg [3:0] tExtt;
	reg [3:0] tYelt;
    reg [3:0] tZerot;

	always @ (negedge g_reset) begin
		tBaset  <= tBase;
		tExtt   <= tExt;
		tYelt   <= tYel;
        tZerot  <= tZero;
	end
	
	always @ (posedge prog_sync) begin
		if      (param_selector==2'b00) tBaset  = time_value;
		else if (param_selector==2'b01) tExtt   = time_value;
		else if (param_selector==2'b10) tYelt   = time_value;
	end
	
	always @ (posedge clk) begin
		if      (interval==2'b00) value = tBaset;
		else if (interval==2'b01) value = tExtt;
		else if (interval==2'b10) value = tYelt;
        else if (interval==2'b11) value = tZerot;
	end

endmodule

