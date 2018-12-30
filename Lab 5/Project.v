/*
	Group 09 (E/15/131, E/15/348)
	Simple Processor
*/

// ******** ALU ********
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

// ******** Register File ********
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

// ******** Program Counter ********
module counter(clk, reset, Read_addr);
	input clk;
	input reset;
	output [31:0] Read_addr;
	reg Read_addr;

	always @(negedge clk)
	begin
		case(reset)
			1'b1 : begin Read_addr = 32'd0; end
			1'b0 : begin Read_addr = Read_addr + 3'b100; end
		endcase
	end
endmodule

// ******** Multiplexer ********
module MUX( OUTPUT, clk, INPUT1, INPUT2, CTRL );
	input [7:0] INPUT1, INPUT2;
	output [7:0] OUTPUT;
	input CTRL, clk;
	reg [7:0] OUTPUT;

	always @(negedge clk)
	begin
		case( CTRL )
			1'b0 : begin OUTPUT <= INPUT1; end
			1'b1 : begin OUTPUT <= INPUT2; end
		endcase
	end
endmodule

// ******** 2's Complement ********
module TwosComplement( OUTPUT, INPUT );
	input signed [7:0] INPUT;
	output signed [7:0] OUTPUT;

	assign OUTPUT = ~INPUT + 8'b00000001;

endmodule

// ******** Instruction Register ********
module Instruction_reg (clk, Read_Addr, instruction);
	input clk;
	input [31:0] Read_Addr;
	output [31:0] instruction;
	reg instruction;

	always @(negedge clk) 
	begin
	instruction = Read_Addr;
	end
endmodule

// ******** Control Unit ********
module CU( instruction, OUT1addr, OUT2addr, INaddr, Imm, Select, addSubMUX, imValueMUX );
	input [31:0] instruction;
	output [2:0] OUT1addr;
	output [2:0] OUT2addr;
	output [2:0] Select;
	output [2:0] INaddr;
	output [7:0] Imm;
	output addSubMUX,imValueMUX;

	reg [2:0] OUT1addr,OUT2addr,INaddr,Select;
	reg [7:0] Imm;
	reg addSubMUX,imValueMUX; 

	always @(instruction) 
		begin
			case(instruction[31:24])
				
			8'b00000000 : begin  //loadi
				assign Select = instruction[26:24];		//Needed For ALU selection
				assign Imm = instruction[7:0];			//Immediate Value
				assign addSubMUX = 1'b0;				//*****Ignore*****
				assign imValueMUX = 1'b0;				//CS Select Imm Value for ALU
				assign OUT1addr = instruction[2:0];		//*****Ignore*****
				assign OUT2addr = instruction[10:8];	//*****Ignore*****
				assign INaddr = instruction[18:16];		//Destination Address
				end
			8'b00001000 : begin  //mov
				assign Select = instruction[26:24];		//Needed For ALU selection
				assign Imm = instruction[7:0];			//*****Ignore*****
				assign addSubMUX = 1'b0;				//*****Ignore*****
				assign imValueMUX = 1'b1;				//Select from Source 1
				assign OUT1addr = instruction[2:0];		//Source 1
				assign OUT2addr = instruction[10:8];	//*****Ignore*****
				assign INaddr = instruction[18:16];		//Destination Address
				end
			8'b00000001 : begin //add
				assign Select = instruction[26:24];		//Needed For ALU selection
				assign Imm = instruction[7:0];			//*****Ignore*****
				assign addSubMUX = 1'b0;				//Select directly from Source 2
				assign imValueMUX = 1'b1;				//Select from Source 1
				assign OUT1addr = instruction[2:0];		//Source 1
				assign OUT2addr = instruction[10:8];	//Source 2
				assign INaddr = instruction[18:16];		//Destination Address
				end
			8'b00001001 : begin //sub
				assign Select = instruction[26:24];		//Needed For ALU selection
				assign Imm = instruction[7:0];			//*****Ignore*****
				assign addSubMUX = 1'b1;				//2's complements of Source 2
				assign imValueMUX = 1'b1;				//Select from Source 1
				assign OUT1addr = instruction[2:0];		//Source 1
				assign OUT2addr = instruction[10:8];	//Source 2
				assign INaddr = instruction[18:16];		//Destination Address
				end
			8'b00000010 : begin //and
				assign Select = instruction[26:24];		//Needed For ALU selection
				assign Imm = instruction[7:0];			//*****Ignore*****
				assign addSubMUX = 1'b0;				//Select directly from Source 2
				assign imValueMUX = 1'b1;				//Select from Source 1
				assign OUT1addr = instruction[2:0];		//Source 1
				assign OUT2addr = instruction[10:8];	//Source 2
				assign INaddr = instruction[18:16];		//Destination Address
				end
			8'b00000011 : begin //or
				assign Select = instruction[26:24];		//Needed For ALU selection
				assign Imm = instruction[7:0];			//*****Ignore*****
				assign addSubMUX = 1'b0;				//Select directly from Source 2
				assign imValueMUX = 1'b1;				//Select from Source 1
				assign OUT1addr = instruction[2:0];		//Source 1
				assign OUT2addr = instruction[10:8];	//Source 2
				assign INaddr = instruction[18:16];		//Destination Address
				end
			
			endcase
		end
endmodule

module Processor();


endmodule







/*
// ******** Test Register File ********
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
 
// ******** Test ALU ********
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