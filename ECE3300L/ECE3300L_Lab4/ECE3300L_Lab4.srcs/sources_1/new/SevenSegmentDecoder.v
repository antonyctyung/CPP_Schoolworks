`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/15/2020 12:11:53 PM
// Design Name: 
// Module Name: SevenSegmentDecoder
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module dec3to8 (W, En, Y);
    input [2:0] W;
    input En;
    output reg [7:0] Y;
  
    always @(W, En)
    begin
        case ({En, W})
        4'b1000: Y = 8'b00000001;
        4'b1001: Y = 8'b00000010;
        4'b1010: Y = 8'b00000100;
        4'b1011: Y = 8'b00001000;
        4'b1100: Y = 8'b00010000;
        4'b1101: Y = 8'b00100000;
        4'b1110: Y = 8'b01000000;
        4'b1111: Y = 8'b10000000;
        default: Y = 8'b00000000;
        endcase
    end
endmodule

module SevenSegmentDecoder(d,C);
    input [7:0] d;               // one hot input indicating which digit from 0 to 7
    output reg [1:7] C;          // to 7-segment cathode { CA, CB, ... , CG }
	always @*
	begin
		case(d)
			8'b00000001:         // case 0
				C=7'b0000001;
			8'b00000010:         // case 1
				C=7'b1001111;
			8'b00000100:         // case 2
				C=7'b0010010;
            8'b00001000:         // case 3
				C=7'b0000110;
			8'b00010000:         // case 4
				C=7'b1001100;
			8'b00100000:         // case 5
				C=7'b0100100;
			8'b01000000:         // case 6
				C=7'b0100000;
			8'b10000000:         // case 7
				C=7'b0001111;
			default: 
				C=7'b1111111;
		endcase
	end
endmodule

module SevenSegmentController(Y, C, DP, AN);
    input [7:0] Y;
    output [1:7] C;
    output DP;
    output [7:0] AN;
    
    SevenSegmentDecoder ssd(Y,C);
    assign AN = 8'b11111110, DP = 1;
endmodule

module BinaryToSevenSegmentDisplay(SW,CA,CB,CC,CD,CE,CF,CG,DP,AN);
    input [2:0] SW;
    output CA,CB,CC,CD,CE,CF,CG,DP;
    output [7:0] AN;
    wire [7:0] Y;
    dec3to8 dec(SW,1,Y);
    SevenSegmentController ssc(Y, {CA,CB,CC,CD,CE,CF,CG} ,DP,AN);
    
endmodule
