/*
 * gpio_initial.h
 *
 *  Created on: 2017年9月10日
 *      Author: admin
 */

#ifndef SRC_GPIO_INITIAL_H_
#define SRC_GPIO_INITIAL_H_
#include "xgpio.h"
extern XGpio Gpio;//申明外部变量

#define uchar unsigned char
#define uint unsigned int
#define ulong unsigned long

int gpio_initial(XGpio *InstancePtr);
/*宏定义每个具体信号的读写值操作
* bit4 lcd_cs
* bit3 lcd_rstn
* bit2 lcd_rs
* bit1 lcd_sck
* bit0 lcd_mosi
*/
#define lcd_cs_L    XGpio_DiscreteWrite(&Gpio,1, 0xffffffef & (XGpio_DiscreteRead(&Gpio, 1)))//保持其他bit位上的数据不被改动
#define lcd_cs_H    XGpio_DiscreteWrite(&Gpio,1, 0x00000010 | (XGpio_DiscreteRead(&Gpio, 1)))//保持其他bit位上的数据不被改动

#define lcd_rstn_L  XGpio_DiscreteWrite(&Gpio,1, 0xfffffff7 & (XGpio_DiscreteRead(&Gpio, 1)))//保持其他bit位上的数据不被改动
#define lcd_rstn_H  XGpio_DiscreteWrite(&Gpio,1, 0x00000008 | (XGpio_DiscreteRead(&Gpio, 1)))//保持其他bit位上的数据不被改动

#define lcd_rs_L    XGpio_DiscreteWrite(&Gpio,1, 0xfffffffb & (XGpio_DiscreteRead(&Gpio, 1)))//保持其他bit位上的数据不被改动
#define lcd_rs_H    XGpio_DiscreteWrite(&Gpio,1, 0x00000004 | (XGpio_DiscreteRead(&Gpio, 1)))//保持其他bit位上的数据不被改动

#define lcd_sck_L   XGpio_DiscreteWrite(&Gpio,1, 0xfffffffd & (XGpio_DiscreteRead(&Gpio, 1)))//保持其他bit位上的数据不被改动
#define lcd_sck_H   XGpio_DiscreteWrite(&Gpio,1, 0x00000002 | (XGpio_DiscreteRead(&Gpio, 1)))//保持其他bit位上的数据不被改动

#define lcd_mosi_L  XGpio_DiscreteWrite(&Gpio,1, 0xfffffffe & (XGpio_DiscreteRead(&Gpio, 1)))//保持其他bit位上的数据不被改动
#define lcd_mosi_H  XGpio_DiscreteWrite(&Gpio,1, 0x00000001 | (XGpio_DiscreteRead(&Gpio, 1)))//保持其他bit位上的数据不被改动

/*设置字库的信号线
* bit3 rom_cs
* bit2 rom_sck
* bit1 rom_miso
* bit0 rom_mosi
*/
#define rom_cs_L    XGpio_DiscreteWrite(&Gpio,2, 0xfffffff7 & (XGpio_DiscreteRead(&Gpio, 2)))//保持其他bit位上的数据不被改动
#define rom_cs_H    XGpio_DiscreteWrite(&Gpio,2, 0x00000008 | (XGpio_DiscreteRead(&Gpio, 2)))//保持其他bit位上的数据不被改动

#define rom_sck_L   XGpio_DiscreteWrite(&Gpio,2, 0xfffffffb & (XGpio_DiscreteRead(&Gpio, 2)))//保持其他bit位上的数据不被改动
#define rom_sck_H   XGpio_DiscreteWrite(&Gpio,2, 0x00000004 | (XGpio_DiscreteRead(&Gpio, 2)))//保持其他bit位上的数据不被改动

#define rom_mosi_L  XGpio_DiscreteWrite(&Gpio,2, 0xfffffffe & (XGpio_DiscreteRead(&Gpio, 2)))//保持其他bit位上的数据不被改动
#define rom_mosi_H  XGpio_DiscreteWrite(&Gpio,2, 0x00000001 | (XGpio_DiscreteRead(&Gpio, 2)))//保持其他bit位上的数据不被改动

#define rom_miso_Val ((0x00000002 & (XGpio_DiscreteRead(&Gpio, 2)))>>1) //读取rom字库传过来的数值

#endif /* SRC_GPIO_INITIAL_H_ */
