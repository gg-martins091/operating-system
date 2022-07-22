#include "terminal.h"

uint16_t *video_mem = 0;
int vmem_cur_x = 0;
int vmem_cur_y = 0;

static uint16_t terminal_make_char(char c, char color)
{
	return (color << 8) | c;
}

static void terminal_put_char(int x, int y, char c, char color)
{
	video_mem[(y * VGA_WIDTH) + x] = terminal_make_char(c, color);
}

static void terminal_write_char(char c, char color)
{
	if (c == '\n') {
		vmem_cur_y++;
		vmem_cur_x = 0;
		return;
	}
	
	terminal_put_char(vmem_cur_x, vmem_cur_y, c, color);

	vmem_cur_x++;
	if (vmem_cur_x >= VGA_WIDTH) {
		vmem_cur_y++;
		vmem_cur_x = 0;
	}
}

void print(const char *str)
{
	const char* c = str;

	while(c) {
		terminal_write_char(*c++, 0x2);
	}
}

void terminal_init()
{
	video_mem = (uint16_t*)(0xb8000);
	vmem_cur_x = 0;
	vmem_cur_y = 0;

	for (int y = 0; y < VGA_HEIGHT; y++) {
		for (int x = 0; x < VGA_WIDTH; x++) {
			terminal_put_char(x, y, ' ', 0);
		}
	}
}
