module ID_EX(
	//outputs
	output reg [1:0]WB_Out,//Reg_Write
	output reg [1:0]M_Out,//MemRead,MemWrite
	output reg [3:0]Ex_Out,//ALU_OP_Out,ALUSrc,RegDst
	output reg [31:0]Rs_Data_Out,//data from source register
	output reg [31:0]Rt_Data_Out,//data from target register
	output reg [31:0]Instr_bit15_to_bit0_Out,//function control and shamt
	output reg [4:0]Rd_Addr_Out,//the address of destination register
	output reg [4:0]Rs_Addr_Out,
	output reg [4:0]Rt_Addr_Out,//the address of target register
	//inputs
	input [1:0]WB_In,
	input [1:0]M_In,
	input [3:0]Ex_In,
	input [31:0]Rs_Data_In,
	input [31:0]Rt_Data_In,
	input [31:0]Instr_bit15_to_bit0_In,
	input [4:0]Rd_Addr_In,
	input [4:0]Rs_Addr_In,
	input [4:0]Rt_Addr_In,
	input clk
);
	/*The data and control signal from ID stage will be 
	send to EX stage when the clock is at positive edge.*/
	always@(posedge clk)begin
		WB_Out = WB_In;
		M_Out = M_In;
		Ex_Out = Ex_In;
		Rs_Data_Out = Rs_Data_In;
		Rt_Data_Out = Rt_Data_In;
		Instr_bit15_to_bit0_Out = Instr_bit15_to_bit0_In;
		Rd_Addr_Out = Rd_Addr_In;
		Rs_Addr_Out = Rs_Addr_In;
		Rt_Addr_Out = Rt_Addr_In;
	end
endmodule

