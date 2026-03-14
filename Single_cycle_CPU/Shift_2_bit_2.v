module Shift_2_bit_2(
	//Outputs
	output reg [31:0]instruction_out,
	//Inputs
	input [31:0]instruction_in
);
always @(instruction_in)begin
	instruction_out <= instruction_in << 2;
end
endmodule
