/*
 *	Template for Project 3 Part 3
 *	Copyright (C) 2021  Lee Kai Xuan or any person belong ESSLab.
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
 *	This file is for people who have taken the cource (1092 Computer
 *	Organizarion) to use.
 *	We (ESSLab) are not responsible for any illegal use.
 *
 */

/*
 * Declaration of top entry for this project.
 * CAUTION: DONT MODIFY THE NAME AND I/O DECLARATION.
 */
module FinalCPU(
	// Outputs
	output	wire	PCWrite,
	output	wire	[31:0]	Addr_Out,
	// Inputs
	input	wire	[31:0]	Addr_In,
	input	wire	clk
);
	//IF stage
	wire [31:0]Instr;
	//ID stage
	wire [31:0]Instruction;
	wire Stall_Control,IF_ID_Write;
	wire Control_RegWrite,Control_MemtoReg,Control_MemWrite,Control_MemRead,Control_RegDst,Control_ALUSrc;
	wire [1:0]Control_ALUOp;
	wire [1:0]IDstage_WB; //WB[1]:RegWrite,WB[0]:MemtoReg
	wire [1:0]IDstage_M; //M[1]:MemWrite M[0]:MemRead
	wire [3:0]IDstage_EX; //EX[3]:RegDst EX[2:1]:ALUOp EX[0]:ALUSrc
	wire [31:0]RsData,RtData;
	wire [31:0]Sign_Extend;
	//EX stage
	wire [1:0]EXstage_WB;
	wire [1:0]EXstage_M;
	wire ALUSrc;
	wire [1:0]ALUOp;
	wire RegDst;
	wire [31:0]EXstage_RsData,EXstage_RtData;
	wire [31:0]EXstage_Sign_Extend;
	wire [31:0]Src1,Src2,ALUResult;
	wire [31:0]ForwardB_RtData;
	wire [4:0]EXstage_RtAddr,EXstage_RsAddr,EXstage_RdAddr;
	wire [5:0]funct;
	wire Zero,Carry;
	wire [4:0]RegDst_RdAddr;
	wire [1:0]ForwardA,ForwardB;
	//MEM stage
	wire [1:0]MEMstage_WB;
	wire MemeRead,MemWrite;
	wire [31:0]MEMstage_ALUResult,MemWriteData,MemReadData;
	wire [4:0]MEMstage_RdAddr;
	//WB stage
	wire RegWrite,MemtoReg;
	wire [31:0]WBstage_MemReadData,WBstage_ALUResult,RdData;
	wire [4:0]RdAddr;
	//IF stage component
	ADD Adder(
		//output
		.Addr_Out(Addr_Out),
		//input
		.Addr_In(Addr_In)
	);  
	/* 
	 * Declaration of Instruction Memory.
	 * CAUTION: DONT MODIFY THE NAME.
	 */
	IM Instr_Memory(
		//outputs
		.Instr(Instr),
		// Inputs
		.insrtAddr(Addr_In)
	);

	// IF/ID register
	IF_ID IF_ID_register(
		//outputs
		.Instr_Out(Instruction), //Instruction to ID stage
		//inputs
		.Instr_In(Instr),//Instruction from IF stage
		.IF_ID_Write(IF_ID_Write),
		.clk(clk)
	);
	//ID stage component
	HDU Hazard_Detection_Unit(
		//outputs
		.Control_Mux(Stall_Control), //let system to stall or not 
		.PCWrite(PCWrite), //PC to renew or not 
		.IF_ID_Write(IF_ID_Write), //IF_ID renew or not 
		//inputs
		.ID_EX_MemReadData(EXstage_M[0]),//to detect the instruction is load word or not
		.IF_ID_RsAddr(Instruction[25:21]), //the address of source register in IF/ID register
		.IF_ID_RtAddr(Instruction[20:16]), //the address of target register in IF/ID register
		.ID_EX_RtAddr(EXstage_RtAddr) //the address of target register in ID/EX register
	);
	
	MUX_8 Control_MUX( //stall MUX
		//outputs
		.Result({IDstage_WB,IDstage_M,IDstage_EX}),
		//input 
		.Control_Signal({Control_RegWrite,Control_MemtoReg,Control_MemWrite,Control_MemRead,Control_RegDst,Control_ALUOp,Control_ALUSrc}),
		.zero(8'bz),
		.s(Stall_Control)
	);

	Control Control_Unit(
		//output
		.RegWrite(Control_RegWrite),
		.MemToReg(Control_MemtoReg),
		.RegDst(Control_RegDst),
		.ALUOP(Control_ALUOp),
		.ALUSrc(Control_ALUSrc),
		.MemWrite(Control_MemWrite),
		.MemRead(Control_MemRead),
		//input
		.OpCode(Instruction[31:26])
	);
	/* 
	 * Declaration of Register File.
	 * CAUTION: DONT MODIFY THE NAME.
	 */
	RF Register_File(
		// Outputs
		.Rs_Data(RsData),
		.Rt_Data(RtData),
		// Inputs
		.Rs_Addr(Instruction[25:21]),
		.Rt_Addr(Instruction[20:16]),
		.Rd_Addr(RdAddr),
		.Rd_Data(RdData),
		.clk(clk),
		.Reg_Write(RegWrite)
	);
	
	Sign_extend Sign_extend1(
		//output
		.Src(Sign_Extend),
		//input
		.imm(Instruction[15:0])
	);

	ID_EX ID_EX_register(
		//outputs
		.WB_Out(EXstage_WB),//Reg_Write
		.M_Out(EXstage_M),//MemeRead,MemWrite
		.Ex_Out({RegDst,ALUOp,ALUSrc}),//ALU_OP_Out,ALUSrc,RegDst
		.Rs_Data_Out(EXstage_RsData),//data from source register
		.Rt_Data_Out(EXstage_RtData),//data from target register
		.Instr_bit15_to_bit0_Out(EXstage_Sign_Extend),//function control and shamt
		.Rd_Addr_Out(EXstage_RdAddr),//the address of destination register
		.Rs_Addr_Out(EXstage_RsAddr),//the address of source register
		.Rt_Addr_Out(EXstage_RtAddr),//the address of target register
		//inputs
		.WB_In(IDstage_WB),
		.M_In(IDstage_M),
		.Ex_In(IDstage_EX),
		.Rs_Data_In(RsData),
		.Rt_Data_In(RtData),
		.Instr_bit15_to_bit0_In(Sign_Extend),
		.Rd_Addr_In(Instruction[15:11]),
		.Rs_Addr_In(Instruction[25:21]),
		.Rt_Addr_In(Instruction[20:16]),
		.clk(clk)
	);

	MUX_4_to_1 MUX_4_to_1A( //forwardA
		//outputs
		.Result(Src1),
		//inputs
		.Src1(EXstage_RsData),
		.Src2(RdData),
		.Src3(MEMstage_ALUResult),
		.s(ForwardA)
	);

	MUX_4_to_1 MUX_4_to_1B( //forwardB
		//outputs
		.Result(ForwardB_RtData),
		//inputs
		.Src1(EXstage_RtData),
		.Src2(RdData),
		.Src3(MEMstage_ALUResult),
		.s(ForwardB)
	);
	
	MUX_32 ALU_Src_MUX_32( //ALUSrc
		//Outputs
		.MUX_out(Src2),
		//Inputs
		.instr0(ForwardB_RtData),
		.instr1(EXstage_Sign_Extend),
		.s(ALUSrc)
	);

	ALU ALU(

		.Src_1(Src1), //inputdata_1
		.Src_2(Src2), //inputdata_2
		.shamt(EXstage_Sign_Extend[10:6]),  //the shifting bit
		.funct(funct),  //to choose which function

		.ALUResult(ALUResult), //after the operation,the result will put into this register
		.Zero(Zero), //ALU output zero
		.Carry(Carry)  //ALU output Carry
	);
	
	ALU_Control ALU_Control(
		//output
		.funct(funct),
		//input
		.funct_ctrl(EXstage_Sign_Extend[5:0]),
		.ALUOP(ALUOp)
	);
	Reg_MUX Reg_MUX(
		//Outputs
		.MUX_out(RegDst_RdAddr),
		//Inputs
		.instr0(EXstage_RtAddr),
		.instr1(EXstage_RdAddr),
		.s(RegDst)
	);

	FU Forwarding_Unit(
		//outputs
		.ForwardA(ForwardA),
		.ForwardB(ForwardB),
		//inputs
		.ID_EX_RsAddr(EXstage_RsAddr),
		.ID_EX_RtAddr(EXstage_RtAddr),
		.EX_MEM_RdAddr(MEMstage_RdAddr),
		.MEM_WB_RdAddr(RdAddr),
		.EX_MEM_RegWrite(MEMstage_WB[1]),
		.MEM_WB_RegWrite(RegWrite)
	);

	EX_MEM EX_MEM_register(
		//outputs
		.WB_Out(MEMstage_WB),//Reg_Write
		.M_Out({MemWrite,MemeRead}),
		.ALU_Result_Out(MEMstage_ALUResult),//Result from ALU
		.Mem_Data_Out(MemWriteData),//the data that will write into memory
		.Rd_Addr_Out(MEMstage_RdAddr),//the address of destination register
		//inputs
		.WB_In(EXstage_WB),
		.M_In(EXstage_M),
		.ALU_Result_In(ALUResult),
		.Mem_Data_In(ForwardB_RtData),
		.Rd_Addr_In(RegDst_RdAddr),
		.clk(clk)
	);

	DM Data_Memory(
		// Outputs
		.MemReadData(MemReadData),
		// Inputs
		.MemAddr(MEMstage_ALUResult),
		.MemWriteData(MemWriteData),
		.clk(clk),
		.MemWrite(MemWrite),
		.MemeRead(MemeRead)
	);

	MEM_WB MEM_WB_register(
		//outputs
		.WB_Out({RegWrite,MemtoReg}),//Reg_Write,MemtoReg
		.ALU_Result_Out(WBstage_ALUResult),//Result from ALU
		.Mem_ReadData_Out(WBstage_MemReadData),
		.Rd_Addr_Out(RdAddr),//the address of destination register
		//inputs
		.WB_In(MEMstage_WB),
		.ALU_Result_In(MEMstage_ALUResult),
		.Mem_ReadData_In(MemReadData),
		.Rd_Addr_In(MEMstage_RdAddr),
		.clk(clk)
	);

	MUX_32 MemtoReg_MUX(
		//Outputs
		.MUX_out(RdData),
		//Inputs
		.instr0(WBstage_ALUResult),
		.instr1(WBstage_MemReadData),
		.s(MemtoReg)
	);
endmodule
