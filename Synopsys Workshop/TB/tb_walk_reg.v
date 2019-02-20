`timescale 1ns/1ps
`include "walkRegister.v"

module tb_walk_reg();
	
	reg clk,g_reset;
	reg WR_Sync,WR_Reset;
	wire WR_Out;
	
	walkRegister w1(clk,g_reset,WR_Sync,WR_Reset,WR_Out);
	
	initial begin
	
		clk = 0;
        g_reset = 1;
        WR_Sync = 0;

        #2 g_reset = 0;
        #6 g_reset = 1;

		#1 WR_Sync = 0;WR_Reset = 0;
		#1 WR_Sync = 1;
		#10 WR_Sync = 0;
		
		#5 WR_Reset = 1;
		#2 WR_Reset = 0;
		
		#2 WR_Sync = 1;
		#10 WR_Sync = 0;

        #8 g_reset = 0;
        #4 g_reset = 1;
		
		#20 $finish();
	end
	
	initial forever #1 clk = ~clk;


endmodule
