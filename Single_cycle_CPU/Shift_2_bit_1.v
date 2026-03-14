module Shift_2_bit_1(
	//Outputs
	output reg [27:0]instruction_out,
	//Inputs
	input [25:0]instruction_in
);
always @(instruction_in)begin
	instruction_out <= {instruction_in,2'b0};
end
endmodule
