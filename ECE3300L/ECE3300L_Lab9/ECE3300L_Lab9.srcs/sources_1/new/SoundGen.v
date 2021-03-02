module SongPlayer( input clock, input reset, input playSound, output reg audioOut, output wire aud_sd,output reg [9:0] number,input [19:0] notePeriod,input [5:0] duration);
    reg [19:0] counter;
    reg [31:0] time1, noteTime;
    reg [9:0] msec;
    wire [5:0] note;
    reg enable;
    parameter clockFrequency = 100_000_000; 
    parameter startNum = 102;
    assign aud_sd = 1'b1;
    
    always @ (posedge clock) 
        begin
            if(reset | ~playSound) 
                begin 
                    counter <=0;  
                    time1   <=0;  
                    number  <=startNum;  
                    enable  <=1;
                    audioOut<=0;    
                end
            else 
                begin
                    counter <= counter + 1; 
                    time1<= time1+1;
                    if( counter >= notePeriod) 
                        begin
                            counter <=0;  
                            enable <= ~enable ; 
                        end    //toggle audio output     
                    if( time1 >= noteTime) 
                        begin    
                            time1 <=0;  
                            number <= number + 1; 
                        end  //play next note
                    if(enable)
                        begin
                            // audioOut <= ~|(counter%10); // 25% duty cycle => 0.25 PWMA
                            audioOut <= 1;
                        end
                    else
                        audioOut <= 0;
                    if(number == 174) number <=startNum; // Make the number reset at the end of the song
                end
        end    

    always @(duration) noteTime = duration * clockFrequency * 4 /70; // ~161 bpm?
           //number of   FPGA clock periods in one note.
endmodule

module MusicSheet( input [9:0] number, 
    output reg [19:0] note,//max 32 different musical notes
    output reg [5:0] duration);
parameter    EIGHTH = 5'b00001;
parameter   QUARTER = 5'b00010;
parameter      HALF = 5'b00100;
parameter       ONE = 2* HALF;
parameter       TWO = 2* ONE;
parameter C4=191110, D4=170265, E4 = 151685, F4=143172, G4 = 127551,C5 = 95557, SP = 1;  
 
always @ (number) begin
case(number) //Row Row Row your boat
0:     begin note = C4;  duration = HALF;    end    //row
1:     begin note = SP; duration = HALF;     end    //
2:     begin note = C4; duration = HALF;     end    //row
3:     begin note = SP;  duration = HALF;    end    //
4:     begin note = C4; duration = HALF;     end    //row
5:     begin note = SP; duration = HALF;     end    //
6:     begin note = D4; duration = HALF;     end    //your
7:     begin note = E4; duration = HALF;     end    //boat
8:     begin note = SP; duration = HALF;     end    //
9:     begin note = E4; duration = HALF;     end    //gently
10:     begin note = SP; duration = HALF;     end    //
11:     begin note = D4; duration = HALF;     end    //down
12:     begin note = E4; duration = HALF;     end    //
13:     begin note = SP;  duration = HALF;    end    //
14:     begin note = F4; duration = HALF;     end    //the
15:     begin note = G4; duration = HALF;     end    //stream
16:     begin note = SP;  duration = HALF;    end    //
    
17:     begin note = C5; duration = HALF;     end    //merrily
18:     begin note = SP; duration = QUARTER;     end    //
19:     begin note = C5; duration = HALF;     end    //
20:     begin note = SP; duration = QUARTER;     end    //
21:     begin note = C5; duration = HALF;     end    //
22:     begin note = SP; duration = QUARTER;     end    //

23:     begin note = G4; duration = HALF;     end    //
24:     begin note = SP; duration = QUARTER;     end    //
25:     begin note = G4; duration = HALF;     end    //
26:     begin note = SP; duration = QUARTER;     end    //
27:     begin note = G4; duration = HALF;     end    //
28:     begin note = SP; duration = QUARTER;     end    //

29:     begin note = E4; duration = HALF;     end    //
30:     begin note = SP; duration = QUARTER;     end    //
31:     begin note = E4; duration = HALF;     end    //
32:     begin note = SP; duration = QUARTER;     end    //
33:     begin note = E4; duration = HALF;     end    //
34:     begin note = SP; duration = QUARTER;     end    //

35:     begin note = C4; duration = HALF;     end    //
36:     begin note = SP; duration = QUARTER;     end    //
37:     begin note = C4; duration = HALF;     end    //
38:     begin note = SP; duration = QUARTER;     end    //
39:     begin note = C4; duration = HALF;     end    //
40:     begin note = SP; duration = QUARTER;     end    //

41:     begin note = G4; duration = ONE;     end    //Life
42:     begin note = SP; duration = HALF;     end    //
43:     begin note = F4; duration = HALF;     end    //is
44:     begin note = E4; duration = HALF;     end    //but
45:     begin note = SP; duration = HALF;     end    //
46:     begin note = D4; duration = HALF;     end    //a
47:     begin note = C4; duration = HALF;     end    //dream
default:     begin note = C4; duration = TWO;     end
endcase
end
endmodule

module BadApple1( input [9:0] number, 
    output reg [19:0] note,//max 32 different musical notes
    output reg [5:0] duration);
parameter THIRTYTWOTH = 6'b000001;
parameter   SIXTEENTH = 2*THIRTYTWOTH;
parameter      EIGHTH = 2*SIXTEENTH;
parameter     QUARTER = 2*EIGHTH;
parameter        HALF = 2*QUARTER;
parameter         ONE = 2*HALF;

