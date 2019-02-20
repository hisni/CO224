module fsm(clk,g_reset,sensor_sync,WR_Out_1,WR_Out_2,prog_sync,expired,WR_Reset,interval,start_timer,lights);

    parameter s1 = 4'd1,s2 = 4'd2,s3 = 4'd3,s4 = 4'd4,s5 = 4'd5,s6 = 4'd6,s7 = 4'd7,s8 = 4'd8,s9 = 4'd9;
    parameter n = 4'd0;
    parameter tBase = 2'b00, tExt = 2'b01, tYel = 2'b10, tZero = 2'b11;

    input sensor_sync,WR_Out_1,WR_Out_2,expired,clk,g_reset,prog_sync;
    output reg WR_Reset,start_timer;
    output reg [1:0] interval;
    output reg [7:0] lights;

    reg [3:0] next_state,current_state;    
          
    always @ (posedge clk) begin

        if (!g_reset)begin
            current_state   <= s1;
            next_state      <= s1;
            lights          <= 8'd0;
            start_timer     <= 1;
        end 
        else if (current_state == next_state) begin
            case(current_state)
                s1: begin
                        next_state <= s2;
                        interval <= tBase;
                    end
                s2: begin
                        next_state <= s3;
                        if(sensor_sync) interval <= tExt;
                        else interval <= tBase;
                    end
                s3: begin
                        if( WR_Out_1 && WR_Out_2 )begin
                            next_state <= s7;
                            WR_Reset = 1;
                        end 
                        else if( WR_Out_1 && (!WR_Out_2) )begin
                            next_state <= s8;
                            WR_Reset = 1;
                        end
                        else if( (!WR_Out_1) && WR_Out_2 )begin
                            next_state <= s9;
                            WR_Reset = 1;
                        end 
                        else next_state <= s4;
                        interval <= tYel;
                    end
                s4: begin
                        next_state <= s5;
                        interval <= tBase;
                    end
                s5: begin
                        next_state <= s6;
                        if(sensor_sync)interval <= tExt;
                        else interval <= tZero;
                    end
                s6: begin
                        next_state <= s1;
                        interval <= tYel;
                    end
                s7: begin
                        next_state <= s4;
                        interval <= tExt;
                    end
                s8: begin
                        next_state <= s4;
                        interval <= tExt;
                    end
                s9: begin
                        next_state <= s4;
                        interval <= tExt;
                    end
            endcase
        end else begin
            start_timer = 0;
            WR_Reset = 0;
        end
    end

    always @ (posedge expired) begin
        current_state = next_state;
        start_timer = 1;
    end

    always @ (*) begin
        case (current_state)            
            s1: lights = 8'b11001111;
            s2: lights = 8'b11001111;
            s3: lights = 8'b10101111;
            s4: lights = 8'b01111011;
            s5: lights = 8'b01111011;
            s6: lights = 8'b01110111;
            s7: lights = 8'b01101100;
            s8: lights = 8'b11001101;
            s9: lights = 8'b01111010;
        endcase
    end

endmodule