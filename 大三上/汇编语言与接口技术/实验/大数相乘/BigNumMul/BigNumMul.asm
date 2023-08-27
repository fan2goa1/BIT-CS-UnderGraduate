.386

.model flat, stdcall
option casemap : none

includelib msvcrt.lib		; 导入库文件中的函数，scanf, printf需要用到
include msvcrt.inc			; prototypes for EXPORT msvcrt functions, 在函数前加crt_

.data
	; A, B两个数的字符表示，一共有200个字节，即可以输入长度为200的数
	; 其中chC为A、B两个数的乘积的字符表示
	chA byte 200 dup(0)
	chB byte 200 dup(0)
	chC byte 400 dup(0)
	
	; A, B两个数的数字表示，一共有200位
	; 其中numC为A、B两个数的乘积的数字表示
	numA dword 200 dup(0)
	numB dword 200 dup(0)
	numC dword 400 dup(0)

	LengthA dword 0		; 数A的长度
	LengthB dword 0		; 数B的长度
	LengthC dword 0		; 数C的长度

	IsNegA dword 0		; A是否为负
	IsNegB dword 0		; B是否为负
	IsNegC dword 0		; C是否为负

	InvalidFlag dword 0	; 标识是否非法

	BigNumMulmsg byte "This is a multiplicator, please follow the guidance below.", 0	; 进入界面提示标语
	InputAmsg byte "Please input num A: ", 0		; 输入数A的提示标语
	InputBmsg byte "Please input num B: ", 0		; 输入数B的提示标语
	NullStr byte " ", 0								; 空串

	Outputmsg byte "The result is: %s", 0DH, 0AH, 0				; 输出正数时的提示标语
	OutputmsgNeg byte "The result is: -%s", 0DH, 0AH, 0				; 输出负数时的提示标语
	ErrorMsg byte "Error! Your input if not two numbers, please input two numbers using 0~9!", 0DH, 0AH, 0	; 报错时提示标语

	PrintFmt db "%d", 0DH, 0AH, 0					; 换行的acsii码
	InputFmt byte "%s", 0							; 输入类型为char(%s)

.code

;------------------------------------------------------------------------------------------------
; @Function Name: myrpint
; @Argument: ptr byte szFormat 表示输出的格式
; @Description: 输出类型dword的变量的中间结果，并且换行
;------------------------------------------------------------------------------------------------
myprint proc szFormat: ptr byte, ip: dword
	invoke crt_printf, szFormat, ip
	ret
myprint endp


;------------------------------------------------------------------------------------------------
; @Function Name: GetLength
; @Argument: chAB: ptr char表示A/B字符串，len: ptr dword表示A/B的长度指针，isNeg: ptr dword表示A/B是否为负
; @Description: 此函数完成了对于输入的数的位数的计算，并提取出了负号
;------------------------------------------------------------------------------------------------
GetLength proc uses eax ebx ecx edx esi edi, chAB: ptr char, len: ptr dword, isNeg: ptr dword
	mov edi, chAB				; 字符串指针
	mov esi, len				; 长度
	mov edx, isNeg
	movzx ebx, byte ptr [edi]	; 高位补0
G1: 
	cmp ebx, 00H				; 判断结束符'\0'
	je G2
	cmp ebx, 2DH				; 如果有负号
	jne G3			
	mov dword ptr [edx], 1
	jmp G4
G3:
	add dword ptr [esi], 1
G4:
	add edi, 1
	movzx ebx, byte ptr [edi]	; 移到下一位
	jmp G1
G2:
	ret
GetLength endp

;------------------------------------------------------------------------------------------------
; @Function Name:CheckValid
; @Argument: numAB: ptr dword表示数字数组的指针，en: ptr dword表示长度
; @Description: 判断输入的数是否合法
;------------------------------------------------------------------------------------------------
CheckValid proc uses eax ebx ecx edx esi edi, numAB: ptr dword, len: dword
	mov edi, numAB
	mov esi, TYPE dword
	mov ecx, 0
