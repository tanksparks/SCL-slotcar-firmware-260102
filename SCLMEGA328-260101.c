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
@Atimeinticks
All seems to work
but reset seems to kill com port  260101
260109
260120  
check how to power on and off in hardware.c
*******************************************************/

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
    switch (cmd)
    {
        case 'P':
            if (args && args[0] == '1')
                track_power_on();
            else
                track_power_off();
            break;

        case 'S':
           // start_lights_sequence();
            break;

        case 'X':
            track_power_off();
         //   lights_off();
            break;
    } 
    
}



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
        
        switch1_poll(); // it will send data to PC
    }
}
