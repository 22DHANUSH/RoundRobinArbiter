//-------------------------Variable Time Slice Round Robin Arbiter -----------------------------//

module round_robin_arbiter_variable_time_slice(
	input clk,
	input rst_n,
	input [3:0] REQ,
	output reg[3:0] GNT
	);

	reg [1:0] count;
	reg [3:0] present_state;
	reg [3:0] next_state;

	parameter [3:0] S_ideal = 4'b0000;
	parameter [3:0] S_0 = 4'b0001;
	parameter [3:0] S_1 = 4'b0010;
	parameter [3:0] S_2 = 4'b0100;
	parameter [3:0] S_3 = 4'b1000;

	always @ (posedge clk or negedge rst_n) begin
		if (!rst_n)
			present_state <= S_ideal;
		else
			present_state <= next_state;
	end

	always @(present_state or REQ) begin
		case(present_state)
			S_ideal: begin
				count = 2'b00;
				if (REQ[0])
					next_state = S_0;
				else if (REQ[1])
					next_state = S_1;
				else if (REQ[2])
					next_state = S_2;
				else if (REQ[3])
					next_state = S_3;
			end

			S_0: begin
				if (REQ[0]) begin
					if (count == 2'b10) begin
						if (REQ[1])
							next_state = S_1;
						else if (REQ[2])
							next_state = S_2;
						else if (REQ[3])
							next_state = S_3;
						else
							next_state = S_0;
					end else
						count = count + 1'b1;
				end else if (REQ[1])
					next_state = S_1;
				else if (REQ[2])
					next_state = S_2;
				else if (REQ[3])
					next_state = S_3;
				else
					next_state = S_ideal;
			end

			S_1: begin
				if (REQ[1]) begin
					if (count == 2'b10) begin
						if (REQ[2])
							next_state = S_2;
						else if (REQ[3])
							next_state = S_3;
						else if (REQ[0])
							next_state = S_0;
						else
							next_state = S_1;
					end else
						count = count + 1'b1;
				end else if (REQ[2])
					next_state = S_2;
				else if (REQ[3])
					next_state = S_3;
				else if (REQ[0])
					next_state = S_0;
				else
					next_state = S_ideal;
			end

			S_2: begin
				if (REQ[2]) begin
					if (count == 2'b10) begin
						if (REQ[3])
							next_state = S_3;
						else if (REQ[0])
							next_state = S_0;
						else if (REQ[1])
							next_state = S_1;
						else
							next_state = S_2;
					end else
						count = count + 1'b1;
				end else if (REQ[3])
					next_state = S_3;
				else if (REQ[0])
					next_state = S_0;
				else if (REQ[1])
					next_state = S_1;
				else
					next_state = S_ideal;
			end

			S_3: begin
				if (REQ[3]) begin
					if (count == 2'b10) begin
						if (REQ[0])
							next_state = S_0;
						else if (REQ[1])
							next_state = S_1;
						else if (REQ[2])
							next_state = S_2;
						else
							next_state = S_3;
					end else
						count = count + 1'b1;
				end else if (REQ[0])
					next_state = S_0;
				else if (REQ[1])
					next_state = S_1;
				else if (REQ[2])
					next_state = S_2;
				else
					next_state = S_ideal;
			end

			default: begin
				count = 2'b00;
				if (REQ[0])
					next_state = S_0;
				else if (REQ[1])
					next_state = S_1;
				else if (REQ[2])
					next_state = S_2;
				else if (REQ[3])
					next_state = S_3;
			end
		endcase
	end

	always @(posedge clk or negedge rst_n) begin
		if (!rst_n)
			GNT <= 4'b0000;
		else
			case(present_state)
				S_0: GNT <= 4'b0001;
				S_1: GNT <= 4'b0010;
				S_2: GNT <= 4'b0100;
				S_3: GNT <= 4'b1000;
				default: GNT <= 4'b0000;
			endcase
	end

endmodule
