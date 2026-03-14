module MUX_32(
	//Outputs
	output reg [31:0]MUX_out,
	//Inputs
	input [31:0]instr0,
	input [31:0]instr1,
	input s
);
always@(*)begin
	case(s)
		1'b0:
			MUX_out <= instr0;
		1'b1:
			MUX_out <= instr1;
		default:
			MUX_out <= 32'bz;
	endcase
end

endmodule
		
