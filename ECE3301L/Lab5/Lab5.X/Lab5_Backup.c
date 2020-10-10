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

const unsigned char BCD[10] = 
{
    // 6543210 PORTX.bit
    // gfedcba
    0b01000000,  // 0
    0b01111001,  // 1  
    0b00100100,  // 2
    0b00110000,  // 3
    0b00011001,  // 4
    0b00010010,  // 5
    0b00000010,  // 6
    0b01111000,  // 7
    0b00000000,  // 8
    0b00010000   // 9
};

void WAIT_1_SEC()
{
    for (int j=0;j<17000;j++);
    
}

double temperature_conversion(unsigned int ADC_Result)
{
    double ADC_mV = ADC_Result * 4;         // convert ADC_Result from a 10-bit integer to mV
                                            // VREF / (2^10) = 4096 mV / 1024 = 4
    printf("mV = %f\r\n", ADC_mV);
    return sqrt(2941394.951-568.1818182*ADC_mV)-1534.204545;
                                            // derived from TI LMT84 data sheet p.11 Equation 2
                                            // https://www.ti.com/lit/ds/symlink/lmt84.pdf
} 

inline double celsius_to_fahrenheit(double celsius)
{
    return celsius*9/5+32;                  // convert temperature from celsius to fahrenheit
}

void display_fahrenheit_BCD(int fahrenheit)
{
    unsigned char upper = fahrenheit/10;
    PORTC = BCD[upper];                     // output upper digit to PORTC
    PORTD = BCD[fahrenheit%10];             // output lower digit to PORTD
    if (upper > 7) upper = 7;
    upper &= 0x3F;
    upper += 0x38;
    unsigned char D2 = 0;
    if (fahrenheit > 45) D2++;
    if (fahrenheit > 55) D2<<=1;
    if (fahrenheit > 65) D2<<=1;    
    if (fahrenheit > 75) D2+=3;
    D2 <<= 3;
    D2 +=  7;
    upper &= D2;
    PORTB = upper;

}

inline void set_to_read_AN0(void)
{
    ADCON0=0x01;                            // select channel AN0, and turn on the ADC subsystem => 0000 0001
}

inline void set_to_read_AN1(void)
{
    ADCON0=0x05;                            // select channel AN1, and turn on the ADC subsystem => 0000 0101
}

void init_ADC(void)
{
    ADCON0=0x01;                            // select channel AN0, and turn on the ADC subsystem => 0000 0001
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
    TRISA = 0x0F;
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

void display_d3(void)
{
    int mV = get_full_ADC()*4;
    unsigned char result = 1;
    if (mV >= 2500) result++;
    if (mV >= 3500) result++;
    PORTE = result;
}

void putch (char c)
{
    while (!TRMT);
    TXREG = c;
}

void main(void)
{
    // config
    init_ADC();
    init_UART();
    init_port();
    //int test_fahrenheit = 0;
    while(1)
    {
        
        // main loop
        set_to_read_AN0();
        double celsius = temperature_conversion(get_full_ADC());
        int fahrenheit = (int) celsius_to_fahrenheit(celsius);
        display_fahrenheit_BCD(fahrenheit);
        set_to_read_AN1();
        display_d3();
        //WAIT_1_SEC();
        //if (test_fahrenheit<95)test_fahrenheit+=5;
        printf("Temperature = %d\r\n", fahrenheit);
    }
}
