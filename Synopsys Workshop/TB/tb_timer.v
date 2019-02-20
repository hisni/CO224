`timescale 1ns/1ps
`include "timer.v"

module tb_timer();
    
    reg clk,g_reset,start_timer;
    reg [3:0] value;
    wire expired;

    timer t1(clk,g_reset,value,start_timer,expired);

    initial forever #1 clk = ~clk;

    initial begin
        
        clk = 0;
        g_reset = 1;
        start_timer = 0;

        value = 4'd3;

        #1 g_reset = 0;
        #3 g_reset = 1;

        #3 start_timer = 1;
        #1 start_timer = 0;

        #120 value = 4'd5;
        #1 start_timer = 1;
        #1 start_timer = 0;

        #120 value = 4'd1;
        #1 start_timer = 1;
        #1 start_timer = 0;

        #50 $finish();
    
    end

endmodule
