`timescale 1ns / 1ps

module BCDCounter(
    input clk,
    input clr,
    output [3:0] BCD0,
    output [3:0] BCD1
    );
    assign c0 = BCD0[0] && BCD0[3];
    assign c1 = BCD1[0] && BCD1[3] && c0;
    upcount lower(4'b0,1,clk,1,(clr||c0),BCD0);
    upcount upper(4'b0,1,clk,c0,(clr||c1),BCD1);
endmodule

module upcount (R, Resetn, Clock, E, L, Q);
    input [3:0] R;
    input Resetn, Clock, E, L;
    output reg [3:0] Q;
    always @(negedge Resetn, posedge Clock)
        if (!Resetn)
            Q <= 0;
        else if (L)
            Q <= R;
        else if (E)
            Q <= Q + 1;
endmodule