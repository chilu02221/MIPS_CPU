module ALU_Control(
	//output
	output reg [5:0]funct,
	//input
	input [5:0]funct_ctrl,
	input [1:0]ALUOP
);
always@(ALUOP,funct_ctrl)begin
	if(ALUOP==2'b10)
	begin
		case(funct_ctrl)
		6'b001011://ADDU
			funct <= 6'b001001;
		6'b001101://SUBU
			funct <= 6'b001010;
		6'b100101://OR
			funct <= 6'b010010;
		6'b000010://SRL
			funct <= 6'b100010;
		default:
			funct <= 6'b000000;
		endcase
	end
	else if(ALUOP==2'b00) //addiu
	begin
		funct <= 6'b001001;
	end
	else if(ALUOP==2'b01) //subiu
	begin
		funct <= 6'b001010;
	end
end
endmodule
