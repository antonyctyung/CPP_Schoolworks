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

#define debug 1
//LEDS
#define _XTAL_FREQ      8000000                                                                     // Set operation for 8 Mhz
#define TMR_CLOCK       _XTAL_FREQ/4                                                                // Timer Clock 2 Mhz

#define TFT_DC      PORTDbits.RD0                                                                   // Location of TFT D/C
#define TFT_CS      PORTDbits.RD1                                                                   // Location of TFT Chip Select
#define TFT_RST     PORTDbits.RD2                                                                   // Location of TFT Reset

//colors                                                            
#define OFF 0                                                                                       // Defines OFF    as decimal value 0
#define RED 1                                                                                       // Defines RED    as decimal value 1
#define GREEN 2                                                                                     // Defines GREEN  as decimal value 2
#define YELLOW 3                                                                                    // Defines YELLOW as decimal value 3

#define NS 0                                                            
#define NSLT 1                                                          
#define EW 2                                                            
#define EWLT 3                                                          

#define Circle_Size     7                                                                           // Size of Circle for Light
#define Circle_Offset   15                                                                          // Location of Circle
#define TS_1            1                                                                           // Size of Normal Text
#define TS_2            2                                                                           // Size of PED Text
#define Count_Offset    10                                                                          // Location of Count

#define XTXT            30                                                                          // X location of Title Text 
#define XRED            40                                                                          // X location of Red Circle
#define XYEL            60                                                                          // X location of Yellow Circle
#define XGRN            80                                                                          // X location of Green Circle
#define XCNT            100                                                                         // X location of Sec Count

#define NS              0                                                                           // Number definition of North/South
#define NSLT            1                                                                           // Number definition of North/South Left Turn
#define EW              2                                                                           // Number definition of East/West
#define EWLT            3                                                                           // Number definition of East/West Left Turn

#define Color_Off       0                                                                           // Number definition of Off Color
#define Color_Red       1                                                                           // Number definition of Red Color
#define Color_Green     2                                                                           // Number definition of Green Color
#define Color_Yellow    3                                                                           // Number definition of Yellow Color

#define NS_Txt_Y        20
#define NS_Cir_Y        NS_Txt_Y + Circle_Offset
#define NS_Count_Y      NS_Txt_Y + Count_Offset
#define NS_Color        ST7735_BLUE 

#define NSLT_Txt_Y      50
#define NSLT_Cir_Y      NSLT_Txt_Y + Circle_Offset
#define NSLT_Count_Y    NSLT_Txt_Y + Count_Offset
#define NSLT_Color      ST7735_MAGENTA

#define EW_Txt_Y        80
#define EW_Cir_Y        EW_Txt_Y + Circle_Offset
#define EW_Count_Y      EW_Txt_Y + Count_Offset
#define EW_Color        ST7735_CYAN

#define EWLT_Txt_Y      110
#define EWLT_Cir_Y      EWLT_Txt_Y + Circle_Offset
#define EWLT_Count_Y    EWLT_Txt_Y + Count_Offset
#define EWLT_Color      ST7735_WHITE

#define PED_NS_Count_Y  30
#define PED_EW_Count_Y  90
#define PED_Count_X  2
#define Switch_Txt_Y    140

#define PED_Count_NS            8
#define PED_Count_EW            9

#include "ST7735_TFT.c"

char buffer[31];                                                                                    // general buffer for display purpose
char *nbr;                                                                                          // general pointer used for buffer
char *txt;                                                          

char NS_Count[]     = "00";                                                                         // text storage for NS Count
char NSLT_Count[]   = "00";                                                                         // text storage for NS Left Turn Count
char EW_Count[]     = "00";                                                                         // text storage for EW Count
char EWLT_Count[]   = "00";                                                                         // text storage for EW Left Turn Count

char PED_NS_Count[] = "00";                                                                         // text storage for NS Pedestrian Count
char PED_EW_Count[] = "00";                                                                         // text storage for EW Pedestrian Count

char SW_NSPED_Txt[] = "0";                                                                          // text storage for NS Pedestrian Switch
char SW_NSLT_Txt[]  = "0";                                                                          // text storage for NS Left Turn Switch
char SW_EWPED_Txt[] = "0";                                                                          // text storage for EW Pedestrian Switch
char SW_EWLT_Txt[]  = "0";                                                                          // text storage for EW Left Turn Switch
char SW_MODE_Txt[]  = "D";                                                                          // text storage for Mode Light Sensor

