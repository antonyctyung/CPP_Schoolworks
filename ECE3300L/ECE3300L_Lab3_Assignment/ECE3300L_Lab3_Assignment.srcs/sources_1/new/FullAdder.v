`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/08/2020 12:55:13 PM
// Design Name: 
// Module Name: EightBitAdder
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


module FullAdderStructural(x,y,Cin,Cout,s);
    input x,y,Cin;
    output s,Cout;
    xor (s, x, y, Cin);
	and (z1, x, y);
	and (z2, x, Cin);
	and (z3, y, Cin);
    or (Cout, z1, z2, z3);
endmodule

module FullAdderBehavioral(x,y,Cin,Cout,s);
    input x,y,Cin;
    output s,Cout;
    assign s = x ^ y ^ Cin, // s = x XOR y XOR Cin
           Cout = (x & y) | (x & Cin) | (y & Cin);
endmodule

module EightBitAdder(X,Y,cin,cout,S);
    input [7:0] X, Y;
    input cin;
    output cout;
    output [7:0] S;
    wire [7:1] C;
    FullAdderBehavioral stage0(X[0],Y[0],cin,C[1],S[0]);
    FullAdderBehavioral stage1(X[1],Y[1],C[1],C[2],S[1]);
    FullAdderBehavioral stage2(X[2],Y[2],C[2],C[3],S[2]);
    FullAdderBehavioral stage3(X[3],Y[3],C[3],C[4],S[3]);
    FullAdderBehavioral stage4(X[4],Y[4],C[4],C[5],S[4]);
    FullAdderBehavioral stage5(X[5],Y[5],C[5],C[6],S[5]);
    FullAdderBehavioral stage6(X[6],Y[6],C[6],C[7],S[6]);
    FullAdderBehavioral stage7(X[7],Y[7],C[7],cout,S[7]);
endmodule

module AdderFPGAInterface(SW, LED);
    input [15:0] SW;        // Switches
    output [15:0] LED;      // LEDs
    EightBitAdder adder(.X(SW[7:0]), .Y(SW[15:8]), .cin(0), .cout(LED[8]), .S(LED[7:0])); 
    // connect switches to adder X,Y input and LED to S, cout output
    assign LED[15:9] = 0; // turn off unused LEDs
endmodule