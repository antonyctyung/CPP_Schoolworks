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

#define NSLT_SW         PORTAbits.RA1
#define NSPED_SW        PORTAbits.RA2
#define EWLT_SW         PORTAbits.RA3
#define EWPED_SW        PORTAbits.RA4
#define NS_RED          PORTAbits.RA5
#define NS_GREEN        PORTBbits.RB0
#define NSLT_RED        PORTBbits.RB1
#define NSLT_GREEN      PORTBbits.RB2
#define EW_RED          PORTBbits.RB4
#define EW_GREEN        PORTBbits.RB5
#define EWLT_RED        PORTEbits.RE0
#define EWLT_GREEN      PORTEbits.RE1
#define SEC_LED         PORTEbits.RE2
#define MODE_LED        PORTDbits.RD7

#define OFF             0
#define RED             1
#define GREEN           2
#define YELLOW          3

#define NS_Direction    0
#define EW_Direction    1

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

unsigned int get_full_ADC(void);

void Wait_One_Second(void);
void Wait_Half_Second(void);
void Wait_N_Seconds (char seconds);
void Wait_One_Second_With_Beep(void);

void Set_NS  (char color);
void Set_NSLT(char color);
void Set_EW  (char color);
void Set_EWLT(char color);

void PED_Control(char Direction, char Num_Sec);                             // Pedestrian counter and buzzer control sequence

inline unsigned int mode(void);                                             // return 0 when day and 1 when night

void Day_Mode(void);                                                        // Day   mode traffic light sequence
void Night_Mode(void);                                                      // Night mode traffic light sequence

void init_ADC(void);                                                        // initialize ADC: make AN0 analog and set to read AN0
void init_IO(void);                                                         // initialize DIO

inline void test_loop_LEDs(void);                                           // test loop to make sure LED works as expected
inline void test_loop_Ped_Ctr(void);                                        // test loop to make sure 7-seg and buzzer works as expected

