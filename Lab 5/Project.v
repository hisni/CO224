/*
	Group 09 (E/15/131, E/15/348)
	Simple Processor
*/


module ALU(RESULT, DATA1, DATA2, SELECT);
	input [7:0] DATA1,DATA2;	//Source 1 & 2	
	input [2:0] SELECT;
	output [7:0] RESULT;
	reg [7:0] Res;
	
	assign RESULT= Res;

	always @(DATA1,DATA2,SELECT)
    	begin
        case ( SELECT )
         0 : Res = DATA1;		//Forward ( loadi, mov )
         1 : Res = DATA1 + DATA2;	//Addition ( add, sub )
         2 : Res = DATA1 & DATA2;	//Bitwise AND ( and )
         3 : Res = DATA1 | DATA2;	//Bitwise OR ( or )
	 default : Res = 0;
        endcase 
    end

endmodule


module regfile8x8a ( clk, INaddr, IN, OUT1addr, OUT1, OUT2addr, OUT2);
	
	input [2:0] OUT1addr,OUT2addr,INaddr;
	input [7:0] IN;
	input clk;
	output [7:0] OUT1,OUT2;

	reg [63:0] regMemory = 0;
	reg [7:0] OUT1reg, OUT2reg;
	integer i;
	
	assign OUT1 = OUT1reg[7:0];
	assign OUT2 = OUT2reg[7:0];

	always @(posedge clk) begin
		for(i=0;i<8;i=i+1) begin
			OUT1reg[i] = regMemory[ OUT1addr*8 + i ];
			OUT2reg[i] = regMemory[ OUT2addr*8 + i ];
		end
	end	
	

	always @(negedge clk) begin
		for(i=0;i<8;i=i+1)begin
			regMemory[INaddr*8 + i] = IN[i];
		end		
	end

endmodule


module testregeter;
 
reg [2:0] INaddr,OUT1addr,OUT2addr;
reg clk;
reg [7:0] IN;
wire [7:0] OUT1,OUT2;
reg [2:0] SELECT;
wire [7:0] RESULT;
 
    	regfile8x8a regf ( clk, INaddr, IN, OUT1addr, OUT1, OUT2addr, OUT2);
	ALU test( RESULT,OUT1,OUT2,SELECT);

    	initial begin
    	clk = 1'b0; end
    	always #10 clk = ~clk;
 
initial begin

#5//T=5
	IN = 12;
	INaddr = 5;
	OUT1addr = 5;
	OUT2addr = 3;

#10//T=15								
	$display("OUT1 = %d OUT2 = %d",OUT1,OUT2);
#20//T=35								
	$display("OUT1 = %d OUT2 = %d",OUT1,OUT2);
	IN = 10;
	INaddr = 3;
#10//T=45
	$display("OUT1 = %d OUT2 = %d",OUT1,OUT2);		
#10//T=55
	$display("OUT1 = %d OUT2 = %d",OUT1,OUT2);
	SELECT = 1;
#10//T=65
	$display("%d + %d = %d\n",OUT1,OUT2,RESULT);	

$finish;

end
endmodule



/*
module testALU;

    reg [7:0] DATA1;
    reg [7:0] DATA2;
    reg [2:0] SELECT;

    wire [7:0] RESULT;

    ALU test( RESULT,DATA1,DATA2,SELECT);
    
    initial begin
        // Apply inputs.
        DATA1 = 45;	//110
        DATA2 = 6;	//011

        SELECT = 0; #100;
	$display("%d\n",RESULT);

        SELECT = 1; #100;
	$display("%d\n",RESULT);        

	SELECT = 2; #100;
	$display("%b & %b = %b\n",DATA1,DATA2,RESULT);

	SELECT = 3; #100;
	$display("%b | %b = %b\n",DATA1,DATA2,RESULT);
    end
      
endmodule
*/
