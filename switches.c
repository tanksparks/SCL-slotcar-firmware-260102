#include <mega328.h>
#include <stdio.h>
#include "switches.h"
#include "sensors.h"   // for g_time_ticks
#include "utils.h"

#define SWITCH1_MASK   (1<<5)   // PD5

#define SWITCH_SAMPLE_TICKS   10     // 1 ms
#define SWITCH_STABLE_COUNT   3      // ~3 ms debounce
#define LONG_PRESS_TICKS     5000    // 500 ms @ 0.1 ms/tick

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
        }
        // RELEASE
        else
        {
            unsigned long duration_ticks = now - press_start_tick;
            unsigned long duration_ms = duration_ticks / 10;

            // @T,<start>,<duration>,
            printf("@T,%lu,%lu,\r\n", press_start_tick, duration_ms);

            // optional classification
            if (duration_ticks >= LONG_PRESS_TICKS)
            {
                // printf("@T,LONG,%lu,\r\n", duration_ms);
            }
        }
    }
}
