#include <stdio.h>
#include <stdlib.h>
#include <xc.h>
#include <math.h>
#include <p18f4620.h>
#include <usart.h>

#pragma config OSC = INTIO67
#pragma config BOREN =OFF
#pragma config WDT=OFF
#pragma config LVP=OFF

#define SEC_LED         PORTEbits.RE0

#define _XTAL_FREQ      8000000

#define ACCESS_CFG      0xAC
#define START_CONV      0xEE
#define READ_TEMP       0xAA
#define CONT_CONV       0x02
#define ACK     1
#define NAK     0

#define SCL_PIN PORTDbits.RD3
#define SCL_DIR TRISDbits.RD3
#define SDA_PIN PORTDbits.RD4
#define SDA_DIR TRISDbits.RD4

#include "softi2c.c"

char DS1621_Read_Temp();
void DS1621_Init();
void DS3231_Read_Time();
void DS3231_Write_Time();

void Wait_Half_Second();
void Wait_One_Second();

inline void Part1_Read_Print_Temp();
inline void Part2_Read_Print_Time_Temp();

char temp = 0;
char second = 0;
char minute = 0;
char hour = 0;
char dow = 0;
char day = 0;
char month = 0;
char year = 0;
char old_second = 0;

char INT0_flag = 0;

char preset_second = 0x00;
char preset_minute = 0x25;
char preset_hour   = 0x04;
char preset_dow    = 0x05;
char preset_day    = 0x06;
char preset_month  = 0x11;
char preset_year   = 0x20;

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

void interrupt high_priority ext_int0()                                                             // High priority interrupt
{
    INTCONbits.INT0IF=0;                                                                            // Clear the interrupt flag
    INT0_flag = 1;
}

void init_INT()
{   
    INTCONbits.INT0IF   = 0;                                                                        // clear INT0 status flag
    INTCON2bits.INTEDG0 = 0;                                                                        // config INT0 interrupt at falling edge
    INTCONbits.INT0IE   = 1;                                                                        // Enable INT0
    INTCONbits.GIE      = 1;                                                                        // Enable interrupt globally
}                      

void Do_Init()                                                                                      // Initialize the ports 
{                              
    TRISA = 0xFF;                                                                                   // PORTA all input
    TRISB = 0x01;                                                                                   // PORTB all input
    TRISC = 0x00;                                                                                   // PORTC all input
    TRISD = 0x02;                                                                                   // PORTD all input
    TRISE = 0x0E;                                                                                   // PORTE all input except RE0
    init_INT();                                                                                     // initialize INT0
    init_UART();                                                                                    // Initialize the uart
    OSCCON = 0x70;                                                                                  // Set oscillator to 8 MHz 
    ADCON1 = 0x0F;                                                                                  // All digital I/O
    I2C_Init(10000);                                                                                // Initialize I2C
    DS1621_Init();
}

void main() 
{ 
    Do_Init();                                                                                      // Initialization    
    while (1)
    {
        if (INT0_flag)
        {
            INT0_flag = 0;                                                                          // clear flag
            DS3231_Write_Time();
        }
        //Part1_Read_Print_Temp();
        Part2_Read_Print_Time_Temp();
    }
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

void Wait_One_Second()
{
    Wait_Half_Second();
    Wait_Half_Second();
}

inline void Part1_Read_Print_Temp()
{
    temp = DS1621_Read_Temp();                                                                      // Read temperature from DS1621
    printf("%3dC %3dF\r\n",temp,temp*9/5+32);                                                       // print it in celsius and fahrenheit
    Wait_One_Second(); 
}

inline void Part2_Read_Print_Time_Temp()
{
    DS3231_Read_Time();                                                                             // Read time from DS3231
    if (old_second != second)
    {
        old_second = second;
        printf("%02x:%02x:%02x %02x/%02x/%02x", hour,minute,second,month,day,year);                 // Print time
        temp = DS1621_Read_Temp();                                                                  // Read temperature from DS1621
        printf("%3dC %3dF\r\n",temp,temp*9/5+32);                                                   // print it in celsius and fahrenheit
    }
}

