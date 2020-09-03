#include <stdio.h> 
#include <stdlib.h> 
#include <xc.h> 
#include <math.h> 
#include <p18f4620.h> 

#pragma config OSC = INTIO67
#pragma config WDT  =   OFF 
#pragma config LVP  =   OFF 
#pragma config BOREN  =   OFF 

void Delay_One_Sec(void);

void main()
{
    char in;                            // Use variable 'in' as char
    TRISA = 0xFF;                       // Configuring PORTA (DIP switch) to read input
    TRISB = 0x00;                       // Configuring PORTB (4 LEDs) to output
    TRISC = 0x00;                       // Configuring PORTC (RBG LED D1) to output
    TRISD = 0x00;                       // Configuring PORTD (RBG LED D2) to output
    ADCON1 = 0x0F;                      // Put AN1-AN12 to digital I/O 
                                        // and use Vdd and Vss as Vref
    char colorD[8] = {4, 7, 5, 0, 1, 6, 2, 3};
    while (1)
    {
        for (char colorcode = 0; colorcode < 8; colorcode++ )
                                        // set color to from 000=0 to 111=7
        {
            PORTC = colorcode;          // output the RGB signal to the corresponding port
            PORTD = colorD[colorcode];  // derive output from PORTC pattern and
                                        // output the RGB signal to the corresponding port
            Delay_One_Sec();
        }
    }
}

void Delay_One_Sec()
{
    for(int I=0; I <17000; I++);
}