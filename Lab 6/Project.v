/*
	Group 09 (E/15/131, E/15/348)
	Simple Processor
*/

// ******** ALU ********
module ALU( RESULT, DATA1, DATA2, SELECT );
	input [7:0] DATA1,DATA2;	//Source 1 & 2	
	input [2:0] SELECT;			//Operation Selection signal
	output reg [7:0] RESULT;		//Result of ALU operation		
	
	always @(DATA1,DATA2,SELECT)
    	begin
        case ( SELECT )
         0 : RESULT = DATA1;			//Forward ( loadi, mov )
         1 : RESULT = DATA1 + DATA2;	//Addition ( add, sub )
         2 : RESULT = DATA1 & DATA2;	//Bitwise AND ( and )
         3 : RESULT = DATA1 | DATA2;	//Bitwise OR ( or )
		 4 : RESULT = DATA1;			//Forward ( load )
		 5 : RESULT = DATA1;			//Forward ( store )
		default : RESULT = 0;
        endcase 
    end

endmodule

// ******** Register File ********
module regfile8x8a ( clk, INaddr, IN, OUT1addr, OUT1, OUT2addr, OUT2, busy_wait );
	
	input [2:0] OUT1addr,OUT2addr,INaddr;
	input [7:0] IN;
	input clk;
	input busy_wait;
	output reg [7:0] OUT1,OUT2;
	reg [63:0] regMemory = 0;

	integer i;
	
	always @(posedge clk) begin			//Read at postive edge of Clock
		for(i=0;i<8;i=i+1) begin
			OUT1[i] = regMemory[ OUT1addr*8 + i ];
			OUT2[i] = regMemory[ OUT2addr*8 + i ];
		end
	end	
	
	always @(negedge clk) begin			//Write at negative edge of Clock
		if ( !busy_wait )begin			//Stall if DM access is happening
			for(i=0;i<8;i=i+1)begin
				regMemory[INaddr*8 + i] = IN[i];
			end
		end
	end

endmodule

// ******** Program Counter ********
module counter(clk, reset, Read_addr, busy_wait, InsWait );
	input clk;
	input reset;
	input busy_wait,InsWait;
	output reg [7:0] Read_addr = 0;

	always @( reset )begin
		if ( reset ) begin
			Read_addr = -1;
		end
	end
	
	always @(posedge clk) begin
		if ( !InsWait  && !busy_wait ) begin				//Stall if DM access is happening
			Read_addr = Read_addr + 8'b00000001;	//PC = PC + 1, if reset = 0
		end
	end
endmodule

// ******** Multiplexer 2x1 ********
module MUX( OUTPUT, INPUT1, INPUT2, CTRL );
	input [7:0] INPUT1, INPUT2;
	output reg [7:0] OUTPUT;
	input CTRL;

	always @( INPUT1, INPUT2, CTRL )
	begin
		case( CTRL )
			1'b0 : begin OUTPUT <= INPUT1; end
			1'b1 : begin OUTPUT <= INPUT2; end
		endcase
	end
endmodule

// ******** Comparator ********
module Comparator( Out, Input1, Input2 );
	input [3:0] Input1;
	input [3:0] Input2;
	output Out;

	wire out1,out2,out3,out4;

	xnor xnor1( out1, Input1[0], Input2[0] );
	xnor xnor2( out2, Input1[1], Input2[1] );
	xnor xnor3( out3, Input1[2], Input2[2] );
	xnor xnor4( out4, Input1[3], Input2[3] );
	and and1( Out, out1, out2, out3, out4 );
	
endmodule

// ******** 2's Complement ********
module TwosComplement( OUTPUT, INPUT );
	input [7:0] INPUT;
	output [7:0] OUTPUT;

	assign OUTPUT[7:0] = -INPUT[7:0];

endmodule

// ******** Instruction Register ********
module Instruction_reg ( clk, Read_Ins, instruction );
	input clk;
	input [31:0] Read_Ins;
	output [31:0] instruction;
	reg instruction;

	always @( Read_Ins ) 
	begin
		instruction = Read_Ins;
	end
