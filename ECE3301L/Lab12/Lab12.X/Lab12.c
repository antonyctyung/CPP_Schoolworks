#include <stdio.h>
#include <stdlib.h>
#include <xc.h>
#include <math.h>
#include <p18f4620.h>
#include <usart.h>


#pragma config OSC      =   INTIO67
#pragma config BOREN    =   OFF
#pragma config WDT      =   OFF
#pragma config LVP      =   OFF
#pragma config CCP2MX   =   PORTBE

#define SEC_LED         PORTEbits.RE0



#define ACCESS_CFG      0xAC
#define START_CONV      0xEE
#define READ_TEMP       0xAA
#define CONT_CONV       0x02

#define ACK             1
#define NAK             0

#define TFT_DC          PORTDbits.RD0
#define TFT_CS          PORTDbits.RD1
#define TFT_RST         PORTDbits.RD2

#define _XTAL_FREQ      8000000

void Initialize_Screen(void); 
void Update_Screen(void);
void Do_Init(void);
void Init_Timer_1();
void Set_RPM_RGB(int );
void Set_DC_RGB(int);
float read_volt();
int get_duty_cycle(float);
int get_RPM(); 
void Monitor_Fan();
void Show_Fan_On();
void Show_Fan_Off();
void Turn_Off_Fan();
void draw_bar_graph_dc(int);
void draw_bar_graph_rpm(int);
unsigned int get_full_ADC();
void Wait_Half_Second();
void Update_Volt();
void DS1621_Init();
char DS1621_Read_Temp();
void DS3231_Read_Time();
void DS3231_Write_Time();

void INT0_ISR();
void INT1_ISR();
void INT2_ISR();
void do_update_pwm(char);


#define SCL_PIN PORTDbits.RD3
#define SCL_DIR TRISDbits.RD3
#define SDA_PIN PORTDbits.RD4
#define SDA_DIR TRISDbits.RD4
#include "softi2c.c"

#define start_x             1
#define start_y             1
#define temp_x              28
#define temp_y              13
#define circ_x              40
#define circ_y              25
#define data_tempc_x        15
#define data_tempc_y        25
#define tempc_x             45
#define tempc_y             25
#define cirf_x              95
#define cirf_y              25
#define data_tempf_x        70
#define data_tempf_y        25
#define tempf_x             100
#define tempf_y             25
#define time_x              50
#define time_y              43
#define data_time_x         15
#define data_time_y         55
#define date_x              50
#define date_y              73
#define data_date_x         15
#define data_date_y         85

#define fan_x               55
#define fan_y               105
#define data_fan_x          50
#define data_fan_y          118

#define volt_x              7
#define volt_y              140
#define data_volt_x         6
#define data_volt_y         150
#define dc_x                60
#define dc_y                140
#define data_dc_x           60
#define data_dc_y           150
#define rpm_x               102
#define rpm_y               140
#define data_rpm_x          100
#define data_rpm_y          150
#define TS_1                1               // Size of Normal Text
#define TS_2                2               // Size of Number Text 

#include "ST7735_TFT.c"
#define FANEN_LED   PORTAbits.RA5
#define DC_RED  PORTAbits.RA1
#define DC_GRN  PORTAbits.RA2
#define RPM_GRN PORTDbits.RD6
#define RPM_BLU PORTDbits.RD7

char buffer[31]     = " ECE3301L Fall'20 L12\0";
char *nbr;
char *txt;
char tempC[]        = "25";
char tempF[]        = "77";
char time[]         = "00:00:00";
char date[]         = "00/00/00";

char Fan_Txt[]      = "OFF";                                                                        // text storage for Fan Mode
char Volt_Txt[]     = "0.00V";                                                                      // text storage for Volt     
char DC_Txt[]       = "00";                                                                         // text storage for Duty Cycle value
char RPM_Txt[]      = "0000";                                                                       // text storage for RPM

void Turn_On_Fan();
void Turn_Off_Fan();

int DS1621_tempC, DS1621_tempF;

int INT0_flag, INT1_flag, INT2_flag, T0_flag;
unsigned char second, minute, hour, dow, day, month, year, old_sec;

char preset_second = 0x00;
char preset_minute = 0x25;
char preset_hour   = 0x04;
char preset_dow    = 0x05;
char preset_day    = 0x06;
char preset_month  = 0x11;
char preset_year   = 0x20;

float volt;
int duty_cycle;
int rpm;
char FANEN;
int Tach_cnt = 0;		

