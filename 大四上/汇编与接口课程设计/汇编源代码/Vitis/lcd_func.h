/*
 * lcd_func.h
 *
 *  Created on: 2017��9��10��
 *      Author: admin
 */

#ifndef SRC_LCD_FUNC_H_
#define SRC_LCD_FUNC_H_

#include "xgpio.h"
#include "gpio_initial.h"
#include"sleep.h"

/*
 * ��ָ��ֿ� IC
 */
void send_command_to_ROM( uchar cmd );

/*
 * �Ӿ���Ѷ�ֿ� IC ��ȡ���ֻ��ַ����ݣ�1 ���ֽڣ�
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
 * ��ʼ��LCD��Ļ
 */
void initial_lcd();

/*
 * ��λ��LCDҪ��ʾ����ʼ����
 */
void lcd_address(uchar page,uchar column);

/*
 * ��������
 */
void clear_screen();

/*
 * ������Ļ��ʾ
 */
void test_screen();

/*
 * ��ʾ 8x16 �ĵ�����ַ�����������Ĳ����ֱ�Ϊ��ҳ,�У��ַ���ָ�룩
 */
//void display_string_8x16(uchar page,uchar column,uchar *text);

/*
 * д��һ�� 16x16 ����ĺ����ַ������ַ���������躬�д��֣�
 * ������Ĳ�����(ҳ���У������ַ�����
 */
//void display_string_16x16(uchar page,uchar column,uchar *text);

/*
*��ʾ 16x16 ����ĺ��ֻ��� ASCII �� 8x16 ������ַ�����ַ���
*������Ĳ�����(ҳ���У��ַ�����
*/
//void display_string_8x16_16x16(uchar page,uchar column,uchar *text);

/*
 * ���ֿ��ȡ32*32����
 */
void display_32x32(uchar page,uchar column,uchar *dp);

/*
 * ��ʾͼ��
 */
void display_graphic(uchar *dp);

//��ָ����ַ��������д��Һ����ָ����page,column)������
void get_and_write_16x16(ulong fontaddr,uchar page,uchar column);
//��ָ����ַ��������д��Һ����ָ����page,column)������
void get_and_write_8x16(ulong fontaddr,uchar page,uchar column);
void display_GB2312_string(uchar page,uchar column,uchar *text);

#endif /* SRC_LCD_FUNC_H_ */
