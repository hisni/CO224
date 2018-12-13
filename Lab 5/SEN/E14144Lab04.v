
/// Author: Jazeel Ismail (E/14/144)
/// CO224 lab04

////////  ALU

module alu(Result,DATA1,DATA2,Select);
input [7:0] DATA1,DATA2;
input [2:0] Select;
output signed [7:0] Result;
reg [7:0] Result;
always @(DATA1,DATA2,Select)
	begin 
	
		case(Select)
			3'b000 : begin Result = DATA1; end
			3'b001 : begin Result = DATA1 + DATA2; end
			3'b010 : begin Result = DATA1 & DATA2; end
			3'b011 : begin Result = DATA1 | DATA2; end
		    3'b100 : $display("Select is invalid");
		    3'b101 : $display("Select is invalid");
		    3'b110 : $display("Select is invalid");
		    3'b111 : $display("Select is invalid");
		endcase
	end
endmodule


/*
module ALUtestbench;

	reg [7:0] x,y;
	reg [2:0] i;
	wire [7:0] z;
	
	alu al1(z,x,y,i);
	
	initial
		begin 

		x = 8'b01000011; y = 8'b10001100; i = 3'b111;
		#5;
		$display("%b >> %b  = %b",x,y,z);
		x = 8'b01000011; y = 8'b10001100; i = 3'b001;
		#5;
		$display("%b + %b  = %b",x,y,z);
		x = 8'b01000011; y = 8'b10001100; i = 3'b010;
		#5;
		$display("%b & %b  = %b",x,y,z);
		x = 8'b01000011; y = 8'b10001100; i = 3'b011;
		#5;
		$display("%b | %b  = %b",x,y,z);		
		$finish;
		end
		
endmodule

*/

////// Register File

module regfile8x8a(input clk,input [2:0]INaddr,input [7:0]IN,
				   input [2:0]OUT1addr,output [7:0]OUT1,
				   input [2:0]OUT2addr,output [7:0]OUT2);

reg [7:0] reg0,reg1,reg2,reg3,reg4,reg5,reg6,reg7;

assign OUT1=OUT1addr == 3'b000 ? reg0:
			OUT1addr == 3'b001 ? reg1:
			OUT1addr == 3'b010 ? reg2:
			OUT1addr == 3'b011 ? reg3:
			OUT1addr == 3'b100 ? reg4:
			OUT1addr == 3'b101 ? reg5:
			OUT1addr == 3'b110 ? reg6:
			OUT1addr == 3'b111 ? reg7: 0;

assign OUT2=OUT2addr == 3'b000 ? reg0:
			OUT2addr == 3'b001 ? reg1:
			OUT2addr == 3'b010 ? reg2:
			OUT2addr == 3'b011 ? reg3:
			OUT2addr == 3'b100 ? reg4:
			OUT2addr == 3'b101 ? reg5:
			OUT2addr == 3'b110 ? reg6:
			OUT2addr == 3'b111 ? reg7: 0;

always @(negedge clk) 
	begin 
		case(INaddr)
		
			3'b000 : begin reg0 <= IN ; end
			3'b001 : begin reg1 <= IN ; end 
			3'b010 : begin reg2 <= IN ; end
			3'b011 : begin reg3 <= IN ; end 
			3'b100 : begin reg4 <= IN ; end 
			3'b101 : begin reg5 <= IN ; end 
			3'b110 : begin reg6 <= IN ; end 
			3'b111 : begin reg7 <= IN ; end 
		endcase
		
	end 
endmodule


