`timescale 1ns/1ps
`include "fsm.v"

module tb_fsm();

    reg clk,g_reset,sensor_sync,WR_Out,prog_sync,expired;

    wire start_timer,WR_Reset;
    wire [1:0] interval;
    wire [6:0] lights;

    fsm fsm1(clk,g_reset,sensor_sync,WR_Out,prog_sync,expired,WR_Reset,interval,start_timer,lights);


    initial begin 
        
        clk         <= 0;
        g_reset     <= 1;
        sensor_sync <= 0;
        WR_Out      <= 0;
        prog_sync   <= 0;

        #1 g_reset = 0;
        #3 g_reset = 1;

        #50 WR_Out = 1;




        #200 $finish();

    end


    initial forever #1 clk = ~clk;

    initial forever begin 
        #10 expired = 1;
        #2 expired  = 0;
    end

    always @(WR_Reset) WR_Out = 0;

endmodule
