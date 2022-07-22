#ifndef TERMINAL_H
#define TERMINAL_H

#include <stdint.h>

#define VGA_WIDTH 80
#define VGA_HEIGHT 20

void print(const char *str);

void terminal_init();

#endif
