#define VIDEO_MEM_ADDRESS 0xb8000
#define MAX_ROWS 25
#define MAX_COLS 80

#define WHITE_ON_BLACK 0x0f
#define REG_SCREEN_CTRL 0x3d4
#define REG_SCREEN_DATA 0x3d5

unsigned short get_cursor_offset();
void set_cursor_offset(unsigned short offset);
void print_char (unsigned char output_char, int col, int row, unsigned char attr);