parameter A0 = 1818182 ;
parameter B0F = 1716135 ;
parameter B0 = 1619816 ;
parameter C1 = 1528903 ;
parameter D1F = 1443092 ;
parameter D1 = 1362097 ;
parameter E1F = 1285649 ;
parameter E1 = 1213491 ;
parameter F1 = 1145383 ;
parameter G1F = 1081097 ;
parameter G1 = 1020420 ;
parameter A1F = 963148 ;
parameter A1 = 909091 ;
parameter B1F = 858068 ;
parameter B1 = 809908 ;
parameter C2 = 764451 ;
parameter D2F = 721546 ;
parameter D2 = 681049 ;
parameter E2F = 642824 ;
parameter E2 = 606745 ;
parameter F2 = 572691 ;
parameter G2F = 540549 ;
parameter G2 = 510210 ;
parameter A2F = 481574 ;
parameter A2 = 454545 ;
parameter B2F = 429034 ;
parameter B2 = 404954 ;
parameter C3 = 382226 ;
parameter D3F = 360773 ;
parameter D3 = 340524 ;
parameter E3F = 321412 ;
parameter E3 = 303373 ;
parameter F3 = 286346 ;
parameter G3F = 270274 ;
parameter G3 = 255105 ;
parameter A3F = 240787 ;
parameter A3 = 227273 ;
parameter B3F = 214517 ;
parameter B3 = 202477 ;
parameter C4 = 191113 ;
parameter D4F = 180386 ;
parameter D4 = 170262 ;
parameter E4F = 160706 ;
parameter E4 = 151686 ;
parameter F4 = 143173 ;
parameter G4F = 135137 ;
parameter G4 = 127553 ;
parameter A4F = 120394 ;
parameter A4 = 113636 ;
parameter B4F = 107258 ;
parameter B4 = 101238 ;
parameter C5 = 95556 ;
parameter D5F = 90193 ;
parameter D5 = 85131 ;
parameter E5F = 80353 ;
parameter E5 = 75843 ;
parameter F5 = 71586 ;
parameter G5F = 67569 ;
parameter G5 = 63776 ;
parameter A5F = 60197 ;
parameter A5 = 56818 ;
parameter B5F = 53629 ;
parameter B5 = 50619 ;
parameter C6 = 47778 ;
parameter D6F = 45097 ;
parameter D6 = 42566 ;
parameter E6F = 40177 ;
parameter E6 = 37922 ;
parameter F6 = 35793 ;
parameter G6F = 33784 ;
parameter G6 = 31888 ;
parameter A6F = 30098 ;
parameter A6 = 28409 ;
parameter B6F = 26815 ;
parameter B6 = 25310 ;
parameter C7 = 23889 ;
parameter D7F = 22548 ;
parameter D7 = 21283 ;
parameter E7F = 20088 ;
parameter E7 = 18961 ;
parameter F7 = 17897 ;
parameter G7F = 16892 ;
parameter G7 = 15944 ;
parameter A7F = 15049 ;
parameter A7 = 14205 ;
parameter B7F = 13407 ;
parameter B7 = 12655 ;
parameter SP = 1;
 
always @ (number) begin
case(number)
  0:     begin note = E1F;  duration = EIGHTH;    end    //
  1:     begin note = E1F; duration = SIXTEENTH;     end    //
  2:     begin note = B2F; duration = EIGHTH;     end    //
  3:     begin note = B2F; duration = SIXTEENTH;     end    //
  4:     begin note = D3F; duration = SIXTEENTH;     end    //
  5:     begin note = E3F; duration = SIXTEENTH;     end    //
  
  6:     begin note = E1F;  duration = EIGHTH;    end    //
  7:     begin note = E1F; duration = SIXTEENTH;     end    //
  8:     begin note = B2F; duration = EIGHTH;     end    //
  9:     begin note = B2F; duration = SIXTEENTH;     end    //
 10:     begin note = D3F; duration = SIXTEENTH;     end    //
 11:     begin note = E3F; duration = SIXTEENTH;     end    //
  
 12:     begin note = E1F;  duration = EIGHTH;    end    //
 13:     begin note = E1F; duration = SIXTEENTH;     end    //
 14:     begin note = B2F; duration = EIGHTH;     end    //
 15:     begin note = B2F; duration = SIXTEENTH;     end    //
 16:     begin note = D3F; duration = SIXTEENTH;     end    //
 17:     begin note = E3F; duration = SIXTEENTH;     end    //
  
 18:     begin note = E1F;  duration = EIGHTH;    end    //
 19:     begin note = E3F; duration = SIXTEENTH;     end    //
 20:     begin note = G3F; duration = SIXTEENTH;     end    //
 21:     begin note = G1F; duration = EIGHTH;    end    //
 22:     begin note = G3F; duration = SIXTEENTH;     end    //
 23:     begin note = A3F; duration = SIXTEENTH;     end    //
 
 24:     begin note = E1F;  duration = EIGHTH;    end    //
 25:     begin note = E1F; duration = SIXTEENTH;     end    //
 26:     begin note = B2F; duration = EIGHTH;     end    //
 27:     begin note = B2F; duration = SIXTEENTH;     end    //
 28:     begin note = D3F; duration = SIXTEENTH;     end    //
 29:     begin note = E3F; duration = SIXTEENTH;     end    //
  
 30:     begin note = E1F;  duration = EIGHTH;    end    //
 31:     begin note = E1F; duration = SIXTEENTH;     end    //
 32:     begin note = B2F; duration = EIGHTH;     end    //
 33:     begin note = B2F; duration = SIXTEENTH;     end    //
 34:     begin note = D3F; duration = SIXTEENTH;     end    //
 35:     begin note = E3F; duration = SIXTEENTH;     end    //
  
 36:     begin note = E1F;  duration = EIGHTH;    end    //
 37:     begin note = E1F; duration = SIXTEENTH;     end    //
 38:     begin note = B2F; duration = EIGHTH;     end    //
 39:     begin note = B2F; duration = SIXTEENTH;     end    //
 40:     begin note = D3F; duration = SIXTEENTH;     end    //
 41:     begin note = E3F; duration = SIXTEENTH;     end    //
 
 42:     begin note = A1F;  duration = EIGHTH;    end    //
 43:     begin note = G3F; duration = SIXTEENTH;     end    //
 44:     begin note = A3F; duration = SIXTEENTH;     end    //
 45:     begin note = G1F; duration = EIGHTH;    end    //
 46:     begin note = E3F; duration = SIXTEENTH;     end    //
 47:     begin note = G3F; duration = SIXTEENTH;     end    //

 48:     begin note = E1F;  duration = EIGHTH;    end    //
 49:     begin note = E1F; duration = SIXTEENTH;     end    //
 50:     begin note = B2F; duration = EIGHTH;     end    //
 51:     begin note = B2F; duration = SIXTEENTH;     end    //
 52:     begin note = D3F; duration = SIXTEENTH;     end    //
 53:     begin note = E3F; duration = SIXTEENTH;     end    //
  
 54:     begin note = E1F;  duration = EIGHTH;    end    //
 55:     begin note = E1F; duration = SIXTEENTH;     end    //
 56:     begin note = B2F; duration = EIGHTH;     end    //
 57:     begin note = B2F; duration = SIXTEENTH;     end    //
 58:     begin note = D3F; duration = SIXTEENTH;     end    //
 59:     begin note = E3F; duration = SIXTEENTH;     end    //
  
 60:     begin note = E1F;  duration = EIGHTH;    end    //
 61:     begin note = E1F; duration = SIXTEENTH;     end    //
 62:     begin note = B2F; duration = EIGHTH;     end    //
 63:     begin note = B2F; duration = SIXTEENTH;     end    //
 64:     begin note = D3F; duration = SIXTEENTH;     end    //
 65:     begin note = E3F; duration = SIXTEENTH;     end    //
  
 66:     begin note = E1F;  duration = EIGHTH;    end    //
 67:     begin note = E3F; duration = SIXTEENTH;     end    //
 68:     begin note = G3F; duration = SIXTEENTH;     end    //
 69:     begin note = G1F; duration = EIGHTH;    end    //
 70:     begin note = G3F; duration = SIXTEENTH;     end    //
 71:     begin note = A3F; duration = SIXTEENTH;     end    //
 
 72:     begin note = E1F;  duration = EIGHTH;    end    //
 73:     begin note = E1F; duration = SIXTEENTH;     end    //
 74:     begin note = B2F; duration = EIGHTH;     end    //
 75:     begin note = B2F; duration = SIXTEENTH;     end    //
 76:     begin note = D3F; duration = SIXTEENTH;     end    //
 77:     begin note = E3F; duration = SIXTEENTH;     end    //
  
 78:     begin note = E1F;  duration = EIGHTH;    end    //
 79:     begin note = E1F; duration = SIXTEENTH;     end    //
 80:     begin note = B2F; duration = EIGHTH;     end    //
 81:     begin note = B2F; duration = SIXTEENTH;     end    //
 82:     begin note = D3F; duration = SIXTEENTH;     end    //
 83:     begin note = E3F; duration = SIXTEENTH;     end    //

 84:     begin note = E1F;  duration = EIGHTH;    end    //
 85:     begin note = E1F; duration = SIXTEENTH;     end    //
 86:     begin note = B2F; duration = EIGHTH;     end    //
 87:     begin note = B2F; duration = SIXTEENTH;     end    //
 88:     begin note = D3F; duration = SIXTEENTH;     end    //
 89:     begin note = E3F; duration = SIXTEENTH;     end    //
 
 90:     begin note = A1F; duration = SIXTEENTH;    end    //
 91:     begin note = A1F; duration = THIRTYTWOTH;     end    //
 92:     begin note = A1F; duration = SIXTEENTH;     end    //
 93:     begin note = A1F; duration = THIRTYTWOTH;    end    //
 94:     begin note = A1F; duration = SIXTEENTH;     end    //
 95:     begin note = A1F; duration = THIRTYTWOTH;     end    //

 96:     begin note = G1F; duration = SIXTEENTH;    end    //
 97:     begin note = G1F; duration = THIRTYTWOTH;     end    //
 98:     begin note = G1F; duration = SIXTEENTH;     end    //
 99:     begin note = G1F; duration = THIRTYTWOTH;    end    //
