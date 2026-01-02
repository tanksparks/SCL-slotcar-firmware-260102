#include <mega328.h>
#include "sensors.h"
#include "utils.h"
#include <stdio.h>

// Optional: bit masks you can use elsewhere in the project
#define SENSOR1_MASK  (1<<0)   // PB0
#define SENSOR2_MASK  (1<<1)   // PB1
#define SENSOR3_MASK  (1<<2)   // PB2
#define SENSOR4_MASK  (1<<3)   // PB3
#define SENSOR5_MASK  (1<<4)   // PB4
#define SENSOR6_MASK  (1<<5)   // PB5
#define SENSOR7_MASK  (1<<6)   // PD6
#define SENSOR8_MASK  (1<<7)   // PD7
#define SWITCH1_MASK  (1<<5)   // PD5

// Timebase: 10 kHz (0.1 ms resolution) - informational for now
#define TICK_HZ          10000UL        // 10,000 per second
#define MIN_GAP_TICKS    50UL           // 5 ms between valid hits (50 * 0.1ms)

// Global time in "ticks" (0.1 ms units at 10 kHz)
volatile unsigned long g_time_ticks = 0;

// Per-lane timing + event flags
volatile unsigned long lane_last_time[8]      = {0};
volatile unsigned long lane_event_time[8]     = {0};
volatile unsigned char lane_event_pending[8]  = {0};

// Debounce / glitch filter: how many *consecutive* low samples seen
static unsigned char low_count[8] = {0};

// Which port each sensor is on: 0 = PINB, 1 = PIND
static const unsigned char sensor_port_index[8] = {
    0,0,0,0,0,0,  // lanes 0..5 on PINB (PB0..PB5)
    1,1           // lanes 6..7 on PIND (PD6..PD7)
};

// Bit mask for each sensor (bit position 0..7)
static const unsigned char sensor_bit_mask[8] = {
    (1<<0), // SENSOR1 = PB0
    (1<<1), // SENSOR2 = PB1
    (1<<2), // SENSOR3 = PB2
    (1<<3), // SENSOR4 = PB3
    (1<<4), // SENSOR5 = PB4
    (1<<5), // SENSOR6 = PB5
    (1<<6), // SENSOR7 = PD6
    (1<<7)  // SENSOR8 = PD7
};


// Timer1 overflow interrupt service routine
interrupt [TIM1_OVF] void timer1_ovf_isr(void)
{
    unsigned long now;
    unsigned char i;
    unsigned char pinb;
    unsigned char pind;
    unsigned char is_low;

    // Reinitialize Timer1 value (adjust 0xF9C0 if you change tick rate)
    TCNT1H = 0xF9C0 >> 8;
    TCNT1L = 0xF9C0 & 0xFF;

    // Global time tick (overflow rate defines resolution)
    g_time_ticks++;
    now = g_time_ticks;

    // Read ports once per ISR
    pinb = PINB;
    pind = PIND;

    // Process all 8 lanes
    for (i = 0; i < 8; i++)
    {
        unsigned char raw;

        // Select raw port value for this lane
        if (sensor_port_index[i] == 0)
        {
            // lane on PINB
            raw = pinb;
        }
        else
        {
            // lane on PIND
            raw = pind;
        }

        // Active-low: sensor "on" when pin reads 0
        is_low = ((raw & sensor_bit_mask[i]) == 0);

        // Debounce / glitch filter: consecutive low samples
        if (is_low)
        {
            if (low_count[i] < 255)
                low_count[i]++;
        }
        else
        {
            low_count[i] = 0;
        }

        // Enough consecutive lows? (3 samples in a row)
        if (low_count[i] == 3)
        {
            // Min time gap filter (ignore double triggers/glitches)
            if (now - lane_last_time[i] >= MIN_GAP_TICKS)
            {
                lane_last_time[i]      = now;
                lane_event_time[i]     = now;
                lane_event_pending[i]  = 1;
            }
        }
    }
}
