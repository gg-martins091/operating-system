void memcpy (unsigned char *dest, const unsigned char *src, int n);
void print_c(char c);
void print_s(const char *c, int len);

void memcpy (unsigned char *dest, const unsigned char *src, int n) {
	while (n--) {
		/* print_c(*src); */
		*(dest++) = *(src++);
	}
}

void print_c(char c) {
	//*(char*)0xb8000 = c;
	memcpy((unsigned char*)0xb8000, (unsigned char*) &c, 1);
}

void print_s(const char *c, int len) {
	print_c(*(&c));
	/* while (len--) print_c(c++); */
	/* memcpy((char*)0xb8000, c, len); */
}

void main() {
	// 0xb800 is the video memory, simples write to.
	char c = 'H';
	print_c(c); 

	char s[8] = "Gabriel\0";

	print_s(s, 8);
	/* printc(*(++s)); */

	return;
}
