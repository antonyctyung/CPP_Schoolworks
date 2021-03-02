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
int get_RPM(void);
void Wait_Half_Second(void);

void main()
{
    init_IO();
    init_ADC();
    init_UART();
    OSCCON = 0x70;                                                                                  // set the system clock to be 1MHz 1/4 of the 4MHz
    while (1)
    {
        int rpm = get_RPM();
        printf ("RPM = %d\r\n",rpm);
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
    TRISD = 0x37;                                                                                   // set PORTD 0011 1000
    TRISE = 0xFE;                                                                                   // set PORTE all input except RE0
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

void Wait_Half_Second()
{
    T0CON = 0x03;                       // Timer 0, 16-bit mode, prescaler 1:16
    TMR0L = 0xDB;                       // set the lower byte of TMR
    TMR0H = 0x0B;                       // set the upper byte of TMR
    INTCONbits.TMR0IF = 0;              // clear the Timer 0 flag
    T0CONbits.TMR0ON = 1;               // Turn on the Timer 0
    while (INTCONbits.TMR0IF == 0);     // wait for the Timer Flag to be 1 for done
    T0CONbits.TMR0ON = 0;               // turn off the Timer 0
}