#include <stdio.h>
#include <stdlib.h>
#include <xc.h>
#include <math.h>
#include <p18f4620.h>
#include <usart.h>
#pragma config OSC = INTIO67
#pragma config WDT = OFF
#pragma config LVP = OFF
#pragma config BOREN = OFF

double temperature_conversion(unsigned int ADC_Result)
{
    double ADC_mV = ADC_Result * 4;         // convert ADC_Result from a 10-bit integer to mV
                                            // VREF / (2^10) = 4096 mV / 1024 = 4
    return sqrt(2941394.951-568.1818182*ADC_mV)-1534.204545;
                                            // derived from TI LMT84 data sheet p.11 Equation 2
                                            // https://www.ti.com/lit/ds/symlink/lmt84.pdf
} 

inline double celsius_to_fahrenheit(double celsius)
{
    return celsius*9/5+32;                  // convert temperature from celsius to fahrenheit
}

void display_fahrenheit_BCD(int fahrenheit,unsigned char* BCD)
{
    unsigned char upper=fahrenheit/10;
    unsigned char lower=fahrenheit%10;
    PORTC = BCD[upper];             // output upper digit to PORTC
    PORTD = BCD[lower];             // output lower digit to PORTD
}

void init_ADC(void)
{
    ADCON0=0x01;                            // select channel AN0, and turn on the ADC subsystem => 0000 0010
    ADCON1=0x1B;                            // select pins AN0 through AN3 as analog signal, VDD-VSS as
                                            // reference voltage => 0000 1011
    ADCON2=0xA9;                            // right justify the result. Set the bit conversion time (TAD) and
                                            // acquisition time
}

void init_UART()
{
    OpenUSART(USART_TX_INT_OFF & USART_RX_INT_OFF & USART_ASYNCH_MODE & USART_EIGHT_BIT & USART_CONT_RX & USART_BRGH_HIGH, 25);
    OSCCON = 0x60;
}

void init_port(void)
{
    TRISB = 0x00;                           // make PORTB as all outputs
    TRISC = 0x00;                           // make PORTC as all outputs
    TRISD = 0x00;                           // make PORTD as all outputs
    TRISE = 0x00;                           // make PORTE as all outputs
}

unsigned int get_full_ADC(void)
{
    int result;
    ADCON0bits.GO=1;                        // Start Conversion
    while(ADCON0bits.DONE==1)               // wait for conversion to be completed
        result = (ADRESH * 0x100) + ADRESL; // combine result of upper byte and
                                            // lower byte into result
    return result;                          // return the result.
}

void putch (char c)
{
    while (!TRMT);
    TXREG = c;
}

void main(void)
{
    unsigned char BCD[]= {
    //6543210 PORTX.bit
    //gfedcba
    0b1000000,  // 0
    0b1111001,  // 1  
    0b0100100,  // 2
    0b0110000,  // 3
    0b0011001,  // 4
    0b0010010,  // 5
    0b0000010,  // 6
    0b1111000,  // 7
    0b0000000,  // 8
    0b0010000   // 9
    };
    // config
    init_ADC();
    init_UART();
    init_port();
    while(1)
    {
        // main loop
        double celsius = temperature_conversion(get_full_ADC());
        int fahrenheit = (int) celsius_to_fahrenheit(celsius);
        display_fahrenheit_BCD(fahrenheit,BCD);
    }
}