void main(void)
{
    // initial configurations
    init_ADC();
    init_IO();
    OSCCON = 0x60;
    
    //test_loop_LEDs();
    //test_loop_Ped_Ctr();

    while (1)
    {   
        // main loop
        MODE_LED = mode();                                                  // scan light sensor and return 1 if >2.5V (night)
        if (MODE_LED)
            Night_Mode();
        else
            Day_Mode();
    }
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

void Wait_One_Second()
{
    SEC_LED = 0;                                                            // First, turn off the SEC LED
    Wait_Half_Second();                                                     // Wait for half second (or 500 msec)
    SEC_LED = 1;                                                            // then turn on the SEC LED
    Wait_Half_Second();                                                     // Wait for half second (or 500 msec)
}

void Wait_Half_Second()
{
    T0CON = 0x02;                                                           // Timer 0, 16-bit mode, prescaler 1:8
    TMR0L = 0xDB;                                                           // set the lower byte of TMR
    TMR0H = 0x0B;                                                           // set the upper byte of TMR
    INTCONbits.TMR0IF = 0;                                                  // clear the Timer 0 flag
    T0CONbits.TMR0ON = 1;                                                   // Turn on the Timer 0
    while (INTCONbits.TMR0IF == 0);                                         // wait for the Timer Flag to be 1 for done
    T0CONbits.TMR0ON = 0;                                                   // turn off the Timer 0
}

void Wait_N_Seconds (char seconds)
{
    char I;
    for (I = 0; I< seconds; I++)
    {
        Wait_One_Second();
    }
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

void Wait_One_Second_With_Beep()
{
    SEC_LED = 1;                                                            // First, turn on the SEC LED
    Activate_Buzzer();                                                      // Activate the buzzer
    Wait_Half_Second();                                                     // Wait for half second (or 500 msec)
    SEC_LED = 0;                                                            // then turn off the SEC LED
    Deactivate_Buzzer();                                                    // Deactivate the buzzer
    Wait_Half_Second();                                                     // Wait for half second (or 500 msec)
}

void Set_NS(char color)
{
    NS_RED=color&0x01;                                                      // set   NS_RED   to bit 0 of color
    NS_GREEN=color>>1;                                                      // set   NS_GREEN to bit 1 of color
}

void Set_NSLT(char color)
{    
    NSLT_RED=color&0x01;                                                    // set NSLT_RED   to bit 0 of color       
    NSLT_GREEN=color>>1;                                                    // set NSLT_GREEN to bit 1 of color  
}

void Set_EW(char color)
{
    EW_RED=color&0x01;                                                      // set   EW_RED   to bit 0 of color
    EW_GREEN=color>>1;                                                      // set   EW_GREEN to bit 1 of color
}

void Set_EWLT(char color)
{
    EWLT_RED=color&0x01;                                                    // set EWLT_RED   to bit 0 of color
    EWLT_GREEN=color>>1;                                                    // set EWLT_GREEN to bit 1 of color
}

inline void display_upper_digit(char digit)
{
    PORTC = BCD[digit];                                                     // output upper digit 7-seg to PORTC
}

inline void display_lower_digit(char digit)
{
    PORTD = BCD[digit] + MODE_LED*0x80;                                     // output lower digit 7-seg to PORTD while preserving decimal point
}

inline void turn_off_upper_digit()
{
    PORTC = 0xff;                                                           // output upper digit off code to PORTC
}

inline void turn_off_lower_digit()
{
    PORTD = 0x7f + MODE_LED*0x80;                                           // output lower digit off code to PORTD while preserving decimal point
}

void PED_Control(char Direction, char Num_Sec)
{
    if (Direction)
    {   // EW direction
        for (int i = Num_Sec-1; i >=0; i--)
        {
            turn_off_upper_digit();
            display_lower_digit(i);
            if (i == 0) turn_off_lower_digit();
            Wait_One_Second_With_Beep();
        } 
    }
    else
    {   // NS direction
        for (int i = Num_Sec-1; i >=0; i--)
        {
            turn_off_lower_digit();
            display_upper_digit(i);
            if (i == 0) turn_off_upper_digit();
            Wait_One_Second_With_Beep();
        } 
    }
}

inline unsigned int mode(void)
{
    return (get_full_ADC()/512);                                            // 2.5/Vcc*1024 = 512; 1 when >= 2.5V; 0 when < 2.5V
}

void Day_Mode(void)
{    
    //  1. Set NS RGB to GREEN and the rest in RED and read the logic state of NSPED_SW
    Set_NS(GREEN);
    Set_NSLT(RED);
    Set_EW(RED);
    Set_EWLT(RED);
    if (NSPED_SW)                                                           // Pedestrian crossing requested at NS direction
        PED_Control(NS_Direction, 9);                                       // Display pedestrian countdown at NS direction for 9 seconds

    //  2. Wait for 8 seconds
    Wait_N_Seconds(8);

    //  3. Set NS RGB to YELLOW and wait for 3 seconds
    Set_NS(YELLOW);
    Wait_N_Seconds(3);

    //  4. Set NS RGB to RED
    Set_NS(RED);
    
    //  5. Check the logic of EWLT_SW
    if (EWLT_SW)                                                            // Left turn requested at EW direction
    {
        // 6. Set EWLT RGB to GREEN  and wait for 7 seconds
        Set_EWLT(GREEN);
        Wait_N_Seconds(7);

        // 7. Set EWLT RGB to YELLOW and wait for 3 seconds
        Set_EWLT(YELLOW);
        Wait_N_Seconds(3);

        // 8. Set EWLT RGB to RED
        Set_EWLT(RED);
    }

    //  9. Set EW RGB to GREEN and read the logic of EWPED_SW
    Set_EW(GREEN);
    if (EWPED_SW)                                                           // Pedestrian crossing requested at EW direction
        PED_Control(EW_Direction, 8);                                       // Display pedestrian countdown at EW direction for 8 seconds

    // 10. Wait for 7 seconds
    Wait_N_Seconds(7);

    // 11. Set EW RGB to YELLOW and wait for 3 seconds
    Set_EW(YELLOW);
    Wait_N_Seconds(3);

    // 12. Set EW RGB to RED
    Set_EW(RED);

    // 13. Check the logic of NSLT_SW
    if (NSLT_SW)
    {
        // 14. Set NSLT RGB to GREEN  and wait for 7 seconds
        Set_NSLT(GREEN);
        Wait_N_Seconds(8);

        // 15. Set NSLT RGB to YELLOW and wait for 3 seconds
        Set_NSLT(YELLOW);
        Wait_N_Seconds(3);

        // 16. Set NSLT RGB to RED
        Set_NSLT(RED);
    }

    // 17. This complete the sequence
}

void Night_Mode(void)
{
    //  1. Set NS RGB to GREEN and the rest in RED
    Set_NS(GREEN);
    Set_NSLT(RED);
    Set_EW(RED);
    Set_EWLT(RED);

    //  2. Wait for 7 seconds
    Wait_N_Seconds(7);

    //  3. Set NS RGB to YELLOW and wait for 3 seconds
    Set_NS(YELLOW);
    Wait_N_Seconds(3);

    //  4. Set NS RGB to RED
    Set_NS(RED);
    
    //  5. Check the logic of EWLT_SW
    if (EWLT_SW)
    {
        // 6. Set EWLT RGB to GREEN  and wait for 7 seconds
        Set_EWLT(GREEN);
        Wait_N_Seconds(7);

        // 7. Set EWLT RGB to YELLOW and wait for 3 seconds
        Set_EWLT(YELLOW);
        Wait_N_Seconds(3);

        // 8. Set EWLT RGB to RED
        Set_EWLT(RED);
    }

    //  9. Set EW RGB to GREEN and wait for 6 seconds
    Set_EW(GREEN);
    Wait_N_Seconds(6);

    // 10. Set EW RGB to YELLOW and wait for 3 seconds
    Set_EW(YELLOW);
    Wait_N_Seconds(3);

    // 11. Set EW RGB to RED
    Set_EW(RED);

    // 12. Check the logic of NSLT_SW
    if (NSLT_SW)
    {
        // 13. Set NSLT RGB to GREEN  and wait for 7 seconds
        Set_NSLT(GREEN);
        Wait_N_Seconds(8);

        // 14. Set NSLT RGB to YELLOW and wait for 3 seconds
        Set_NSLT(YELLOW);
        Wait_N_Seconds(3);

        // 15. Set NSLT RGB to RED
        Set_NSLT(RED);
    }

    // 16. This complete the sequence

}

inline void config_ADCON1(unsigned int VREFp, unsigned int VREFn, unsigned char number_of_analog_channel)
{
    ADCON1 = 32*(!(!VREFn))+16*(!(!VREFp))+0x0f-(0x0f&number_of_analog_channel);
                                                                            // !(!VREFn) return 1 if value not 0 i.e. act as bool
                                                                            // VREF- at bit 5 and VREF+ at bit 4
                                                                            // subtracting number of analog channel enabled from 1111 gives
                                                                            // the config to put in lower nybble
}   

void init_ADC(void) 
{   
    ADCON0=0x01;                                                            // select channel AN0, and turn on the ADC subsystem => 0000 0001
    config_ADCON1(0,0,1);                                                   // select pins AN0 as analog signal, Vdd and VSS as
                                                                            // reference voltage => 0000 1110
    ADCON2=0xA9;                                                            // right justify the result. Set the bit conversion time (TAD) and
                                                                            // acquisition time
}   

void init_IO(void)  
{   
    TRISA = 0xDF;                                                           // make PORTA as IIOI IIII
    TRISB = 0xC0;                                                           // make PORTB as IIOO OOOO
    TRISC = 0x00;                                                           // make PORTC as all outputs
    TRISD = 0x00;                                                           // make PORTD as all outputs
    TRISE = 0x00;                                                           // make PORTE as all outputs
}                             

inline void test_loop_LEDs()
{
    while (1)
    {
        for (int i=0; i<4;i++)
        {
            Set_NS(i);                                                      // Set color for North-South direction
            Set_NSLT(i);                                                    // Set color for North-South Left-Turn direction
            Set_EW(i);                                                      // Set color for East-West direction
            Set_EWLT(i);                                                    // Set color for East-West Left-Turn direction
            Wait_N_Seconds(1);
        }
    }
}

inline void test_loop_Ped_Ctr()
{
    while (1)
    {
        PED_Control(0, 8);                                                  // Set direction 0 and do for 8 seconds
        PED_Control(1, 6);                                                  // Set direction 1 for 6 seconds
    }
}