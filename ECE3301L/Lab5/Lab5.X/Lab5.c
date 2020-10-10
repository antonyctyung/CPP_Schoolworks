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

// common anode 7-segment code to display decimal digit

const unsigned char BCD[10] = 
{
    // 6543210 PORTX.bit
    // gfedcba
    0b01000000,     // 0
    0b01111001,     // 1
    0b00100100,     // 2
    0b00110000,     // 3
    0b00011001,     // 4
    0b00010010,     // 5
    0b00000010,     // 6
    0b01111000,     // 7
    0b00000000,     // 8
    0b00010000      // 9
};

// Prototypes

inline unsigned int ADC_mV(unsigned int ADC_Result);

inline double celsius_from_mV(unsigned int ADC_mV);
inline double fahrenheit_from_celsius(double celsius);
inline unsigned int fahrenheit_from_mV(unsigned int ADC_mV);

void display_fahrenheit_BCD(unsigned int fahrenheit);
void set_temperature_RGB_LEDs(unsigned int fahrenheit);
void set_brightness_RGB_LED(unsigned int ADC_mV);

unsigned int get_full_ADC(void);
inline void config_ADC_channel(unsigned char channel);
inline void set_to_read_AN0(void);
inline void set_to_read_AN1(void);

void init_ADC(void);
void init_UART(void);
void init_IO(void);

void putch (char c);
void WAIT_1_SEC();

void main(void)
{
    // initial configurations
    init_ADC();
    init_UART();
    init_IO();

    // main loop
    while(1)
    {        
        // obtain and display temperature from LMT84 at AN0
        set_to_read_AN0();                                              // set to read temperature from LMT84 at AN0
        unsigned int temp_steps = get_full_ADC();                       // obtain ADC step number at AN0
        unsigned int temp_mV = ADC_mV(temp_steps);                      // obtain mV at AN0 from ADC step number
        unsigned int fahrenheit = fahrenheit_from_mV(temp_mV);          // obtain temparature from voltage at AN0
        display_fahrenheit_BCD(fahrenheit);                             // output temperature to seven segment display
        set_temperature_RGB_LEDs(fahrenheit);                           // output temperature to RGB LEDs

        // obtain and display brightness from photoresistor at AN1
        set_to_read_AN1();                                              // set to read temperature from photoresistor at AN1
        unsigned int bright_steps = get_full_ADC();                     // obtain ADC step number at AN0
        unsigned int bright_mV = ADC_mV(bright_steps);                  // obtain mV at AN0 from ADC step number
        set_brightness_RGB_LED(bright_mV);                              // output brightness indicator to RGB LEDs


        // print to serial monitor
        printf("Temperature: %4u steps, %4u mV, %2u degF    |    Brightness: %4u steps, %4u mV\r\n",temp_steps,temp_mV,fahrenheit,bright_steps,bright_mV);
    }
}

void WAIT_1_SEC()
{
    for (int j=0;j<17000;j++);
}

inline unsigned int ADC_mV(unsigned int ADC_Result)
{
    return ADC_Result*4;                                                // convert ADC_Result from a 10-bit integer to mV
                                                                        // VREF / (2^10) = 4096 mV / 1024 = 4
}

inline double celsius_from_mV(unsigned int ADC_mV)
{
    return sqrt(2941394.951-568.1818182*ADC_mV)-1534.204545;            // derived from TI LMT84 data sheet p.11 Equation 2
                                                                        // https://www.ti.com/lit/ds/symlink/lmt84.pdf
} 

inline double fahrenheit_from_celsius(double celsius)
{
    return celsius*9/5+32;                                              // convert temperature from celsius to fahrenheit
}

inline unsigned int fahrenheit_from_mV(unsigned int ADC_mV)
{
    return (unsigned int) fahrenheit_from_celsius(celsius_from_mV(ADC_mV));
}

void display_fahrenheit_BCD(unsigned int fahrenheit)
{
    PORTC = BCD[fahrenheit/10];                                         // output upper digit 7-seg to PORTC
    PORTD = BCD[fahrenheit%10];                                         // output lower digit 7-seg to PORTD
}

