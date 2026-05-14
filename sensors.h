#ifndef SENSORS_H
#define SENSORS_H

#include <stdint.h>

extern volatile unsigned long g_time_ticks;
extern volatile unsigned char lane_event_pending[8];
extern volatile unsigned long lane_event_time[8];
extern volatile unsigned char lane_release_pending[8];
extern volatile unsigned long lane_release_time[8];
extern volatile unsigned char g_sensor_trigger_level;
void sensors_set_trigger_level(unsigned char level);
unsigned char sensors_get_trigger_level(void);
void uart_init(unsigned long baud );
#endif
