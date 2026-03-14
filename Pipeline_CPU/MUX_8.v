module MUX_8(
	//outputs
	output reg [7:0]Result,
	//input 
	input [7:0]Control_Signal,zero,
	input s
);
	always@(s,Control_Signal)begin
		if(s==1)
			Result <= zero;
		else if(s==0)
			Result <= Control_Signal;
		else
			Result <= 8'b0;
	end
endmodule