endmodule

// ******** Control Unit ********
module CU( instruction, busy_wait, OUT1addr, OUT2addr, INaddr, Imm, Select, addSubMUX, imValueMUX, dmMUX, read, write, address, 
			InsAddr, IMread, IMaddress );
	
	input [31:0] instruction;
	input busy_wait;
	output reg [2:0] OUT1addr;
	output reg [2:0] OUT2addr;
	output reg [2:0] Select;
	output reg [2:0] INaddr;
	output reg [7:0] Imm, address;
	output reg addSubMUX, imValueMUX, dmMUX, read, write;

	input [7:0]InsAddr;
	output reg IMread;
	output reg [7:0] IMaddress;

	always @( InsAddr )begin
		IMaddress = InsAddr;
		IMread = 1'b1;
	end

	always @( instruction, busy_wait ) begin
		if ( !busy_wait ) begin						//Stall if DM access is happening
			assign Select = instruction[26:24];		//Common Signals
			assign Imm = instruction[7:0];
			assign OUT1addr = instruction[2:0];
			assign OUT2addr = instruction[10:8];
			assign INaddr = instruction[18:16];
			assign imValueMUX = 1'b1;
			assign addSubMUX = 1'b0;
			assign write = 1'b0;
			assign read = 1'b0;
			assign dmMUX = 1'b1;
			
			case(instruction[31:24])
				
			8'b00000000 : begin			//loadi
				assign imValueMUX = 1'b0;
				end
			
			8'b00001001 : begin			//sub
				assign addSubMUX = 1'b1;
				end

			8'b00000100 : begin			//load
				assign read = 1'b1;
				assign dmMUX = 1'b0;
				assign address = instruction[7:0];	
			end
			
			8'b00000101: begin			//store
				assign write = 1'b1;
				assign address = instruction[23:16];
			end		

			endcase
		end
	end
endmodule

// ******** Data Memory ********
module data_mem( clk, rst, read, write, address, write_data, read_data,	busy_wait );
	input clk;
	input rst;
	input read;
	input write;
	input[6:0] address;
	input[15:0] write_data;
	output[15:0] read_data;
	output busy_wait;
	
	reg busy_wait = 1'b0;
	reg[15:0] read_data;

	integer  i;
	
	// Declare memory 128x16 bits 
	reg [15:0] memory_array [127:0];

	always @(posedge rst)			//Reset Data memory
	begin
		if ( rst )
		begin
			for (i=0;i<128; i=i+1)
				memory_array[i] <= 0;
		end
	end
	
	always @( read, write, address, write_data ) begin
		if ( write && !read )			//Write to Data memory
		begin
			busy_wait <= 1;
			//Artificial delay 99 cycles
			repeat(99)
			begin
				@(posedge clk);
			end
			memory_array[address] = write_data;
			busy_wait <= 0;
		end
		if ( !write && read ) begin		//Read from Data memory
			busy_wait <= 1;
			//Artificial delay 99 cycles
			repeat(99)
			begin
				@(posedge clk);
			end

			read_data = memory_array[address];
			busy_wait <= 0;
		end
	end
	
endmodule

