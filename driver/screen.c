#include "screen.h"
#include "port.h"

void print_char (unsigned char output_char, int col, int row, unsigned char attr){
	
	unsigned short vga_offset;
	if (! attr) attr = WHITE_ON_BLACK;
	if (col >= 0 && row >= 0){
		// TODO: print to the col and row
		// int i;
	}else{
		vga_offset = get_cursor_offset();
	}
	
	unsigned char* video_memory = (unsigned char*) VIDEO_MEM_ADDRESS;
	video_memory[vga_offset] = output_char;
	video_memory[vga_offset + 1] = attr;
	
	set_cursor_offset(vga_offset + 2);
}

unsigned short get_cursor_offset(){
	unsigned short offset;
	port_byte_out(REG_SCREEN_CTRL, 14);	/* Tell the control to get high byte of current cursor */
	offset = port_byte_in(REG_SCREEN_DATA) << 8; /* shift 8 bits left as it is the high byte */
	port_byte_out(REG_SCREEN_CTRL, 15); /* low byte */
	offset += port_byte_in(REG_SCREEN_DATA);
	
	return offset * 2;
}

void set_cursor_offset(unsigned short offset){

	offset /= 2;
	/* Set high byte and low byte of the cursor offset to the cursor port */
	port_byte_out(REG_SCREEN_CTRL, 14);
	port_byte_out(REG_SCREEN_DATA, (unsigned char) (offset >> 8));
	port_byte_out(REG_SCREEN_CTRL, 15);
	port_byte_out(REG_SCREEN_DATA, (unsigned char) (offset & 0x00ff));
}


