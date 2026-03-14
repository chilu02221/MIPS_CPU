module ADD(
	//output
	output [31:0]Addr_Out,
	//input
	input [31:0]Addr_In1,Addr_In2
);     
assign Addr_Out=Addr_In1+Addr_In2; 
endmodule