int Half_sec_cnt = 0;                                                                               // Initialize half_sec count 

void putch (char c)
{   
    while (!TRMT);       
    TXREG = c;
}

void init_UART()
{
    	OpenUSART (USART_TX_INT_OFF & USART_RX_INT_OFF & USART_ASYNCH_MODE & USART_EIGHT_BIT & USART_CONT_RX & USART_BRGH_HIGH, 25);
    	OSCCON = 0x70;
}

void interrupt  high_priority chkisr() 
{ 
    if ( INTCONbits.INT0IF) INT0_ISR();                                                             // check if INT0 has occured
    if (INTCON3bits.INT1IF) INT1_ISR();                                                             // check if INT1 has occured
    if (INTCON3bits.INT2IF) INT2_ISR();                                                             // check if INT2 has occured
}

void INT0_ISR() 
{    
    INTCONbits.INT0IF=0;                                                                            // Clear the interrupt flag
    INT0_flag = 1;                                                                                  // set software INT0 flag
    printf("\r\nINT0 fired\r\n");
} 

void INT1_ISR() 
{ 
    INTCON3bits.INT1IF=0;                                                                           // Clear the interrupt flag
    INT1_flag = 1;                                                                                  // set software INT1 flag
    printf("\r\nINT1 fired\r\n");
}

void INT2_ISR() 
{    
    INTCON3bits.INT2IF=0;                                                                           // Clear the interrupt flag
    INT2_flag = 1;                                                                                  // set software INT2 flag
    printf("\r\nINT2 fired\r\n");
} 

void Initialize_Screen(void) 
{ 
    LCD_Reset();                                                                                    // Screen reset
    TFT_GreenTab_Initialize();                                  
    fillScreen(ST7735_BLACK);                                                                       // Fills background of screen with color passed to it
                         
    strcpy(txt, "ECE3301L Fall'20 L12\0");                                                          // Text displayed 
    drawtext(start_x , start_y, txt, ST7735_WHITE  , ST7735_BLACK, TS_1);                           // X and Y coordinates of where the text is to be displayed
    strcpy(txt, "Temperature:");
    drawtext(temp_x  , temp_y , txt, ST7735_MAGENTA, ST7735_BLACK, TS_1);                           // including text color and the background of it
    drawCircle(circ_x, circ_y , 2  , ST7735_YELLOW);
    strcpy(txt, "C/");
    drawtext(tempc_x , tempc_y, txt, ST7735_YELLOW , ST7735_BLACK, TS_2); 
    strcpy(txt, "F");         
    drawCircle(cirf_x, cirf_y , 2  , ST7735_YELLOW);
    drawtext(tempf_x , tempf_y, txt, ST7735_YELLOW , ST7735_BLACK, TS_2);
    strcpy(txt, "Time");
    drawtext(time_x  , time_y , txt, ST7735_BLUE   , ST7735_BLACK, TS_1);
    strcpy(txt, "Date");
    drawtext(date_x  , date_y , txt, ST7735_RED    , ST7735_BLACK, TS_1);
    strcpy(txt, "FAN:");
    drawtext(fan_x, fan_y, txt, ST7735_WHITE  , ST7735_BLACK, TS_1); 
    strcpy(txt, "VOLT");
    drawtext(volt_x, volt_y, txt, ST7735_WHITE  , ST7735_BLACK, TS_1);    
    strcpy(txt, "DC");
    drawtext(dc_x, dc_y, txt, ST7735_WHITE  , ST7735_BLACK, TS_1);
    strcpy(txt, "RPM");
    drawtext(rpm_x, rpm_y, txt, ST7735_WHITE    , ST7735_BLACK  , TS_1);  
    drawtext(data_tempc_x, data_tempc_y, tempC  , ST7735_YELLOW , ST7735_BLACK , TS_2);       
    drawtext(data_tempf_x, data_tempf_y, tempF  , ST7735_YELLOW , ST7735_BLACK , TS_2);
    drawtext(data_time_x , data_time_y , time   , ST7735_CYAN   , ST7735_BLACK , TS_2);
    drawtext(data_date_x , data_date_y , date   , ST7735_GREEN  , ST7735_BLACK , TS_2);
    drawtext(data_fan_x  , data_fan_y  , Fan_Txt, ST7735_RED    , ST7735_BLACK , TS_2);    
    drawtext(data_dc_x   , data_dc_y   , DC_Txt , ST7735_RED    , ST7735_BLACK , TS_1);
    drawtext(data_rpm_x  , data_rpm_y  , RPM_Txt, ST7735_RED    , ST7735_BLACK , TS_1);  
}