/*
module rgstrfiletestbench;
 
reg mx1,mx2;
reg [2:0] INaddr,OUT1addr,OUT2addr,Select;
reg signed [7:0] Imm;
wire signed [7:0] Result;
reg clk;

wire signed [7:0] OUT1,OUT2,DATA1,DATA2,cmp;
 
    regfile8x8a regf(.clk(clk),.INaddr(INaddr),.IN(Result),
		.OUT1addr(OUT1addr),.OUT1(OUT1),.OUT2addr(OUT2addr),
		.OUT2(OUT2));
	comp cmp1(.Output(cmp),.Input(OUT1));
	mux mux1(.Output(DATA2),.clk(clk),.Input1(OUT1),.Input2(cmp),.Ctrl(mx1));
	mux mux2(.Output(DATA1),.clk(clk),.Input1(Imm),.Input2(DATA2),.Ctrl(mx2));
	alu al1(.Result(Result),.DATA1(DATA1),.DATA2(OUT2),
			.Select(Select));
			
	initial begin
    clk = 1'b0; end
    always #10 clk = ~clk;
 
initial begin

#20 
	mx1 = 1'b0;
	mx2 = 1'b0;
	INaddr = 3'b010;
	Imm = 8'b00001111;
	Select = 3'b000;
#20
	$display("Source 1 => %d ",Result);

#30 
	Imm = 8'b00001100;
    INaddr = 3'b011;
    Select = 3'b000;
	mx1 = 1'b0;
	mx2 = 1'b0;
#40
	$display("Source 2 => %d ",Result);
  
#60 
	OUT1addr = 3'b010;
	OUT2addr = 3'b011;
	INaddr = 3'b111;   
	mx1 = 1'b0;
	mx2 = 1'b1;
	Select = 3'b001;
 #60
	$display("%d + %d = %d",OUT2,DATA1,Result);
 
#80
	mx1 = 1'b1;
	mx2 = 1'b1;
	Select = 3'b001;
#80 
	$display("%d + %d = %d",OUT2,DATA1,Result);
    $finish;
end
endmodule
*/

/////   Multiplexer

module mux(Output,clk,Input1,Input2,Ctrl);
input signed [7:0] Input1,Input2;
output signed [7:0] Output;
input Ctrl,clk;

reg [7:0] Output;

always @(negedge clk)
	begin
		case(Ctrl)
			1'b0 : begin Output <= Input1; end
			1'b1 : begin Output <= Input2; end
		endcase
	end

endmodule

/*
module muxtestbench;

	reg [7:0] x,y;
	reg c;
	wire [7:0] z;
	
	mux mx1(z,x,y,c);
	
	initial
		begin 

		x = 8'b01000011; y = 8'b10001100; c = 1'b1;
		#5;
		$display("%b >> %b  = %b",x,y,z);
		
		x = 8'b01000011; y = 8'b10001100; c = 1'b0;
		#5;
		$display("%b >> %b  = %b",x,y,z);
		$finish;
		end
endmodule
*/


///////    2's Compliment

module comp(Output,Input);
input signed [7:0] Input;
output signed [7:0] Output;

assign Output = ~Input + 8'b00000001;

endmodule


/*
module comptestbench;
	reg signed [7:0] Input;
	wire signed [7:0] Output; 
	
	comp cmp1(Input,Output);
	
	initial
		begin 

		Input = 8'd66;
		#5;
		$display("%d >> %d",Input,Output);
		
		Input = 8'b10111110;
		#5;
		$display("%d >> %d",Input,Output);
		$finish;
		end
	
endmodule
*/


/////////  Control Unit

module CU(instruction, OUT1addr, OUT2addr, INaddr,Imm,Select,mx1,mx2);
input [31:0] instruction;
output [2:0] OUT1addr;
output [2:0] OUT2addr,Select;
output [2:0] INaddr;
output mx1,mx2;
output [7:0] Imm;

reg [2:0] OUT1addr,OUT2addr,INaddr,Select;
reg [7:0] Imm;
reg mx1,mx2; 

