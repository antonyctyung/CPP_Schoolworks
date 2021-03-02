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
	  if (counter == 100_000_000) //why is this a 0.5 Hz?
		begin
			outsignal=~outsignal;
			counter =0;
		end
    end
    end
endmodule

module turing(
    input clk,
    input reset,
    output state_reg,
    output [2:0] index,
    output [7:0] tape_reg
    );

    // data registers initialization
    reg [7:0] tape_reg = 8'b00111000;
    reg [2:0] index = 5;

    // state assignment
    localparam
           init = 2'b00,
        running = 2'b01,
           halt = 2'b10;
    
    // state register
    reg [1:0] state_reg  = init; // double as turing_state, done_reg
    reg [1:0] state_next = init;

    // state progression
    always @(posedge clk, posedge reset)
        if (reset)
                state_reg <= init;
        else
            state_reg <= state_next;

    // state behavior
    always @(negedge clk)
        begin
            state_next = state_reg;
            case (state_reg)
                init:
                    begin
                        tape_reg = 8'b00111000;
                        index = 5;
                        state_next = running;
                    end
                running:
                    begin
                        if (tape_reg[index] == 0)
                            begin
                                tape_reg[index] = 1'b1;
                                state_next = halt;
                                index = index - 1;
                            end
                        else
                            index = index - 1;
                    end
                halt: state_next = halt;
                default:
                    state_next = init;
            endcase
        end
endmodule

module main(
    input CLK100MHZ,
    input BTNR,
    output [15:0] LED
    );

    wire [7:0] tape_reg;
    wire [2:0] index;
    wire halt,running;

    assign reset = BTNR;

    slowerClkGen scg(CLK100MHZ, reset, clkhalfhz);
    turing tm(clkhalfhz, reset, {halt,running}, index, tape_reg);
    assign LED[15] = halt;
    assign LED[14] = running;
    assign LED[13] = 0;
    assign LED[12] = 0;
    assign LED[11:9] = index;
    assign LED[8] = 0;
    assign LED[7:0] = tape_reg;

endmodule