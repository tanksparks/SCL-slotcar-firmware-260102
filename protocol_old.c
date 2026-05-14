// protocol_old.c
// 260116 
#include <stdio.h>
#include "protocol_old.h"

#define OLD_200MS_TICKS 2000UL   // 200ms / 0.1ms = 2000 ticks

static unsigned long last200_tick;   // last 200ms boundary tick
static unsigned char oldproto_running = 0;

void oldproto_init(unsigned long now_tick)
{
    last200_tick = now_tick;
}

void oldproto_start(unsigned long now_tick)
{
    oldproto_running = 1;
    oldproto_init(now_tick);
}

void oldproto_stop(void)
{
    oldproto_running = 0;
}

unsigned char oldproto_is_running(void)
{
    return oldproto_running;
}

void oldproto_poll(unsigned long now_tick)
{
    if (!oldproto_running)
        return;

    // emit "200\r" for each elapsed 200ms block
    while ((unsigned long)(now_tick - last200_tick) >= OLD_200MS_TICKS)
    {
        last200_tick += OLD_200MS_TICKS;
        printf("200\r");  // CR only (matches your description)
    }
}

void oldproto_send_lane(unsigned char lane, unsigned long event_tick)
{
    unsigned long rem_ticks;      
    unsigned int rem_ms;      
    char lane_char; 

    if (!oldproto_running)
        return;

    // First catch up the 200ms stream up to this moment
    oldproto_poll(event_tick);

    // remainder ticks since last 200ms boundary
    rem_ticks = (unsigned long)(event_tick - last200_tick);

    // convert to milliseconds remainder (0..199)
    rem_ms = (unsigned int)(rem_ticks / 10UL);   // divide by 10  to get 1ms

    lane_char = 'A' + lane;

    // OLD event format: "<ms>\r<letter>"
    printf("%u\r%c", rem_ms, lane_char);

    // Old firmware behavior often “resets” the sub-200ms accumulator on event:
    // If your old protocol did that, do this:
    last200_tick = event_tick;
}
