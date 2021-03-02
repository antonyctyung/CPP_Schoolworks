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

#define DC_RED      PORTAbits.RA1
#define DC_GRN      PORTAbits.RA2
#define RPM_GRN     PORTDbits.RD6
#define RPM_BLU     PORTDbits.RD7
#define FANEN_LED   PORTAbits.RA5
#define SEC_LED     PORTEbits.RE0
#define TFT_DC      PORTDbits.RD0                                                                   // Location of TFT D/C
#define TFT_CS      PORTDbits.RD1                                                                   // Location of TFT Chip Select
#define TFT_RST     PORTDbits.RD2                                                                   // Location of TFT Reset

void putch (char c)
{
    while (!TRMT);
    TXREG = c;
}

char INT0_flag = 0;
char INT1_flag = 0;
float g_volt = 0;
int g_rpm = 0;
int g_duty_cycle = 0;
char FANEN = 0;

void INT0_ISR(void);
void INT1_ISR(void);
void init_INT(void);
void init_UART(void);
void init_ADC(void);
void init_IO(void);
void Set_DC_RGB(int);
void Set_RPM_RGB(int);
unsigned int get_full_ADC(void);
int get_RPM(void);
float read_volt(void);
int get_duty_cycle(float);
void do_update_pwm(char);
void Monitor_Fan(void);
void Wait_Half_Second(void);
void Turn_Off_Fan(void);
void Turn_On_Fan(void);
void Show_Fan_Off(void);
void Show_Fan_On(void);
void Update_Volt(void);
void Initialize_Screen(void);
void draw_bar_graph_dc(int);
void draw_bar_graph_rpm(int);

#define _XTAL_FREQ      8000000                                                                     // Set operation for 8 Mhz
#define TMR_CLOCK       _XTAL_FREQ/4                                                                // Timer Clock 2 Mhz

#define TS_1            1                                                                           // Size of Normal Text
#define TS_2            2                                                                           // Size of PED Text

#define Fan_Txt_Y       15                                                          
#define Volt_Txt_Y      35                                                          
#define DC_Txt_X        55                                                          
#define DC_Txt_Y        67                                                          

#define DC_Rect_X       15                                                          
#define DC_Rect_Y       85                                                          
#define DC_Rect_Height  20                                                          
#define DC_Rect_Width   100                                                         

#define RPM_Txt_X       40                                                          
#define RPM_Txt_Y       122                                                         

#define RPM_Rect_X      15                                                          
#define RPM_Rect_Y      140                                                         
#define RPM_Rect_Height 20                                                          
#define RPM_Rect_Width  100                                                         

#include "ST7735_TFT.c"                                                         
char buffer[31];                                                                                    // general buffer for display purpose
char *nbr;                                                                                          // general pointer used for buffer
char *txt;                                                          

char Fan_Txt[]  = "OFF";                                                                            // text storage for Fan Mode
char Volt_Txt[] = "0.00V";                                                                          // text storage for Volt            
char DC_Txt[]  = "00";                                                                              // text storage for Duty Cycle value
char RPM_Txt[] = "0000";                                                                            // text storage for RPMs

void main(void)
{
    init_INT();
    init_IO();
    init_ADC();
    init_UART();

    OSCCON = 0x70;                                                                                  // set the system clock to be 1MHz 1/4 of the 4MHz

    Initialize_Screen();

    DC_GRN = 0;
    DC_RED = 0;
    RPM_BLU = 0;
    RPM_GRN = 0;
    SEC_LED = 0;

    RBPU = 0;
    
    while (1)
    {
        if (INT0_flag)
        {
            INT0_flag = 0;
            Turn_Off_Fan();
        }
        if (INT1_flag)
        {
            INT1_flag = 0;
            Turn_On_Fan();
        }
        Update_Volt();
        if (FANEN) Monitor_Fan();
        else 
        {
            Wait_Half_Second();
            Wait_Half_Second();
        }
    }
}

void interrupt high_priority chkisr()                                                               // High priority interrupt
{
    if ( INTCONbits.INT0IF) INT0_ISR();                                                             // check if INT0 has occured
    if (INTCON3bits.INT1IF) INT1_ISR();                                                             // check if INT1 has occured
    // if (INTCON3bits.INT2IF) INT2_ISR();                                                             // check if INT2 has occured
}

void INT0_ISR()
{
    INTCONbits.INT0IF=0;                                                                            // Clear the interrupt flag
    INT0_flag = 1;                                                                                  // set software INT0 flag
    printf("INT0 fired\r\n");
}

void INT1_ISR()
{
    INTCON3bits.INT1IF=0;                                                                           // Clear the interrupt flag
    INT1_flag = 1;                                                                                  // set software INT1 flag
    printf("INT1 fired\r\n");
}

void init_INT()
{   
    INTCONbits.INT0IF   = 0;                                                                        // clear INT0 status flag
    INTCON3bits.INT1IF  = 0;                                                                        // clear INT1 status flag

    INTCON2bits.INTEDG0 = 0;                                                                        // config INT0 interrupt at falling edge
    INTCON2bits.INTEDG1 = 0;                                                                        // config INT1 interrupt at falling edge

    INTCONbits.INT0IE   = 1;                                                                        // Enable INT0
    INTCON3bits.INT1IE  = 1;                                                                        // Enable INT1

    INTCONbits.GIE      = 1;                                                                        // Enable interrupt globally
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
    TRISE = 0x06;                                                                                   // set PORTE all input except RE0
}