100:     begin note = G1F; duration = SIXTEENTH;     end    //
101:     begin note = G1F; duration = THIRTYTWOTH;     end    //

//16
102:     begin note = E2F; duration = EIGHTH;     end    //
103:     begin note = B2F; duration = EIGHTH;     end    //
104:     begin note = E2F; duration = EIGHTH;     end    //
105:     begin note = B2F; duration = EIGHTH;     end    //
106:     begin note = E2F; duration = EIGHTH;     end    //
107:     begin note = B2F; duration = EIGHTH;     end    //
108:     begin note = E2F; duration = EIGHTH;     end    //
109:     begin note = B2F; duration = EIGHTH;     end    //

//17
110:     begin note = E2F; duration = EIGHTH;     end    //
111:     begin note = B2F; duration = EIGHTH;     end    //
112:     begin note = E2F; duration = EIGHTH;     end    //
113:     begin note = B2F; duration = EIGHTH;     end    //
114:     begin note = E2F; duration = EIGHTH;     end    //
115:     begin note = B2F; duration = EIGHTH;     end    //
116:     begin note = E2F; duration = EIGHTH;     end    //
117:     begin note = B2F; duration = EIGHTH;     end    //

//18
118:     begin note =  B1; duration = EIGHTH;     end    //
119:     begin note = G2F; duration = EIGHTH;     end    //
120:     begin note =  B1; duration = EIGHTH;     end    //
121:     begin note = G2F; duration = EIGHTH;     end    //
122:     begin note =  B1; duration = EIGHTH;     end    //
123:     begin note = G2F; duration = EIGHTH;     end    //
124:     begin note =  B1; duration = EIGHTH;     end    //
125:     begin note = G2F; duration = EIGHTH;     end    //

//19
126:     begin note = D2F; duration = EIGHTH;     end    //
127:     begin note = A2F; duration = EIGHTH;     end    //
128:     begin note = D2F; duration = EIGHTH;     end    //
129:     begin note = A2F; duration = EIGHTH;     end    //
130:     begin note = D2F; duration = EIGHTH;     end    //
131:     begin note = A2F; duration = EIGHTH;     end    //
132:     begin note = D2F; duration = EIGHTH;     end    //
133:     begin note = A2F; duration = EIGHTH;     end    //

//20
134:     begin note = E2F; duration = EIGHTH;     end    //
135:     begin note = B2F; duration = EIGHTH;     end    //
136:     begin note = E2F; duration = EIGHTH;     end    //
137:     begin note = B2F; duration = EIGHTH;     end    //
138:     begin note = E2F; duration = EIGHTH;     end    //
139:     begin note = B2F; duration = EIGHTH;     end    //
140:     begin note = E2F; duration = EIGHTH;     end    //
141:     begin note = B2F; duration = EIGHTH;     end    //

//21
142:     begin note = E2F; duration = EIGHTH;     end    //
143:     begin note = B2F; duration = EIGHTH;     end    //
144:     begin note = E2F; duration = EIGHTH;     end    //
145:     begin note = B2F; duration = EIGHTH;     end    //
146:     begin note = E2F; duration = EIGHTH;     end    //
147:     begin note = B2F; duration = EIGHTH;     end    //
148:     begin note = E2F; duration = EIGHTH;     end    //
149:     begin note = B2F; duration = EIGHTH;     end    //

//22
150:     begin note =  B1; duration = EIGHTH;     end    //
151:     begin note = G2F; duration = EIGHTH;     end    //
152:     begin note =  B1; duration = EIGHTH;     end    //
153:     begin note = G2F; duration = EIGHTH;     end    //
154:     begin note =  B1; duration = EIGHTH;     end    //
155:     begin note = G2F; duration = EIGHTH;     end    //
156:     begin note =  B1; duration = EIGHTH;     end    //
157:     begin note = G2F; duration = EIGHTH;     end    //

//23
158:     begin note = D2F; duration = EIGHTH;     end    //
159:     begin note = A2F; duration = EIGHTH;     end    //
160:     begin note = D2F; duration = EIGHTH;     end    //
161:     begin note = A2F; duration = EIGHTH;     end    //

162:     begin note = D2 ; duration = SIXTEENTH;    end    //
163:     begin note = SP ; duration = THIRTYTWOTH;     end    //
164:     begin note = D2 ; duration = SIXTEENTH;     end    //
165:     begin note = SP ; duration = THIRTYTWOTH;    end    //
166:     begin note = D2 ; duration = SIXTEENTH;     end    //
167:     begin note = SP ; duration = THIRTYTWOTH;     end    //

