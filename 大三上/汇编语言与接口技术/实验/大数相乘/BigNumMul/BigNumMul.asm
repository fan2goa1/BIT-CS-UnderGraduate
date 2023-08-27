.386

.model flat, stdcall
option casemap : none

includelib msvcrt.lib		; ������ļ��еĺ�����scanf, printf��Ҫ�õ�
include msvcrt.inc			; prototypes for EXPORT msvcrt functions, �ں���ǰ��crt_

.data
	; A, B���������ַ���ʾ��һ����200���ֽڣ����������볤��Ϊ200����
	; ����chCΪA��B�������ĳ˻����ַ���ʾ
	chA byte 200 dup(0)
	chB byte 200 dup(0)
	chC byte 400 dup(0)
	
	; A, B�����������ֱ�ʾ��һ����200λ
	; ����numCΪA��B�������ĳ˻������ֱ�ʾ
	numA dword 200 dup(0)
	numB dword 200 dup(0)
	numC dword 400 dup(0)

	LengthA dword 0		; ��A�ĳ���
	LengthB dword 0		; ��B�ĳ���
	LengthC dword 0		; ��C�ĳ���

	IsNegA dword 0		; A�Ƿ�Ϊ��
	IsNegB dword 0		; B�Ƿ�Ϊ��
	IsNegC dword 0		; C�Ƿ�Ϊ��

	InvalidFlag dword 0	; ��ʶ�Ƿ�Ƿ�

	BigNumMulmsg byte "This is a multiplicator, please follow the guidance below.", 0	; ���������ʾ����
	InputAmsg byte "Please input num A: ", 0		; ������A����ʾ����
	InputBmsg byte "Please input num B: ", 0		; ������B����ʾ����
	NullStr byte " ", 0								; �մ�

	Outputmsg byte "The result is: %s", 0DH, 0AH, 0				; �������ʱ����ʾ����
	OutputmsgNeg byte "The result is: -%s", 0DH, 0AH, 0				; �������ʱ����ʾ����
	ErrorMsg byte "Error! Your input if not two numbers, please input two numbers using 0~9!", 0DH, 0AH, 0	; ����ʱ��ʾ����

	PrintFmt db "%d", 0DH, 0AH, 0					; ���е�acsii��
	InputFmt byte "%s", 0							; ��������Ϊchar(%s)

.code

;------------------------------------------------------------------------------------------------
; @Function Name: myrpint
; @Argument: ptr byte szFormat ��ʾ����ĸ�ʽ
; @Description: �������dword�ı������м��������һ���
;------------------------------------------------------------------------------------------------
myprint proc szFormat: ptr byte, ip: dword
	invoke crt_printf, szFormat, ip
	ret
myprint endp


;------------------------------------------------------------------------------------------------
; @Function Name: GetLength
; @Argument: chAB: ptr char��ʾA/B�ַ�����len: ptr dword��ʾA/B�ĳ���ָ�룬isNeg: ptr dword��ʾA/B�Ƿ�Ϊ��
; @Description: �˺�������˶������������λ���ļ��㣬����ȡ���˸���
;------------------------------------------------------------------------------------------------
GetLength proc uses eax ebx ecx edx esi edi, chAB: ptr char, len: ptr dword, isNeg: ptr dword
	mov edi, chAB				; �ַ���ָ��
	mov esi, len				; ����
	mov edx, isNeg
	movzx ebx, byte ptr [edi]	; ��λ��0
G1: 
	cmp ebx, 00H				; �жϽ�����'\0'
	je G2
	cmp ebx, 2DH				; ����и���
	jne G3			
	mov dword ptr [edx], 1
	jmp G4
G3:
	add dword ptr [esi], 1
G4:
	add edi, 1
	movzx ebx, byte ptr [edi]	; �Ƶ���һλ
	jmp G1
G2:
	ret
GetLength endp

;------------------------------------------------------------------------------------------------
; @Function Name:CheckValid
; @Argument: numAB: ptr dword��ʾ���������ָ�룬en: ptr dword��ʾ����
; @Description: �ж���������Ƿ�Ϸ�
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
; @Description: �жϽ���������ţ�������IsNegΪ0������Ϊ1��
;------------------------------------------------------------------------------------------------
pdSign proc uses eax ebx ecx edx esi edi
	mov eax, IsNegA
	mov ebx, IsNegB

	cmp eax, 1
	jne P1
	cmp ebx, 1
	jne P1
	mov IsNegC, 0	; A B��Ϊ����
	jmp last
P1:
	cmp eax, 0
	jne P2
	cmp ebx, 0
	jne P2
	mov IsNegC, 0	; A B��Ϊ����
	jmp last
P2:
	mov IsNegC, 1	; һ��һ��
last:
	ret
pdSign endp

;------------------------------------------------------------------------------------------------
; @Function Name: char2num
; @Argument: charAB: ptr char��ʾ�ַ�����numAB: ptr dword��ʾ�������飬len: dword��ʾ��λ
; @Description: ���ַ���ת��Ϊ���֣�����ת�������
;------------------------------------------------------------------------------------------------
char2num proc uses eax ebx ecx edx esi edi, chAB: ptr char, numAB: ptr dword, len: dword
	mov edi, chAB
	mov esi, TYPE byte
	mov ecx, 0
C1:
	cmp ecx, len
	jnl C2
	movzx ebx, byte ptr [edi]
	sub ebx, 30H		; 0~9�ַ���ascii���48��ʼ
	push ebx			; ����ǰ�ַ�ѹ��ջ
	add edi, esi
	add ecx, 1
	jmp C1

