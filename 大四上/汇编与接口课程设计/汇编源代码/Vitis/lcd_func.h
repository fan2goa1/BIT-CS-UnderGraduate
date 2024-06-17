/*
 * lcd_func.h
 *
 *  Created on: 2017年9月10日
 *      Author: admin
 */

#ifndef SRC_LCD_FUNC_H_
#define SRC_LCD_FUNC_H_

#include "xgpio.h"
#include "gpio_initial.h"
#include"sleep.h"

/*
 * 送指令到字库 IC
 */
void send_command_to_ROM( uchar cmd );

/*
 * 从晶联讯字库 IC 中取汉字或字符数据（1 个字节）
*/
uchar get_data_from_ROM( );

/*
 *  sent command to lcd
 */
void transfer_command(unsigned char cmd);

/*
 *  sent data to lcd
 */
void transfer_data(unsigned char data);

/*
 * 初始化LCD屏幕
 */
void initial_lcd();

/*
 * 定位到LCD要显示的起始坐标
 */
void lcd_address(uchar page,uchar column);

/*
 * 清屏操作
 */
void clear_screen();

/*
 * 测试屏幕显示
 */
void test_screen();

/*
 * 显示 8x16 的点阵的字符串，括号里的参数分别为（页,列，字符串指针）
 */
//void display_string_8x16(uchar page,uchar column,uchar *text);

/*
 * 写入一组 16x16 点阵的汉字字符串（字符串表格中需含有此字）
 * 括号里的参数：(页，列，汉字字符串）
 */
//void display_string_16x16(uchar page,uchar column,uchar *text);

/*
*显示 16x16 点阵的汉字或者 ASCII 码 8x16 点阵的字符混合字符串
*括号里的参数：(页，列，字符串）
*/
//void display_string_8x16_16x16(uchar page,uchar column,uchar *text);

/*
 * 从字库读取32*32的字
 */
void display_32x32(uchar page,uchar column,uchar *dp);

/*
 * 显示图形
 */
void display_graphic(uchar *dp);

//从指定地址读出数据写到液晶屏指定（page,column)座标中
void get_and_write_16x16(ulong fontaddr,uchar page,uchar column);
//从指定地址读出数据写到液晶屏指定（page,column)座标中
void get_and_write_8x16(ulong fontaddr,uchar page,uchar column);
void display_GB2312_string(uchar page,uchar column,uchar *text);

#endif /* SRC_LCD_FUNC_H_ */
