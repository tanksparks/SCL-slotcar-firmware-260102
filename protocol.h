// protocol.h
#pragma once
#include <stdint.h>

typedef void (*protocol_handler_fn)(char cmd, const char* args);

void protocol_init(protocol_handler_fn handler);

// Feed raw received bytes (call from main loop)
void protocol_feed(uint8_t b);
