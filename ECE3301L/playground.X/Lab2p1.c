#include <stdio.h> 
#include <stdlib.h> 
#include <xc.h> 
#include <math.h> 
#include <p18f4620.h> 

#pragma config OSC = INTIO67
#pragma config WDT  =   OFF 
#pragma config LVP  =   OFF 
#pragma config BOREN  =   OFF 

void main()
{
    char in;            // Use variable 'in' as char
    TRISA = 0xFF;       // Configuring PORTA (DIP switch) to read input
    TRISB = 0x00;       // Configuring PORTB (RBG LED) to read output
    ADCON1 = 0x0F;      // Put AN1-AN12 to digital I/O and use Vdd and Vss as Vref
    while (1)
    {
        in = PORTA;     // read data from PORTA and save it
                        // into ?in?
        in = in & 0x0F; // Mask out the unused upper four bits
        PORTB = in;     // Output the data to PORTB
    }
}