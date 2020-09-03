`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/13/2020 01:11:46 AM
// Design Name: 
// Module Name: lab1_sim
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


module lab1_sim;
    reg [2:0] test_data;
    wire [7:0] test_y;
    decoder uut(.data(test_data), .y(test_y) );
    
    initial begin
    test_data = 0;
    #1 test_data = 1;
    #1 test_data = 2;
    #1 test_data = 3;
    #1 test_data = 4;
    #1 test_data = 5;
    #1 test_data = 6;
    #1 test_data = 7;
    end
endmodule
