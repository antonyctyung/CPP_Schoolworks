#include <stdio.h>
#include <stdlib.h>
#include <xc.h>
#include <math.h>
#include <p18f4620.h>

#pragma config OSC = INTIO67
#pragma config WDT = OFF
#pragma config LVP = OFF
#pragma config BOREN = OFF

#define delay 5
// Prototype Area to place all the references to the routines used in the program



char array[10] = {0x40};				// fill array here

void WAIT_1_SEC()
{
    for (int j=0;j<17000;j++);
    
}


void main(void)
{

	ADCON1 = 0x0F;
    TRISB = 0x00;                        // make PORTB as all outputs
    TRISC = 0x00;
    TRISD = 0X00;
    TRISE = 0X00;  
    PORTB = 0;
    PORTE = 0;
    
    while(1)
    {
      for (int i=0;i<8;i++)
      {   
//        i=5;
		PORTC = ~(0x01 << i);
        PORTD = ~(0x01 << i);

//        PORTC = array[i];
//        PORTD = array[i];
        WAIT_1_SEC();
      }
      
      for (int i=0;i<8;i++)
      {    
;         i=3;             
          PORTB = i;
          WAIT_1_SEC();
      } 
      PORTB = 0;   
      
      for (int i=0;i<8;i++)
      {
;         i=4;          
          PORTB = (i<< 3);
          WAIT_1_SEC();
      } 
      PORTB = 0;
      
      for (int i=0;i<4;i++)
      {    
;          i=2;
          PORTE = i;
          WAIT_1_SEC();
      } 
      PORTE = 0;
    }
      
}

