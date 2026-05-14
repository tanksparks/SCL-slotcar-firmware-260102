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
poweron/poweroff tested with x-ctu
*******************************************************/

// 260111   Flash = 11.3% used
//

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
#include "protocol_old.h"  // Old SCL3 v3.2 or older
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
void protocol_mode_load(void);
void protocol_mode_save(void);
static void sensor_trigger_load(void);
static void sensor_trigger_save(unsigned char level);
void protocol_mode_led_update(void);
static void print_startup_banner(void);
static void print_startup_banner(void);
static void protocol_on_cmd(char cmd, const char* args);
unsigned char g_proto_mode = PROTO_NEW;
eeprom unsigned char ee_proto_mode = PROTO_NEW;
eeprom unsigned char ee_sensor_trigger_level = 0;

unsigned long get_time_ticks_01ms(void)
{
    unsigned long t;

    #asm("cli")
    t = g_time_ticks;
    #asm("sei")

    return t;
}

void main(void)
{
    unsigned char lane;

    setup();
    uart_init(9600);
    switches_init();
    protocol_mode_load();
    sensor_trigger_load();
    led_poweron_blink();
    protocol_mode_led_update();
    print_startup_banner();

    protocol_init(protocol_on_cmd); // pass function

    while (1)
    {
        // 1) Handle lane events ASAP
        for (lane = 0; lane < 8; lane++)
        {
            if (lane_event_pending[lane])
            {
                unsigned long t = lane_event_time[lane]; // in 0.1ms ticks
                lane_event_pending[lane] = 0;

                if (g_proto_mode == PROTO_NEW)
                {
                    char lane_char = 'A' + lane;
                    printf("@%c,%lu,\r\n", lane_char, t);
                }
                else
                {
                    oldproto_send_lane(lane, t);
                }
            }

            if (lane_release_pending[lane])
            {
                unsigned long t = lane_release_time[lane]; // in 0.1ms ticks
                lane_release_pending[lane] = 0;

                if (g_proto_mode == PROTO_NEW)
                {
                    char lane_char = 'a' + lane;
                    printf("@%c,%lu,\r\n", lane_char, t);
                }
            }
        }

        // 2) Always run protocol RX (PC->firmware commands)
        protocol_poll();

        // 3) OLD protocol needs periodic "200" output even with no lane events
        // Keep LED1 tied directly to the active protocol branch.
        if (g_proto_mode == PROTO_OLD)
        {
            LED1_ON();
            oldproto_poll(get_time_ticks_01ms());
        }
        else
        {
            LED1_OFF();
        }

        // 4) Existing switch / track-call logic
        switch1_poll();
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

void protocol_mode_load(void)
{
    unsigned char saved;

    saved = ee_proto_mode;
    if (saved == PROTO_OLD || saved == PROTO_NEW)
        g_proto_mode = saved;
    else
    {
        g_proto_mode = PROTO_NEW;
        ee_proto_mode = PROTO_NEW;
    }
}

void protocol_mode_save(void)
{
    if (ee_proto_mode != g_proto_mode)
        ee_proto_mode = g_proto_mode;
}
static void sensor_trigger_load(void)
{
    unsigned char saved;

    saved = ee_sensor_trigger_level;
    if (saved > 1)
    {
        saved = 0;
        ee_sensor_trigger_level = saved;
    }
    sensors_set_trigger_level(saved);
}

static void sensor_trigger_save(unsigned char level)
{
    level = level ? 1 : 0;
    sensors_set_trigger_level(level);
    if (ee_sensor_trigger_level != level)
        ee_sensor_trigger_level = level;
}

void protocol_mode_led_update(void)
{
    DDRD |= LED1_MASK;

    if (g_proto_mode == PROTO_OLD)
        LED1_ON();
    else
        LED1_OFF();
}

static void print_startup_banner(void)
{
    // %p = FLASH string in CodeVision
    printf("\r\n%p v%p %p %p\r\n",
           FW_NAME, FW_VERSION, FW_BUILD_DATE, FW_BUILD_TIME);
}

static void protocol_on_cmd(char cmd, const char* args)
{
    static unsigned char pending_old_config_cmd = 0;
    unsigned long ts;
    unsigned char raw_cmd;

    raw_cmd = (args && args[0] == 1 && args[1] == 0);

    // Manual mode only: serial traffic never changes g_proto_mode.
    if (g_proto_mode == PROTO_NEW)
    {
        if (raw_cmd)
            return;
    }
    else
    {
        if (!raw_cmd)
            return;
    }

    if (raw_cmd && pending_old_config_cmd)
    {
        if (cmd == ',')
            return;

        if (cmd == '0' || cmd == '1')
        {
            if (pending_old_config_cmd == 'C')
                sensor_trigger_save((unsigned char)(cmd - '0'));
            pending_old_config_cmd = 0;
            return;
        }

        pending_old_config_cmd = 0;
    }

    #asm("cli")
    ts = g_time_ticks;
    #asm("sei")

    switch (cmd)
    {
        case 'S':
            if (raw_cmd)
                oldproto_start(ts);
            // else start_lights_sequence();
            break;

        case 'P':
            if (raw_cmd)
            {
                oldproto_stop();
            }
            else if (args && args[0] == '1')
            {   // NEW: POWER ON
                track_power_on();
                printf("@P,1,%lu,\r\n", ts);
            }
            else
            {   // NEW: POWER OFF
                track_power_off();
                printf("@P,0,%lu,\r\n", ts);
            }
            break;

        case 'R':
        case 'n':
            if (raw_cmd)
                track_power_on();
            break;

        case 'E':
        case 'f':
            if (raw_cmd)
                track_power_off();
            break;

        case 'H':
            if (raw_cmd)
                printf("1000\r\n");
            break;

        case 'N':
            if (raw_cmd)
                printf("8\r\n");
            break;

        case 'C':
            if (raw_cmd)
                pending_old_config_cmd = 'C';
            break;

        case 'L':
        case 'O':
            // LED1 is reserved as protocol-mode indicator.
            break;

        case 'V':
            if (raw_cmd)
                printf("V3.2c\r\n");
            else
                print_startup_banner();
            break;

        case 'X':
            if (!raw_cmd)
                track_power_off();
            break;
    }
}
