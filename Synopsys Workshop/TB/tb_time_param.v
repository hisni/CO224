`timescale 1ns/1ps
`include "time_param.v"

module tb_time_para();
	
	reg clk,g_reset,prog_sync;
	reg [1:0] param_selector,interval;
	reg [3:0] time_value;
	
	wire [3:0] value;
	
	time_para time_para1(clk,g_reset,prog_sync,param_selector,time_value,interval,value);

	initial begin
		clk = 0;prog_sync = 0;
		
		#1 g_reset = 1;
		#1 g_reset = 0;
		#4 g_reset = 1;
		
		#1 interval = 2'd0;
		#2 interval = 2'd1;
		#2 interval = 2'd2;
        #2 interval = 2'd3<F4>;

		#2 param_selector = 2'd0;
		#1 time_value = 4'd9;
		
		#1 prog_sync = 1;
		#10 prog_sync = 0;
						
		#20 $finish();
	end
	
	initial forever #1 clk = ~clk;

endmodule
