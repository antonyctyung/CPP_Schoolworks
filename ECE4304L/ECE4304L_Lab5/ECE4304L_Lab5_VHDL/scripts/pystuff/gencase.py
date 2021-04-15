#!/usr/bin/env python3
f = open("cases.txt", "w")
input_line = ''
for i in range(int('10000000000',2)):
    i_str = format(i,'010b')
    opcode_str = i_str[:2]
    A_str = i_str[2:6]
    B_str = i_str[6:10]
    A = int(A_str,2)
    B = int(B_str,2)
    div_0_flag = False
    # convert A and B to BCD
    A = A-10 if (A>9) else A
    B = B-10 if (B>9) else B
    out = 0
    out_1 = 0
    out_0 = 0
    if (opcode_str == "00"): # add
        out = A + B
    elif (opcode_str == "01"): # subtract
        if (B>A): # negative use 10's comp
            out = 100 + A - B
        else:
            out = A - B
    elif (opcode_str == "10"): # multiply
        out = A * B
    elif (opcode_str == "11"): # divide
        if B == 0:
            div_0_flag = True
        out = 0 if B == 0 else A / B
    out_1 = int(out / 10)
    out_0 = int(out) % 10
    if (div_0_flag):
        out = 'when \"{0}\" => out_1 <= \"{1}\"; out_0 <= \"{2}\";'.format(i_str, "1101",format(0,'04b')) # output D0 as error message when divide by 0
    else:
        out = 'when \"{0}\" => out_1 <= \"{1}\"; out_0 <= \"{2}\";'.format(i_str, format(out_1,'04b'),format(out_0,'04b'))
    input_line += out+'\n'
f.write(input_line)    
f.close()
