module EX_MEM(
	//outputs
	output reg [1:0]WB_Out,//Reg_Write
	output reg [1:0]M_Out,
	output reg [31:0]ALU_Result_Out,//Result from ALU
	output reg [31:0]Mem_Data_Out,//the data that will write into memory
	output reg [4:0]Rd_Addr_Out,//the address of destination register
	//inputs
	input [1:0]WB_In,
	input [1:0]M_In,
	input [31:0]ALU_Result_In,
	input [31:0]Mem_Data_In,
	input [4:0]Rd_Addr_In,
	input clk
);
	/*The data and control signal from EX stage will be 
	send to MEM stage when the clock is at positive edge.*/
	always@(posedge clk)begin
		WB_Out = WB_In;
		M_Out = M_In;
		ALU_Result_Out = ALU_Result_In;
		Mem_Data_Out = Mem_Data_In;
		Rd_Addr_Out = Rd_Addr_In;
	end
endmodule

