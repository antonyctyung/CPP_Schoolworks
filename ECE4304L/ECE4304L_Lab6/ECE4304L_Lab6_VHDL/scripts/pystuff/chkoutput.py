#!/usr/bin/env python3

f = open("output.txt", "r")
lines = f.readlines()
total = 0
error = 0

def cathcode_match(x, a2g):
    switcher = {
        "0000":"0000001",
        "0001":"1001111",
        "0010":"0010010",
        "0011":"0000110",
        "0100":"1001100",
        "0101":"0100100",
        "0110":"0100000",
        "0111":"0001111",
        "1000":"0000000",
        "1001":"0000100",
        "1010":"0001000",
        "1011":"1100000",
        "1100":"0110001",
        "1101":"1000010",
        "1110":"0110000",
        "1111":"0111000"
    }
    return (switcher[x] == a2g)

for line in lines:
    items = line.strip().split(' ')
    LR_sel = items[0]
    shift_sel = items[1]
    inp = items[2]
    out_digit = items[3]
    seg_en = items[4]
    barrel_out = items[5]
    r_rot = int(shift_sel,2) if (LR_sel == '0') else 0
    l_rot = int(shift_sel,2) if (LR_sel == '1') else 0
    temp = (l_rot - r_rot) % len(inp)
    shifted_inp = inp[temp : ] + inp[ : temp]

    total += 1
    error_this = 0
    if (shifted_inp != barrel_out):
        error_this += 1
    elif (seg_en == '11111111'): # no display on 7-seg
        pass 
    elif (seg_en == '10111111'): # inp high
        if (cathcode_match(inp[:4],out_digit)):
            pass
        else:
            error_this += 1
    elif (seg_en == '11011111'): # inp low
        if (cathcode_match(inp[4:],out_digit)):
            pass
        else:
            error_this += 1
    elif (seg_en == '11110111'): # shift sel
        if (cathcode_match(('0'+shift_sel),out_digit)):
            pass
        else:
            error_this += 1
    elif (seg_en == '11111101'): # shifted high
        if (cathcode_match(shifted_inp[:4],out_digit)):
            pass
        else:
            error_this += 1
    elif (seg_en == '11111110'): # shifted low
        if (cathcode_match(shifted_inp[4:],out_digit)):
            pass
        else:
            error_this += 1
    else:
        error_this += 1
    if error_this == 1:
        print(line + 'shifted_inp: ' + shifted_inp)
    error += error_this

print("Errors: " + str(error)+'/'+str(total))
f.close()
input("Press Enter to exit...")
exit()