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

const unsigned char RREF_num = 1;

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

// Prototypes

inline void config_ADCON1(unsigned int VREFp, unsigned int VREFn, unsigned char number_of_channel);

void init_ADC(void);
void init_IO(void);
void init_UART(void);

inline void config_ADC_read_from_channel(unsigned char channel);
inline void set_to_read_AN0(void);
inline void set_to_read_AN1(void);

inline void config_ADCON_by_RREF_num(unsigned char RREF_num);
inline double get_RREF_resistance(unsigned char RREF_num);

unsigned int get_full_ADC(void);
inline unsigned int ADC_mV(unsigned int ADC_Result);                        // given VREF+ at 4.096V

inline void display_to_seven_segment(unsigned int, unsigned int dp);        // given 7-seg upper digit at PORTC and lower digit at PORTD
inline void display_overflow(void);                                         // display -- on 7-seg
inline void display_number_to_seven_segment(double number);                 // wrapper to display number to seven segment display
                                                                            // given 0 <= number <= 100 with two sig figs 
inline void display_integer_to_seven_segment(unsigned int number);          // wrapper to display without decimal point
void display_two_digit_float_to_seven_segment(double number);               // wrapper to display 2-digit number with decimal in between
                                                                            // regardless of order of magnitude of original number

inline double resistance_measured(double VL, double Rref);      // get resistance in ohm from load voltage in volt
                                                                            // and reference resistance in ohm
inline void set_RGB_LEDs_Buzzer(double kOhm);                               // set D1, D2 and buzzer according to RL readings

void Activate_Buzzer(void);
void Deactivate_Buzzer(void);

void WAIT_1_SEC(void);
void putch (char c);

void main(void)
{
    // initial configurations
    init_ADC();
    init_IO();
    init_UART();

    config_ADCON_by_RREF_num(RREF_num);
    double RREF_ohm = get_RREF_resistance(RREF_num);

    while(1)
    {   unsigned int steps = get_full_ADC();     
        double ADC_V = ADC_mV(steps)/1000.;                                 // obtain  voltage in V from VLx
        double kOhm  = resistance_measured(ADC_V, RREF_ohm)/1000.;          // calculate resistance in kOhm

        display_number_to_seven_segment(kOhm);                              // display   resistance in kOhm to 7-segment
        set_RGB_LEDs_Buzzer(kOhm);
        printf("RREF_ohm: %6.0f   |   Steps: %4d   |   Resistance: %3.3f kOhm\r\n",RREF_ohm,steps,kOhm);                          // display resistance in kOhm to serial
    }
}

inline void config_ADCON1(unsigned int VREFp, unsigned int VREFn, unsigned char number_of_analog_channel)
{
    ADCON1 = 32*(VREFn/VREFn)+16*(VREFp/VREFp)+0x0f-(0x0f&number_of_analog_channel);
                                                                            // VREFn/VREFn return 1 if value not 0 i.e. act as bool
                                                                            // VREF- at bit 5 and VREF+ at bit 4
                                                                            // subtracting number of analog channel enabled from 1111 gives
                                                                            // the config to put in lower nybble
}   

void init_ADC(void) 
{   
    ADCON0=0x01;                                                            // select channel AN0, and turn on the ADC subsystem => 0000 0001
    config_ADCON1(1,0,5);                                                    // select pins AN0 through AN4 as analog signal, VREF+ and VSS as
                                                                            // reference voltage => 0001 1010
    ADCON2=0xA9;                                                            // right justify the result. Set the bit conversion time (TAD) and
                                                                            // acquisition time
}   

void init_IO(void)  
{   
    TRISA = 0xFF;                                                           // make PORTA as     all inputs
    TRISB = 0xD0;                                                           // make PORTB as partial outputs 7(IIOI OOOO)0
    TRISC = 0x00;                                                           // make PORTC as     all outputs
    TRISD = 0x00;                                                           // make PORTD as     all outputs
    TRISE = 0x00;                                                           // make PORTE as     all outputs
}                                    

void init_UART()
{
    OpenUSART(USART_TX_INT_OFF & USART_RX_INT_OFF & USART_ASYNCH_MODE & USART_EIGHT_BIT & USART_CONT_RX & USART_BRGH_HIGH, 25);
    OSCCON = 0x60;
}

