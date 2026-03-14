module FU(
	//outputs
	output reg [1:0]ForwardA,ForwardB,
	//inputs
	input [4:0]ID_EX_RsAddr,
	input [4:0]ID_EX_RtAddr,
	input [4:0]EX_MEM_RdAddr,
	input [4:0]MEM_WB_RdAddr,
	input EX_MEM_RegWrite,
	input MEM_WB_RegWrite
);
	always@(ID_EX_RsAddr,ID_EX_RtAddr,EX_MEM_RdAddr,MEM_WB_RdAddr,EX_MEM_RegWrite,MEM_WB_RegWrite)begin
		if(EX_MEM_RegWrite && (EX_MEM_RdAddr != 0) && (EX_MEM_RdAddr == ID_EX_RsAddr))
			ForwardA = 2'b10; //EX hazard at source register
		else if(MEM_WB_RegWrite && (MEM_WB_RdAddr != 0) && (EX_MEM_RdAddr != ID_EX_RsAddr) && (MEM_WB_RdAddr == ID_EX_RsAddr))
			ForwardA = 2'b01; //MEM hazard at source register
		else
			ForwardA = 2'b00;//no hazard at source register

		if(EX_MEM_RegWrite && ( EX_MEM_RdAddr != 0 ) && ( EX_MEM_RdAddr == ID_EX_RtAddr ))
			ForwardB = 2'b10; //EX hazard at target register
		else if(MEM_WB_RegWrite && (MEM_WB_RdAddr != 0) && (EX_MEM_RdAddr != ID_EX_RtAddr) && (MEM_WB_RdAddr == ID_EX_RtAddr))
			ForwardB = 2'b01; //MEM hazard at target register
		else
			ForwardB = 2'b00;//no hazard at target register
		
	end
endmodule