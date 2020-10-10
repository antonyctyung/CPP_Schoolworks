`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/21/2020 04:12:45 PM
// Design Name: 
// Module Name: sim
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


module sim;
    reg [2:0] test_data;
    wire [7:0] test_y;
    decoder uut(.data(test_data), .y(test_y) );
    
    initial begin
    test_data = 0;
    #1;
    test_data = 1;
    #1;
    test_data = 2;
    #1;
    test_data = 3;
    #1;
    test_data = 4;
    #1;
    test_data = 5;
    #1;
    test_data = 6;
    #1;
    test_data = 7;
    end
endmodule
