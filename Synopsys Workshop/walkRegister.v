`timescale 1ns/1ps

module walkRegister( clk, g_reset, WR_Sync_1, WR_Sync_2, WR_Reset, WR_Out_1, WR_Out_2 );
    
    input clk, g_reset;
    input WR_Sync_1, WR_Sync_2, WR_Reset;
    output reg WR_Out_1, WR_Out_2;

    always @(posedge clk, posedge g_reset) begin
        if ( WR_Reset | !g_reset ) begin
            WR_Out_1 = 0;
            WR_Out_2 = 0;
        end
        else begin
            if( WR_Sync_1 ) WR_Out_1 = 1;
            if( WR_Sync_2 ) WR_Out_2 = 1;
        end  
    end
endmodule
