`timescale 1ns/1ps

`include "labkit.v"

module top();

    reg clk,g_reset,sensor,walk_request,reprogram;
    reg [1:0] time_parameter_selector;
    reg [3:0] time_value;

    wire [6:0] leds;
    
    labkit labkitMod(clk,g_reset,sensor,walk_request,reprogram,time_parameter_selector,time_value,leds);
    
    initial forever #1 clk = ~clk;

    initial begin
        
        clk             <= 0;
        g_reset         <= 1;
        sensor          <= 0;
        walk_request    <= 0;
        reprogram       <= 0;

        #2 g_reset = 0;
        #2 g_reset = 1;


        #50 sensor=1;
        #100 sensor=0;

        #50 walk_request = 1;
        #20 walk_request = 0;

        #30 sensor = 1;
        #100 sensor = 0;



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
        #100 sensor=0;

        #50 walk_request = 1;
        #20 walk_request = 0;

        #30 sensor = 1;
        #100 sensor = 0;



        #1000 $finish();

    end


endmodule
