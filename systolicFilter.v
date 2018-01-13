module systolicFilter(
	input Clk_i,
	input [17:0] Data_i,
	input DataNd_i,
	output [17:0] Data_o,
	output DataValid_o
);

	wire [47:0] outData;
	wire outDataValid;
	systolicFilterBlock # (
		.CoeffCount(16)
	)
	systolicFilterBlockInst
	(
		.Clk_i(Clk_i),
		.Data_i(Data_i),
		.DataNd_i(DataNd_i),
		.Data_o(outData),
		.DataValid_o(outDataValid)
	);
	
	wire dataValid;
	roundSymmetric #
	( 
		.inDataWidth(38),
		.outDataWidth(18)
	)
	roundInst
	(
		.Rst_i(Rst_i),
		.Clk_i(Clk_i),
		.Data_i(outData[37:0]),
		.DataNd_i(outDataValid),
		.Data_o(Data_o),
		.DataValid_o(DataValid_o)
	);


endmodule
