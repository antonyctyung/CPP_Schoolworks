#!/usr/bin/env python3
f = open("cases.txt", "w")
input_line = ''
for i in range(int('110000000000000000',2)):
    i_str = format(i,'018b')
    opcode_str = i_str[:2]
    A_str = i_str[2:10]
    B_str = i_str[10:18]
    A = int(A_str,2)
    B = int(B_str,2)
    out = 0
    if (opcode_str == "00"): # add
        out = A + B
    elif (opcode_str == "01"): # subtract
        if (B>A): # negative use 2's comp
            out = 2**16 + A - B
        else:
            out = A - B
    elif (opcode_str == "10"): # multiply
        out = A * B
    out = 'when \"{0}\" => C <= \"{1}\";'.format(i_str, format(out,'016b'))
    print(out)
    input_line = out+'\n'
    f.write(input_line)
f.close()