char Act_Mode_Txt[]  = "D";                                                                         // text storage for Actual Mode
char EmergencyS_Txt[] = "0";                                                                        // text storage for Emergency Status
char EmergencyR_Txt[] = "0";                                                                        // text storage for Emergency Request
char dir;                                                           
char Count;                                                                                         // RAM variable for Second Count
char PED_Count;                                                                                     // RAM variable for Second Pedestrian Count

char SW_NSPED;                                                                                      // RAM variable for NS Pedestrian Switch
char SW_NSLT;                                                                                       // RAM variable for NS Left Turn Switch
char SW_EWPED;                                                                                      // RAM variable for EW Pedestrian Switch
char SW_EWLT;                                                                                       // RAM variable for EW Left Turn Switch
char SW_MODE;                                                                                       // RAM variable for Mode Light Sensor
char EMERGENCY = 0;
char EMERGENCY_REQUEST = 0;                                                         
int MODE;                                                           
char direction;                                                         
float volt;                                                         

char NS_PED_SW = 0;
char EW_PED_SW = 0;

#define SEC_LED  PORTEbits.RE0                                                                      // Defines SEC_LED as PORTE bit RE0

#define NS_RED   PORTAbits.RA1                                                                      // Defines NS_RED as PORTB bits RA1
#define NS_GREEN PORTAbits.RA2                                                                      // Defines NS_GREEN as PORTA bit RA2

#define NSLT_RED PORTAbits.RA3                                                                      // Defines NS_LT RED as PORTC bit RA3
#define NSLT_GREEN PORTAbits.RA4                                                                    // Defines NS_LT GREEN as PORTC bit RA4

#define EW_RED   PORTDbits.RD4                                                                      // Defines EW_RED as PORTC bit RB4
#define EW_GREEN PORTDbits.RD5                                                                      // Defines EW_GREEN as PORTC bit RB5

#define EWLT_RED PORTDbits.RD6                                                                      // Defines EWLT_RED as PORTD bit RD6
#define EWLT_GREEN PORTDbits.RD7                                                                    // Defines EWLT_GREEN as PORTD bit RD7

#define NS_LT_SW PORTBbits.RB4                                                                      // Defines NS_LT as PORTB bit RB4 for left turn
//#define NS_PED_SW PORTBbits.RB0                                                                   // Defines NS_PED as PORTB bit RB0 for Ped-switch

#define EW_LT_SW PORTBbits.RB5                                                                      // Defines EW_LT as PORTB bit RB1 for left turn
//#define EW_PED_SW PORTBbits.RB1                                                                   // Defines EW_PED as PORTB bit RB5 for Ped-switch

#define MODE_LED PORTDbits.RD3                                                                      // Defines MODE_LED as PORTD bit RD3,to differentiate day/night mode

void INT0_ISR();
void INT1_ISR();
void INT2_ISR();

unsigned int get_full_ADC(void);
void init_INT(void);
void init_ADC(void);
void init_IO(void);
void init_VAR(void);

void Set_NS(char color);
void Set_NS_LT(char color);
void Set_EW(char color);
void Set_EW_LT(char color);

inline unsigned int mode(void);                                                                     // return 1 when day and 0 when night

void PED_Control( char Direction, char Num_Sec);
void Day_Mode(void);
void Night_Mode(void);
void Do_Emergency(void);

void Wait_One_Second(void);
void Wait_Half_Second(void);
void Wait_N_Seconds (char);
void Wait_One_Second_With_Beep(void);

void update_color(char , char );
void update_PED_Count(char direction, char count);
void Initialize_Screen(void);
void update_misc(void);
void update_count(char, char);

inline void test_loop_LEDs(void);                                                                   // test loop to make sure LED works as expected

