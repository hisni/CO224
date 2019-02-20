`timescale 1ns/1ps
`include "synchronizer.v"

module tb_synchonizer();

    reg clk,g_reset,in;    
    wire out;

    synchronize syncMod(clk,g_reset,in,out);

    initial forever #1 clk = ~clk;

    initial begin 

        clk = 0;
        g_reset = 1;
        in = 0;

        #1 g_reset = 0;
        #2 g_reset = 1;

        #1 in = 0;
        #1 in = 1;
        #10 in  = 0;

        #1 in = 0;
        #10 in = 1;
        #15 in  = 0;



        #50 $finish();

    end




endmodule
