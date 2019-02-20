`timescale 1ns/1ps

`include "labkit.v"

module top();

    reg clk,g_reset,sensor,walk_request_1,walk_request_2,reprogram;
    reg [1:0] time_parameter_selector;
    reg [3:0] time_value;

    wire [7:0] leds;
    
    labkit labkitMod(clk,g_reset,sensor,walk_request_1,walk_request_2,reprogram,time_parameter_selector,time_value,leds);
    
    initial forever #1 clk = ~clk;

    always @clk $display("CLK = %d  Sensor = %d  WR_Main = %d  WR_Side = %d  LEDs = %b  Reprogram = %d",clk,sensor,walk_request_1,walk_request_2,leds,reprogram);
	
    initial begin
        
        clk             <= 0;
        g_reset         <= 1;
        sensor          <= 0;
        walk_request_1  <= 0;
        walk_request_2  <= 0;
        reprogram       <= 0;

        #2 g_reset = 0;
        #2 g_reset = 1;

        #50 sensor=1;
        #150 sensor=0;

        #50 walk_request_1 = 1; walk_request_2 = 1;
        #20 walk_request_1 = 0; walk_request_2 = 0;

        #30 sensor = 1;
        #200 sensor = 0;

        #200 walk_request_1 = 1;
        #20 walk_request_1 = 0;

        #200 time_parameter_selector = 2'b00;time_value = 4'd10;
        #210 reprogram = 1;
        #220 reprogram = 0;

        #200 time_parameter_selector = 2'b01;time_value = 4'd9;
        #210 reprogram = 1;
        #220 reprogram = 0;

        #200 time_parameter_selector = 2'b10;time_value = 4'd8;
        #210 reprogram = 1;
        #220 reprogram = 0;

        #50 sensor=1;
        #200 sensor=0;

        #150 walk_request_2 = 1;
        #20 walk_request_2 = 0;

        #30 sensor = 1;
        #100 sensor = 0;

        #1000 $finish();
    
    end
endmodule
