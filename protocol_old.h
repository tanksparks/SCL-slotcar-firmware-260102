// proto.h
#ifndef PROTOCOL_OLD_H
#define PROTOCOL_OLD_H

void oldproto_init(unsigned long);
void oldproto_start(unsigned long);
void oldproto_stop(void);
unsigned char oldproto_is_running(void);
void oldproto_send_lane(unsigned char, unsigned long);
void oldproto_poll(unsigned long);

#endif

