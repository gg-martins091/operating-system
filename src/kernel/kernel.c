#include "kernel.h"
#include "terminal.h"
#include <stddef.h>

void kernel_start()
{
	terminal_init();

	print("Hello ");
	print("World im\n trying a long message lets see if \nthis is big enough idk if it will break a line or not lets see");
}