V1:
	cmp ecx, len
	jnl V2
	mov eax, dword ptr [edi]
	.if eax < 0
		mov InvalidFlag, 1
		jmp V2
	.elseif eax > 9
		mov InvalidFlag, 1
		jmp V2
	.endif
	add edi, esi
	inc ecx
	jmp V1
V2:
	ret
CheckValid endp

;------------------------------------------------------------------------------------------------
; @Function Name: pdSign
; @Argument: 
; @Description: 判断结果的正负号（正数则IsNeg为0，否则为1）
;------------------------------------------------------------------------------------------------
pdSign proc uses eax ebx ecx edx esi edi
	mov eax, IsNegA
	mov ebx, IsNegB

	cmp eax, 1
	jne P1
	cmp ebx, 1
	jne P1
	mov IsNegC, 0	; A B均为负数
	jmp last
P1:
	cmp eax, 0
	jne P2
	cmp ebx, 0
	jne P2
	mov IsNegC, 0	; A B均为正数
	jmp last
P2:
	mov IsNegC, 1	; 一正一负
last:
	ret
pdSign endp

;------------------------------------------------------------------------------------------------
; @Function Name: char2num
; @Argument: charAB: ptr char表示字符串，numAB: ptr dword表示数字数组，len: dword表示数位
; @Description: 将字符串转换为数字，并反转过来存放
;------------------------------------------------------------------------------------------------
char2num proc uses eax ebx ecx edx esi edi, chAB: ptr char, numAB: ptr dword, len: dword
	mov edi, chAB
	mov esi, TYPE byte
	mov ecx, 0
C1:
	cmp ecx, len
	jnl C2
	movzx ebx, byte ptr [edi]
	sub ebx, 30H		; 0~9字符的ascii码从48开始
	push ebx			; 将当前字符压入栈
	add edi, esi
	add ecx, 1
	jmp C1

C2:
	; 逐一弹栈完成转换
	mov edi, numAB
	mov esi, TYPE dword
	mov ecx, 0
C3:
	cmp ecx, len
	jnl C4
	pop ebx
	mov dword ptr [edi], ebx
	inc ecx
	add edi, esi
	jmp C3
C4:
	ret
char2num endp

;------------------------------------------------------------------------------------------------
; @Function Name: num2char
; @Argument: numAB: ptr dword表示数字数组，charAB: ptr char表示字符串，len: dword表示数位
; @Description: 将数字转换为字符串，并反转过来，此时反转完为正
;------------------------------------------------------------------------------------------------
num2char proc uses eax ebx ecx edx esi edi, chAB: ptr char, numAB: ptr dword, len: dword
	mov edi, numAB
	mov esi, TYPE dword
	mov ecx, 0
N1:
	cmp ecx, len
	jnl N2
	mov eax, dword ptr [edi]
	add eax, 30H		; 0~9字符的ascii码从48开始
	push eax			; 将当前字符压入栈
	add edi, esi
	add ecx, 1
	jmp N1

N2:
	; 逐一弹栈完成转换
	mov edi, chAB
	mov esi, TYPE byte
	mov ecx, 0
N3:
	cmp ecx, len
	jnl N4
	pop eax
	mov byte ptr [edi], al
	inc ecx
	add edi, esi
	jmp N3
N4:
	mov byte ptr [edi], 00H
	ret
num2char endp

;------------------------------------------------------------------------------------------------
; @Function Name: MulSim
; @Argument: 
; @Description: 模拟numA和numB的乘法竖式，并将结果存在numC中
;------------------------------------------------------------------------------------------------
MulSim proc uses eax ebx ecx edx esi edi
	mov eax, LengthA
	add eax, LengthB	; 计算初始result的长度（A长度+B长度）
	dec eax
	mov LengthC, eax
	
	mov edi, offset numA	; numA的指针头
	mov esi, offset numB	; numB的指针头
	mov edx, offset numC	; numC的指针头
	mov eax, 0
M1:
	cmp eax, LengthA
	jnl M2
	mov ebx, 0		; numB的数组当前位置
