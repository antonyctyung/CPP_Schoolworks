`timescale 1ns / 1ps

module sim(
    );
    reg clk;
    wire [5:0] sec1;
    wire [5:0] min1;
    wire [5:0] sec2;
    wire [5:0] min2;
    AlarmTimer uut(clk,1,0,sec1,min1,sec2,min2,se);

    initial 
        begin 
            clk = 0;
            forever #1 clk = !clk;
        end

    initial
        begin
            sec1 = 0;
            sec2 = 0;
            min1 = 2;
            min2 = 0;
            #5  min2 = 2;


        end


endmodule
