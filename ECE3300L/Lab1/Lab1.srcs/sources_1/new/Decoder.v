module Decoder (data, y);
    input [5:0] data;
    output reg [0:63] y;
    always @(data)
	begin
		y=0;
		y[data]=1;
	end
endmodule