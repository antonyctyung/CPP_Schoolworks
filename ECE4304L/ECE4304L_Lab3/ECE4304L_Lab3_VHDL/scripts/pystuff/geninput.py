#!/usr/bin/env python3
import random
from datetime import datetime
random.seed(datetime.now())
f = open("input.txt", "w")
input_line = ''
lst = [iter for iter in range(int('100000000',2))]
rounds = 10
for i in range(rounds):
    random.shuffle(lst)
    for e in lst:
        out = format(e,'08b')
        out = '{0} {1}'.format(out[:4], out[4:])
        input_line += out+'\n'
f.write(input_line)    
f.close()