void Initialize_Screen()
{
  LCD_Reset();
  TFT_GreenTab_Initialize();
  fillScreen(ST7735_BLACK);
  
  /* TOP HEADER FIELD */
  txt = buffer;
  strcpy(txt, "ECE3301L Fall 2020");  
  drawtext(2, 2, txt, ST7735_WHITE, ST7735_BLACK, TS_1);
  
  /* MODE FIELD */
  strcpy(txt, "Mode:");
  drawtext(2, 10, txt, ST7735_WHITE, ST7735_BLACK, TS_1);
  drawtext(35,10, Act_Mode_Txt, ST7735_WHITE, ST7735_BLACK, TS_1);

  /* EMERGENCY REQUEST FIELD */
  strcpy(txt, "ER:");
  drawtext(50, 10, txt, ST7735_WHITE, ST7735_BLACK, TS_1);
  drawtext(70, 10, EmergencyR_Txt, ST7735_WHITE, ST7735_BLACK, TS_1);
  
  /* EMERGENCY STATUS FIELD */
  strcpy(txt, "ES:");
  drawtext(80, 10, txt, ST7735_WHITE, ST7735_BLACK, TS_1);
  drawtext(100, 10, EmergencyS_Txt, ST7735_WHITE, ST7735_BLACK, TS_1); 

  /* SECOND UPDATE FIELD */
  strcpy(txt, "*");
  drawtext(120, 10, txt, ST7735_WHITE, ST7735_BLACK, TS_1);
      
  /* NORTH/SOUTH UPDATE FIELD */
  strcpy(txt, "NORTH/SOUTH");
  drawtext  (XTXT, NS_Txt_Y  , txt, NS_Color, ST7735_BLACK, TS_1);
  drawRect  (XTXT, NS_Cir_Y-8, 60, 18, NS_Color);
  drawCircle(XRED, NS_Cir_Y  , Circle_Size, ST7735_RED);
  drawCircle(XYEL, NS_Cir_Y  , Circle_Size, ST7735_YELLOW);
  fillCircle(XGRN, NS_Cir_Y  , Circle_Size, ST7735_GREEN);
  drawtext  (XCNT, NS_Count_Y, NS_Count, NS_Color, ST7735_BLACK, TS_2);
    
  /* NORTH/SOUTH LEFT TURN UPDATE FIELD */
  strcpy(txt, "N/S LT");
  drawtext  (XTXT, NSLT_Txt_Y, txt, NSLT_Color, ST7735_BLACK, TS_1);
  drawRect  (XTXT, NSLT_Cir_Y-8, 60, 18, NSLT_Color);
  fillCircle(XRED, NSLT_Cir_Y, Circle_Size, ST7735_RED);
  drawCircle(XYEL, NSLT_Cir_Y, Circle_Size, ST7735_YELLOW);
  drawCircle(XGRN, NSLT_Cir_Y, Circle_Size, ST7735_GREEN);  
  drawtext  (XCNT, NSLT_Count_Y, NSLT_Count, NSLT_Color, ST7735_BLACK, TS_2);
  
  /* EAST/WEST UPDATE FIELD */
  strcpy(txt, "EAST/WEST");
  drawtext  (XTXT, EW_Txt_Y, txt, EW_Color, ST7735_BLACK, TS_1);
  drawRect  (XTXT, EW_Cir_Y-8, 60, 18, EW_Color);
  fillCircle(XRED, EW_Cir_Y, Circle_Size, ST7735_RED);
  drawCircle(XYEL, EW_Cir_Y, Circle_Size, ST7735_YELLOW);
  drawCircle(XGRN, EW_Cir_Y, Circle_Size, ST7735_GREEN);  
  drawtext  (XCNT, EW_Count_Y, EW_Count, EW_Color, ST7735_BLACK, TS_2);

  /* EAST/WEST LEFT TURN UPDATE FIELD */
  strcpy(txt, "E/W LT");
  drawtext  (XTXT, EWLT_Txt_Y, txt, EWLT_Color, ST7735_BLACK, TS_1);
  drawRect  (XTXT, EWLT_Cir_Y-8, 60, 18, EWLT_Color);  
  fillCircle(XRED, EWLT_Cir_Y, Circle_Size, ST7735_RED);
  drawCircle(XYEL, EWLT_Cir_Y, Circle_Size, ST7735_YELLOW);
  drawCircle(XGRN, EWLT_Cir_Y, Circle_Size, ST7735_GREEN);   
  drawtext  (XCNT, EWLT_Count_Y, EWLT_Count, EWLT_Color, ST7735_BLACK, TS_2);

  /* NORTH/SOUTH PEDESTRIAM UPDATE FIELD */
  strcpy(txt, "PNS");  
  drawtext(3, NS_Txt_Y, txt, NS_Color, ST7735_BLACK, TS_1);
  drawtext(2, PED_NS_Count_Y, PED_NS_Count, NS_Color, ST7735_BLACK, TS_2);
  
  /* EAST/WEST PEDESTRIAM UPDATE FIELD */  
  drawtext(2, PED_EW_Count_Y, PED_EW_Count, EW_Color, ST7735_BLACK, TS_2);
  strcpy(txt, "PEW");  
  drawtext(3, EW_Txt_Y, txt, EW_Color, ST7735_BLACK, TS_1);
      
  /* MISCELLANEOUS UPDATE FIELD */  
  strcpy(txt, "NSP NSLT EWP EWLT MD");
  drawtext(1,  Switch_Txt_Y, txt, ST7735_WHITE, ST7735_BLACK, TS_1);
  drawtext(6,  Switch_Txt_Y+9, SW_NSPED_Txt, ST7735_WHITE, ST7735_BLACK, TS_1);
  drawtext(32, Switch_Txt_Y+9, SW_NSLT_Txt, ST7735_WHITE, ST7735_BLACK, TS_1);
  drawtext(58, Switch_Txt_Y+9, SW_EWPED_Txt, ST7735_WHITE, ST7735_BLACK, TS_1);
  drawtext(87, Switch_Txt_Y+9, SW_EWLT_Txt, ST7735_WHITE, ST7735_BLACK, TS_1);  
  drawtext(112,Switch_Txt_Y+9, SW_MODE_Txt, ST7735_WHITE, ST7735_BLACK, TS_1);
}

