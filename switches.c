#include <mega328.h>
#include <stdio.h>
#include "switches.h"
#include "sensors.h"   // for g_time_ticks
#include "protocol.h"
#include "protocol_old.h"
#include "UART.h"
#include "utils.h"

#define SWITCH1_MASK   (1<<5)   // PD5

#define SWITCH_SAMPLE_TICKS   10     // 1 ms
#define SWITCH_STABLE_COUNT   3      // ~3 ms debounce
#define MODE_HOLD_TICKS      50000UL // 5 seconds @ 0.1 ms/tick
#define OLD_TRACK_CALL_HOLDOFF_TICKS 22000UL // 2.2 seconds @ 0.1 ms/tick

static void toggle_protocol_mode(void)
{
    if (g_proto_mode == PROTO_NEW)
    {
        g_proto_mode = PROTO_OLD;
        uart_flush_rx();
        protocol_reset();
        oldproto_stop();
        protocol_mode_save();
        protocol_mode_led_update();
    }
    else
    {
        g_proto_mode = PROTO_NEW;
        uart_flush_rx();
        protocol_reset();
        oldproto_stop();
        protocol_mode_save();
        protocol_mode_led_update();
    }
}

void switches_init(void)
{
    // PD5 input + pull-up
    DDRD  &= ~SWITCH1_MASK;
    PORTD |=  SWITCH1_MASK;
}

void switch1_poll(void)
{
    unsigned char raw;
    static unsigned long last_sample_tick = 0;
    static unsigned char last_raw = 1;
    static unsigned char stable_state = 1;
    static unsigned char stable_count = 0;
    static unsigned long press_start_tick = 0;
    static unsigned long last_old_track_call_tick = 0;
    static unsigned char mode_hold_done = 0;

    unsigned long now = g_time_ticks;

    // non-blocking time-based sampling
    if ((unsigned long)(now - last_sample_tick) < SWITCH_SAMPLE_TICKS)
        return;

    last_sample_tick = now;

    raw = (PIND & SWITCH1_MASK) ? 1 : 0;

    if (raw == last_raw)
    {
        if (stable_count < SWITCH_STABLE_COUNT)
            stable_count++;
    }
    else
    {
        stable_count = 0;
        last_raw = raw;
    }

    if (stable_count == SWITCH_STABLE_COUNT && raw != stable_state)
    {
        stable_state = raw;

        // PRESS
        if (stable_state == 0)
        {
            press_start_tick = now;
            mode_hold_done = 0;
        }
        // RELEASE
        else
        {
            unsigned long duration_ticks = now - press_start_tick;
            unsigned long duration_ms = duration_ticks / 10;

            if (!mode_hold_done && g_proto_mode == PROTO_NEW)
            {
                // @T,<start>,<duration>,
                printf("@T,%lu,%lu,\r\n", press_start_tick, duration_ms);
            }
            else if (!mode_hold_done)
            {
                if (last_old_track_call_tick == 0 ||
                    (unsigned long)(now - last_old_track_call_tick) >= OLD_TRACK_CALL_HOLDOFF_TICKS)
                {
                    putchar('W');
                    last_old_track_call_tick = now;
                }
            }
        }
    }

    if (stable_state == 0 && !mode_hold_done &&
        (unsigned long)(now - press_start_tick) >= MODE_HOLD_TICKS)
    {
        toggle_protocol_mode();
        mode_hold_done = 1;
    }
}