168:     begin note = D2 ; duration = SIXTEENTH;    end    //
169:     begin note = SP ; duration = THIRTYTWOTH;     end    //
170:     begin note = D2 ; duration = SIXTEENTH;     end    //
171:     begin note = SP ; duration = THIRTYTWOTH;    end    //
172:     begin note = D2 ; duration = SIXTEENTH;     end    //
173:     begin note = SP ; duration = THIRTYTWOTH;     end    //

default:     begin note = SP; duration = ONE;     end
endcase
end
endmodule


module BadApple2( input [9:0] number, 
    output reg [19:0] note,//max 32 different musical notes
    output reg [5:0] duration);
parameter THIRTYTWOTH = 6'b000001;
parameter   SIXTEENTH = 2*THIRTYTWOTH;
parameter      EIGHTH = 2*SIXTEENTH;
parameter     QUARTER = 2*EIGHTH;
parameter        HALF = 2*QUARTER;
parameter         ONE = 2*HALF;

parameter A0 = 1818182 ;
parameter B0F = 1716135 ;
parameter B0 = 1619816 ;
parameter C1 = 1528903 ;
parameter D1F = 1443092 ;
parameter D1 = 1362097 ;
parameter E1F = 1285649 ;
parameter E1 = 1213491 ;
parameter F1 = 1145383 ;
parameter G1F = 1081097 ;
parameter G1 = 1020420 ;
parameter A1F = 963148 ;
parameter A1 = 909091 ;
parameter B1F = 858068 ;
parameter B1 = 809908 ;
parameter C2 = 764451 ;
parameter D2F = 721546 ;
parameter D2 = 681049 ;
parameter E2F = 642824 ;
parameter E2 = 606745 ;
parameter F2 = 572691 ;
parameter G2F = 540549 ;
parameter G2 = 510210 ;
parameter A2F = 481574 ;
parameter A2 = 454545 ;
parameter B2F = 429034 ;
parameter B2 = 404954 ;
parameter C3 = 382226 ;
parameter D3F = 360773 ;
parameter D3 = 340524 ;
parameter E3F = 321412 ;
parameter E3 = 303373 ;
parameter F3 = 286346 ;
parameter G3F = 270274 ;
parameter G3 = 255105 ;
parameter A3F = 240787 ;
parameter A3 = 227273 ;
parameter B3F = 214517 ;
parameter B3 = 202477 ;
parameter C4 = 191113 ;
parameter D4F = 180386 ;
parameter D4 = 170262 ;
parameter E4F = 160706 ;
parameter E4 = 151686 ;
parameter F4 = 143173 ;
parameter G4F = 135137 ;
parameter G4 = 127553 ;
parameter A4F = 120394 ;
parameter A4 = 113636 ;
parameter B4F = 107258 ;
parameter B4 = 101238 ;
parameter C5 = 95556 ;
parameter D5F = 90193 ;
parameter D5 = 85131 ;
parameter E5F = 80353 ;
parameter E5 = 75843 ;
parameter F5 = 71586 ;
parameter G5F = 67569 ;
parameter G5 = 63776 ;
parameter A5F = 60197 ;
parameter A5 = 56818 ;
parameter B5F = 53629 ;
parameter B5 = 50619 ;
parameter C6 = 47778 ;
parameter D6F = 45097 ;
parameter D6 = 42566 ;
parameter E6F = 40177 ;
parameter E6 = 37922 ;
parameter F6 = 35793 ;
parameter G6F = 33784 ;
parameter G6 = 31888 ;
parameter A6F = 30098 ;
parameter A6 = 28409 ;
parameter B6F = 26815 ;
parameter B6 = 25310 ;
parameter C7 = 23889 ;
parameter D7F = 22548 ;
parameter D7 = 21283 ;
parameter E7F = 20088 ;
parameter E7 = 18961 ;
parameter F7 = 17897 ;
parameter G7F = 16892 ;
parameter G7 = 15944 ;
parameter A7F = 15049 ;
parameter A7 = 14205 ;
parameter B7F = 13407 ;
parameter B7 = 12655 ;
parameter SP = 1;
 
