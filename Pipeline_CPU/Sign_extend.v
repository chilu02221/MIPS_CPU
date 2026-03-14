module Sign_extend(
	//output
	output [31:0]Src,
	//input
	input [15:0]imm
);
	assign Src = {16'b0,imm};
endmodule
