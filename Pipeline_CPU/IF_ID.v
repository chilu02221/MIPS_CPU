module IF_ID(
	//outputs
	output reg [31:0]Instr_Out, //Instruction to ID stage
	//inputs
	input [31:0]Instr_In,//Instruction from IF stage
	input IF_ID_Write,
	input clk
);
	/*The instruction from IF stage will be send to 
	  ID stage when the clock is at positive edge.*/
	always@(posedge clk)begin 
		if(IF_ID_Write)
			Instr_Out = Instr_In;
			
	end
endmodule
