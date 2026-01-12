#ifndef PROTOCOL_H
#define PROTOCOL_H
 

#include <stdint.h>

typedef void (*protocol_handler_fn)(char cmd, const char* args);

void protocol_init(protocol_handler_fn handler);

void protocol_poll(void);
// Feed raw received bytes (call from main loop)
void protocol_feed(uint8_t b);


#endif
