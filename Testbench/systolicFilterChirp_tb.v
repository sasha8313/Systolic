`timescale 1ps / 1ps
module systolicFilterChirp_tb;

	// Inputs
	reg Clk_i;
	reg [17:0] Data_i;
	reg DataNd_i;

	// Outputs
	wire [17:0] Data_o;
	wire DataValid_o;

	// Instantiate the Unit Under Test (UUT)
	systolicFilter uut (
		.Clk_i(Clk_i), 
		.Data_i(Data_i), 
		.DataNd_i(DataNd_i), 
		.Data_o(Data_o), 
		.DataValid_o(DataValid_o)
	);

	initial begin
		// Initialize Inputs
		Clk_i = 0;
		Data_i = 0;
		DataNd_i = 0;

		// Wait 100 ns for global reset to finish
		#100;
	end
	
	parameter period = 5000;
	always # (period / 2) Clk_i <= ~Clk_i;
	
	integer simCnt = 0;
	always @ (posedge Clk_i) simCnt <= simCnt + 1;
	
	real pi = 3.14159265358;
	real phase = 0;
	real phaseInc = 0.001;
	real signal;
	always @ (posedge Clk_i)
		begin
			DataNd_i <= 1;
			if (simCnt >= 1000)
				begin
					phase = phase + phaseInc;
					phaseInc <= phaseInc + 0.0005;
					signal = $sin(2*pi*phase);
					Data_i = 2**16 * signal;
				end
			else
				Data_i = 0;
		end
			
	reg [17:0] dataOutTest;
	always @ (posedge Clk_i)
		if (DataValid_o)
			dataOutTest <= Data_o;		
      
endmodule