void Update_Screen(void)
{
    tempC[0]  = DS1621_tempC/10  + '0';                                                             // Tens digit of C
    tempC[1]  = DS1621_tempC%10  + '0';                                                             // Unit digit of C
    tempF[0]  = DS1621_tempF/10  + '0';                                                             // Tens digit of F
    tempF[1]  = DS1621_tempF%10  + '0';                                                             // Unit digit of F
    time[0]  = (hour   >>    4)  + '0';                                                             // Hour   MSD
    time[1]  = (hour   &  0x0f)  + '0';                                                             // Hour   LSD
    time[3]  = (minute >>    4)  + '0';                                                             // Minute MSD
    time[4]  = (minute &  0x0f)  + '0';                                                             // Minute LSD
    time[6]  = (second >>    4)  + '0';                                                             // Second MSD
    time[7]  = (second &  0x0f)  + '0';                                                             // Second LSD
    date[0]  = (month  >>    4)  + '0';                                                             // Month  MSD
    date[1]  = (month  &  0x0f)  + '0';                                                             // Month  LSD
    date[3]  = (day    >>    4)  + '0';                                                             // Day    MSD
    date[4]  = (day    &  0x0f)  + '0';                                                             // Day   LSD
    date[6]  = (year   >>    4)  + '0';                                                             // Year   MSD
    date[7]  = (year   &  0x0f)  + '0';                                                             // Year   LSD
                      
    drawtext(data_tempc_x, data_tempc_y, tempC , ST7735_YELLOW , ST7735_BLACK , TS_2);       
    drawtext(data_tempf_x, data_tempf_y, tempF , ST7735_YELLOW , ST7735_BLACK , TS_2);
    drawtext(data_time_x , data_time_y , time  , ST7735_CYAN   , ST7735_BLACK , TS_2);
    drawtext(data_date_x , data_date_y , date  , ST7735_GREEN  , ST7735_BLACK , TS_2);
}

void Init_ADC()
{
    ADCON0 = 0x01;                                                                                  // AN0, ADC on
    ADCON1 = 0x0E;                                                                                  // VREF = Vdd-Vss, all DIO except AN0
    ADCON2 = 0xA9;                                                                                  // Right justified (10 bits), 12 Tad, Fosc/8
}

void Init_IO()
{
    TRISA = 0x01;                                                                                   // set PORTA all output except AN0/RA0
    TRISB = 0xFF;                                                                                   // set PORTB all input
    TRISC = 0xD3;                                                                                   // set PORTC 1101 0011
    TRISD = 0x20;                                                                                   // set PORTD 0010 0000
    TRISE = 0x06;                                                                                   // set PORTE all input except RE0
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

void Do_Init()                                                                                      // Initialize the ports 
{                                                               
    init_UART();                                                                                    // Initialize the uart
    OSCCON =0x70;                                                                                   // Set oscillator to 8 MHz 
    Init_ADC();                                                                                     // Initialize ADC
    Init_IO();                                                                                      // Initialize DIO

    RBPU = 0;                                                                                       // Enable internal PORTB pull-up
    init_INT();                                                                                     // Initialize INT0/1/2
    I2C_Init(100000);                                                                               // Initialize I2C Master with 100KHz clock
    DS1621_Init();                                                                                  // Initialize DS1621
} 

void main()
{
    Do_Init();                                                                                      // Initialization    
    
    txt = buffer;       
    Initialize_Screen();
    old_sec = 0xff;
    Turn_Off_Fan();
 
    while(TRUE)
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
        if (INT2_flag)
        {   
            INT2_flag = 0;                                                                          // clear flag
            DS3231_Write_Time();
        }
        
        DS3231_Read_Time();                                                                         // Read time from DS3231
        if (old_sec != second)
        {
            old_sec = second;
            printf("%02x:%02x:%02x %02x/%02x/%02x", hour,minute,second,month,day,year);             // Print time
            DS1621_tempC = DS1621_Read_Temp();                                                      // Read temperature from DS1621
            DS1621_tempF = DS1621_tempC*9/5+32;                                                     // convert to fahrenheit
            printf(" %3dC %3dF",DS1621_tempC,DS1621_tempF);                                         // print it in celsius and fahrenheit
            Update_Volt();
            if (FANEN) Monitor_Fan();
            else Wait_Half_Second();
            printf("\r\n");
            Update_Screen();
        }
    }
}

