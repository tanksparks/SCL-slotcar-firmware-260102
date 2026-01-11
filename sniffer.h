// sniffer.h
#pragma once
#include <stdint.h>

void sniffer_init(void);

// feed one received byte at a time (call from main loop, not ISR)
void sniffer_feed(uint8_t b);

// call often from main loop to flush logs out the UART
void sniffer_poll(void);
