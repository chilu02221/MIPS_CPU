/*
 *	Template for Project 2 Part 3
 *	Copyright (C) 2022  Chen Chia Yi or any person belong ESSLab.
 *	All Right Reserved.
 *
 *	This program is free software: you can redistribute it and/or modify
 *	it under the terms of the GNU General Public License as published by
 *	the Free Software Foundation, either version 3 of the License, or
 *	(at your option) any later version.
 *
 *	This program is distributed in the hope that it will be useful,
 *	but WITHOUT ANY WARRANTY; without even the implied warranty of
 *	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *	GNU General Public License for more details.
 *
 *	You should have received a copy of the GNU General Public License
 *	along with this program.  If not, see <https://www.gnu.org/licenses/>.
 *
 *	This file is for people who have taken the cource (1102 Computer
 *	Organizarion) to use.
 *	We (ESSLab) are not responsible for any illegal use.
 *
 */

/*
 * Declaration of top entry for this project.
 * CAUTION: DONT MODIFY THE NAME AND I/O DECLARATION.
 */
module SimpleCPU(
	// Outputs
	output	wire	[31:0]	Addr_Out,
	// Inputs
	input	wire	[31:0]	Addr_In,
	input	wire			clk
);
	wire [31:0]inner_instruction;
	wire [31:0]inner_Rs_Data;
	wire [31:0]inner_Rt_Data;
	wire [4:0]inner_Rd_Addr;
	wire inner_RegWrite;
	wire inner_RegDst;
	wire [31:0]inner_Src_2;
	wire [31:0]inner_Sign_extend;
	wire inner_ALUSrc;
	wire [5:0]inner_funct;
	wire [31:0]inner_ALUResult;
	wire Zero,Carry;
	wire [31:0]inner_MemReadData;
	wire inner_MemToReg;
	wire [31:0]inner_Rd_Data;
	wire inner_MemRead,inner_MemWrite;
	wire [1:0]inner_ALUOP;
	wire [31:0]inner_JumpAddress;
	wire [31:0]inner_Address;
	wire inner_Beq_Control;
	wire inner_Jump_Control;
	wire [27:0]inner_instruction_out;
	wire [31:0]Addr_O;
	wire [31:0]inner_sign_extend_shift;
	wire inner_Branch_Control;
	/* 
	 * Declaration of Instruction Memory.
	 * CAUTION: DONT MODIFY THE NAME.
	 */
	IM Instr_Memory(
		// Outputs
		.Instruction(inner_instruction),
		// Inputs
		.Instr_Addr(Addr_In)

	);

	/* 
	 * Declaration of Register File.
	 * CAUTION: DONT MODIFY THE NAME.
	 */
	RF Register_File(
		// Outputs
		.Rs_Data(inner_Rs_Data),
		.Rt_Data(inner_Rt_Data),
		// Inputs
		.Rs_Addr(inner_instruction[25:21]),
		.Rt_Addr(inner_instruction[20:16]),
		.Rd_Addr(inner_Rd_Addr),
		.Rd_Data(inner_Rd_Data),
		.clk(clk),
		.RegWrite(inner_RegWrite)	

	);

	/* 
	 * Declaration of Data Memory.
	 * CAUTION: DONT MODIFY THE NAME.
	 */
	DM Data_Memory(
		// Outputs
		.MemReadData(inner_MemReadData),
		// Inputs
		.MemAddr(inner_ALUResult),
		.MemWriteData(inner_Rt_Data),
		.clk(clk),
		.MemWrite(inner_MemWrite),
		.MemeRead(inner_MemeRead)

	);
	
	Reg_MUX Reg_MUX_1(
		//Outputsinner_Beq_Control
		.MUX_out(inner_Rd_Addr),
		//Inputs
		.instr0(inner_instruction[20:16]),
		.instr1(inner_instruction[15:11]),
		.s(inner_RegDst)
	);
	
	MUX_32 MUX_32_1(
		//Outputs
		.MUX_out(inner_Src_2),
		//Inputs
		.instr0(inner_Rt_Data),
		.instr1(inner_Sign_extend),
		.s(inner_ALUSrc)
	);

	MUX_32 MUX_32_2(
		//Outputs
		.MUX_out(inner_Rd_Data),
		//Inputs
		.instr0(inner_ALUResult),
		.instr1(inner_MemReadData),
		.s(inner_MemToReg)
	);

	MUX_32 MUX_32_3(
		//Outputs
		.MUX_out(inner_Address),
		//Inputs
		.instr0(Addr_O),
		.instr1(inner_JumpAddress),
		.s(inner_Beq_Control)
	);
	
	MUX_32 MUX_32_4(
		//Outputs
		.MUX_out(Addr_Out),
		//Inputs
		.instr0(inner_Address),
		.instr1({Addr_O[31:28],inner_instruction_out}),
		.s(inner_Jump_Control)
	);

	ADD ADD_1(
		//output
		.Addr_Out(Addr_O),
		//input
		.Addr_In1(Addr_In),
		.Addr_In2(32'd4)
	);      
	
	ADD ADD_2(
		//output
		.Addr_Out(inner_JumpAddress),
		//input
		.Addr_In1(Addr_O),
		.Addr_In2(inner_sign_extend_shift)
	); 
	
	Shift_2_bit_1 Shift_2_bit_1(
		//Outputs
		.instruction_out(inner_instruction_out),
		//Inputs
		.instruction_in(inner_instruction[25:0])
	);

	Shift_2_bit_2 Shift_2_bit_2(
		//Outputs
		.instruction_out(inner_sign_extend_shift),
		//Inputs
		.instruction_in(inner_Sign_extend)
	);

	Sign_extend Sign_extend_1( 
		//output
		.Src(inner_Sign_extend),
		//input
		.imm(inner_instruction[15:0])
	);
	
	ALU_Control ALU_Control_1(
		//output
		.funct(inner_funct),
		//input
		.funct_ctrl(inner_instruction[5:0]),
		.ALUOP(inner_ALUOP)
	);
	

	ALU ALU_1(

		.Src_1(inner_Rs_Data), //inputdata_1
		.Src_2(inner_Src_2), //inputdata_2
		.shamt(inner_instruction[10:6]),  //the shifting bit
		.funct(inner_funct),  //to choose which function

		.ALUResult(inner_ALUResult), //after the operation,the result will put into this register
		.Zero(Zero), //ALU output zero
		.Carry(Carry)  //ALU output Carry
	);

	Control Control_1(
		//output
		.RegWrite(inner_RegWrite),
		.RegDst(inner_RegDst),
		.ALUSrc(inner_ALUSrc),
		.MemWrite(inner_MemWrite),
		.MemRead(inner_MemeRead),
		.MemToReg(inner_MemToReg),
		.ALUOP(inner_ALUOP),
		.Jump(inner_Jump_Control),
		.Branch(inner_Branch_Control),
		//input
		.OpCode(inner_instruction[31:26])
	);
	
	AND AND_1(
		//Output
		.and_out(inner_Beq_Control),
		//input
		.Branch(inner_Branch_Control),
		.Zero(Zero)
	);
endmodule
