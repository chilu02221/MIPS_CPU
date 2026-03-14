module AND(
	//Output
	output and_out,
	//input
	input Branch,Zero
);
assign and_out = Branch & Zero;
endmodule
