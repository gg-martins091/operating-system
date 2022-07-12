
void main() {
	// 0xb800 is the video memory, simples write to.
	*(char*)0xb800 = 'Q';

	return;
}