void Monitor_Fan()
{
    volt = read_volt();
    duty_cycle = get_duty_cycle(volt);
    do_update_pwm(duty_cycle);
    rpm = get_RPM();
    Set_DC_RGB(duty_cycle);
    Set_RPM_RGB(rpm);
    printf (" duty cycle = %3d RPM = %4d",duty_cycle, rpm);
}

void Update_Volt()
{
    volt = read_volt();
    Volt_Txt[0]= ((int)  volt        ) + '0';
    Volt_Txt[2]= ((int) (volt*10 )%10) + '0';
    Volt_Txt[3]= ((int) (volt*100)%10) + '0';
    drawtext(data_volt_x, data_volt_y, Volt_Txt, ST7735_WHITE  , ST7735_BLACK, TS_1);
}

float read_volt()
{
    float l_volt;
    int nStep = get_full_ADC();
    l_volt = nStep * 5 /1024.0;
    return (l_volt);
}

int get_duty_cycle(float l_volt)
{
    int dc = (int) (l_volt / 5.0 * 100.0);                                                          // duty cycle input percentage of 5V
    return (dc);
}

void Wait_Half_Second()
{    
    SEC_LED = ~SEC_LED;
    T0CON = 0x03;                                                                                   // Timer 0, 16-bit mode, prescaler 1:16
    TMR0L = 0xDB;                                                                                   // set the lower byte of TMR
    TMR0H = 0x0B;                                                                                   // set the upper byte of TMR
    INTCONbits.TMR0IF = 0;                                                                          // clear the Timer 0 flag
    T0CONbits.TMR0ON = 1;                                                                           // Turn on the Timer 0
    while (INTCONbits.TMR0IF == 0);                                                                 // wait for the Timer Flag to be 1 for done
    T0CONbits.TMR0ON = 0;                                                                           // turn off the Timer 0
    SEC_LED = ~SEC_LED;
}

int get_RPM()
{
    TMR1L = 0x00;                                                                                   // clear the count
    T1CON = 0x03;                                                                                   // start Timer1 as counter of number of pulses
    Wait_Half_Second();                                                                             // wait half second
    int RPS = TMR1L;                                                                                // read the count. Since there are 2 pulses per rev
                                                                                                    // and 2 half sec per sec, then RPS = count
    return (RPS * 60);                                                                              // return RPM = 60 * RPS
}

void Show_Fan_On()
{
    Fan_Txt[1] = 'N';
    Fan_Txt[2] = ' ';
    drawtext(data_fan_x, data_fan_y, Fan_Txt, ST7735_GREEN, ST7735_BLACK, TS_2);
}

void Show_Fan_Off()
{
    Fan_Txt[1] = 'F';
    Fan_Txt[2] = 'F';
    drawtext(data_fan_x, data_fan_y, Fan_Txt,ST7735_RED, ST7735_BLACK, TS_2);
}

void Turn_Off_Fan()
{
    Show_Fan_Off();
    duty_cycle = 0;
    do_update_pwm(duty_cycle);
    Set_DC_RGB(duty_cycle);
    rpm = 0;
    Set_RPM_RGB(rpm);
    FANEN = 0;
    FANEN_LED = 0;
}

void Turn_On_Fan()
{
    Show_Fan_On();
    FANEN = 1;
    FANEN_LED = 1;
}

void do_update_pwm(char l_duty_cycle) 
{ 
    float dc_f;
    int dc_I;
    PR2 = 0b00000100;                                                                               // set the frequency for 25 Khz
    T2CON = 0b00000111;                                                                             
    dc_f = ( 4.0 * l_duty_cycle / 20.0);                                                            // calculate factor of duty cycle versus a 25 kHz signal
    dc_I = (int) dc_f;                                                                              // get the integer part
    if (dc_I > l_duty_cycle) dc_I++;                                                                // round up function
    CCP1CON = ((dc_I & 0x03) << 4) | 0b00001100;
    CCPR1L = (dc_I) >> 2;
}

char DS1621_Read_Temp()
{
    return I2C_Write_Cmd_Read_One_Byte(0x48, READ_TEMP);
}

void DS1621_Init()
{
    char Device = 0x48;                                                                             // DS1621 thermometer I2C address
    I2C_Write_Cmd_Write_Data(Device, ACCESS_CFG, CONT_CONV);
    I2C_Write_Cmd_Only(Device, START_CONV);
}