always @(instruction) 
	begin
		case(instruction[31:24])
			
		8'b00000000 : begin  //loadi
			 assign Select = instruction[26:24];
			 assign Imm = instruction[7:0];
			 assign mx1 = 1'b0;
			 assign mx2 = 1'b0;
			 assign OUT1addr = instruction[2:0]; 
			 assign OUT2addr = instruction[10:8];
			 assign INaddr = instruction[18:16];
			 end
		8'b00001000 : begin  //mov
			 assign Select = instruction[26:24];
			 assign Imm = instruction[7:0];
			 assign mx1 = 1'b0;
			 assign mx2 = 1'b1;
			 assign OUT1addr = instruction[2:0]; 
			 assign OUT2addr = instruction[10:8];
			 assign INaddr = instruction[18:16];
			 end
		8'b00000001 : begin //add
			 assign Select = instruction[26:24];
			 assign Imm = instruction[7:0];
			 assign mx1 = 1'b0;
			 assign mx2 = 1'b1;
			 assign OUT1addr = instruction[2:0]; 
			 assign OUT2addr = instruction[10:8];
			 assign INaddr = instruction[18:16];
			 end
		8'b00001001 : begin //sub
			 assign Select = instruction[26:24];
			 assign Imm = instruction[7:0];
			 assign mx1 = 1'b1;
			 assign mx2 = 1'b1;
			 assign OUT1addr = instruction[2:0]; 
			 assign OUT2addr = instruction[10:8];
			 assign INaddr = instruction[18:16];
			 end
		8'b00000010 : begin //and
			 assign Select = instruction[26:24];
			 assign Imm = instruction[7:0];
			 assign mx1 = 1'b0;
			 assign mx2 = 1'b1;
			 assign OUT1addr = instruction[2:0]; 
			 assign OUT2addr = instruction[10:8];
			 assign INaddr = instruction[18:16];
			 end
		8'b00000011 : begin //or
			 assign Select = instruction[26:24];
			 assign Imm = instruction[7:0];
			 assign mx1 = 1'b0;
			 assign mx2 = 1'b1;
			 assign OUT1addr = instruction[2:0]; 
			 assign OUT2addr = instruction[10:8];
			 assign INaddr = instruction[18:16];
			 end
		
		endcase
	end
endmodule


/*
module CUtestbench;
 
wire [2:0] OUT1addr;
wire [2:0] OUT2addr;
wire [2:0] INaddr,Select;
wire mx1,mx2;
wire [7:0] Imm;
reg [31:0] instruction;
 
		CU cu1CU(instruction, OUT1addr, OUT2addr, INaddr,Imm,Select,mx1,mx2);
    
initial begin
    instruction = 32'b00000000101011111010101110101010;
#4
    $display("%b %b %b %b %b %b %b",OUT1addr,OUT2addr,INaddr,Imm,Select,mx1,mx2);
end
endmodule
*/


///////   Program Counter

module counter(clk, reset,Read_addr);
input clk;
input reset;
output [31:0] Read_addr;
// The outputs are defined as registers too
reg Read_addr;

// The counter doesn't have any delay since the
//output is latched when the negedge of the clock happens.

always @(negedge clk)
	begin
		case(reset)
			1'b1 : begin Read_addr = 32'd0; end
			1'b0 : begin Read_addr = Read_addr + 32'd4; end
		endcase
	end
// add code here//
endmodule


/////  Instruction

module Instruction_reg (clk, Read_Addr, instruction);
input clk;
input [31:0] Read_Addr;
output [31:0] instruction;

reg instruction;

// define necessary reg's here//
always @(negedge clk) 
	begin
	instruction = Read_Addr;
	//add your code here//
	end
endmodule


/*

module insregtestbench;
	reg [31:0] Read_Addr;
	reg clk;
	wire [31:0] instruction; 
	
	Instruction_reg ir1(clk, Read_Addr, instruction);
	
	initial begin
    clk = 0;
    forever #1 clk = ~clk;
end
	
	initial
		begin 

		Read_Addr = 32'd11;
		#5;
		$display("%b >> %b",Read_Addr,instruction);
		
		$finish;
		end
	
endmodule
*/



//////  Test Bench for whole impliment


module test;

reg [31:0] Read_Addr;
reg clk;
wire  signed [7:0] Result;

