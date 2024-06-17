/*
 * gpio_initial.c
 *
 *  Created on: 2017年9月10日
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

	/*设置LCD显示屏的信号线的方向，其实默认就是输出，但是这里也设置一下，一共
	 * 5根信号线，从bit4~bit0， 0标识输出，1标识输入。
	 * bit4 lcd_cs      0
	 * bit3 lcd_rstn    0
	 * bit2 lcd_rs      0
	 * bit1 lcd_sck     0
	 * bit0 lcd_mosi    0
	 */
	XGpio_SetDataDirection(InstancePtr, 1,0x00000000);//通道1的方向为输出

	/*设置字库的信号线的方向，一共
	 * 4根信号线，从bit3~bit0， 0标识输出，1标识输入。miso是输入，其他是输出信号。
	 * bit3 rom_cs     0
	 * bit2 rom_sck    0
	 * bit1 rom_miso   1
	 * bit0 rom_mosi   0
	 */
	XGpio_SetDataDirection(InstancePtr, 2,0x00000002);//输入通道2的方向为输入

	return 0;
}
