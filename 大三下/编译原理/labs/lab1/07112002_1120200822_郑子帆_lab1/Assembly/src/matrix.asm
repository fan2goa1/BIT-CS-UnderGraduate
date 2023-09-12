include Irvine32.inc

; 定义函数
GetMyFile PROTO, PtrFilename: PTR DWORD
ParseMat PROTO, PtrMat: DWORD, numRows: DWORD, numCols: DWORD
matMul PROTO

.data

tableBuffer BYTE 370000 DUP(0)
BufferSize DWORD 370000

filename1 BYTE "A.txt", 0 ;文件名
filename2 BYTE "B.txt", 0
PtrFilename1 DWORD OFFSET filename1	;文件名指针
PtrFilename2 DWORD OFFSET filename2

MatA DWORD 90000 DUP(0)
MatB DWORD 90000 DUP(0)
MatC DWORD 90000 DUP(0)
PtrMatA DWORD OFFSET MatA
PtrMatB DWORD OFFSET MatB

numRowsA DWORD 0
numColsA DWORD 0
numRowsB DWORD 0
numColsB DWORD 0
startTime DWORD	?
msg1 byte "total running time: ", 0
msg2 byte "ms",0
.code
main PROC
	invoke GetMyFile, PtrFilename1 ;读文件A.txt
	invoke ParseMat, PtrMatA, OFFSET numRowsA, OFFSET numColsA

	invoke GetMyFile, PtrFilename2
	invoke ParseMat, PtrMatB, OFFSET numRowsB, OFFSET numColsB
	invoke GetMSeconds
	mov startTime, eax
	invoke matMul
	invoke GetMSeconds
	sub eax, startTime
	mov startTime, eax	;得到矩阵乘法运行时间
	
	mov edx, OFFSET msg1
	call WriteString
	mov edx, startTime
	call WriteDec
	mov edx, OFFSET msg2
	call WriteString

	invoke ExitProcess,0
main ENDP

;------------------------------------------------------------
; function name: GetMyFile
; description: 将txt文件内容以长字符串形式读入tableBuffer，用ASCII码存
; Params： 1) PtrFilename 文件名指针
;------------------------------------------------------------
GetMyFile PROC USES edx eax ecx,
	PtrFilename: PTR DWORD
	LOCAL FileHandle: DWORD	;句柄
	mov edx, PtrFilename
	call OpenInputFile
	mov FileHandle, eax
	mov edx, OFFSET tableBuffer
	mov ecx, DWORD PTR BufferSize
	call ReadFromFile
	mov eax, FileHandle
	call closeFile
	ret
GetMyFile ENDP

;------------------------------------------------------------
; function name: ParseMat
; description: 将tableBuffer中的ASCII码转换为十进制数
; Params： 1) PtrMat: 矩阵指针	2) numRows: 矩阵行数指针    3) numCols: 矩阵列数指针
;------------------------------------------------------------
ParseMat PROC USES eax esi edx ebx ecx,
	PtrMat: DWORD,
	numRows: DWORD,
	numCols: DWORD
	LOCAL index: DWORD, tmpRow: DWORD, tmpCol: DWORD, digit: DWORD, sum: DWORD
	mov index, 0
	mov tmpRow, 0
	mov tmpCol, 0
	mov esi, 0
	.while tableBuffer[esi] != 0
		.if tableBuffer[esi] == 20h ;空格	
			.if tmpRow < 1
				add tmpCol, 1
			.endif
			inc esi
		.elseif tableBuffer[esi] == 0dh	;CL(回车)
			add tmpRow, 1
			add esi, 2	;跳过换行
		.else	;找数
			mov sum, 0
			mov digit, 0
			.while tableBuffer[esi] >= 30h && tableBuffer[esi] <= 39h
				mov edx, 0h
				movzx eax, tableBuffer[esi]
				mov ecx, 30h
				div ecx
				mov digit, edx
				mov eax, sum
				mov ebx, 10
				mul ebx
				mov sum, eax
				mov edx, digit
				add sum, edx
				inc esi
			.ENDW
				mov ecx, PtrMat
				add ecx, index
				mov eax, sum
				mov [ecx], eax		
				add index, 4
			.if index == 360000	; 读完跳出
				inc tmpRow
				jmp jp1
			.endif
		.ENDIF
	.ENDW
	jp1:
	mov eax, tmpCol
	mov esi, numCols
	mov [esi], eax
	mov eax, tmpRow
	mov esi, numRows
	mov [esi], eax
	ret
ParseMat ENDP

;------------------------------------------------------------
; function name: matMul
; description: 将矩阵MatA和MatB相乘，得到的结果存入MatC
; Params： none
;------------------------------------------------------------
matMul PROC USES eax ebx edx ecx esi
	LOCAL i: DWORD, j: DWORD, k: DWORD, index: DWORD, sum: DWORD, p1: DWORD, p2: DWORD
	mov i, 0
	mov j, 0
	mov k, 0
	mov index, 0
	mov sum, 0
	mov p1, 0
	mov p2, 0
	mov esi, index
mulbegin:
	mov eax, i
	cmp eax, numRowsA
	jae quit
L1: mov eax, j		
	cmp eax, numColsB
	mov sum, 0		;sum=0
	jae plusJ
L2: mov eax, k
	cmp eax, numColsA
	jae plusK
	mov eax, i
	mov ebx, numColsA
	mul ebx
	add eax, k
	mov eax, MatA[eax*4]
	mov p1, eax		;p1=A[i][k]
	mov eax, k
	mov ebx, numColsB
	mul ebx
	add eax, j
	mov eax, MatB[eax*4]
	mov p2, eax		;p2=B[k][j]
	mov eax, p1
	mov ebx, p2
	imul ebx
	add sum, eax    ;sum+=p1*p2
	add k, 1
	jmp L2
plusK:
	mov k, 0
	add j, 1
	mov eax, sum
	mov MatC[esi*4], eax
	inc esi
	jmp L1
plusJ:
	mov j, 0
	add i, 1
	jmp mulbegin
quit:
	ret
matMul ENDP

END main