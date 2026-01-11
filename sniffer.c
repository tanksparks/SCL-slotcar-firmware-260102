//Sniffer
// sniffer.c
#include "sniffer.h"
#include "uart.h"
#include <string.h>
#include <stdio.h>

#ifndef SNIFFER_ENABLE
#define SNIFFER_ENABLE 1
#endif

#if SNIFFER_ENABLE

// Holds the current line being assembled
#define SNIFF_LINE_MAX 80
static char line[SNIFF_LINE_MAX];
static uint8_t idx = 0;

// A tiny queue of completed lines to print later (so we never print while assembling)
#define SNIFF_Q_LINES 4
static char q[SNIFF_Q_LINES][SNIFF_LINE_MAX];
static volatile uint8_t q_wr = 0, q_rd = 0, q_count = 0;

static void q_push_line(const char* s)
{
    if (q_count >= SNIFF_Q_LINES) return; // drop if full (sniffer shouldn't break timing)
    strncpy(q[q_wr], s, SNIFF_LINE_MAX - 1);
    q[q_wr][SNIFF_LINE_MAX - 1] = 0;
    q_wr = (uint8_t)((q_wr + 1) % SNIFF_Q_LINES);
    q_count++;
}

static uint8_t q_pop_line(char* out)
{
    if (q_count == 0) return 0;
    strcpy(out, q[q_rd]);
    q_rd = (uint8_t)((q_rd + 1) % SNIFF_Q_LINES);
    #asm("cli")
    q_count--;
    #asm("sei")
    return 1;
}

void sniffer_init(void)
{
    idx = 0;
    q_wr = q_rd = q_count = 0;
}

// Feed bytes; when we see '\n' we queue the line
void sniffer_feed(uint8_t b)
{
    if (b == '\r') return; // ignore CR

    if (b == '\n')
    {
        line[idx] = 0;
        if (idx > 0) q_push_line(line);
        idx = 0;
        return;
    }

    if (idx < (SNIFF_LINE_MAX - 1))
        line[idx++] = (char)b;
    else
        idx = 0; // overflow: reset
}

// Flush queued lines out UART (call from main loop)
void sniffer_poll(void)
{
    char tmp[SNIFF_LINE_MAX];
    if (q_pop_line(tmp))
    {
        // Prefix so you can distinguish sniffer output from normal messages
        printf("@D,%s\r\n", tmp);
    }
}

#else

void sniffer_init(void) {}
void sniffer_feed(uint8_t b) {}
void sniffer_poll(void) {}

#endif
