module ADD(
	//output
	output [31:0]Addr_Out,
	//input
	input [31:0]Addr_In
);     
assign Addr_Out=Addr_In+32'd4; 
endmodule