always @ (number) begin
case(number) 
  0:     begin note = E2F; duration = EIGHTH;    end    //
  1:     begin note = E2F; duration = SIXTEENTH;     end    //
  2:     begin note = E3F; duration = EIGHTH;    end    //
  3:     begin note = E3F; duration = SIXTEENTH;     end    //
  4:     begin note = SP ; duration = SIXTEENTH;     end    //
  5:     begin note = SP ; duration = SIXTEENTH;     end    //
    
  6:     begin note = E2F; duration = EIGHTH;    end    //
  7:     begin note = E2F; duration = SIXTEENTH;     end    //
  8:     begin note = E3F; duration = EIGHTH;    end    //
  9:     begin note = E3F; duration = SIXTEENTH;     end    //
 10:     begin note = SP ; duration = SIXTEENTH;     end    //
 11:     begin note = SP ; duration = SIXTEENTH;     end    //
    
 12:     begin note = E2F; duration = EIGHTH;    end    //
 13:     begin note = E2F; duration = SIXTEENTH;     end    //
 14:     begin note = E3F; duration = EIGHTH;    end    //
 15:     begin note = E3F; duration = SIXTEENTH;     end    //
 16:     begin note = SP ; duration = SIXTEENTH;     end    //
 17:     begin note = SP ; duration = SIXTEENTH;     end    //
    
 18:     begin note = E2F; duration = EIGHTH;    end    //
 19:     begin note = SP ; duration = SIXTEENTH;     end    //
 20:     begin note = SP ; duration = SIXTEENTH;     end    //
 21:     begin note = G2F; duration = EIGHTH;    end    //
 22:     begin note = SP ; duration = SIXTEENTH;     end    //
 23:     begin note = SP ; duration = SIXTEENTH;     end    //
    
 24:     begin note = E2F; duration = EIGHTH;    end    //
 25:     begin note = E2F; duration = SIXTEENTH;     end    //
 26:     begin note = E3F; duration = EIGHTH;    end    //
 27:     begin note = E3F; duration = SIXTEENTH;     end   //
 28:     begin note = SP ; duration = SIXTEENTH;     end    //
 29:     begin note = SP ; duration = SIXTEENTH;     end    //
    
 30:     begin note = E2F; duration = EIGHTH;    end    //
 31:     begin note = E2F; duration = SIXTEENTH;     end    //
 32:     begin note = E3F; duration = EIGHTH;    end    //
 33:     begin note = E3F; duration = SIXTEENTH;     end    //
 34:     begin note = SP ; duration = SIXTEENTH;     end    //
 35:     begin note = SP ; duration = SIXTEENTH;     end    //
    
 36:     begin note = E2F; duration = EIGHTH;    end    //
 37:     begin note = E2F; duration = SIXTEENTH;     end    //
 38:     begin note = E3F; duration = EIGHTH;    end    //
 39:     begin note = E3F; duration = SIXTEENTH;     end    //
 40:     begin note = SP ; duration = SIXTEENTH;     end    //
 41:     begin note = SP ; duration = SIXTEENTH;     end    //
    
 42:     begin note = A2F; duration = EIGHTH;    end    //
 43:     begin note = SP ; duration = SIXTEENTH;     end    //
 44:     begin note = SP ; duration = SIXTEENTH;     end    //
 45:     begin note = G2F; duration = EIGHTH;    end    //
 46:     begin note = SP ; duration = SIXTEENTH;     end    //
 47:     begin note = SP ; duration = SIXTEENTH;     end    //

 48:     begin note = E2F; duration = EIGHTH;    end    //
 49:     begin note = E2F; duration = SIXTEENTH;     end    //
 50:     begin note = E3F; duration = EIGHTH;    end    //
 51:     begin note = E3F; duration = SIXTEENTH;     end    //
 52:     begin note = SP ; duration = SIXTEENTH;     end    //
 53:     begin note = SP ; duration = SIXTEENTH;     end    //
    
 54:     begin note = E2F; duration = EIGHTH;    end    //
 55:     begin note = E2F; duration = SIXTEENTH;     end    //
 56:     begin note = E3F; duration = EIGHTH;    end    //
 57:     begin note = E3F; duration = SIXTEENTH;     end    //
 58:     begin note = SP ; duration = SIXTEENTH;     end    //
 59:     begin note = SP ; duration = SIXTEENTH;     end    //
    
 60:     begin note = E2F; duration = EIGHTH;    end    //
 61:     begin note = E2F; duration = SIXTEENTH;     end    //
 62:     begin note = E3F; duration = EIGHTH;    end    //
 63:     begin note = E3F; duration = SIXTEENTH;     end    //
 64:     begin note = SP ; duration = SIXTEENTH;     end    //
 65:     begin note = SP ; duration = SIXTEENTH;     end    //
    
 66:     begin note = E2F; duration = EIGHTH;    end    //
 67:     begin note = SP ; duration = SIXTEENTH;     end    //
 68:     begin note = SP ; duration = SIXTEENTH;     end    //
 69:     begin note = G2F; duration = EIGHTH;    end    //
 70:     begin note = SP ; duration = SIXTEENTH;     end    //
 71:     begin note = SP ; duration = SIXTEENTH;     end    //
    
 72:     begin note = E2F; duration = EIGHTH;    end    //
 73:     begin note = E2F; duration = SIXTEENTH;     end    //
 74:     begin note = E3F; duration = EIGHTH;    end    //
 75:     begin note = E3F; duration = SIXTEENTH;     end   //
 76:     begin note = SP ; duration = SIXTEENTH;     end    //
 77:     begin note = SP ; duration = SIXTEENTH;     end    //
    
 78:     begin note = E2F; duration = EIGHTH;    end    //
 79:     begin note = E2F; duration = SIXTEENTH;     end    //
 80:     begin note = E3F; duration = EIGHTH;    end    //
 81:     begin note = E3F; duration = SIXTEENTH;     end    //
 82:     begin note = SP ; duration = SIXTEENTH;     end    //
 83:     begin note = SP ; duration = SIXTEENTH;     end    //
    
 84:     begin note = E2F; duration = EIGHTH;    end    //
 85:     begin note = E2F; duration = SIXTEENTH;     end    //
 86:     begin note = E3F; duration = EIGHTH;    end    //
 87:     begin note = E3F; duration = SIXTEENTH;     end    //
 88:     begin note = SP ; duration = SIXTEENTH;     end    //
 89:     begin note = SP ; duration = SIXTEENTH;     end    //
    
 90:     begin note = A2F; duration = SIXTEENTH;    end    //
 91:     begin note = A2F; duration = THIRTYTWOTH;     end    //
 92:     begin note = A2F; duration = SIXTEENTH;     end    //
 93:     begin note = A2F; duration = THIRTYTWOTH;    end    //
 94:     begin note = A2F; duration = SIXTEENTH;     end    //
 95:     begin note = A2F; duration = THIRTYTWOTH;     end    //

 96:     begin note = G2F; duration = SIXTEENTH;    end    //
 97:     begin note = G2F; duration = THIRTYTWOTH;     end    //
 98:     begin note = G2F; duration = SIXTEENTH;     end    //
 99:     begin note = G2F; duration = THIRTYTWOTH;    end    //
100:     begin note = G2F; duration = SIXTEENTH;     end    //
101:     begin note = G2F; duration = THIRTYTWOTH;     end    //

//16
102:     begin note = SP ; duration = EIGHTH;     end    //
103:     begin note = E3F; duration = EIGHTH;     end    //
104:     begin note = SP ; duration = EIGHTH;     end    //
105:     begin note = E3F; duration = EIGHTH;     end    //
106:     begin note = SP ; duration = EIGHTH;     end    //
107:     begin note = E3F; duration = EIGHTH;     end    //
108:     begin note = SP ; duration = EIGHTH;     end    //
109:     begin note = E3F; duration = EIGHTH;     end    //

//17
110:     begin note = SP ; duration = EIGHTH;     end    //
111:     begin note = E3F; duration = EIGHTH;     end    //
112:     begin note = SP ; duration = EIGHTH;     end    //
113:     begin note = E3F; duration = EIGHTH;     end    //
114:     begin note = SP ; duration = EIGHTH;     end    //
115:     begin note = E3F; duration = EIGHTH;     end    //
116:     begin note = SP ; duration = EIGHTH;     end    //
117:     begin note = E3F; duration = EIGHTH;     end    //

//18
118:     begin note = SP ; duration = EIGHTH;     end    //
119:     begin note =  B2; duration = EIGHTH;     end    //
120:     begin note = SP ; duration = EIGHTH;     end    //
121:     begin note =  B2; duration = EIGHTH;     end    //
122:     begin note = SP ; duration = EIGHTH;     end    //
123:     begin note =  B2; duration = EIGHTH;     end    //
124:     begin note = SP ; duration = EIGHTH;     end    //
125:     begin note =  B2; duration = EIGHTH;     end    //

//19
126:     begin note = SP ; duration = EIGHTH;     end    //
127:     begin note = D3F; duration = EIGHTH;     end    //
128:     begin note = SP ; duration = EIGHTH;     end    //
129:     begin note = D3F; duration = EIGHTH;     end    //
130:     begin note = SP ; duration = EIGHTH;     end    //
131:     begin note = D3F; duration = EIGHTH;     end    //
132:     begin note = SP ; duration = EIGHTH;     end    //
133:     begin note = D3F; duration = EIGHTH;     end    //

