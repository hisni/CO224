module timer(clk,g_reset,oneHzEnable,value,start_timer,expired);

    input clk,g_reset,oneHzEnable,start_timer;
    input [3:0] value;

    output reg expired;

    reg [3:0] counter;
    reg flag_start;

    always @ (posedge clk) begin
        if (!g_reset) begin
            flag_start = 0;
            counter = 4'd0;
            expired = 0;
        end else if (start_timer) begin 
            flag_start = 1;
            counter = 4'd0;
            expired = 0;
        end else if (counter == value) begin
            flag_start = 0;
            counter = 4'd0;
            expired = 1;
        end else if (oneHzEnable & flag_start) counter = counter + 4'd1;
    end

endmodule