void set_temperature_RGB_LEDs(unsigned int fahrenheit)
{   
    // set the two RGB LEDs at PORTB to indicating the range of temperature in fahrenheit

    // obtain D1 value
    unsigned char D1 = fahrenheit/10;                                   // get the upper digit of temperature
    if (D1 > 7) D1 = 7;                                                 // prevent overflow on D1 when >79 degF
    D1 &= 0x07;                                                         // mask out highest five bit
    D1 += 0x38;                                                         // prepare D1 to accept D2 value
                                                                        // by ANDing with bit 3-5

    // obtain D2 value                        
    unsigned char D2 = 0;                                               //  0 < T <= 45     => 000 OFF
    if (fahrenheit > 45) D2++;                                          // 45 < T <= 55     => 001 RED
    if (fahrenheit > 55) D2<<=1;                                        // 55 < T <= 65     => 010 GREEN
    if (fahrenheit > 65) D2<<=1;                                        // 65 < T <= 75     => 100 BLUE
    if (fahrenheit > 75) D2+=3;                                         // 75 < T           => 111 WHITE

    // combine D1 and D2 and output to PORTB
    D2 <<= 3;                                                           // shift to bit 3-5
    D2 +=  7;                                                           // make lower 3 bit 111 to be AND with D1
    D1 &= D2;                                                           // 00111(D1) & 00(D2)111 = 00(D2)(D1)
    PORTB = D1;                                                         // output result to PORTB
}

inline void config_ADC_channel(unsigned char channel)
{
    ADCON0=channel*4+1;                                                 // select channel, and turn on the ADC subsystem => 00(channel)01
}

inline void set_to_read_AN0(void)
{
    config_ADC_channel(0);                                              // select channel AN0, and turn on the ADC subsystem => 0000 0001
}

inline void set_to_read_AN1(void)
{
    config_ADC_channel(1);                                              // select channel AN1, and turn on the ADC subsystem => 0000 0101
}

void init_ADC(void)
{
    ADCON0=0x01;                                                        // select channel AN0, and turn on the ADC subsystem => 0000 0001
    ADCON1=0x1B;                                                        // select pins AN0 through AN3 as analog signal, VDD-VSS as
                                                                        // reference voltage => 0000 1011
    ADCON2=0xA9;                                                        // right justify the result. Set the bit conversion time (TAD) and
                                                                        // acquisition time
}

void init_UART()
{
    OpenUSART(USART_TX_INT_OFF & USART_RX_INT_OFF & USART_ASYNCH_MODE & USART_EIGHT_BIT & USART_CONT_RX & USART_BRGH_HIGH, 25);
    OSCCON = 0x60;
}

void init_IO(void)
{
    TRISA = 0x0F;                                                       // make PORTA lower nybble outputs
    TRISB = 0x00;                                                       // make PORTB as all outputs
    TRISC = 0x00;                                                       // make PORTC as all outputs
    TRISD = 0x00;                                                       // make PORTD as all outputs
    TRISE = 0x00;                                                       // make PORTE as all outputs
}                            
                            
unsigned int get_full_ADC(void)                            
{                            
    int result;                            
    ADCON0bits.GO=1;                                                    // Start Conversion
    while(ADCON0bits.DONE==1)                                           // wait for conversion to be completed
        result = (ADRESH * 0x100) + ADRESL;                             // combine result of upper byte and
                                                                        // lower byte into result
    return result;                                                      // return the result.
}

void set_brightness_RGB_LED(unsigned int ADC_mV)
{
    // set D3 to indicate the range of mV inversely proportional
    // to brightness detected by the photoresistor

    unsigned char result = 1;                                           //    0 <= mV < 2500     => 01 RED
    if (ADC_mV >= 2500) result++;                                       // 2500 <= mV < 3500     => 10 GREEN
    if (ADC_mV >= 3500) result++;                                       // 3500 <= mV            => 11 YELLOW
    PORTE = result;
}

void putch (char c)
{
    while (!TRMT);
    TXREG = c;
}