//20
134:     begin note = SP ; duration = EIGHTH;     end    //
135:     begin note = E3F; duration = EIGHTH;     end    //
136:     begin note = SP ; duration = EIGHTH;     end    //
137:     begin note = E3F; duration = EIGHTH;     end    //
138:     begin note = SP ; duration = EIGHTH;     end    //
139:     begin note = E3F; duration = EIGHTH;     end    //
140:     begin note = SP ; duration = EIGHTH;     end    //
141:     begin note = E3F; duration = EIGHTH;     end    //

//21
142:     begin note = SP ; duration = EIGHTH;     end    //
143:     begin note = E3F; duration = EIGHTH;     end    //
144:     begin note = SP ; duration = EIGHTH;     end    //
145:     begin note = E3F; duration = EIGHTH;     end    //
146:     begin note = SP ; duration = EIGHTH;     end    //
147:     begin note = E3F; duration = EIGHTH;     end    //
148:     begin note = SP ; duration = EIGHTH;     end    //
149:     begin note = E3F; duration = EIGHTH;     end    //

//22
150:     begin note = SP ; duration = EIGHTH;     end    //
151:     begin note =  B2; duration = EIGHTH;     end    //
152:     begin note = SP ; duration = EIGHTH;     end    //
153:     begin note =  B2; duration = EIGHTH;     end    //
154:     begin note = SP ; duration = EIGHTH;     end    //
155:     begin note =  B2; duration = EIGHTH;     end    //
156:     begin note = SP ; duration = EIGHTH;     end    //
157:     begin note =  B2; duration = EIGHTH;     end    //

//23
158:     begin note = SP ; duration = EIGHTH;     end    //
159:     begin note = D3F; duration = EIGHTH;     end    //
160:     begin note = SP ; duration = EIGHTH;     end    //
161:     begin note = D3F; duration = EIGHTH;     end    //

162:     begin note = D3 ; duration = SIXTEENTH;    end    //
163:     begin note = SP ; duration = THIRTYTWOTH;     end    //
164:     begin note = D3 ; duration = SIXTEENTH;     end    //
165:     begin note = SP ; duration = THIRTYTWOTH;    end    //
166:     begin note = D3 ; duration = SIXTEENTH;     end    //
167:     begin note = SP ; duration = THIRTYTWOTH;     end    //

168:     begin note = D3 ; duration = SIXTEENTH;    end    //
169:     begin note = SP ; duration = THIRTYTWOTH;     end    //
170:     begin note = D3 ; duration = SIXTEENTH;     end    //
171:     begin note = SP ; duration = THIRTYTWOTH;    end    //
172:     begin note = D3 ; duration = SIXTEENTH;     end    //
173:     begin note = SP ; duration = THIRTYTWOTH;     end    //

default:     begin note = SP; duration = ONE;     end
endcase
end
endmodule


module BadApple3( input [9:0] number, 
    output reg [19:0] note,//max 32 different musical notes
    output reg [5:0] duration);
parameter THIRTYTWOTH = 6'b000001;
parameter   SIXTEENTH = 2*THIRTYTWOTH;
parameter      EIGHTH = 2*SIXTEENTH;
parameter     QUARTER = 2*EIGHTH;
parameter        HALF = 2*QUARTER;
parameter         ONE = 2*HALF;

parameter A0 = 1818182 ;
parameter B0F = 1716135 ;
parameter B0 = 1619816 ;
parameter C1 = 1528903 ;
parameter D1F = 1443092 ;
parameter D1 = 1362097 ;
parameter E1F = 1285649 ;
parameter E1 = 1213491 ;
parameter F1 = 1145383 ;
parameter G1F = 1081097 ;
parameter G1 = 1020420 ;
parameter A1F = 963148 ;
parameter A1 = 909091 ;
parameter B1F = 858068 ;
parameter B1 = 809908 ;
parameter C2 = 764451 ;
parameter D2F = 721546 ;
parameter D2 = 681049 ;
parameter E2F = 642824 ;
parameter E2 = 606745 ;
parameter F2 = 572691 ;
parameter G2F = 540549 ;
parameter G2 = 510210 ;
parameter A2F = 481574 ;
parameter A2 = 454545 ;
parameter B2F = 429034 ;
parameter B2 = 404954 ;
parameter C3 = 382226 ;
parameter D3F = 360773 ;
parameter D3 = 340524 ;
parameter E3F = 321412 ;
parameter E3 = 303373 ;
parameter F3 = 286346 ;
parameter G3F = 270274 ;
parameter G3 = 255105 ;
parameter A3F = 240787 ;
parameter A3 = 227273 ;
parameter B3F = 214517 ;
parameter B3 = 202477 ;
parameter C4 = 191113 ;
parameter D4F = 180386 ;
parameter D4 = 170262 ;
parameter E4F = 160706 ;
parameter E4 = 151686 ;
parameter F4 = 143173 ;
parameter G4F = 135137 ;
parameter G4 = 127553 ;
parameter A4F = 120394 ;
parameter A4 = 113636 ;
parameter B4F = 107258 ;
parameter B4 = 101238 ;
parameter C5 = 95556 ;
parameter D5F = 90193 ;
parameter D5 = 85131 ;
parameter E5F = 80353 ;
parameter E5 = 75843 ;
parameter F5 = 71586 ;
parameter G5F = 67569 ;
parameter G5 = 63776 ;
parameter A5F = 60197 ;
parameter A5 = 56818 ;
parameter B5F = 53629 ;
parameter B5 = 50619 ;
parameter C6 = 47778 ;
parameter D6F = 45097 ;
parameter D6 = 42566 ;
parameter E6F = 40177 ;
parameter E6 = 37922 ;
parameter F6 = 35793 ;
parameter G6F = 33784 ;
parameter G6 = 31888 ;
parameter A6F = 30098 ;
parameter A6 = 28409 ;
parameter B6F = 26815 ;
parameter B6 = 25310 ;
parameter C7 = 23889 ;
parameter D7F = 22548 ;
parameter D7 = 21283 ;
parameter E7F = 20088 ;
parameter E7 = 18961 ;
parameter F7 = 17897 ;
parameter G7F = 16892 ;
parameter G7 = 15944 ;
parameter A7F = 15049 ;
parameter A7 = 14205 ;
parameter B7F = 13407 ;
parameter B7 = 12655 ;
parameter SP = 1;
 
