/*******************************************************
This program was created by the CodeWizardAVR V3.51 
Automatic Program Generator
© Copyright 1998-2023 Pavel Haiduc, HP InfoTech S.R.L.
http://www.hpinfotech.ro

Project : SCL firmware, slot car timing firmware
Version : 260101
Date    : 12/31/2025
Author  : Daniel Groulx
Company : Trackmate Racing
Comments: 
Program size: 10%
 
Chip type               : ATmega328
Program type            : Application
AVR Core Clock frequency: 16.000000 MHz
Memory model            : Small
External RAM size       : 0
Data Stack size         : 512
Slot car firmware 2026 version
using utils.h  #define BIT(x) (1U << (x))
Will have time stamp. main tick will continue to tick, no reset will last 5 days
overflow will not cause a problem.
Protocol
@A,timeinticks,crlf
All seems to work
but reset seems to kill com port  260101
260109
260120  
check how to power on and off in hardware.c
using GitHub trakmate/SCL-slotcar-firmware-260102 
you can use my .gitignore file in other projects

*******************************************************/

// 260111   Flash = 11.3% used

// I/O Registers definitions
#include <mega328.h>
#include <stdio.h>
#include <delay.h>
#include "UART.h"
#include "sensors.h"
#include "setup.h"
#include "switches.h"
#include "version.h"
#include "protocol.h"
#include "sniffer.h"
#include "hardware.h"

#pragma used-

#define LED1_MASK  (1 << 2)   // PD2

#define LED1_ON()   (PORTD |=  LED1_MASK)
#define LED1_OFF()  (PORTD &= ~LED1_MASK)

#define LEDB1 PORTC.0 
#define LEDB2 PORTC.1 
#define LEDB3 PORTC.2 
#define LEDB4 PORTC.3 
#define LEDB5 PORTC.4 

#define RELAY1 PORTC.0
#define RELAY2 PORTC.1
#define RELAY3 PORTC.2
#define RELAY4 PORTC.3
#define RELAY5 PORTC.4
#define RELAYS_PORTC_BITS 0x1f   //1F = BIT 0 TO 4 
#define SWITCH1 PIND.5	 

// Declare your global variables here

// Private functions
void led_poweron_blink(void);
static void print_startup_banner(void);
static void print_startup_banner(void);
static void protocol_on_cmd(char cmd, const char* args);


void main(void)
{
  unsigned char lane;
  char lane_char; 
  setup(); 
  uart_init(9600);       
  switches_init();
  led_poweron_blink();
  print_startup_banner();      
     
  protocol_init(protocol_on_cmd); // pass function 
   while (1)
    {              
      // no delays allowed in while loop 
      // We need to send data to PC as soon as possible
        for (lane = 0; lane < 8; lane++)
        {
            if (lane_event_pending[lane])
            {
                unsigned long t = lane_event_time[lane];
                lane_event_pending[lane] = 0;

                lane_char = 'A' + lane;

                // NOW with trailing comma after timestamp
                // Format: @A,<timestamp>,\r\n 
                // Lane 1 to 8 is A to H
                printf("@%c,%lu,\r\n", lane_char, t);   
            }
        }         
        protocol_poll();   // <-- reads PC commands like @P,1\r\n and calls protocol_on_cmd()
        switch1_poll(); // it will send data to PC
    }
}

// --------------------------------------------

void led_poweron_blink(void)
{
    unsigned char i;
    for (i = 0; i < 4; i++)
    {
        LED1_ON();   delay_ms(150);    LED1_OFF();   delay_ms(150);
    }
}

static void print_startup_banner(void)
{
    // %p = FLASH string in CodeVision
    printf("\r\n%p v%p (build %p) %p %p\r\n",
           FW_NAME, FW_VERSION, FW_BUILD_NUM, FW_BUILD_DATE, FW_BUILD_TIME);
}


static void protocol_on_cmd(char cmd, const char* args)
{
   unsigned long ts;
    switch (cmd)
    {
        case 'P':
            if (args && args[0] == '1')
            {
                track_power_on();    
                 // send timestamped power-on event
                // safe way of reading 32 bit tick value from interrupt     
                #asm("cli")
                ts = g_time_ticks;
                #asm("sei")
                
                printf("@P,1,%lu,\r\n", ts);
            }
            else
             {
                track_power_off();
                 #asm("cli")
                ts = g_time_ticks;
                #asm("sei")
                
                printf("@P,0,%lu,\r\n", ts); 
                  
             }   
            break;

        case 'S':
           // start_lights_sequence();
            break;

        case 'X':
            track_power_off();
         //   lights_off();
            break;      
        case 'V':
              print_startup_banner();
              break;

        break;    
    } 
    
}
