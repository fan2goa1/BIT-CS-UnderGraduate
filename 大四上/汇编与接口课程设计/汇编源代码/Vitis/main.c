#include <stdio.h>
#include "xgpio.h"
#include "gpio_initial.h"
#include "lcd_func.h"
#include "bluetooth_top.h"


uchar text_buf[16 * 128] = {0};
uchar row_buf[20] = {0};
XGpio Gpio;

int main()
{
	u32 rx_data32 = 0, cnt = 0, mode = 0;
	u32 now_row = 1;
	u8 rx_data8 = 0;

	gpio_initial(&Gpio); //��ʼ��GPIO��
	initial_lcd();
	clear_screen();

	while(1) {
		usleep(100);	// 100MHz��ʱ�ӣ�һ�����ڶ�һ��

		rx_data32 = BLUETOOTH_TOP_mReadReg((void *)XPAR_BLUETOOTH_TOP_0_S00_AXI_BASEADDR, 0); // ���Ĵ����е�����
		rx_data8 = (uchar)(rx_data32 & 0xff);		// ȡ����λ
		if(rx_data32 & 0x00000100) {
			if(rx_data8 == '#') {	// mode0��ʼΪ"#"���ţ���ʾ��ӡ�ַ�
				if(cnt == 0) {		// �տ�ʼ����
					mode = 0;
					cnt = 1;
				}
				else {					// �������
					clear_screen();
					now_row = 2;

					for(int i = 0; i < cnt-1; i ++) {
						row_buf[i%14] = text_buf[i];
						if(i % 14 == 13) {
							row_buf[14] = '\0';
							display_GB2312_string(now_row, 0, row_buf);
							now_row += 2;
							if(now_row == 14) now_row = 2;
						}
					}
					row_buf[(cnt-2) % 14 + 1] = '\0';
					display_GB2312_string(now_row, 0, row_buf);
					now_row += 2;
					if(now_row == 13) now_row = 3;
					cnt = 0;
					mode = 10;
				}
			}
			else if(rx_data8 == '*') {	// mode1��ʼΪ"*"���ţ���ʾ��ӡͼƬ
				if(cnt == 0) {			// ��ʼ
					mode = 1;
					cnt = 1;
				}
				else {					// ֹͣ
					clear_screen();
					display_graphic(bmp1);
					cnt = 0;
					mode = 10;
				}
			}
			else {
				text_buf[cnt-1] = rx_data8;
				cnt ++;
			}
		}

//		if(cnt == 32 && mode == 1) {
//			clear_screen();
//			display_graphic(bmp1);
//			cnt = 0;
//			mode = 10;
//		}
	}

	return 0;
}