void DS3231_Read_Time()
{
    char Device = 0x68;                                                                             // I2C Address of DS3231
    char Address = 0x00;                                                                            // Register address to read from
    char Data_Ret;    
    I2C_Start();                                                                                    // Start I2C protocol
    I2C_Write((Device << 1) | 0);                                                                   // Device address
    I2C_Write(Address);                                                                             // Send register address
    I2C_ReStart();                                                                                  // Restart I2C
    I2C_Write((Device << 1) | 1);                                                                   // Initialize data read
    second = I2C_Read(ACK);                                                                         // Read second
    minute = I2C_Read(ACK);                                                                         // Read minute
    hour = I2C_Read(ACK);                                                                           // Read hour
    dow = I2C_Read(ACK);                                                                            // Read day of week
    day = I2C_Read(ACK);                                                                            // Read day
    month = I2C_Read(ACK);                                                                          // Read month
    year = I2C_Read(NAK);                                                                           // Read year
    I2C_Stop();
}

void DS3231_Write_Time()
{
    char Device = 0x68;                                                                             // I2C Address of DS3231
    char Address = 0x00;                                                                            // Register address to read from
    I2C_Start();                                                                                    // Start I2C protocol
    I2C_Write((Device << 1) | 0);                                                                   // Device address Write mode
    I2C_Write(Address);                                                                             // Send register address
    I2C_Write(preset_second);                                                                       // Read second
    I2C_Write(preset_minute);                                                                       // Read minute
    I2C_Write(preset_hour  );                                                                       // Read hour
    I2C_Write(preset_dow   );                                                                       // Read day of week
    I2C_Write(preset_day   );                                                                       // Read day
    I2C_Write(preset_month );                                                                       // Read month
    I2C_Write(preset_year  );                                                                       // Read year
    I2C_Stop(); 
}

void Set_DC_RGB(int l_duty_cycle)
{
    draw_bar_graph_dc(l_duty_cycle);
    DC_RED = (l_duty_cycle&&(l_duty_cycle<66));                                                     // turn   red on if duty cycle  <66 and not 0
    DC_GRN = (l_duty_cycle>=33);                                                                    // turn green on if duty cycle >=33
}

void Set_RPM_RGB(int l_rpm)
{
    draw_bar_graph_rpm(l_rpm);
    RPM_GRN = (l_rpm&&(l_rpm<2400));                                                                // turn green on if rpm  <2400 and not 0
    RPM_BLU = (l_rpm>=1200);                                                                        // turn  blue on if rpm >=1200
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

void draw_bar_graph_dc(int l_dc)
{
    DC_Txt[0] = l_dc/10  + '0';
    DC_Txt[1] = l_dc%10  + '0';            

    if (l_dc == 0)
        drawtext(data_dc_x, data_dc_y, DC_Txt, ST7735_RED, ST7735_BLACK, TS_1);
    else if (l_dc < 33)
        drawtext(data_dc_x, data_dc_y, DC_Txt, ST7735_RED, ST7735_BLACK, TS_1);
    else if (l_dc >=33 && l_dc < 66)
        drawtext(data_dc_x, data_dc_y, DC_Txt, ST7735_YELLOW, ST7735_BLACK, TS_1);
    else        
        drawtext(data_dc_x, data_dc_y, DC_Txt, ST7735_GREEN, ST7735_BLACK, TS_1);

}

void draw_bar_graph_rpm(int l_rpm)
{
    RPM_Txt[0] =  l_rpm/1000     + '0';
    RPM_Txt[1] = (l_rpm/100 )%10 + '0';
    RPM_Txt[2] = (l_rpm/10  )%10 + '0';
    RPM_Txt[3] =  l_rpm%10       + '0';
 
    int bar = (l_rpm>3600)? 100 : l_rpm/36;

    if (bar == 0)
        drawtext(data_rpm_x, data_rpm_y, RPM_Txt, ST7735_GREEN, ST7735_BLACK, TS_1); 
    else if (bar < 33)
        drawtext(data_rpm_x, data_rpm_y, RPM_Txt, ST7735_GREEN, ST7735_BLACK, TS_1);
    else if (bar >=33 && bar < 66)
        drawtext(data_rpm_x, data_rpm_y, RPM_Txt, ST7735_CYAN, ST7735_BLACK, TS_1);
    else
        drawtext(data_rpm_x, data_rpm_y, RPM_Txt, ST7735_BLUE, ST7735_BLACK, TS_1);
}