void interrupt high_priority chkisr()                                                               // High priority interrupt
{
    if ( INTCONbits.INT0IF) INT0_ISR();                                                             // check if INT0 has occured
    if (INTCON3bits.INT1IF) INT1_ISR();                                                             // check if INT1 has occured
    if (INTCON3bits.INT2IF) INT2_ISR();                                                             // check if INT2 has occured
}

void INT0_ISR()
{
    INTCONbits.INT0IF=0;                                                                            // Clear the interrupt flag
    NS_PED_SW = 1;                                                                                  // set software NS_PED_SW
    update_misc();                                                                                  // update status display
}

void INT1_ISR()
{
    INTCON3bits.INT1IF=0;                                                                           // Clear the interrupt flag
    EW_PED_SW = 1;                                                                                  // set software EW_PED_SW
    update_misc();                                                                                  // update status display
}

void INT2_ISR()
{
    INTCON3bits.INT2IF=0;                                                                           // Clear the interrupt flag
    EMERGENCY_REQUEST = 1;                                                                          // set EMERGENCY_REQUEST
    update_misc();                                                                                  // update status display
}

void init_UART()
{
    OpenUSART (USART_TX_INT_OFF & USART_RX_INT_OFF &
    USART_ASYNCH_MODE & USART_EIGHT_BIT & USART_CONT_RX &
    USART_BRGH_HIGH, 25);
    OSCCON = 0x60;
}

void putch (char c)
{
    while (!TRMT);
    TXREG = c;
}

void main(void)
{
    init_IO();
    init_ADC();
    init_UART();
    init_INT();

    OSCCON = 0x70;                                                                                  // set the system clock to be 1MHz 1/4 of the 4MHz
    Initialize_Screen();                                                                            // Initialize the TFT screen
    RBPU = 0;

    init_VAR();
    update_misc();
    //test_loop_LEDs();

    while(1)
    {
        // main loop

        if (EMERGENCY_REQUEST)
        {
            EMERGENCY_REQUEST = 0;                                                                  // clear status 
            Do_Emergency();
        }

        if (SW_MODE = mode())    
        {
            Day_Mode();                                                                             // calls Day_Mode() function
        }
        else
        {
            Night_Mode();                                                                           // calls Night_Mode() function
        }
    } 
}

