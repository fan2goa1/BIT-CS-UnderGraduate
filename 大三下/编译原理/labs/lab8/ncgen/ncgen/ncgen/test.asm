.386
.model		flat,stdcall
option		casemap:none
include		windows.inc
include		gdi32.inc
include		masm32.inc
include		kernel32.inc
include		user32.inc
include		winmm.inc
includelib	gdi32.lib
includelib  msvcrt.lib
includelib	winmm.lib
includelib	user32.lib
includelib	kernel32.lib
includelib	kernel32.lib

scanf proto c : dword, :vararg
printf proto c : dword, :vararg

.data
scanFmt		db	'%d', 0
printIntFmt	db   '%d ', 0
printStrFmt db   '%s', 0
Mars_PrintStr0 db "The sum is :", 0ah, 0
Mars_PrintStr1 db "All perfect numbers within 100:", 0ah, 0

.code
perfectNumber proc n:dword
local p[1000]:dword
local i:dword
local num:dword
local count:dword
local s:dword
local invc:dword
local tmp1:dword
local tmp4:dword
local tmp3:dword
local tmp2:dword
local tmp6:dword
local tmp5:dword
local tmp7:dword
local tmp9:dword
local tmp10:dword
local tmp11:dword
local tmp12:dword
local tmp13:dword
local tmp14:dword
mov eax, 0
mov invc, eax
@For1: 
mov eax, 2
mov num, eax
@CondFor1: 
mov eax, num
cmp eax, n
jge @EndFor1
mov eax, 0
mov count, eax
mov eax, num
mov s, eax
@For2: 
mov eax, 1
mov i, eax
@CondFor2: 
mov edx, 0
mov eax, num
mov ebx, 2
div ebx
mov tmp4, eax
mov eax, tmp4
add eax, 1
mov tmp3, eax
mov eax, i
cmp eax, tmp3
jge @EndFor2
mov edx, 0
mov eax, num
mov ebx, i
div ebx
mov tmp6, edx
mov eax, tmp6
cmp eax, 0
jne IfNCond0
mov eax, count
mov tmp7, eax
mov eax, count
inc eax
mov count, eax
mov eax, 0
mov tmp9, eax
mov eax, tmp9
add eax, tmp7
mov tmp9, eax
mov esi, tmp9
mov eax, p[4 * esi]
mov tmp10, eax
mov eax, i
mov tmp10, eax
mov eax, tmp10
mov esi, tmp9
mov p[4 * esi], eax
mov eax, s
sub eax, i
mov s, eax
Jmp @Endif0
IfNCond0: 
@Endif0: 
mov eax, i
mov tmp11, eax
mov eax, i
inc eax
mov i, eax
Jmp @CondFor2
@EndFor2: 
mov eax, 0
cmp eax, s
jne IfNCond1
invoke printf, addr printIntFmt, num
mov eax, invc
mov tmp13, eax
mov eax, invc
inc eax
mov invc, eax
Jmp @Endif1
IfNCond1: 
@Endif1: 
mov eax, num
mov tmp14, eax
mov eax, num
inc eax
mov num, eax
Jmp @CondFor1
@EndFor1: 
invoke printf, addr Mars_PrintStr0
invoke printf, addr printIntFmt, invc
ret
perfectNumber endp

main proc
local Con100:dword
invoke printf, addr Mars_PrintStr1
mov Con100, 100
invoke perfectNumber, Con100
mov eax, 0
ret
main endp
end main

