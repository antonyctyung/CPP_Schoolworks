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

for line in lines:
    items = line.strip().split(' ')
    inp0 = items[0]
    inp1 = items[1]
    a2g = items[2]
    an = items[3]
    dp = items[4]
    total += 1
    if (dp == '0'):
        error += 1
    elif (an == '11111110'):
        if (cathcode_match(inp0,a2g)):
            pass
        else:
            error += 1
    elif (an == '11101111'):
        if (cathcode_match(inp1,a2g)):
            pass
        else:
            error += 1
    else:
        error += 1

print("Errors: " + str(error)+'/'+str(total))
f.close()
input("Press Enter to exit...")
exit()