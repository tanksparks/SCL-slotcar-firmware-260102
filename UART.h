// UART.h
// 260110
#ifndef UART_H
#define UART_H

char getchar(void);
void putchar(char c);
void uart_init(unsigned long baud);
char uart_try_getchar(char* out);
#endif