void init_INT()
{    

    INTCONbits.INT0IF   = 0;                                                                        // clear INT0 status flag
    INTCON3bits.INT1IF  = 0;                                                                        // clear INT1 status flag
    INTCON3bits.INT2IF  = 0;                                                                        // clear INT2 status flag

    INTCON2bits.INTEDG0 = 0;                                                                        // config INT0 interrupt at falling edge
    INTCON2bits.INTEDG1 = 0;                                                                        // config INT1 interrupt at falling edge
    INTCON2bits.INTEDG2 = 1;                                                                        // config INT2 interrupt at  rising edge

    INTCONbits.INT0IE   = 1;                                                                        // Enable INT0
    INTCON3bits.INT1IE  = 1;                                                                        // Enable INT1
    INTCON3bits.INT2IE  = 1;                                                                        // Enable INT2

    INTCONbits.GIE      = 1;                                                                        // Enable interrupt globally
}                                                           

void init_IO(void)  
{   
    TRISA = 0xE1;                                                                                   // make PORTA as IIIO OOOI
    TRISB = 0xF7;                                                                                   // make PORTB as IIII OIII
    TRISC = 0x00;                                                                                   // make PORTC as all outputs
    TRISD = 0x00;                                                                                   // make PORTD as all outputs
    TRISE = 0x00;                                                                                   // make PORTE as all outputs
}                   

void init_ADC()
{
    ADCON0 = 0x01;
    ADCON1 = 0x0E; 
    ADCON2 = 0xA9;
}

void init_VAR()
{
    // initialize variables
    NS_PED_SW = 0;
    EW_PED_SW = 0;
    EMERGENCY = 0;                                                         
    EMERGENCY_REQUEST = 0;  
}

unsigned int get_full_ADC()
{
    unsigned int result;
    ADCON0bits.GO=1;                                                                                // Start Conversion
    while(ADCON0bits.DONE==1);                                                                      // wait for conversion to be completed
    result = (ADRESH * 0x100) + ADRESL;                                                             // combine result of upper byte and lower byte into result
    return result;                                                                                  // return the result.
}

void Set_NS(char color)
{
    if (color>RED)
        direction = NS;
    update_color(NS, color);
    NS_RED=color&0x01;                                                                              // set   NS_RED   to bit 0 of color
    NS_GREEN=color>>1;                                                                              // set   NS_GREEN to bit 1 of color
}

void Set_NSLT(char color)
{
    if (color>RED)
        direction = NSLT;
    update_color(NSLT, color);        
    NSLT_RED=color&0x01;                                                                            // set NSLT_RED   to bit 0 of color       
    NSLT_GREEN=color>>1;                                                                            // set NSLT_GREEN to bit 1 of color  
}

void Set_EW(char color)
{
    if (color>RED)    
        direction = EW;
    update_color(EW, color);
    EW_RED=color&0x01;                                                                              // set   EW_RED   to bit 0 of color
    EW_GREEN=color>>1;                                                                              // set   EW_GREEN to bit 1 of color
}