always @ (number) begin
case(number) 
  0:     begin note = SP; duration = EIGHTH;    end    //
  1:     begin note = SP; duration = SIXTEENTH;     end    //
  2:     begin note = SP; duration = EIGHTH;    end    //
  3:     begin note = SP; duration = SIXTEENTH;     end    //
  4:     begin note = SP ; duration = SIXTEENTH;     end    //
  5:     begin note = SP ; duration = SIXTEENTH;     end    //
    
  6:     begin note = SP; duration = EIGHTH;    end    //
  7:     begin note = SP; duration = SIXTEENTH;     end    //
  8:     begin note = SP; duration = EIGHTH;    end    //
  9:     begin note = SP; duration = SIXTEENTH;     end    //
 10:     begin note = SP ; duration = SIXTEENTH;     end    //
 11:     begin note = SP ; duration = SIXTEENTH;     end    //
    
 12:     begin note = SP; duration = EIGHTH;    end    //
 13:     begin note = SP; duration = SIXTEENTH;     end    //
 14:     begin note = SP; duration = EIGHTH;    end    //
 15:     begin note = SP; duration = SIXTEENTH;     end    //
 16:     begin note = SP ; duration = SIXTEENTH;     end    //
 17:     begin note = SP ; duration = SIXTEENTH;     end    //
    
 18:     begin note = SP; duration = EIGHTH;    end    //
 19:     begin note = SP ; duration = SIXTEENTH;     end    //
 20:     begin note = SP ; duration = SIXTEENTH;     end    //
 21:     begin note = SP; duration = EIGHTH;    end    //
 22:     begin note = SP ; duration = SIXTEENTH;     end    //
 23:     begin note = SP ; duration = SIXTEENTH;     end    //
    
 24:     begin note = SP; duration = EIGHTH;    end    //
 25:     begin note = SP; duration = SIXTEENTH;     end    //
 26:     begin note = SP; duration = EIGHTH;    end    //
 27:     begin note = SP; duration = SIXTEENTH;     end   //
 28:     begin note = SP ; duration = SIXTEENTH;     end    //
 29:     begin note = SP ; duration = SIXTEENTH;     end    //
    
 30:     begin note = SP; duration = EIGHTH;    end    //
 31:     begin note = SP; duration = SIXTEENTH;     end    //
 32:     begin note = SP; duration = EIGHTH;    end    //
 33:     begin note = SP; duration = SIXTEENTH;     end    //
 34:     begin note = SP ; duration = SIXTEENTH;     end    //
 35:     begin note = SP ; duration = SIXTEENTH;     end    //
    
 36:     begin note = SP; duration = EIGHTH;    end    //
 37:     begin note = SP; duration = SIXTEENTH;     end    //
 38:     begin note = SP; duration = EIGHTH;    end    //
 39:     begin note = SP; duration = SIXTEENTH;     end    //
 40:     begin note = SP ; duration = SIXTEENTH;     end    //
 41:     begin note = SP ; duration = SIXTEENTH;     end    //
    
 42:     begin note = SP; duration = EIGHTH;    end    //
 43:     begin note = SP ; duration = SIXTEENTH;     end    //
 44:     begin note = SP ; duration = SIXTEENTH;     end    //
 45:     begin note = SP; duration = EIGHTH;    end    //
 46:     begin note = SP ; duration = SIXTEENTH;     end    //
 47:     begin note = SP ; duration = SIXTEENTH;     end    //

 48:     begin note = SP; duration = EIGHTH;    end    //
 49:     begin note = SP; duration = SIXTEENTH;     end    //
 50:     begin note = SP; duration = EIGHTH;    end    //
 51:     begin note = SP; duration = SIXTEENTH;     end    //
 52:     begin note = SP ; duration = SIXTEENTH;     end    //
 53:     begin note = SP ; duration = SIXTEENTH;     end    //
    
 54:     begin note = SP; duration = EIGHTH;    end    //
 55:     begin note = SP; duration = SIXTEENTH;     end    //
 56:     begin note = SP; duration = EIGHTH;    end    //
 57:     begin note = SP; duration = SIXTEENTH;     end    //
 58:     begin note = SP ; duration = SIXTEENTH;     end    //
 59:     begin note = SP ; duration = SIXTEENTH;     end    //
    
 60:     begin note = SP; duration = EIGHTH;    end    //
 61:     begin note = SP; duration = SIXTEENTH;     end    //
 62:     begin note = SP; duration = EIGHTH;    end    //
 63:     begin note = SP; duration = SIXTEENTH;     end    //
 64:     begin note = SP ; duration = SIXTEENTH;     end    //
 65:     begin note = SP ; duration = SIXTEENTH;     end    //
    
 66:     begin note = SP; duration = EIGHTH;    end    //
 67:     begin note = SP ; duration = SIXTEENTH;     end    //
 68:     begin note = SP ; duration = SIXTEENTH;     end    //
 69:     begin note = SP; duration = EIGHTH;    end    //
 70:     begin note = SP ; duration = SIXTEENTH;     end    //
 71:     begin note = SP ; duration = SIXTEENTH;     end    //
    
 72:     begin note = SP; duration = EIGHTH;    end    //
 73:     begin note = SP; duration = SIXTEENTH;     end    //
 74:     begin note = SP; duration = EIGHTH;    end    //
 75:     begin note = SP; duration = SIXTEENTH;     end   //
 76:     begin note = SP ; duration = SIXTEENTH;     end    //
 77:     begin note = SP ; duration = SIXTEENTH;     end    //
    
 78:     begin note = SP; duration = EIGHTH;    end    //
 79:     begin note = SP; duration = SIXTEENTH;     end    //
 80:     begin note = SP; duration = EIGHTH;    end    //
 81:     begin note = SP; duration = SIXTEENTH;     end    //
 82:     begin note = SP ; duration = SIXTEENTH;     end    //
 83:     begin note = SP ; duration = SIXTEENTH;     end    //
    
 84:     begin note = SP; duration = EIGHTH;    end    //
 85:     begin note = SP; duration = SIXTEENTH;     end    //
 86:     begin note = SP; duration = EIGHTH;    end    //
 87:     begin note = SP; duration = SIXTEENTH;     end    //
 88:     begin note = SP ; duration = SIXTEENTH;     end    //
 89:     begin note = SP ; duration = SIXTEENTH;     end    //
    
 90:     begin note = A3F; duration = SIXTEENTH;    end    //
 91:     begin note = A3F; duration = THIRTYTWOTH;     end    //
 92:     begin note = G3F; duration = SIXTEENTH;     end    //
 93:     begin note = G3F; duration = THIRTYTWOTH;    end    //
 94:     begin note = A3F; duration = SIXTEENTH;     end    //
 95:     begin note = A3F; duration = THIRTYTWOTH;     end    //

 96:     begin note = G3F; duration = SIXTEENTH;    end    //
 97:     begin note = G3F; duration = THIRTYTWOTH;     end    //
 98:     begin note = E3F; duration = SIXTEENTH;     end    //
 99:     begin note = E3F; duration = THIRTYTWOTH;    end    //
