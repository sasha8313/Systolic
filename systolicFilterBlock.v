module systolicFilterBlock # (
	parameter CoeffCount = 16
)
(
	input Clk_i,
	input [17:0] Data_i,
	input DataNd_i,
	output [47:0] Data_o,
	output DataValid_o
);

	wire signed [17:0] coeff[0:CoeffCount-1];

	assign coeff[0] = 18'h3e6c9;
	assign coeff[1] = 18'h3c349;
	assign coeff[2] = 18'h3cfde;
	assign coeff[3] = 18'h3f440;
	assign coeff[4] = 18'h05e4b;
	assign coeff[5] = 18'h0e79f;
	assign coeff[6] = 18'h172aa;
	assign coeff[7] = 18'h1c760;
	assign coeff[8] = 18'h1c760;
	assign coeff[9] = 18'h172aa;
	assign coeff[10] = 18'h0e79f;
	assign coeff[11] = 18'h05e4b;
	assign coeff[12] = 18'h3f440;
	assign coeff[13] = 18'h3cfde;
	assign coeff[14] = 18'h3c349;
	assign coeff[15] = 18'h3e6c9;	

	wire signed [17:0] dataIn = Data_i;
	reg [3:0] ndShReg;
	
	always @ (posedge Clk_i)
		ndShReg <= {ndShReg[2:0], DataNd_i};
	
	reg signed [17:0] inReg0[0:CoeffCount-1];
	reg signed [17:0] inReg1[0:CoeffCount-1];
	reg signed [34:0] multResult[0:CoeffCount-1];
	reg signed [47:0] sumResult[0:CoeffCount-1];
	
	
	genvar i;
	generate
		for (i = 0; i < CoeffCount; i = i + 1)
			begin 
				always @ (posedge Clk_i)
					begin
						if (DataNd_i)
							begin
								if (i == 0)
									begin
										inReg0[i] <= 0;
										inReg1[i] <= dataIn;
									end
								else
									begin
										inReg0[i] <= inReg1[i-1];
										inReg1[i] <= inReg0[i];
									end
							end
						
						if (ndShReg[0])
							multResult[i] <= inReg1[i] * coeff[i];
						
						if (ndShReg[1])
							begin
								if (i == 0)
									sumResult[i] <= multResult[i];
								else
									sumResult[i] <= multResult[i] + sumResult[i-1];
							end
					end
			end
	endgenerate

	assign Data_o = sumResult[CoeffCount-1];
	assign DataValid_o = ndShReg[2];

endmodule
