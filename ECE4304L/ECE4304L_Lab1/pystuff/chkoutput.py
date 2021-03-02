#!/usr/bin/env python3

f = open("output.txt", "r")
lines = f.readlines()
total = 0
error = 0
for line in lines:
    items = line.strip().split(' ')
    inp = items[0]
    sel = int(items[1],2)
    op = items[2]
    total += 1
    if (inp[len(inp)-1-sel] != op):
        error += 1 
print("Errors: " + str(error)+'/'+str(total))
f.close()
input("Press Enter to exit...")
exit()