C2:
	; ��һ��ջ���ת��
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
; @Argument: numAB: ptr dword��ʾ�������飬charAB: ptr char��ʾ�ַ�����len: dword��ʾ��λ
; @Description: ������ת��Ϊ�ַ���������ת��������ʱ��ת��Ϊ��
;------------------------------------------------------------------------------------------------
num2char proc uses eax ebx ecx edx esi edi, chAB: ptr char, numAB: ptr dword, len: dword
	mov edi, numAB
	mov esi, TYPE dword
	mov ecx, 0
N1:
	cmp ecx, len
	jnl N2
	mov eax, dword ptr [edi]
	add eax, 30H		; 0~9�ַ���ascii���48��ʼ
	push eax			; ����ǰ�ַ�ѹ��ջ
	add edi, esi
	add ecx, 1
	jmp N1

N2:
	; ��һ��ջ���ת��
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
; @Description: ģ��numA��numB�ĳ˷���ʽ�������������numC��
;------------------------------------------------------------------------------------------------
MulSim proc uses eax ebx ecx edx esi edi
	mov eax, LengthA
	add eax, LengthB	; �����ʼresult�ĳ��ȣ�A����+B���ȣ�
	dec eax
	mov LengthC, eax
	
	mov edi, offset numA	; numA��ָ��ͷ
	mov esi, offset numB	; numB��ָ��ͷ
	mov edx, offset numC	; numC��ָ��ͷ
	mov eax, 0
M1:
	cmp eax, LengthA
	jnl M2
	mov ebx, 0		; numB�����鵱ǰλ��
M3:
	cmp ebx, LengthB
	jnl M4
	mov ecx, dword ptr [edi + 4*eax]
	imul ecx, dword ptr [esi + 4*ebx]
	add eax, ebx		; �õ���ǰnumC���±�
	add dword ptr [edx + 4*eax], ecx
	sub eax, ebx		; ��ԭeax
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
; @Description: ģ��numC�Ľ�λ���
;------------------------------------------------------------------------------------------------
CarryNum proc uses eax ebx ecx edx esi edi
	LOCAL CarryFlag: dword
	mov CarryFlag, 0		; ��¼�Ƿ������λ
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
	div ebx				; ���Ľ����eax��������edx
	mov dword ptr [edi + 4*ecx], edx	; ������
	add dword ptr [edi + 4*ecx + 4], eax	; ����������һλ
	mov CarryFlag, 1
	jmp C4
C3: 
	mov CarryFlag, 0
C4:
	inc ecx
	jmp C1
C2:
	.if CarryFlag == 1		; ����н�λ��LengthC+1
		inc LengthC
	.endif
	ret
CarryNum endp

;------------------------------------------------------------------------------------------------
; @Function Name: main
; @Argument: 
; @Description: ������
;------------------------------------------------------------------------------------------------
main proc
	invoke crt_printf, addr BigNumMulmsg		; �����ͷ��ʾ����
	invoke crt_puts, addr NullStr

	invoke crt_printf, addr InputAmsg			; ��ʾ�����һ����A

	invoke crt_scanf, addr InputFmt, addr chA	; ������A���ַ���ʽ��

	invoke crt_printf, addr InputBmsg			; ��ʾ����ڶ�����B
	invoke crt_scanf, addr InputFmt, addr chB	; ������B���ַ���ʽ��

	invoke GetLength, addr chA, addr LengthA, addr IsNegA	; ȡA�ĳ��ȣ�0ΪA�ı�ʶ��
	invoke GetLength, addr chB, addr LengthB, addr IsNegB	; ȡB�ĳ��ȣ�1ΪB�ı�ʶ��

M7:
	invoke pdSign		; �ж�result�ķ���
	cmp IsNegA, 0
	jne M1
	invoke char2num, addr chA, addr numA, LengthA	; ����ַ���A�����ֵ�ת����������
	jmp M2
M1:
	invoke char2num, addr chA+1, addr numA, LengthA	; ����ַ���A�����ֵ�ת����������
	
M2:
	cmp IsNegB, 0
	jne M3
	invoke char2num, addr chB, addr numB, LengthB	; ����ַ���B�����ֵ�ת����������
	jmp M8
M3:
	invoke char2num, addr chB+1, addr numB, LengthB	; ����ַ���B�����ֵ�ת����������

M8:
	; �ж������Ƿ�Ϸ�
	invoke CheckValid, addr numA, LengthA		; �ж�A�Ƿ�����Ϸ�
	invoke CheckValid, addr numB, LengthB		; �ж�B�Ƿ�����Ϸ�
	
	cmp InvalidFlag, 1
	jne M4			; ����Ϸ���ģ��߾��ȳ˷�
	invoke crt_printf, addr ErrorMsg	; ���Ϸ�����ʾ������Ϣ
	jmp M6
M4:
	invoke MulSim		; ģ��߾��ȳ˷�
	invoke CarryNum		; ģ���λ

	invoke num2char, addr chC, addr numC, LengthC	; ��numCת��chC
	
	cmp IsNegC, 0
	jne M5
	invoke crt_printf, addr Outputmsg, addr chC	; ����������
	jmp M6
M5:
	invoke crt_printf, addr OutputmsgNeg, addr chC	; ����������

M6:
	mov eax, 1
	.while eax == 1
		mov eax, 1
	.endw
	ret
main endp
end main