M3:
	cmp ebx, LengthB
	jnl M4
	mov ecx, dword ptr [edi + 4*eax]
	imul ecx, dword ptr [esi + 4*ebx]
	add eax, ebx		; 得到当前numC的下标
	add dword ptr [edx + 4*eax], ecx
	sub eax, ebx		; 还原eax
	inc ebx
	jmp M3
M4:
	inc eax
	jmp M1
M2:
	ret
MulSim endp

;------------------------------------------------------------------------------------------------
; @Function Name: CarryNum
; @Argument: 
; @Description: 模拟numC的进位情况
;------------------------------------------------------------------------------------------------
CarryNum proc uses eax ebx ecx edx esi edi
	LOCAL CarryFlag: dword
	mov CarryFlag, 0		; 记录是否产生进位
	mov edi, offset numC
	mov ecx, 0
C1:
	cmp ecx, LengthC
	jnl C2
	cmp dword ptr [edi + 4*ecx], 9
	jng C3
	mov eax, dword ptr [edi + 4*ecx]
	mov edx, 0
	mov ebx, 10
	div ebx				; 除的结果在eax，余数在edx
	mov dword ptr [edi + 4*ecx], edx	; 余数留
	add dword ptr [edi + 4*ecx + 4], eax	; 除数进到下一位
	mov CarryFlag, 1
	jmp C4
C3: 
	mov CarryFlag, 0
C4:
	inc ecx
	jmp C1
C2:
	.if CarryFlag == 1		; 如果有进位，LengthC+1
		inc LengthC
	.endif
	ret
CarryNum endp

;------------------------------------------------------------------------------------------------
; @Function Name: main
; @Argument: 
; @Description: 主函数
;------------------------------------------------------------------------------------------------
main proc
	invoke crt_printf, addr BigNumMulmsg		; 输出开头提示标语
	invoke crt_puts, addr NullStr

	invoke crt_printf, addr InputAmsg			; 提示输入第一个数A

	invoke crt_scanf, addr InputFmt, addr chA	; 输入数A（字符形式）

	invoke crt_printf, addr InputBmsg			; 提示输入第二个数B
	invoke crt_scanf, addr InputFmt, addr chB	; 输入数B（字符形式）

	invoke GetLength, addr chA, addr LengthA, addr IsNegA	; 取A的长度，0为A的标识符
	invoke GetLength, addr chB, addr LengthB, addr IsNegB	; 取B的长度，1为B的标识符

M7:
	invoke pdSign		; 判断result的符号
	cmp IsNegA, 0
	jne M1
	invoke char2num, addr chA, addr numA, LengthA	; 完成字符串A到数字的转换（正数）
	jmp M2
M1:
	invoke char2num, addr chA+1, addr numA, LengthA	; 完成字符串A到数字的转换（负数）
	
M2:
	cmp IsNegB, 0
	jne M3
	invoke char2num, addr chB, addr numB, LengthB	; 完成字符串B到数字的转换（正数）
	jmp M8
M3:
	invoke char2num, addr chB+1, addr numB, LengthB	; 完成字符串B到数字的转换（负数）

M8:
	; 判断输入是否合法
	invoke CheckValid, addr numA, LengthA		; 判断A是否输入合法
	invoke CheckValid, addr numB, LengthB		; 判断B是否输入合法
	
	cmp InvalidFlag, 1
	jne M4			; 如果合法，模拟高精度乘法
	invoke crt_printf, addr ErrorMsg	; 不合法，显示错误信息
	jmp M6
M4:
	invoke MulSim		; 模拟高精度乘法
	invoke CarryNum		; 模拟进位

	invoke num2char, addr chC, addr numC, LengthC	; 将numC转成chC
	
	cmp IsNegC, 0
	jne M5
	invoke crt_printf, addr Outputmsg, addr chC	; 输出正数结果
	jmp M6
M5:
	invoke crt_printf, addr OutputmsgNeg, addr chC	; 输出负数结果

M6:
	mov eax, 1
	.while eax == 1
		mov eax, 1
	.endw
	ret
main endp
end main