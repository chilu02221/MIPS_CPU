module HDU(
	//outputs
	output reg Control_Mux, //let system to stall or not 
	output reg PCWrite, //PC to renew or not 
	output reg IF_ID_Write, //IF_ID renew or not 
	//inputs
	input ID_EX_MemReadData,//to detect the instruction is load word or not
	input [4:0]IF_ID_RsAddr, //the address of source register in IF/ID register
	input [4:0]IF_ID_RtAddr, //the address of target register in IF/ID register
	input [4:0]ID_EX_RtAddr //the address of target register in ID/EX register
);

	initial begin //initial the system to let PC runing
		Control_Mux = 1'b0;
		PCWrite = 1'b1;
		IF_ID_Write = 1'b1;
	end
	
	always@(ID_EX_MemReadData,IF_ID_RsAddr,IF_ID_RtAddr,ID_EX_RtAddr)begin
		if(ID_EX_MemReadData && (( ID_EX_RtAddr == IF_ID_RsAddr ) || ( ID_EX_RtAddr == IF_ID_RtAddr )))begin //stall the pipeline
			Control_Mux = 1'b1;
			PCWrite = 1'b0;
			IF_ID_Write = 1'b0;
		end
		else begin //unstall
			Control_Mux = 1'b0;
			PCWrite = 1'b1;
			IF_ID_Write = 1'b1;
		end
	end
endmodule
		
		