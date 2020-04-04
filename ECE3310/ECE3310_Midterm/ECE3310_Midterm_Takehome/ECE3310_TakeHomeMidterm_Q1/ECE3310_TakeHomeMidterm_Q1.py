from tkinter import *
from functools import partial
# Author: Choi Tim Antony Yung

simulating = False
simulatetime = 250

def changebuttoncolor(r,c,color=None):
   if color is None:
      if universe[r][c].cget("bg") == "white":
         color = "black"
      if universe[r][c].cget("bg") == "black":
         color = "white"
   universe[r][c].config(bg=color)
   universe[r][c].grid(row=r,column=c)

def liveordie(statematrix,r,c):
   neighborcount = 0
   for i in [-1,0,1]:
      for j in [-1,0,1]:
         if i+r < 0 or i+r > 9 or j+c < 0 or j+c > 9:
            # outside of universe, nothing in nothingness
            pass
         elif i==0 and j==0:
            # self is not a neighbor
            pass
         else:
            neighborcount += statematrix[r+i][c+j] 
   if (neighborcount==3) or (universe[r][c].cget("bg")=="black" and neighborcount == 2):
      # condition to be populated:
      # three neighbor, or
      # populated with two neighbor
      changebuttoncolor(r,c,"black")
   else:
      changebuttoncolor(r,c,"white")

def genstatematrix():
   # a two dimensional array/list with 0 as white and 1 as black
   statematrix = [[0 for i in range(10)]for i in range(10)]
   for r in range(10):
      for c in range(10):
         if universe[r][c].cget("bg")=="black":
            statematrix[r][c]=1
   return statematrix
         
def simulateonce():
   statematrix = genstatematrix()
   for r in range(10):
      for c in range(10):
         liveordie(statematrix,r,c)

def clear():
   if simulating:
      runstop()
   for r in range(10):
      for c in range(10):
         changebuttoncolor(r,c,"white")

def runstop():
   global simulating 
   simulating = not simulating
   if simulating:
      runstopbutton.config(text="Stop")
   else: 
      runstopbutton.config(text="Run")

def simulate():
   if simulating:
      simulateonce()
   root.after(simulatetime,simulate)

def block():
   clear()
   changebuttoncolor(4,4)
   changebuttoncolor(4,5)
   changebuttoncolor(5,4)
   changebuttoncolor(5,5)

def glider():
   clear()
   changebuttoncolor(0,1)
   changebuttoncolor(1,2)
   changebuttoncolor(2,0)
   changebuttoncolor(2,1)
   changebuttoncolor(2,2)

def blinker():
   clear()
   changebuttoncolor(4,4)
   changebuttoncolor(4,5)
   changebuttoncolor(4,6)

def selectpreset(*args):
   preset = variable.get()
   if preset == OptionList[0]:
      glider()
   elif preset == OptionList[1]:
      blinker()
   elif preset == OptionList[2]:
      block()
   else:
      pass
   return

universe = [[None for i in range(10)]for i in range(10)]
# universe of black or white buttons
OptionList = [ "Glider", "Blinker", "Block"]
root = Tk()
root.resizable(False, False)
topframe = Frame(root)
topframe.pack()
bottomframe = Frame(root)
bottomframe.pack( side = BOTTOM, fill=BOTH, expand=1 )
for r in range(10):
   for c in range(10):
      universe[r][c]=Button(
         topframe,width = 5,height = 2, borderwidth=1, bg="white")
      universe[r][c].config(command=partial(changebuttoncolor,r,c))
      universe[r][c].grid(row=r,column=c)

variable = StringVar(bottomframe)
variable.set(OptionList[0])
opt = OptionMenu(bottomframe, variable, *OptionList)
opt.pack(side=RIGHT)
nextbutton = Button(bottomframe,text="Next",command=simulateonce)
nextbutton.pack(side=LEFT)
runstopbutton = Button(bottomframe,text="Run",command=runstop)
runstopbutton.pack(side=LEFT)
clearbutton = Button(bottomframe,text="Clear",command=clear)
clearbutton.pack(side=LEFT)

variable.trace("w", selectpreset)
root.after(simulatetime,simulate)
root.mainloop()