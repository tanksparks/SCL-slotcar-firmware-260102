// protocol.c
#include "protocol.h"
#include <string.h>

#define LINE_MAX 80

static protocol_handler_fn g_handler = 0;
static char linebuf[LINE_MAX];
static uint8_t idx = 0;
/*
 * protocol_init()
 *
 * Tells the protocol parser which function to call when a command is received.
 *
 * The parser’s job is only to collect incoming characters and recognize
 * complete "@CMD,..." messages ending with CR/LF. It does not know what the
 * commands mean.
 *
 * The function passed to protocol_init() is saved and called later whenever
 * a valid command is decoded. This lets the same parser work with different
 * protocols or modes (slot racing, drag racing, demo mode, etc.) without
 * changing the parser code.
 */


void protocol_init(protocol_handler_fn handler)
{
    g_handler = handler;
    idx = 0;
}

static void handle_line(char* s)
{
    char cmd;
    const char* args = 0;   // NULL = no args

    if (s[0] != '@' || s[1] == 0)
        return;

    cmd = s[1];

    if (s[2] == ',')
        args = &s[3];       // points into RAM buffer
    else if (s[2] != 0)
        args = &s[2];

    if (g_handler)
        g_handler(cmd, args);
}


void protocol_feed(uint8_t b)
{
    if (b == '\r') return;

    if (b == '\n')
    {
        linebuf[idx] = 0;
        if (idx > 0)
            handle_line(linebuf);
        idx = 0;
        return;
    }

    if (idx < (LINE_MAX - 1))
        linebuf[idx++] = (char)b;
    else
        idx = 0; // overflow -> reset
}
