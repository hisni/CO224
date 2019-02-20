`timescale 1ns/1ps
`include "walkRegister.v"

module tb_walk_reg();
	
	reg clk,g_reset;
	reg WR_Sync_1,WR_Sync_2,WR_Reset;
	wire WR_Out_1,WR_Out_2;
	
	walkRegister w1(clk,g_reset,WR_Sync_1,WR_Sync_2,WR_Reset,WR_Out_1,WR_Out_2);
	
	initial begin
	
		clk = 0;
        g_reset = 1;
        WR_Sync_1 = 0;
        WR_Sync_2 = 0;

        #2 g_reset = 0;
        #6 g_reset = 1;

		#1 WR_Sync_1 = 0; WR_Sync_2 = 0; WR_Reset = 0;
		#1 WR_Sync_1 = 1; WR_Sync_2 = 1;
		#10 WR_Sync_1 = 0;
		#10 WR_Sync_2 = 0;
		
		#5 WR_Reset = 1;
		#2 WR_Reset = 0;
		
		#2 WR_Sync1 = 1;
		#10 WR_Sync1 = 0;

        #8 g_reset = 0;
        #4 g_reset = 1;
		
		#20 $finish();
	end
	
	initial forever #1 clk = ~clk;

endmodule