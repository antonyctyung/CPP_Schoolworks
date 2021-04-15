#!/usr/bin/env python3
import random
from datetime import datetime
random.seed(datetime.now())
f = open("input.txt", "w")

in_bits = [1,3,8]
rounds = 2

input_line = ''
lst = [iter for iter in range(int('1'+'0'*sum(in_bits),2))]

for i in range(rounds):
    random.shuffle(lst)
    for e in lst:
        out = format(e,'0' + str(sum(in_bits)) + 'b')
        for i in range(len(in_bits)):
            if (i == 0):
                input_line += out[0:in_bits[0]]
            else:
                input_line += ' '
                input_line += out[sum(in_bits[0:i]):sum(in_bits[0:i+1])]
        input_line += '\n'
f.write(input_line)    
f.close()