void Set_DC_RGB(int duty_cycle)
{
    draw_bar_graph_dc(g_duty_cycle);
    DC_RED = (duty_cycle&&(duty_cycle<66));                                                         // turn   red on if duty cycle  <66 and not 0
    DC_GRN = (duty_cycle>=33);                                                                      // turn green on if duty cycle >=33
}

void Set_RPM_RGB(int rpm)
{
    draw_bar_graph_rpm(g_rpm);
    RPM_GRN = (rpm&&(rpm<2400));                                                                    // turn green on if rpm  <2400 and not 0
    RPM_BLU = (rpm>=1200);                                                                          // turn  blue on if rpm >=1200
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
    int dc = (int) (read_volt() / 5.0 * 100.0);                                                     // duty cycle input percentage of 5V
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
    SEC_LED = !SEC_LED;                                                                             // toggle SEC_LED
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

void Monitor_Fan(void)
{
    g_volt = read_volt();
    g_duty_cycle = get_duty_cycle(g_volt);
    do_update_pwm(g_duty_cycle);
    g_rpm = get_RPM();
    Set_DC_RGB(g_duty_cycle);
    Set_RPM_RGB(g_rpm);
    printf ("duty cycle = %d RPM = %d\r\n",g_duty_cycle, g_rpm);
    Wait_Half_Second();
}

void Turn_Off_Fan(void)
{
    Show_Fan_Off();
    g_duty_cycle = 0;
    do_update_pwm(g_duty_cycle);
    Set_DC_RGB(g_duty_cycle);
    g_rpm = 0;
    Set_RPM_RGB(g_rpm);
    FANEN = 0;
    FANEN_LED = 0;
}

void Turn_On_Fan(void)
{
    Show_Fan_On();
    FANEN = 1;
    FANEN_LED = 1;
}

void Show_Fan_On()
{
    Fan_Txt[1] = 'N';
    Fan_Txt[2] = ' ';
    drawtext(75, Fan_Txt_Y, Fan_Txt, ST7735_GREEN, ST7735_BLACK, TS_2);
}

void Show_Fan_Off()
{
    Fan_Txt[1] = 'F';
    Fan_Txt[2] = 'F';
    drawtext(75, Fan_Txt_Y, Fan_Txt, ST7735_RED, ST7735_BLACK, TS_2);
}

void Update_Volt()
{
    g_volt = read_volt();
    Volt_Txt[0]= ((int)  g_volt        ) + '0';
    Volt_Txt[2]= ((int) (g_volt*10 )%10) + '0';
    Volt_Txt[3]= ((int) (g_volt*100)%10) + '0';  
    drawtext(70, Volt_Txt_Y, Volt_Txt, ST7735_WHITE, ST7735_BLACK, TS_2);    
}

void Initialize_Screen()
{
    LCD_Reset();
    TFT_GreenTab_Initialize();
    fillScreen(ST7735_BLACK);

    txt = buffer;                                                                                   // TOP HEADER FIELD 
    strcpy(txt, "ECE3301L Fall'20 L10");  
    drawtext(2, 2, txt, ST7735_WHITE, ST7735_BLACK, TS_1);

    strcpy(txt, "FAN:");
    drawtext(15, Fan_Txt_Y, txt, ST7735_WHITE, ST7735_BLACK, TS_2);
    drawtext(75, Fan_Txt_Y, Fan_Txt, ST7735_RED, ST7735_BLACK, TS_2);
    
    strcpy(txt, "VOLT:");
    drawtext(2, Volt_Txt_Y, txt, ST7735_WHITE, ST7735_BLACK, TS_2);
    drawtext(70, Volt_Txt_Y, Volt_Txt, ST7735_WHITE, ST7735_BLACK, TS_2);

    strcpy(txt, "Duty Cycle");
    drawtext(35, 55, txt, ST7735_BLUE, ST7735_BLACK, TS_1);
    drawtext(DC_Txt_X, DC_Txt_Y, DC_Txt, ST7735_RED, ST7735_BLACK, TS_2);
    drawRect(DC_Rect_X, DC_Rect_Y, DC_Rect_Width, DC_Rect_Height,ST7735_RED) ; 

    strcpy(txt, "RPM");
    drawtext(54, 110, txt, ST7735_BLUE, ST7735_BLACK, TS_1);
    drawtext(RPM_Txt_X, RPM_Txt_Y, RPM_Txt, ST7735_GREEN, ST7735_BLACK, TS_2);  
    drawRect(RPM_Rect_X, RPM_Rect_Y, RPM_Rect_Width, RPM_Rect_Height,ST7735_GREEN) ;
}

void draw_bar_graph_dc(int dc)
{
    DC_Txt[0] = dc/10  + '0';
    DC_Txt[1] = dc%10  + '0';            

    
    fillRect(DC_Rect_X, DC_Rect_Y, DC_Rect_Width, DC_Rect_Height,ST7735_BLACK) ;

    if (dc == 0)
    {
       drawtext(DC_Txt_X, DC_Txt_Y, DC_Txt, ST7735_RED, ST7735_BLACK, TS_2);        
       drawRect(DC_Rect_X, DC_Rect_Y, DC_Rect_Width, DC_Rect_Height,ST7735_RED) ;
    }
    else if (dc < 33)
    {
       drawtext(DC_Txt_X, DC_Txt_Y, DC_Txt, ST7735_RED, ST7735_BLACK, TS_2);        
       drawRect(DC_Rect_X, DC_Rect_Y, DC_Rect_Width, DC_Rect_Height,ST7735_RED) ;        
       fillRect(DC_Rect_X, DC_Rect_Y, dc, DC_Rect_Height,ST7735_RED) ;
    }
    else if (dc >=33 && dc < 66)
    {
       drawtext(DC_Txt_X, DC_Txt_Y, DC_Txt, ST7735_YELLOW, ST7735_BLACK, TS_2);        
       fillRect(DC_Rect_X, DC_Rect_Y, 33, DC_Rect_Height,ST7735_RED) ;
       fillRect(DC_Rect_X+33, DC_Rect_Y, (dc-33), DC_Rect_Height,ST7735_YELLOW) ;
       drawRect(DC_Rect_X, DC_Rect_Y, DC_Rect_Width, DC_Rect_Height,ST7735_YELLOW) ;       
    }
    else 
    {
       drawtext(DC_Txt_X, DC_Txt_Y, DC_Txt, ST7735_GREEN, ST7735_BLACK, TS_2);        
       fillRect(DC_Rect_X, DC_Rect_Y, 33, DC_Rect_Height,ST7735_RED) ;
       fillRect(DC_Rect_X+33, DC_Rect_Y, 33, DC_Rect_Height,ST7735_YELLOW) ;
       fillRect(DC_Rect_X+66, DC_Rect_Y, (dc-66), DC_Rect_Height,ST7735_GREEN) ;
       drawRect(DC_Rect_X, DC_Rect_Y, DC_Rect_Width, DC_Rect_Height,ST7735_GREEN) ;    
    }        
}

void draw_bar_graph_rpm(int rpm)
{
    RPM_Txt[0] =  rpm/1000     + '0';
    RPM_Txt[1] = (rpm/100 )%10 + '0';
    RPM_Txt[2] = (rpm/10  )%10 + '0';
    RPM_Txt[3] =  rpm%10       + '0';   
    
    fillRect(RPM_Rect_X, RPM_Rect_Y, RPM_Rect_Width, RPM_Rect_Height,ST7735_BLACK) ;

    int bar = (rpm>3600)? 100 : rpm/36;
            
    if (bar == 0)
    {
       drawtext(RPM_Txt_X, RPM_Txt_Y, RPM_Txt, ST7735_GREEN, ST7735_BLACK, TS_2);        
       drawRect(RPM_Rect_X, RPM_Rect_Y, RPM_Rect_Width, RPM_Rect_Height,ST7735_GREEN) ;
    }
    else if (bar < 33)
    {
       drawtext(RPM_Txt_X, RPM_Txt_Y, RPM_Txt, ST7735_GREEN, ST7735_BLACK, TS_2);        
       drawRect(RPM_Rect_X, RPM_Rect_Y, RPM_Rect_Width, RPM_Rect_Height,ST7735_GREEN) ;        
       fillRect(RPM_Rect_X, RPM_Rect_Y, bar, RPM_Rect_Height,ST7735_GREEN) ;
    }
    else if (bar >=33 && bar < 66)
    {
       drawtext(RPM_Txt_X, RPM_Txt_Y, RPM_Txt, ST7735_CYAN, ST7735_BLACK, TS_2);        
       fillRect(RPM_Rect_X, RPM_Rect_Y, 33, RPM_Rect_Height,ST7735_GREEN) ;
       fillRect(RPM_Rect_X+33, RPM_Rect_Y, (bar-33), RPM_Rect_Height,ST7735_CYAN) ;
       drawRect(RPM_Rect_X, RPM_Rect_Y, RPM_Rect_Width, RPM_Rect_Height,ST7735_CYAN) ;       
    }
    else 
    {
       drawtext(RPM_Txt_X, RPM_Txt_Y, RPM_Txt, ST7735_BLUE, ST7735_BLACK, TS_2);        
       fillRect(RPM_Rect_X, RPM_Rect_Y, 33, RPM_Rect_Height,ST7735_GREEN) ;
       fillRect(RPM_Rect_X+33, RPM_Rect_Y, 33, RPM_Rect_Height,ST7735_CYAN) ;
       fillRect(RPM_Rect_X+66, RPM_Rect_Y, (bar-66), RPM_Rect_Height,ST7735_BLUE) ;
       drawRect(RPM_Rect_X, RPM_Rect_Y, RPM_Rect_Width, RPM_Rect_Height,ST7735_BLUE) ;      
    }
}