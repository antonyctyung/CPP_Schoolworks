`timescale 1ns / 1ps

module sign_mag_add
   #(parameter N=4 ) // number of bits of inputs/output
   (input wire [N-1:0] a, b,
    output reg [N-1:0] sum
   );
   // signal declaration
   reg [N-2:0]  mag_a, mag_b, mag_sum, max, min;
   reg sign_a, sign_b, sign_sum;
   //body
   always @*
   begin
      // separate magnitude and sign
      mag_a = a[N-2:0];
      mag_b = b[N-2:0];
      sign_a = a[N-1];
      sign_b = b[N-1];
      // sort according to magnitude
      if (mag_a > mag_b)
         begin
            max = mag_a;
            min = mag_b;
            sign_sum = sign_a;
         end
      else
         begin
            max = mag_b;
            min = mag_a;
            sign_sum = sign_b;
         end
      // add/sub magnitude
      if (sign_a==sign_b)
         mag_sum = max + min;
      else
         mag_sum = max - min;
      // form output
      sum = {sign_sum, mag_sum};
   end
endmodule

module SevenSegmentDecoder(d,C);    // encode binary input to display hex on 7-seg
    input [3:0] d;                  // 4-bit (sign magnitude) integer
    output reg [1:7] C;             // to 7-segment cathode { CA, CB, ... , CG }
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

module BinaryToSevenSegmentDisplay(SW,LED,CA,CB,CC,CD,CE,CF,CG,DP,AN);
   input [7:0] SW;                  // Switches, [7:4] for input a, [3:0] for input b
   output CA,CB,CC,CD,CE,CF,CG,DP;  // Seven segment display inputs
   output [7:0] AN;                 // Seven segment display enable
   output [3:0] LED;                // LED output for result
   wire [3:0] Y;                    // node connecting adder output, LED and ssc input
   sign_mag_add smadd(SW[7:4],SW[3:0],Y);
   SevenSegmentController ssc(Y, {CA,CB,CC,CD,CE,CF,CG} ,DP,AN);
   assign LED = Y;                  // output result to LEDs 
endmodule