wire [31:0] instruction;
wire [2:0] OUT1addr,OUT2addr,INaddr,Select;
wire  [7:0] Imm,OUT1,OUT2,DATA1,DATA2,cmp;
wire mx1,mx2;


	Instruction_reg ir1(.clk(clk),.Read_Addr(Read_Addr),
						.instruction(instruction));
	CU cu1(.instruction(instruction),.OUT1addr(OUT1addr),
		   .OUT2addr(OUT2addr),.INaddr(INaddr),.Imm(Imm),
		   .Select(Select),.mx1(mx1),.mx2(mx2));
	regfile8x8a rf1(.clk(clk),.INaddr(INaddr),.IN(Result),
				.OUT1addr(OUT1addr),.OUT1(OUT1),.OUT2addr(OUT2addr),
				.OUT2(OUT2));
	comp cmp1(.Output(cmp),.Input(OUT1));
	mux mux1(.Output(DATA2),.clk(clk),.Input1(OUT1),.Input2(cmp),
			.Ctrl(mx1));
	mux mux2(.Output(DATA1),.clk(clk),.Input1(Imm),.Input2(DATA2),
			.Ctrl(mx2));
	alu al1(.Result(Result),.DATA1(DATA1),.DATA2(OUT2),
			.Select(Select));
	

initial begin
    clk = 0;
    forever #1 clk = ~clk;
end
 
initial begin
	 
	// Operation set 1
	$display("\nOperation      Binary   | Decimal");
	$display("---------------------------------");
#20
	Read_Addr = 32'b0000000000000100xxxxxxxx11111111;//loadi 4,X,0xFF
#20
    $display("load v1        %b | %d",Result,Result);
   
#40
	Read_Addr = 32'b0000000000000110xxxxxxxx10101010;//loadi 6,X,0xAA
#40
    $display("load v2        %b | %d",Result,Result); 
    
#60
	Read_Addr = 32'b0000000000000011xxxxxxxx10111011;//loadi 3,X,0xBB
#60
   $display("load v3        %b | %d",Result,Result);
    
#100
	Read_Addr = 32'b00000001000001010000011000000011;//add 5,6,3
#100
    $display("add v4 (v2+v3) %b | %d  (Here it's overflow)",Result,Result);
    
#120
	Read_Addr = 32'b00000010000000010000010000000101;//and 1,4,5
#120
    $display("and v5 (v1,v4) %b | %d",Result,Result);
   
#140
	Read_Addr = 32'b00000011000000100000000100000110;//or 2,1,6
#140
    $display("or v6 (v5,v2)  %b | %d",Result,Result);
    
#160
	Read_Addr = 32'b0000100000001111xxxxxxxx00000010;//mov 7,X,2
#160
    $display("copy v7 (v6)   %b | %d",Result,Result);
    
#180
	Read_Addr = 32'b00001001000001000000111100000011;//sub 4,7,3
#180
    $display("sub v8 (v7-v3) %b | %d",Result,Result);
    
    // Operation set 2
    
$display("\nOperation      Binary   | Decimal");
	$display("---------------------------------");
#20
	Read_Addr = 32'b0000000000000100xxxxxxxx00001101;//loadi 4,X,0xFF
#20
    $display("load v1        %b | %d",Result,Result);
   
#40
	Read_Addr = 32'b0000000000000110xxxxxxxx00101101;//loadi 6,X,0xAA
#40
    $display("load v2        %b | %d",Result,Result); 
    
#60
	Read_Addr = 32'b0000000000000011xxxxxxxx00100001;//loadi 3,X,0xBB
#60
   $display("load v3        %b | %d",Result,Result);
    
#100
	Read_Addr = 32'b00000001000001010000011000000011;//add 5,6,3
#100
    $display("add v4 (v2+v3) %b | %d",Result,Result);
    
#120
	Read_Addr = 32'b00000010000000010000010000000101;//and 1,4,5
#120
    $display("and v5 (v1,v4) %b | %d",Result,Result);
   
#140
	Read_Addr = 32'b00000011000000100000000100000110;//or 2,1,6
#140
    $display("or v6 (v5,v2)  %b | %d",Result,Result);
    
#160
	Read_Addr = 32'b0000100000001111xxxxxxxx00000010;//mov 7,X,2
#160
    $display("copy v7 (v6)   %b | %d",Result,Result);
    
#180
	Read_Addr = 32'b00001001000001000000111100000011;//sub 4,7,3
#180
    $display("sub v8 (v7-v3) %b | %d",Result,Result);
   
    $finish;
end
endmodule

