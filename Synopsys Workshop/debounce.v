// Switch Debounce Module
// use your system clock for the clock input
// to produce a synchronous, debounced output
module debounce (g_reset, clk, noisy, clean);

    parameter DELAY = 2;   // .01 sec with a 27Mhz clock
    input g_reset, clk, noisy;
    output clean;

    reg [18:0] count;
    reg new, clean;

    always @(posedge clk) begin
        if (!g_reset) begin
            count <= 0;
            new <= noisy;
            clean <= noisy;
        end else if (noisy != new) begin
	        new <= noisy;
	        count <= 0;
        end else if (count == DELAY)
            clean <= new;
        else count <= count+19'd1;
    end
      
endmodule
