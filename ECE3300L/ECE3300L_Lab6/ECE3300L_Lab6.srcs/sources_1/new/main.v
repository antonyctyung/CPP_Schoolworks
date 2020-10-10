`timescale 1ns / 1ps

module slowerClkGen(clk, resetSW, outsignal);
    input clk;
    input resetSW;
    output  outsignal;
    reg [26:0] counter;  
    reg outsignal;
    always @ (posedge clk)
    begin
    if (resetSW)
        begin
        counter=0;
        outsignal=0;
        end
    else
        begin
        counter = counter +1;
        if (counter == 100_000_000)     // why is this a 0.5 Hz?
            begin
            outsignal=~outsignal;
            counter =0;
            end
        end
    end
endmodule

module upcounter (Resetn, Clock, E, Q);
	input Resetn, Clock, E;
	output reg [2:0] Q;
	
	always @(negedge Resetn, posedge Clock)
	 	if (!Resetn)
			Q <= 0;
		else if (E)
			Q <= Q + 1;
			
endmodule

module SevenSegmentDecoder(d,C);        // encode binary input to display hex on 7-seg
    input [3:0] d;                      // 4-bit (sign magnitude) integer
    output reg [1:7] C;                 // to 7-segment cathode { CA, CB, ... , CG }
    always @*
    begin
        case(d)
            'h0:  C=7'b0000001;
            'h1:  C=7'b1001111;
            'h2:  C=7'b0010010;
            'h3:  C=7'b0000110;
            'h4:  C=7'b1001100;
            'h5:  C=7'b0100100;
            'h6:  C=7'b0100000;
            'h7:  C=7'b0001111;
            'h8:  C=7'b0000000;
            'h9:  C=7'b0000100;
            'hA:  C=7'b0001000;
            'hB:  C=7'b1100000;
            'hC:  C=7'b0110001;
            'hD:  C=7'b1000010;
            'hE:  C=7'b0110000;
            'hF:  C=7'b0111000;
            default: 
                C=7'b1111111;           // default to off
        endcase
    end
endmodule

module SevenSegmentController(Y, C, DP, AN);
   input [3:0] Y;                   
   output [1:7] C;
   output DP;
   output [7:0] AN;
   
   SevenSegmentDecoder ssd(Y,C);
   assign AN = 8'b11111110, DP = 1;
endmodule

module ThreeBitCounterOnSevenSegmentDisplay(CLK100MHZ,BTNC,LED,CA,CB,CC,CD,CE,CF,CG,DP,AN);
    input CLK100MHZ;                    // system clock input signal
    input BTNC;                         // reset button
    output CA,CB,CC,CD,CE,CF,CG,DP;     // Seven segment display inputs
    output [7:0] AN;                    // Seven segment display enable
    output [2:0] LED;                   // LED output for result
    wire [2:0] Y;                       // node connecting adder output, LED and ssc input
    wire cntrE;                         // counter enable
    wire slowclk;                       // slow clock signal
    slowerClkGen scg(CLK100MHZ, BTNC, slowclk);
    assign cntrE = 1;                   // enable upcounter
    upcounter counter(!BTNC,slowclk,cntrE,Y);
    SevenSegmentController ssc({0,Y}, {CA,CB,CC,CD,CE,CF,CG} ,DP,AN);
    assign LED = Y;                     // output result to LEDs 
endmodule