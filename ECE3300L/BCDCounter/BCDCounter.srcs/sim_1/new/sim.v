`timescale 1ns / 1ps

module sim;
    reg clk, clr;
    wire [3:0] lower;
    wire [3:0] upper;
    BCDCounter uut(clk, clr, lower, upper);
    initial 
        begin 
            clk = 0;
            clr = 1;
            #1 clk = 1;
            #1 clr = 0;
            forever #1 clk = !clk;
        end
endmodule
