void printChar(char c) {
	*(char*)0xb8000 = c;
}

void main() {
	// 0xb800 is the video memory, simples write to.
	printChar('J');

	return;
}