void Set_EWLT(char color)
{
    if (color>RED)
        direction = EWLT;
    update_color(EWLT, color);
    EWLT_RED=color&0x01;                                                                            // set EWLT_RED   to bit 0 of color
    EWLT_GREEN=color>>1;                                                                            // set EWLT_GREEN to bit 1 of color
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

inline unsigned int mode(void)
{
    return !(get_full_ADC()/717);                                                                   // 3.5/Vcc*1024 = 717; 0 when >= 3.5V; 1 when < 3.5V
}

void PED_Control( char direction, char Num_Sec)
{ 
    for(char i = Num_Sec-1;i>0; i--)
    {
        update_PED_Count(direction, i);
        Wait_One_Second_With_Beep();                                                                // hold the number on 7-Segment for 1 second
    }                                                   

    update_PED_Count(direction, 0);                                                 
    Wait_One_Second_With_Beep();                                                                    // leaves the 7-Segment off for 1 second

    if (direction == NS) NS_PED_SW = 0;                                                             // clear NS_PED_SW variable
    if (direction == EW) EW_PED_SW = 0;                                                             // clear EW_PED_SW variable
    update_misc();
}                                                   

void Day_Mode()                                                 
{                                                   
    MODE = 1;                                                                                       // turns on the MODE_LED
    MODE_LED = 1;
    Act_Mode_Txt[0] = 'D';
    
    //  1. Set NS RGB to GREEN and the rest in RED and read the logic state of NSPED_SW
    Set_NSLT(RED);
    Set_EW(RED);
    Set_EWLT(RED);
    Set_NS(GREEN);
    if (SW_NSPED)                                                                                   // Pedestrian crossing requested at NS direction
        PED_Control(NS, 9);                                                                         // Display pedestrian countdown at NS direction for 9 seconds

    //  2. Wait for 8 seconds
    Wait_N_Seconds(8);

    //  3. Set NS RGB to YELLOW and wait for 3 seconds
    Set_NS(YELLOW);
    Wait_N_Seconds(3);

    //  4. Set NS RGB to RED
    Set_NS(RED);
    
    //  5. Check the logic of EWLT_SW
    if (SW_EWLT)                                                                                    // Left turn requested at EW direction
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
    if (SW_EWPED)                                                                                   // Pedestrian crossing requested at EW direction
        PED_Control(EW, 8);                                                                         // Display pedestrian countdown at EW direction for 8 seconds

    // 10. Wait for 7 seconds
    Wait_N_Seconds(7);

    // 11. Set EW RGB to YELLOW and wait for 3 seconds
    Set_EW(YELLOW);
    Wait_N_Seconds(3);

    // 12. Set EW RGB to RED
    Set_EW(RED);

    // 13. Check the logic of NSLT_SW
    if (SW_NSLT)
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

    // 17. This complete the sequence}
}

void Night_Mode()
{ 
    MODE = 0;                                                                                       // turns on the MODE_LED
    MODE_LED = 0;
    Act_Mode_Txt[0] = 'N';
    
    //  1. Set NS RGB to GREEN and the rest in RED
    Set_NSLT(RED);
    Set_EW(RED);
    Set_EWLT(RED);
    Set_NS(GREEN);

    //  2. Wait for 7 seconds
    Wait_N_Seconds(7);

    //  3. Set NS RGB to YELLOW and wait for 3 seconds
    Set_NS(YELLOW);
    Wait_N_Seconds(3);

    //  4. Set NS RGB to RED
    Set_NS(RED);
    
    //  5. Check the logic of EWLT_SW
    if (SW_EWLT)
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
    if (SW_NSLT)
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

void Do_Emergency()
{
    EMERGENCY = 1;
    while (EMERGENCY)
    {
        EMERGENCY = EMERGENCY_REQUEST? 0 : 1;                                                       // clear EMERGENCY (exit loop) if EMERGENCY_REQUESTed
    
        // set all to red
        Set_NS(RED);
        Set_NSLT(RED);
        Set_EW(RED);
        Set_EWLT(RED);
        Wait_One_Second();

        // Set all to off
        Set_NS(OFF);
        Set_NSLT(OFF);
        Set_EW(OFF);
        Set_EWLT(OFF);
        Wait_One_Second();
    }
    EMERGENCY_REQUEST = 0;                                                                          // clear EMERGENCY_REQUEST when exiting emergency mode
    update_misc();                                                                                  // update status display
}

void Old_Wait_One_Second()                                                                          // creates one second delay and blinking asterisk
{
    SEC_LED = 1;
    Wait_Half_Second();                                                                             // Wait for half second (or 500 msec)
    SEC_LED = 0;
    Wait_Half_Second();                                                                             // Wait for half second (or 500 msec)

}

void Wait_One_Second()							                                                    // creates one second delay and blinking asterisk
{
    SEC_LED = 1;
    strcpy(txt,"*");
    drawtext(120,10,txt,ST7735_WHITE,ST7735_BLACK,TS_1);
    Wait_Half_Second();                                                                             // Wait for half second (or 500 msec)

    SEC_LED = 0;
    strcpy(txt," ");
    drawtext(120,10,txt,ST7735_WHITE,ST7735_BLACK,TS_1);
    Wait_Half_Second();                                                                             // Wait for half second (or 500 msec)
    update_misc();
}

void Wait_One_Second_With_Beep()				                                                    // creates one second delay as well as sound buzzer
{
    SEC_LED = 1;                                                                                    // First, turn on the SEC LED
    strcpy(txt,"*");                        
    drawtext(120,10,txt,ST7735_WHITE,ST7735_BLACK,TS_1);                        
    Activate_Buzzer();                                                                              // Activate the buzzer
    Wait_Half_Second();                                                                             // Wait for half second (or 500 msec)

    SEC_LED = 0;                                                                                    // then turn off the SEC LED
    strcpy(txt," ");                        
    drawtext(120,10,txt,ST7735_WHITE,ST7735_BLACK,TS_1);                        
    Deactivate_Buzzer();                                                                            // Deactivate the buzzer
    Wait_Half_Second();                                                                             // Wait for half second (or 500 msec)}
    update_misc();

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

void Wait_N_Seconds (char seconds)
{
    char I;
    for (I = seconds; I> 0; I--)
    {
        update_count(direction, I);
        Wait_One_Second();                                                                          // calls Wait_One_Second for x number of times

    }                                                   
    update_count(direction, 0);                                                     
    Wait_One_Second();                                                                              // calls Wait_One_Second for x number of times

}

void update_color(char direction, char color)
{
    char Circle_Y;
    Circle_Y = NS_Cir_Y + direction * 30;    
    
    if (color == Color_Off)                                                                         // if Color off make all circles black but leave outline
    {
            fillCircle(XRED, Circle_Y, Circle_Size, ST7735_BLACK);
            fillCircle(XYEL, Circle_Y, Circle_Size, ST7735_BLACK);
            fillCircle(XGRN, Circle_Y, Circle_Size, ST7735_BLACK); 
            drawCircle(XRED, Circle_Y, Circle_Size, ST7735_RED);            
            drawCircle(XYEL, Circle_Y, Circle_Size, ST7735_YELLOW);
            drawCircle(XGRN, Circle_Y, Circle_Size, ST7735_GREEN);                       
    }    
    
    if (color == Color_Red)                                                                         // if the color is red only fill the red circle with red
    {
            fillCircle(XRED, Circle_Y, Circle_Size, ST7735_RED);
            fillCircle(XYEL, Circle_Y, Circle_Size, ST7735_BLACK);
            fillCircle(XGRN, Circle_Y, Circle_Size, ST7735_BLACK); 
            drawCircle(XRED, Circle_Y, Circle_Size, ST7735_RED);            
            drawCircle(XYEL, Circle_Y, Circle_Size, ST7735_YELLOW);
            drawCircle(XGRN, Circle_Y, Circle_Size, ST7735_GREEN);  
    }
          
    if (color == Color_Green)                                                                       // if the color is red only fill the red circle with red
    {
            fillCircle(XRED, Circle_Y, Circle_Size, ST7735_BLACK);
            fillCircle(XYEL, Circle_Y, Circle_Size, ST7735_BLACK);
            fillCircle(XGRN, Circle_Y, Circle_Size, ST7735_GREEN); 
            drawCircle(XRED, Circle_Y, Circle_Size, ST7735_RED);            
            drawCircle(XYEL, Circle_Y, Circle_Size, ST7735_YELLOW);
            drawCircle(XGRN, Circle_Y, Circle_Size, ST7735_GREEN);  
    }
    
    if (color == Color_Yellow)                                                                      // if the color is red only fill the red circle with red
    {
            fillCircle(XRED, Circle_Y, Circle_Size, ST7735_BLACK);
            fillCircle(XYEL, Circle_Y, Circle_Size, ST7735_YELLOW);
            fillCircle(XGRN, Circle_Y, Circle_Size, ST7735_BLACK); 
            drawCircle(XRED, Circle_Y, Circle_Size, ST7735_RED);            
            drawCircle(XYEL, Circle_Y, Circle_Size, ST7735_YELLOW);
            drawCircle(XGRN, Circle_Y, Circle_Size, ST7735_GREEN);  
    }
}

void update_count(char direction, char count)
{
   switch (direction)                       
   {
        case NS:       
            NS_Count[0] = count/10  + '0';
            NS_Count[1] = count%10  + '0';
            drawtext(XCNT, NS_Count_Y, NS_Count, NS_Color, ST7735_BLACK, TS_2); 
            break;

        case NSLT:       
            NSLT_Count[0] = count/10  + '0';
            NSLT_Count[1] = count%10  + '0';
            drawtext(XCNT, NSLT_Count_Y, NSLT_Count, NSLT_Color, ST7735_BLACK, TS_2); 
            break;
      
        case EW:       
            EW_Count[0] = count/10  + '0';
            EW_Count[1] = count%10  + '0';
            drawtext(XCNT, EW_Count_Y, EW_Count, EW_Color, ST7735_BLACK, TS_2); 
            break;
        
        case EWLT:       
            EWLT_Count[0] = count/10  + '0';
            EWLT_Count[1] = count%10  + '0';
            drawtext(XCNT, EWLT_Count_Y, EWLT_Count, EWLT_Color, ST7735_BLACK, TS_2); 
            break;
    }  
}

void update_PED_Count(char direction, char count)
{

    switch (direction)
    {
        case NS:       
            PED_NS_Count[0] = count/10  + '0';                                                      // PED count upper digit
            PED_NS_Count[1] = count%10  + '0';                                                      // PED Lower
            drawtext(PED_Count_X, PED_NS_Count_Y, PED_NS_Count, NS_Color, ST7735_BLACK, TS_2);      // Put counter digit on screen
            break;

        case EW:       
            PED_EW_Count[0] = count/10  + '0';                                                      // PED count upper digit
            PED_EW_Count[1] = count%10  + '0';                                                      // PED Lower
            drawtext(PED_Count_X, PED_EW_Count_Y, PED_EW_Count, EW_Color, ST7735_BLACK, TS_2);      // Put counter digit on screen
            break;
        
    }
   
}

void update_misc()
{

    SW_MODE = mode();
    
    SW_NSPED = NS_PED_SW;
    SW_NSLT = NS_LT_SW;
    SW_EWPED = EW_PED_SW;
    SW_EWLT = EW_LT_SW;
      
    if (SW_MODE == 0) SW_MODE_Txt[0] = 'N'; else SW_MODE_Txt[0] = 'D';                              // Set Text at bottom of screen to switch states
    if (SW_NSPED == 0) SW_NSPED_Txt[0] = '0'; else SW_NSPED_Txt[0] = '1';                           // Set Text at bottom of screen to switch states
    if (SW_NSLT == 0) SW_NSLT_Txt[0] = '0'; else SW_NSLT_Txt[0] = '1';                              // Set Text at bottom of screen to switch states
    if (SW_EWPED == 0) SW_EWPED_Txt[0] = '0'; else SW_EWPED_Txt[0] = '1';                           // Set Text at bottom of screen to switch states
    if (SW_EWLT == 0) SW_EWLT_Txt[0] = '0'; else SW_EWLT_Txt[0] = '1';                              // Set Text at bottom of screen to switch states
    if (EMERGENCY_REQUEST == 0) EmergencyR_Txt[0] = '0'; else EmergencyR_Txt[0] = '1';              // Set Text at    top of screen to switch states
    if (EMERGENCY == 0) EmergencyS_Txt[0] = '0'; else EmergencyS_Txt[0] = '1';                      // Set Text at    top of screen to switch states

    drawtext(35,10, Act_Mode_Txt, ST7735_WHITE, ST7735_BLACK, TS_1);    
    drawtext(70,10, EmergencyR_Txt, ST7735_WHITE, ST7735_BLACK, TS_1); 
    drawtext(100,10, EmergencyS_Txt, ST7735_WHITE, ST7735_BLACK, TS_1);     
    drawtext(6,  Switch_Txt_Y+9, SW_NSPED_Txt, ST7735_WHITE, ST7735_BLACK, TS_1);                   // Show switch and sensor states at bottom of the screen
    drawtext(32,  Switch_Txt_Y+9, SW_NSLT_Txt, ST7735_WHITE, ST7735_BLACK, TS_1);
    drawtext(58,  Switch_Txt_Y+9, SW_EWPED_Txt, ST7735_WHITE, ST7735_BLACK, TS_1);
    drawtext(87,  Switch_Txt_Y+9, SW_EWLT_Txt, ST7735_WHITE, ST7735_BLACK, TS_1);
    drawtext(112,  Switch_Txt_Y+9, SW_MODE_Txt, ST7735_WHITE, ST7735_BLACK, TS_1);
            
}

inline void test_loop_LEDs()
{
    while (1)
    {
        for (int i=0; i<4;i++)
        {
            Set_NS(i);                                                                              // Set color for North-South direction
            Set_NSLT(i);                                                                            // Set color for North-South Left-Turn direction
            Set_EW(i);                                                                              // Set color for East-West direction
            Set_EWLT(i);                                                                            // Set color for East-West Left-Turn direction
            Wait_N_Seconds(1);
        }
    }
}