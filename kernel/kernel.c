#include "../driver/screen.h"
void main(){
	unsigned char* video_memory = (unsigned char*) VIDEO_MEM_ADDRESS;
	// *video_memory = 'B';
	unsigned short cursor_offset = get_cursor_offset();
	video_memory[cursor_offset] = 'X';
	video_memory[cursor_offset+1] = WHITE_ON_BLACK;
	int i = 0;
	set_cursor_offset(0x0001);
	print_char('A', -1, -1, 0);	
}
