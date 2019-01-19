module regtest( rst, index, data );
    input [2:0]index;
    input rst;
    output [15:0] data;
    reg [15:0] data;

    reg [7:0] cache_ram [15:0];

    integer i;

    always @( rst )			//Reset Data memory
	begin
		if ( rst )
		begin
			for (i=0;i<7; i=i+1)
				cache_ram[i] <= 0;
		end
	end

    always @( index, data ) begin 
        cache_ram[3]  = 15;
        data =  cache_ram[index];
    end
    

endmodule

module testasd;

    reg [2:0] id;
    wire [15:0]out;
    reg rst;

    regtest regte( rst,id,out );

    initial begin
        rst = 1;
        #5
        rst = 0;
        #5

        id = 1;
        #10
        $display("**** %d \n",out);
		id = 2;
        #10
        $display("**** %d \n",out);
        id = 3;
        #10
        $display("**** %d \n",out);
		$finish;
    end


endmodule