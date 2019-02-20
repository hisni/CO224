`timescale 1ns/1ps

`include "debounce.v"
`include "synchronizer.v"
`include "walkRegister.v"
`include "divider.v"
`include "timer.v"
`include "time_param.v"
`include "fsm.v"

module labkit(clk,g_reset,sensor,walk_request_1,walk_request_2,reprogram,time_parameter_selector,time_value,leds);

    input clk,g_reset,sensor,walk_request_1,walk_request_2,reprogram;
    input [1:0] time_parameter_selector;
    input [3:0] time_value;

    output [7:0] leds;

    //cleaned outputs
    wire clean_g_reset,clean_sensor,clean_walk_request_1,clean_walk_request_2,clean_reprogram;

    //snchronized outputs
    wire g_reset_sync,sensor_sync,walk_request_sync_1,walk_request_sync_2,reprogram_sync;

    //walk Register Outputs
    wire WR_Out_1,WR_Out_2;

    //Divider Outouts
    wire oneHzEnable;

    //Timer Outputs
    wire expired;
    
    //Time Parameter Outputs
    wire [3:0] value;
    
    //FSM Outputs
    wire [1:0] interval;
    wire WR_Reset;
    wire start_timer;

    debounce debounce_g_reset        (g_reset, clk, g_reset        , clean_g_reset       );
    debounce debounce_sensor         (g_reset, clk, sensor         , clean_sensor        );
    debounce debounce_walk_request_1 (g_reset, clk, walk_request_1 , clean_walk_request_1);
    debounce debounce_walk_request_2 (g_reset, clk, walk_request_2 , clean_walk_request_2);
    debounce debounce_reprogram      (g_reset, clk, reprogram      , clean_reprogram     );

    synchronize synchronize_g_reset        (clk,clean_g_reset       ,g_reset_sync        );
    synchronize synchronize_sensor         (clk,clean_sensor        ,sensor_sync         );
    synchronize synchronize_walk_request_1 (clk,clean_walk_request_1,walk_request_sync_1 );
    synchronize synchronize_walk_request_2 (clk,clean_walk_request_2,walk_request_sync_2 );
    synchronize synchronize_reprogram      (clk,clean_reprogram     ,reprogram_sync      );
      
    walkRegister walkRegister_Mod(clk,g_reset,walk_request_sync_1,walk_request_sync_2,WR_Reset,WR_Out_1,WR_Out_2);

    divider divider_Mod(clk,g_reset,oneHzEnable);

    timer timer_Mod(clk,g_reset,oneHzEnable,value,start_timer,expired);
    
    time_param time_param_Mod(clk,g_reset,reprogram_sync,time_parameter_selector,time_value,interval,value);
    
    fsm fsm_Mod(clk,g_reset,sensor_sync,WR_Out_1,WR_Out_2,reprogram_sync,expired,WR_Reset,interval,start_timer,leds);

endmodule