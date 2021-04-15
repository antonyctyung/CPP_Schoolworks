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
        "1010":"0000001",
        "1011":"1001111",
        "1100":"0010010",
        "1101":"0000110",
        "1110":"1001100",
        "1111":"0100100"
    }
    return (switcher[x] == a2g)

def calc(digit,opcode_str,A_str,B_str):
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
        out_1 = 13
        out_0 = 0
    out = out_1 if (digit > 0) else out_0
    return format(out,'04b')


for line in lines:
    items = line.strip().split(' ')
    opcode = items[0]
    selA = items[1]
    selB = items[2]
    A = items[3]
    B = items[4]
    a2g = items[5]
    an = items[6]
    dp = items[7]
    total += 1
    error_this = 0
    if (dp == '0'):
        error_this += 1
    elif (an == '11111111'):
        pass
    elif (an == '10111111'):
        if (cathcode_match( (format(int(A,2)-10,'04b') if int(A,2)>9 else A) if selA == '1' else A ,a2g)):
            pass
        else:
            error_this += 1
    elif (an == '11101111'):
        if (cathcode_match( (format(int(B,2)-10,'04b') if int(B,2)>9 else B) if selB == '1' else B ,a2g)):
            pass
        else:
            error_this += 1
    elif (an == '11111101'):
        if (cathcode_match(calc(1,opcode,A,B),a2g)):
            pass
        else:
            error_this += 1
    elif (an == '11111110'):
        if (cathcode_match(calc(0,opcode,A,B),a2g)):
            pass
        else:
            error_this += 1
    else:
        error_this += 1
    if error_this == 1:
        print(line)
    error += error_this

print("Errors: " + str(error)+'/'+str(total))
f.close()
input("Press Enter to exit...")
exit()