// ******** Data Memory Cache ********
module data_cache( clk, rst, read, write, address, write_data, read_data, busy_wait ,
					DMread, DMwrite, DMaddress, DMwrite_data, DMread_data, DMbusy_wait );
	input clk;
    input rst;
	
    input read;					//Cache links with Control unit
    input write;
    input [7:0] address;
    input [7:0] write_data;
    output [7:0] read_data;
    output busy_wait;

	output DMread;				//Cache links with Data Memory
	output DMwrite;
    output [6:0] DMaddress;
    output [15:0] DMwrite_data;
    input [15:0] DMread_data;
	input DMbusy_wait;

	reg [15:0] DMwrite_data;
	reg [6:0] DMaddress;
	reg DMread,DMwrite;
	reg [7:0] read_data;
	reg busy_wait = 1'b0;

	integer  i;

	//Cache Memory 16x8 bits 
	//16 Bytes // 2Bytes/Block
	reg [7:0] cache_ram [15:0];
	
	wire cout;
	wire hit;
	reg valid [7:0];
	reg dirty [7:0];
	reg [3:0] cacheTAG [7:0];
	wire [3:0] tag;
	wire [2:0] index;
	wire offset;
	reg flag = 1'b0;
	

	assign offset = address[0];
	assign index = address[3:1];
	assign tag = address[7:4];

	always @(posedge rst)begin				//Cache Reset
		if(rst)begin
			for (i=0; i<8; i=i+1)begin
				valid [i] <= 0;
				dirty [i] <= 0;
			end	
			for (i=0; i<16; i=i+1) begin
				cache_ram[i] <= 0;
			end
		end
	end

	//Look for HIT
	Comparator cm1( cout, tag, cacheTAG[index] );
	and and1( hit, cout, valid[index] );
	
	always @( clk ) begin
	
		if ( write && !read )begin			//Write to Data memory
			if( hit && !DMbusy_wait ) begin
				if( flag ) begin				//IF fetching from DM is finished store in Cache
					cache_ram[ 2*index ] = DMread_data[7:0];
					cache_ram[ 2*index+1 ] = DMread_data[15:8];
					flag = 1'b0;
					busy_wait = 1'b0;
				end
				cache_ram[ 2*index+offset ] = write_data;
				dirty[index] = 1'b1;
			end
			
			if( !hit ) begin	//If not a hit
				busy_wait = 1'b1;
				if( dirty[index] && !DMbusy_wait ) begin			//If dirty Write back
					DMwrite_data[7:0] = cache_ram[ 2*index ];
					DMwrite_data[15:8] = cache_ram[ 2*index +1 ];

					DMread = 1'b0;
					DMwrite = 1'b1;

					DMaddress[2:0] = address[3:1];
					DMaddress[6:3] = cacheTAG[ index ];
					dirty[index] = 1'b0;
				end  
				else if( !dirty[index] && !DMbusy_wait ) begin			//If not dirty fetch from Data Memory
					DMaddress = address[7:1];
					DMread = 1'b1;
					DMwrite = 1'b0;
					cacheTAG[ index ] = address[7:4];
					valid[index] = 1'b1;
					flag = 1'b1;
				end
			end
		end
		
		if ( !write && read ) begin		//Read from Data memory
			if( hit && !DMbusy_wait ) begin
				if( flag ) begin				//IF fetching from DM is finished store in Cache
					cache_ram[ 2*index ] = DMread_data[7:0];
					cache_ram[ 2*index+1 ] = DMread_data[15:8];
					flag = 1'b0;
					busy_wait = 1'b0;
				end
				read_data = cache_ram[ 2*index+offset ];
			end

			if( !hit ) begin		//If not a hit
				busy_wait = 1'b1;
				if( dirty[index] && !DMbusy_wait ) begin			//If dirty Write back
					DMwrite_data[7:0] = cache_ram[ 2*index ];
					DMwrite_data[15:8] = cache_ram[ 2*index +1 ];

					DMread = 1'b0;
					DMwrite = 1'b1;

					DMaddress[2:0] = address[3:1];
					DMaddress[6:3] = cacheTAG[ index ];
					dirty[index] = 1'b0;
				end 
				else if( !dirty[index] && !DMbusy_wait ) begin			//If not dirty fetch from Data Memory
					DMaddress = address[7:1];
					DMread = 1'b1;
					DMwrite = 1'b0;
					cacheTAG[ index ] = address[7:4];
					valid[index] = 1'b1;
					flag = 1'b1;
				end
			end			
		end
	end

endmodule

