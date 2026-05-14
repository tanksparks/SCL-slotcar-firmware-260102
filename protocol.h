#ifndef PROTOCOL_H
#define PROTOCOL_H
 

#include <stdint.h>


typedef enum { PROTO_OLD, PROTO_NEW } proto_mode_t;

extern unsigned char g_proto_mode;
void protocol_mode_load(void);
void protocol_mode_save(void);
void protocol_mode_led_update(void);

typedef void (*protocol_handler_fn)(char cmd, const char* args);

void protocol_init(protocol_handler_fn handler);

void protocol_poll(void);
void protocol_reset(void);
// Feed raw received bytes (call from main loop)
void protocol_feed(uint8_t b);


#endif