100:     begin note = G3F; duration = SIXTEENTH;     end    //
101:     begin note = G3F; duration = THIRTYTWOTH;     end    //

//16
102:     begin note = E4F; duration = EIGHTH;     end    //
103:     begin note = F4 ; duration = EIGHTH;     end    //
104:     begin note = G4F; duration = EIGHTH;     end    //
105:     begin note = A4F; duration = EIGHTH;     end    //
106:     begin note = B4F; duration = EIGHTH;     end    //
107:     begin note = B4F; duration = EIGHTH;     end    //
108:     begin note = E5F; duration = EIGHTH;     end    //
109:     begin note = D5F; duration = EIGHTH;     end    //

//17
110:     begin note = B4F; duration = EIGHTH;     end    //
111:     begin note = B4F; duration = EIGHTH;     end    //
112:     begin note = E4F; duration = EIGHTH;     end    //
113:     begin note = E4F; duration = EIGHTH;     end    //
114:     begin note = B4F; duration = EIGHTH;     end    //
115:     begin note = A4F; duration = EIGHTH;     end    //
116:     begin note = G4F; duration = EIGHTH;     end    //
117:     begin note = F4 ; duration = EIGHTH;     end    //

//18
118:     begin note = E4F; duration = EIGHTH;     end    //
119:     begin note = F4 ; duration = EIGHTH;     end    //
120:     begin note = G4F; duration = EIGHTH;     end    //
121:     begin note = A4F; duration = EIGHTH;     end    //
122:     begin note = B4F; duration = EIGHTH;     end    //
123:     begin note = B4F; duration = EIGHTH;     end    //
124:     begin note = A4F; duration = EIGHTH;     end    //
125:     begin note = G4F; duration = EIGHTH;     end    //


//19
126:     begin note = F4 ; duration = EIGHTH;     end    //
127:     begin note = E4F; duration = EIGHTH;     end    //
128:     begin note = F4 ; duration = EIGHTH;     end    //
129:     begin note = G4F; duration = EIGHTH;     end    //
130:     begin note = F4 ; duration = EIGHTH;     end    //
131:     begin note = E4F; duration = EIGHTH;     end    //
132:     begin note = D4 ; duration = EIGHTH;     end    //
133:     begin note = F4 ; duration = EIGHTH;     end    //

//20
134:     begin note = E4F; duration = EIGHTH;     end    //
135:     begin note = F4 ; duration = EIGHTH;     end    //
136:     begin note = G4F; duration = EIGHTH;     end    //
137:     begin note = A4F; duration = EIGHTH;     end    //
138:     begin note = B4F; duration = EIGHTH;     end    //
139:     begin note = B4F; duration = EIGHTH;     end    //
140:     begin note = E5F; duration = EIGHTH;     end    //
141:     begin note = D5F; duration = EIGHTH;     end    //

//21
142:     begin note = B4F; duration = EIGHTH;     end    //
143:     begin note = B4F; duration = EIGHTH;     end    //
144:     begin note = E4F; duration = EIGHTH;     end    //
145:     begin note = E4F; duration = EIGHTH;     end    //
146:     begin note = B4F; duration = EIGHTH;     end    //
147:     begin note = A4F; duration = EIGHTH;     end    //
148:     begin note = G4F; duration = EIGHTH;     end    //
149:     begin note = F4 ; duration = EIGHTH;     end    //

//22
150:     begin note = E4F; duration = EIGHTH;     end    //
151:     begin note = F4 ; duration = EIGHTH;     end    //
152:     begin note = G4F; duration = EIGHTH;     end    //
153:     begin note = A4F; duration = EIGHTH;     end    //
154:     begin note = B4F; duration = EIGHTH;     end    //
155:     begin note = B4F; duration = EIGHTH;     end    //
156:     begin note = A4F; duration = EIGHTH;     end    //
157:     begin note = G4F; duration = EIGHTH;     end    //

//23
158:     begin note = F4 ; duration = EIGHTH;     end    //
159:     begin note = F4 ; duration = EIGHTH;     end    //
160:     begin note = G4F; duration = EIGHTH;     end    //
161:     begin note = G4F; duration = EIGHTH;     end    //

162:     begin note = A4F; duration = SIXTEENTH;    end    //
163:     begin note = A4F; duration = THIRTYTWOTH;     end    //
164:     begin note = A4F; duration = SIXTEENTH;     end    //
165:     begin note = A4F; duration = THIRTYTWOTH;    end    //
166:     begin note = A4F; duration = SIXTEENTH;     end    //
167:     begin note = A4F; duration = THIRTYTWOTH;     end    //

168:     begin note = B4F; duration = SIXTEENTH;    end    //
169:     begin note = B4F; duration = THIRTYTWOTH;     end    //
170:     begin note = B4F; duration = SIXTEENTH;     end    //
171:     begin note = B4F; duration = THIRTYTWOTH;    end    //
172:     begin note = B4F; duration = SIXTEENTH;     end    //
173:     begin note = B4F; duration = THIRTYTWOTH;     end    //

default:     begin note = SP; duration = ONE;     end
endcase
end
endmodule

module mux3x1rot(
    input [2:0] D,
    input clk,
    output y
);
    reg [1:0] count = 0;
    always @(posedge clk)
    begin
        count = (count+1)%3;
    end
    assign y=D>>count;
endmodule

module SoundGen(
    input clk,
    input reset,
    input enable,
    output audio_out,
    output AUD_SD
    );

    assign AUD_SD = 1'b1;

    wire [9:0] number1;
    wire [19:0] notePeriod1;
    wire [5:0] duration1;
    wire outsig1;

    SongPlayer sp1(clk,reset,enable,outsig1,void1,number1, notePeriod1, duration1);
    BadApple1  ba1(number1, notePeriod1, duration1);

    wire [9:0] number2;
    wire [19:0] notePeriod2;
    wire [5:0] duration2;
    wire outsig2;

    SongPlayer sp2(clk,reset,enable,outsig2,void2,number2, notePeriod2, duration2);
    BadApple2  ba2(number2, notePeriod2, duration2);

    wire [9:0] number3;
    wire [19:0] notePeriod3;
    wire [5:0] duration3;
    wire outsig3;

    SongPlayer sp3(clk,reset,enable,outsig3,void3,number3, notePeriod3, duration3);
    BadApple3  ba3(number3, notePeriod3, duration3);

    mux3x1rot rot({outsig1, outsig2, outsig3},clk,audio_out);

    //assign audio_out = |{outsig1, outsig2, outsig3};
endmodule