// ******** Instruction Memory ********
module instr_mem( clk, Reset, read, address, READ_INST, WAIT );
	input clk,Reset;
	input read;
	input[5:0] address;
	output reg [127:0] READ_INST;
	output WAIT;
	reg WAIT = 1'b0;
	
	// Declare memory 128x64 bits 
	reg [127:0] memory_array [63:0];

	integer  i;
	
	always @(Reset)begin
		if ( Reset ) begin
			memory_array[0] = 128'b00000000000000100000000000001101000000000000001100000000010000110000010100111001000000000000001000000101001110000000000000000011;
			memory_array[1] = 128'b00000100000001110000000000111001000001000000100000000000001110000000000000000011000000000110000100000101000110000000000000000011;
			memory_array[2] = 128'b00000100000010000000000000011000000000010000010100000111000010000000100100000101000010000000011100000100000010000000000000111000;
			memory_array[3] = 128'b00000100000010000000000000111001000001010011100100000000000000110000010000001000000000000001100000000101000110010000000000000010;
			memory_array[4] = 128'b00000100000010000000000000011000000001010001100100000000000000100000010100011001000000000000001000000101000110010000000000000010;
		end
	end

	//0000000000000010xxxxxxxx00101101	loadi
	//0000000000000011xxxxxxxx01000001	loadi
	//00000101001110010000000000000010	Store
	//00000101001110000000000000000011	Store

	always @( address ) begin
		if ( read ) begin		//Read from Data memory
			WAIT <= 1;
			//Artificial delay 100 cycles
			repeat(98)
			begin
				@(posedge clk);
			end

			READ_INST = memory_array[address];
			WAIT <= 0;
		end
	end
endmodule

// ******** Instruction Memory Cache ********
module instr_cache( clk, rst, read, address, read_data, InsWait ,
					IMread, IMaddress, IMread_data, IMbusy_wait,hit );
	input clk;
    input rst;
	output hit;
	
    input read;					//Cache links with Control unit
    input [7:0] address;
    output reg [31:0] read_data;
    output InsWait;

	output reg IMread;				//Cache links with Instruction Memory
    output reg [5:0] IMaddress;
    input [127:0] IMread_data;
	input IMbusy_wait;

	reg InsWait = 1'b0;
	
	integer  i;
	//Cache Memory 32x16 bits 
	//64 Bytes // 16Bytes/Block
	reg [31:0] cache_ram [15:0];
	
	wire cout;
	wire hit;
	reg valid [3:0];
	reg [3:0] cacheTAG [3:0];
	wire [3:0] tag;
	wire [1:0] index;
	wire [1:0] offset;
	reg flag = 1'b0;
	

	assign offset = address[1:0];
	assign index = address[3:2];
	assign tag = address[7:4];

	always @(posedge rst)begin				//Cache Reset
		if( rst )begin
			for (i=0; i<4; i=i+1)begin
				valid [i] <= 0;
			end	
			for (i=0; i<16; i=i+1) begin
				cache_ram[i] <= 0;
			end
		end
	end

	//Look for HIT
	Comparator cm1( cout, tag, cacheTAG[index] );
	and and1( hit, cout, valid[index] );
	
	always @(posedge clk ) begin
		if( read ) begin //Read from Instruction memory
			if( hit && !IMbusy_wait ) begin
				if( flag ) begin
					cache_ram[ 4*index ] = IMread_data[127:96];
					cache_ram[ 4*index+1 ] = IMread_data[95:64];
					cache_ram[ 4*index+2 ] = IMread_data[63:32];
					cache_ram[ 4*index+3 ] = IMread_data[31:0];
					flag = 1'b0;
					InsWait = 1'b0;
				end
				read_data = cache_ram[ 4*index+offset ];
			end

			if( !hit ) begin		//If not a hit	
				InsWait = 1'b1;
				IMaddress = address[7:2];
				IMread = 1'b1;
				cacheTAG[ index ] = address[7:4];
				valid[index] = 1'b1;
				flag = 1'b1;
			end
		end		
	end

endmodule


