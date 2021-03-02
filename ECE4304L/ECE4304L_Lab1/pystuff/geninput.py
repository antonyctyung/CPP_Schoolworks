#!/usr/bin/env python3
import random
from datetime import datetime
random.seed(datetime.now())
f = open("input.txt", "w")
input_line = ''
gen_line_num = 100000
for y in range(gen_line_num):
    for x in range(64):
        bit = random.randint(0,1)
        input_line+=str(bit)
    input_line+=str(' ')
    for x in range(6):
        bit = random.randint(0,1)
        input_line+=str(bit)
    input_line+=str('\n')
f.write(input_line)    
f.close()
