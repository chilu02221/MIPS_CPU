module Reg_MUX(
	//Outputs
	output reg [4:0]MUX_out,
	//Inputs
	input [4:0]instr0,
	input [4:0]instr1,
	input s
);
always@(*)begin
	case(s)
		1'b0:
			MUX_out <= instr0;
		1'b1:
			MUX_out <= instr1;
		default:
			MUX_out <= 5'bz;
	endcase
end

endmodule
		