// ******** Processor ********
module Processor( InsWait, busy_wait, InsAddr, clk, rst, instruction, address );
	
	input clk,rst;
	output InsWait;
	output busy_wait;
	output [7:0] InsAddr;
	output [31:0] instruction;
	output [7:0] address;
	
	wire [7:0] hit;
	wire [7:0] Result;
	wire [31:0] instruction;
	wire [2:0] OUT1addr,OUT2addr,INaddr,Select;
	wire  [7:0] Imm,OUT1,OUT2,OUTPUT,INPUT,cmp;
	wire [7:0] read_data,address;
	wire [7:0] imValueMUXout, addSubMUXout, DataMemMUXout;
	wire addSubMUX, imValueMUX, dmMUX;
	wire read, write, busy_wait, rst;
	wire [6:0] DMaddress;
	wire [15:0] DMwrite_data, DMread_data;
	wire DMread, DMwrite, DMbusy_wait;
	wire InsRead, InsWait;
	wire IMread, IMbusy_wait;
	wire [7:0] InsAddr,InsAddress;
	wire [31:0] InsRead_data;
	wire [5:0]IMaddress;
	wire [127:0]READ_INST;

	
	Instruction_reg ir1(clk, InsRead_data, instruction);				//Instruction Regiter
	counter pc(clk, rst, InsAddr, busy_wait, InsWait );
	CU cu1( instruction, busy_wait, OUT1addr, OUT2addr, INaddr, Imm, Select, addSubMUX, imValueMUX, dmMUX, read, write, address, 
			InsAddr, InsRead, InsAddress );	//Control Unit
	regfile8x8a rf1( clk, INaddr, DataMemMUXout, OUT1addr, OUT1, OUT2addr, OUT2, busy_wait );			//Register File
	TwosComplement tcomp( OUTPUT, OUT1 );							//2'sComplement
	MUX addsubMUX( addSubMUXout, OUT1, OUTPUT, addSubMUX );			//2's complement MUX
	MUX immValMUX( imValueMUXout, Imm, addSubMUXout, imValueMUX );	//Imediate Value MUX
	MUX DataMemMUX( DataMemMUXout, read_data ,Result, dmMUX);		//Data Memory MUX 
	ALU alu1( Result, imValueMUXout, OUT2, Select );				//ALU
	
	data_cache dmc( clk, rst, read, write, address, Result, read_data, busy_wait ,
					DMread, DMwrite, DMaddress, DMwrite_data, DMread_data, DMbusy_wait );		//Data Memory Cache
	data_mem dm( clk, rst, DMread, DMwrite, DMaddress, DMwrite_data, DMread_data, DMbusy_wait);	//Data Memory

	instr_cache imc( clk, rst, InsRead, InsAddress, InsRead_data, InsWait ,
					IMread, IMaddress, READ_INST, IMbusy_wait,hit2 );	//Instruction Memory Cache
	instr_mem im( clk, rst, IMread, IMaddress, READ_INST, IMbusy_wait );	//Instruction Memory

endmodule

module testDM;
	reg [31:0] Read_Addr;
	wire [7:0] Result;
	wire w1,w2;
	reg clk,rst;
	wire [31:0]instruction;
	wire [7:0] address;

	Processor simpleP( w1, w2, Result, clk, rst,instruction,address);

	initial begin
      $dumpfile("testbench.vcd");
      $dumpvars(0,testDM);
    end

	initial begin
		clk = 0;
		forever #1 clk = ~clk;
	end

	initial begin
		
		$display("\nPrinting The results of MUX that is before register file( output from ALU OR DM )\n");
		rst = 0;
		#2
		rst = 1;
		#2
		rst = 0;
		$display("%d %d %d %b %b",w1, w2,Result,instruction,address);
		#198
		$display("%d %d %d %b %b",w1, w2,Result,instruction,address);
		#2
		$display("%d %d %d %b %b",w1, w2,Result,instruction,address);
		#2	
		$display("%d %d %d %b %b",w1, w2,Result,instruction,address);
		#2
		$display("%d %d %d %b %b",w1, w2,Result,instruction,address);
		#198
		$display("%d %d %d %b %b",w1, w2,Result,instruction,address);

		#50000$finish;
	end

endmodule
