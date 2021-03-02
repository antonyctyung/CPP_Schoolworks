#include <stdio.h>
#include <stdlib.h>
#include <xc.h>
#include <math.h>
#include <p18f4620.h>
#include <usart.h>

#pragma config OSC    = INTIO67
#pragma config WDT    = OFF
#pragma config LVP    = OFF
#pragma config BOREN  = OFF
#pragma config CCP2MX = PORTBE

void putch (char c)
{
    while (!TRMT);
    TXREG = c;
}

void init_UART(void);
void init_ADC(void);
void init_IO(void);
unsigned int get_full_ADC(void);
int get_RPM(void);
float read_volt(void);
int get_duty_cycle(float);
void do_update_pwm(char);
void Wait_Half_Second(void);

void main(void)
{
    int duty_cycle = 50;
    init_IO();
    init_ADC();
    init_UART();
    OSCCON = 0x70;                                                                                  // set the system clock to be 1MHz 1/4 of the 4MHz
    
    while (1)
    {
        float volt = read_volt();
        duty_cycle = get_duty_cycle(volt);
        do_update_pwm(duty_cycle);
        int rpm = get_RPM();
        printf ("duty cycle = %d RPM = %d\r\n",duty_cycle, rpm);
        Wait_Half_Second();
    }
}

void init_UART()
{
    OpenUSART (USART_TX_INT_OFF & USART_RX_INT_OFF &
    USART_ASYNCH_MODE & USART_EIGHT_BIT & USART_CONT_RX &
    USART_BRGH_HIGH, 25);
    OSCCON = 0x60;
}

void init_ADC()
{
    ADCON0 = 0x01;
    ADCON1 = 0x0E; 
    ADCON2 = 0xA9;
}

void init_IO()
{
    TRISA = 0x01;                                                                                   // set PORTA all output except AN0/RA0
    TRISB = 0xFF;                                                                                   // set PORTB all input
    TRISC = 0xD3;                                                                                   // set PORTC 1101 0011
    TRISD = 0x38;                                                                                   // set PORTD 0011 1000
    TRISE = 0x0E;                                                                                   // set PORTE all input except RE0
}

unsigned int get_full_ADC()
{
    unsigned int result;
    ADCON0bits.GO=1;                                                                                // Start Conversion
    while(ADCON0bits.DONE==1);                                                                      // wait for conversion to be completed
    result = (ADRESH * 0x100) + ADRESL;                                                             // combine result of upper byte and
                                                                                                    // lower byte into result
    return result;                                                                                  // return the result.
}

int get_RPM()
{
    TMR1L = 0x00;                                                                                   // clear the count
    T1CON = 0x03;                                                                                   // start Timer1 as counter of number of pulses
    Wait_Half_Second();                                                                             // wait half second
    int RPS = TMR1L;                                                                                // read the count. Since there are 2 pulses per rev
                                                                                                    // and 2 ½ sec per sec, then RPS = count
    return (RPS * 60);                                                                              // return RPM = 60 * RPS
}

float read_volt()
{
    float volt;
    int nStep = get_full_ADC();
    volt = nStep * 5 /1024.0;
    return (volt);
}

int get_duty_cycle(float volt)
{
    int dc = (int) (read_volt() / 5.0 * 100.0);
    return (dc);
}

void Wait_Half_Second()
{
    T0CON = 0x03;                                                                                   // Timer 0, 16-bit mode, prescaler 1:16
    TMR0L = 0xDB;                                                                                   // set the lower byte of TMR
    TMR0H = 0x0B;                                                                                   // set the upper byte of TMR
    INTCONbits.TMR0IF = 0;                                                                          // clear the Timer 0 flag
    T0CONbits.TMR0ON = 1;                                                                           // Turn on the Timer 0
    while (INTCONbits.TMR0IF == 0);                                                                 // wait for the Timer Flag to be 1 for done
    T0CONbits.TMR0ON = 0;                                                                           // turn off the Timer 0
}

void do_update_pwm(char duty_cycle)
{
    float dc_f;
    int dc_I;
    PR2 = 0b00000100;                                                                               // set the frequency for 25 Khz
    T2CON = 0b00000111;                                                                             
    dc_f = ( 4.0 * duty_cycle / 20.0);                                                              // calculate factor of duty cycle versus a 25 kHz signal
    dc_I = (int) dc_f;                                                                              // get the integer part
    if (dc_I > duty_cycle) dc_I++;                                                                  // round up function
    CCP1CON = ((dc_I & 0x03) << 4) | 0b00001100;
    CCPR1L = (dc_I) >> 2;
}