inline void config_ADCON_by_RREF_num(unsigned char RREF_num)
{
    config_ADC_read_from_channel(RREF_num>2?RREF_num+1:RREF_num);           // configure ADC to read from designated analog channel
}

inline double get_RREF_resistance(unsigned char RREF_num)
{
    double RREF_ohm = 1000;
    if (RREF_num > 1) { RREF_ohm *= 10; }                                   // compute RREF resistance
    if (RREF_num > 2) { RREF_ohm *= 10; }                                   // compute RREF resistance
    return RREF_ohm;
}

inline void config_ADC_read_from_channel(unsigned char channel) 
{   
    ADCON0 = channel*4+1;                                                   // select channel, and turn on the ADC subsystem => 00(channel)01
}   

inline void set_to_read_AN0(void)   
{   
    config_ADC_read_from_channel(0);                                        // select channel AN0, and turn on the ADC subsystem => 0000 0001
}   

inline void set_to_read_AN1(void)   
{   
    config_ADC_read_from_channel(1);                                        // select channel AN1, and turn on the ADC subsystem => 0000 0101
}   

unsigned int get_full_ADC(void)                             
{                               
    int result;                             
    ADCON0bits.GO=1;                                                        // Start Conversion
    while(ADCON0bits.DONE==1)                                               // wait for conversion to be completed
        result = (ADRESH * 0x100) + ADRESL;                                 // combine result of upper byte and
                                                                            // lower byte into result
    return result;                                                          // return the result.
}   

inline unsigned int ADC_mV(unsigned int ADC_Result) 
{   
    return ADC_Result*4;                                                    // convert ADC_Result from a 10-bit integer to mV
                                                                            // VREF / (2^10) = 4096 mV / 1024 = 4
}

inline void display_to_seven_segment(unsigned int number, unsigned int dp)
{
    PORTC = BCD[number/10];                                                 // output upper digit 7-seg                   to PORTC
    PORTD = BCD[(number%10)]+((!dp)*0x80);                                  // output lower digit 7-seg and decimal point to PORTD
}

inline void display_overflow()
{
    PORTC = 0x3F;                                                           // output "-" i.e. turn on g only
    PORTD = 0xBF;                                                           // output "-" i.e. turn on g only and turn off dp
}

inline void display_number_to_seven_segment(double number)
{
    if (number>=100) 
    {
        display_overflow();                                                 // display -- if overflow
        return;
    }

    // given 0 <= number <= 100 with two sig figs
    unsigned char dp = number < 10;
    if (dp) number *= 10;                                                   // prepare number to be display if have decimal point
    display_to_seven_segment((unsigned int)number,dp);                      // display decimal point if number < 10
}

inline void display_integer_to_seven_segment(unsigned int number)
{
    display_to_seven_segment(number,0);                                     // display without decimal point
}

void display_two_digit_float_to_seven_segment(double number)
{
    while ( number >= 100 ) { number /= 10; }                               // divide   to make it two digit if too large
    while ( number <  10  ) { number *= 10; }                               // multiply to make it two digit if too small
    display_to_seven_segment( ( (unsigned int)number ), 1 );                // truncate and display as two digit number 
                                                                            // with decimal point in between     
    return;
}

inline double resistance_measured(double VL, double Rref)
{
    return ( VL*Rref/(4.096-VL) );                           // By KCL and KVL
}

inline void set_RGB_LEDs_Buzzer(double kOhm)
{   
    // set the two RGB LEDs at PORTB to indicating the range of number

    // obtain D1 value
    unsigned char D12 = (kOhm>70)?7:((unsigned char)kOhm/10);           // get the upper digit of number
    D12 &= 0x07;                                                        // mask out highest five bit
    if (kOhm < 0.05)
    {
        D12 += 0x20;                                                    // set bit 5 to turn on D2
        Activate_Buzzer();
    } 
    else
    {
        Deactivate_Buzzer();
    }
    PORTB = D12;                                                        // output result to PORTB
}

void Activate_Buzzer()
{
    PR2     = 0b11111001 ;
    T2CON   = 0b00000101 ;
    CCPR2L  = 0b01001010 ;
    CCP2CON = 0b00111100 ;
}

void Deactivate_Buzzer()
{
    CCP2CON = 0x0;
    PORTBbits.RB3 = 0;
}

void WAIT_1_SEC()
{
    for (int j=0;j<17000;j++);
}

void putch (char c)
{
    while (!TRMT);
    TXREG = c;
}