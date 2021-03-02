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
      if (counter == 50_000_000) 
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

module PLSR(
    input load,
    input enable,
    input clk,
    input serial_in,
    input [7:0] R,
    output reg [7:0] Q
);

    // MSB in LSB out i.e. shift right

    always @(posedge clk, posedge load)
    if (load)
        Q = R;
    else if (enable)
        Q = {serial_in, Q[7:1]};

endmodule

module PLSR16(
    input load,
    input enable,
    input clk,
    input serial_in,
    input [15:0] R,
    output reg [15:0] Q
);

    // MSB in LSB out i.e. shift right

    always @(posedge clk, posedge load)
    if (load)
        Q = R;
    else if (enable)
        Q = {serial_in, Q[15:1]};

endmodule


module oddParityGen(
    input clk,
    input in,
    input reset,
    output out
);

    // state registers
    reg state_reg = 1;
    reg state_next = 1;

    // output
    assign out = state_reg;

    // state progression
    always @(posedge clk)
        state_reg <= state_next;

    // state behavior
    always @*
    begin
        state_next = state_reg;
        if (reset)
            state_next = 1;
        else
            case (state_reg)
                1:
                    if (in)
                        state_next = 0;
                0:
                    if (in)
                        state_next = 1;
                default: state_next = 1;
            endcase
    end

endmodule

module debouncer(
        input clk,
        input sw,
        output db
    );
    
    // 10 ms tick generation
    reg [20:0] counter;
    always @(posedge clk)
        counter = (counter == 999999)? 0 : counter + 1;
    wire m_tick;
    assign m_tick = ~|counter;

    // state alias
    localparam [2:0] 
        zero    = 3'b000,
        wait1_1 = 3'b001,
        wait1_2 = 3'b010,
        wait1_3 = 3'b011,
        one     = 3'b100,
        wait0_1 = 3'b101,
        wait0_2 = 3'b110,
        wait0_3 = 3'b111;
    
    // state registers
    reg [2:0] state_reg;
    reg [2:0] state_next;

    // output
    assign db = state_reg[2];

    // state progression
    always @(posedge clk)
        state_reg <= state_next;
    
    // state behavior
    always @*
        begin
            state_next = state_reg;
            case (state_reg)
                zero:
                    if (sw)
                        state_next = wait1_1;
                wait1_1:
                    if (!sw)
                        state_next = zero;
                    else if (m_tick)
                        state_next = wait1_2;
                wait1_2:
                    if (!sw)
                        state_next = zero;
                    else if (m_tick)
                        state_next = wait1_3;
                wait1_3:
                    if (!sw)
                        state_next = zero;
                    else if (m_tick)
                        state_next = one;
                one:
                    if (!sw)
                        state_next = wait0_1;
                wait0_1:
                    if (sw)
                        state_next = one;
                    else if (m_tick)
                        state_next = wait0_2;
                wait0_2:
                    if (sw)
                        state_next = one;
                    else if (m_tick)
                        state_next = wait0_3;
                wait0_3:
                    if (sw)
                        state_next = one;
                    else if (m_tick)
                        state_next = zero;
                default:
                    state_next = zero;
            endcase
        end
endmodule

module mux2x1(
    input [1:0]d,
    input select,
    output q
);
assign q = (select)? d[1]: d[0];
endmodule

module Dflipflop(
    input D,
    input clk,
    output reg Q
);
always @(posedge clk) Q = D; 
endmodule

module DataTransmission(
    input load,
    input clk,
    input [7:0]b,
    output serial_out
);

wire [7:0] Q;
wire [2:0] count;
assign sel = &count;
assign w = Q[0];

PLSR         pls( load,    1,  clk,     0, b, Q);
oddParityGen opg(  clk, Q[0], load,     p);
upcounter    cnt(!load,  clk,    1, count);
mux2x1       mux({p,w},  sel,    D);
Dflipflop    dff(    D,  clk, serial_out);

endmodule

module main(
    input BTNL,
    input CLK100MHZ,
    input [7:0]SW,
    output [15:0]LED
);

slowerClkGen scg(CLK100MHZ, load, clk1Hz);
debouncer db(CLK100MHZ, BTNL, load);
DataTransmission dt(load, clk1Hz, SW[7:0], serial_out);
PLSR16 pls(load,1,clk1Hz,serial_out,0,LED);

endmodule