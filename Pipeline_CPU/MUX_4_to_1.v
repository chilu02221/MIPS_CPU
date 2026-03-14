module MUX_4_to_1(
	//outputs
	output reg[31:0]Result,
	//inputs
	input [31:0]Src1,Src2,Src3,
	input [1:0]s
);
	always@(Src1,Src2,Src3,s)begin
		if(s==2'b00)
			Result = Src1;
		else if(s==2'b01)
			Result = Src2;
		else if(s==2'b10)
			Result = Src3;
	end
endmodule
