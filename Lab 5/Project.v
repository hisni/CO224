/*
	Group 09 (E/15/131, E/15/348)
	Simple Processor
*/


module ALU(RESULT, DATA1, DATA2, SELECT);
	input [7:0] DATA1,DATA2;	//Source 1 & 2
	input [2:0] SELECT;
	output [7:0] RESULT;

	wire [7:0] Reg1,Reg2;
    	reg [7:0] Reg3;
    
    	assign Reg1 = DATA1;
    	assign Reg2 = DATA2;
	assign RESULT= Reg3;

	always @( SELECT )
    	begin
        case ( SELECT )
         0 : Reg3 = Reg1;		//Forward ( loadi, mov )
         1 : Reg3 = Reg1 + Reg2;	//Addition ( add, sub )
         2 : Reg3 = Reg1 & Reg2;	//Bitwise AND ( and )
         3 : Reg3 = Reg1 | Reg2;	//Bitwise OR ( or )
	 default : Reg3 = 0;
        endcase 
    end

endmodule

/*
module regfile8x8a ( clk, INaddr, IN, OUT1addr, OUT1, OUT2addr, OUT2);
	input [2:0] OUT1addr,OUT1addr,INaddr;
	input [7:0] IN;
	input clk;
	output [7:0] OUT1,OUT2;
	

endmodule
*/

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