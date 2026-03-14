module Control(
	//output
	output reg RegWrite,RegDst,ALUSrc,MemWrite,MemRead,MemToReg,
	output reg [1:0]ALUOP,
	//input
	input [5:0]OpCode
);
always@(OpCode)begin
	case(OpCode)
	6'b000000://R-Format
	begin
		RegDst <= 1'b1;
		ALUSrc <= 1'b0;
		MemToReg <= 1'b0;
		RegWrite <= 1'b1;
		MemRead <= 1'b0;
		MemWrite <= 1'b0;
		ALUOP <= 2'b10;
	end
	6'b001100://I-Format addiu
	begin
		RegDst <= 1'b0;
		ALUSrc <= 1'b1;
		MemToReg <= 1'b0;
		RegWrite <= 1'b1;
		MemRead <= 1'b0;
		MemWrite <= 1'b0;
		ALUOP <= 2'b00;
	end
	6'b001101://I-Format subiu
	begin
		RegDst <= 1'b0;
		ALUSrc <= 1'b1;
		MemToReg <= 1'b0;
		RegWrite <= 1'b1;
		MemRead <= 1'b0;
		MemWrite <= 1'b0;
		ALUOP <= 2'b01;
	end
	6'b010000://I-Format sw
	begin
		RegDst <= 1'bz;
		ALUSrc <= 1'b1;
		MemToReg <= 1'bz;
		RegWrite <= 1'b0;
		MemRead <= 1'b0;
		MemWrite <= 1'b1;
		ALUOP <= 2'b00;
	end
	6'b010001://I-Format lw
	begin
		RegDst <= 1'b0;
		ALUSrc <= 1'b1;
		MemToReg <= 1'b1;
		RegWrite <= 1'b1;
		MemRead <= 1'b1;
		MemWrite <= 1'b0;
		ALUOP <= 2'b00;
		
	end
	default:
	begin
		RegWrite <= 1'b0;
		ALUOP <= 2'bz;
	end
	endcase
end
endmodule
