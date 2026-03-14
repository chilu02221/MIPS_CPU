`define AU  6'b001001 //9
`define SU  6'b001010 //0a
`define OR  6'b010010 //12
`define SRL 6'b100010 //22

module ALU(

	input [31:0] Src_1, //inputdata_1
	input [31:0] Src_2, //inputdata_2
	input [4:0] shamt,  //the shifting bit
	input [5:0] funct,  //to choose which function

	output reg [31:0] ALUResult, //after the operation,the result will put into this register
	output reg Zero, //ALU output zero
	output reg Carry  //ALU output Carry
);
	always @(Src_1, Src_2, shamt, funct)
		begin
		Zero = 1'b0; //intialize the zero and carry to zero
		Carry = 1'b0;
		case(funct)
			`AU: begin {Carry, ALUResult} <= Src_1 + Src_2; //add function
			if( Src_1 + Src_2 == 0 ) //set the Zero if result equals to zero
				Zero = 1'b1;
			else
				Zero = 1'b0;
			end
			`SU: begin {Carry, ALUResult} <= Src_1 - Src_2; //sub function
			if( Src_1 - Src_2 == 0 )//set the Zero if result equals to zero
				Zero = 1'b1;
			else
				Zero = 1'b0;
			end
			`OR: begin {Carry, ALUResult} <= Src_1 | Src_2; //or function
			if( (Src_1 | Src_2) == 0 )//set the Zero if result equals to zero
				Zero = 1'b1;
			else
				Zero = 1'b0;
			end
			`SRL: begin{Carry, ALUResult} <= Src_1 >> shamt; //shifting function
			if((Src_1 >> shamt) == 0)//set the Zero if result equals to zero
				Zero = 1'b1;
			else
				Zero = 1'b0;
			end
			default: {Carry, ALUResult} <= 0;
		endcase
		
		end
endmodule
