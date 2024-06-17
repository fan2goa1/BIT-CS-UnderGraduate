/*
 * gpio_initial.c
 *
 *  Created on: 2017��9��10��
 *      Author: admin
 */
#include "xgpio.h"
#include"xparameters.h"
#include "gpio_initial.h"
int gpio_initial(XGpio *InstancePtr)
{
	/*
	 * Initialization functions in xgpio_sinit.c
	 */
	XGpio_Initialize(InstancePtr, XPAR_GPIO_0_DEVICE_ID);

	/*����LCD��ʾ�����ź��ߵķ�����ʵĬ�Ͼ����������������Ҳ����һ�£�һ��
	 * 5���ź��ߣ���bit4~bit0�� 0��ʶ�����1��ʶ���롣
	 * bit4 lcd_cs      0
	 * bit3 lcd_rstn    0
	 * bit2 lcd_rs      0
	 * bit1 lcd_sck     0
	 * bit0 lcd_mosi    0
	 */
	XGpio_SetDataDirection(InstancePtr, 1,0x00000000);//ͨ��1�ķ���Ϊ���

	/*�����ֿ���ź��ߵķ���һ��
	 * 4���ź��ߣ���bit3~bit0�� 0��ʶ�����1��ʶ���롣miso�����룬����������źš�
	 * bit3 rom_cs     0
	 * bit2 rom_sck    0
	 * bit1 rom_miso   1
	 * bit0 rom_mosi   0
	 */
	XGpio_SetDataDirection(InstancePtr, 2,0x00000002);//����ͨ��2�ķ���Ϊ����

	return 0;
}
