`timescale 1ns/1ps

module tb1();
	
	reg clk,rst;
	wire clk_out;
	
	divider d1(clk,rst,clk_out);
	
	initial begin
	
		$dumpfile("tb1.vcd");
		$dumpvars(0, tb1);
	
		clk = 0;
		#1 rst = 0;
		#1 rst = 1;
		
		$display("asda");
		
		#100 $finish();
		
	end
	initial forever #1 clk = ~clk;


endmodule
