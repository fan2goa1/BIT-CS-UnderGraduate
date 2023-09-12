.386
.model flat, stdcall
option casemap:none

includelib		msvcrt.lib
printf			PROTO C :ptr sbyte, :VARARG
scanf			PROTO C:ptr sbyte,:VARARG

.data
scanArg	    byte	'%d', 0
printIntArg byte   '%d ', 0
printStrArg byte   '%s', 0
const0	byte	'please input ten int number for bubble sort:', 0ah, 0
const1	byte	'before bubble sort:', 0ah, 0
const2	byte	0ah, 0
const3	byte	'after bubble sort:', 0ah, 0
tmp1	dword	?
tmp2	dword	?
tmp3	dword	?
tmp4	dword	?
tmp5	dword	?
tmp6	dword	?
tmp7	dword	?
tmp8	dword	?
tmp9	dword	?
tmp10	dword	?
tmp11	dword	?
tmp12	dword	?
tmp13	dword	?
tmp14	dword	?
tmp15	dword	?
tmp16	dword	?
tmp17	dword	?
tmp18	dword	?
tmp19	dword	?
tmp20	dword	?
tmp21	dword	?
tmp22	dword	?
tmp23	dword	?
tmp24	dword	?
tmp25	dword	?
tmp26	dword	?
tmp27	dword	?
tmp28	dword	?
.code
main	proc C	
local	a[10], tmp, i, j: dword
invoke	printf, offset const0
mov		ebx, 0
mov		i, ebx
loop1entry:
mov		ebx, 10
mov		tmp2, ebx
mov		ebx, i
sub		tmp2, ebx
mov		eax, 0
setns	al
mov		tmp2, eax
mov		eax, 0
setnz	al
and		tmp2, eax
mov		eax, tmp2
test	eax, eax
jz		loop1exit
mov		ecx, 0
mov		ebx, 1
imul	ebx, i
add		ecx, ebx
imul		ecx, 4
lea		ebx, a[ecx]
invoke	scanf, offset scanArg, ebx
mov		ebx, i
mov		tmp3, ebx
mov		ebx, i
mov		i, ebx
mov		ebx, 1
add		i, ebx
jmp		loop1entry
loop1exit:
invoke	printf, offset const1
mov		ebx, 0
mov		i, ebx
loop2entry:
mov		ebx, 10
mov		tmp5, ebx
mov		ebx, i
sub		tmp5, ebx
mov		eax, 0
setns	al
mov		tmp5, eax
mov		eax, 0
setnz	al
and		tmp5, eax
mov		eax, tmp5
test	eax, eax
jz		loop2exit
mov		ecx, 0
mov		ebx, 1
imul	ebx, i
add		ecx, ebx
imul		ecx, 4
mov		ebx, a[ecx]
mov		tmp6, ebx
invoke	printf, offset printIntArg, tmp6
mov		ebx, i
mov		tmp8, ebx
mov		ebx, i
mov		i, ebx
mov		ebx, 1
add		i, ebx
jmp		loop2entry
loop2exit:
invoke	printf, offset const2
mov		ebx, 0
mov		i, ebx
loop3entry:
mov		ebx, 10
mov		tmp10, ebx
mov		ebx, i
sub		tmp10, ebx
mov		eax, 0
setns	al
mov		tmp10, eax
mov		eax, 0
setnz	al
and		tmp10, eax
mov		eax, tmp10
test	eax, eax
jz		loop3exit
mov		ebx, 0
mov		j, ebx
loop4entry:
mov		ebx, 10
mov		tmp13, ebx
mov		ebx, i
sub		tmp13, ebx
mov		ebx, tmp13
mov		tmp12, ebx
mov		ebx, 1
sub		tmp12, ebx
mov		ebx, tmp12
mov		tmp11, ebx
mov		ebx, j
sub		tmp11, ebx
mov		eax, 0
setns	al
mov		tmp11, eax
mov		eax, 0
setnz	al
and		tmp11, eax
mov		eax, tmp11
test	eax, eax
jz		loop4exit
mov		ecx, 0
mov		ebx, 1
imul	ebx, j
add		ecx, ebx
imul		ecx, 4
mov		ebx, a[ecx]
mov		tmp15, ebx
mov		ebx, j
mov		tmp16, ebx
mov		ebx, 1
add		tmp16, ebx
mov		ecx, 0
mov		ebx, 1
imul	ebx, tmp16
add		ecx, ebx
imul		ecx, 4
mov		ebx, a[ecx]
mov		tmp17, ebx
mov		ebx, tmp15
mov		tmp14, ebx
mov		ebx, tmp17
sub		tmp14, ebx
mov		eax, 0
setns	al
mov		tmp14, eax
mov		eax, 0
setnz	al
and		tmp14, eax
mov		eax, tmp14
test	eax, eax
jz		selection1exit
mov		ecx, 0
mov		ebx, 1
imul	ebx, j
add		ecx, ebx
imul		ecx, 4
mov		ebx, a[ecx]
mov		tmp18, ebx
mov		ebx, tmp18
mov		tmp, ebx
mov		ebx, j
mov		tmp19, ebx
mov		ebx, 1
add		tmp19, ebx
mov		ecx, 0
mov		ebx, 1
imul	ebx, tmp19
add		ecx, ebx
imul		ecx, 4
mov		ebx, a[ecx]
mov		tmp20, ebx
mov		ecx, 0
mov		ebx, 1
imul	ebx, j
add		ecx, ebx
imul		ecx, 4
mov		ebx, tmp20
mov		a[ecx], ebx
mov		ebx, j
mov		tmp21, ebx
mov		ebx, 1
add		tmp21, ebx
mov		ecx, 0
mov		ebx, 1
imul	ebx, tmp21
add		ecx, ebx
imul		ecx, 4
mov		ebx, tmp
mov		a[ecx], ebx
selection1exit:
mov		ebx, j
mov		tmp22, ebx
mov		ebx, j
mov		j, ebx
mov		ebx, 1
add		j, ebx
jmp		loop4entry
loop4exit:
mov		ebx, i
mov		tmp23, ebx
mov		ebx, i
mov		i, ebx
mov		ebx, 1
add		i, ebx
jmp		loop3entry
loop3exit:
invoke	printf, offset const3
mov		ebx, 0
mov		i, ebx
loop5entry:
mov		ebx, 10
mov		tmp25, ebx
mov		ebx, i
sub		tmp25, ebx
mov		eax, 0
setns	al
mov		tmp25, eax
mov		eax, 0
setnz	al
and		tmp25, eax
mov		eax, tmp25
test	eax, eax
jz		loop5exit
mov		ecx, 0
mov		ebx, 1
imul	ebx, i
add		ecx, ebx
imul		ecx, 4
mov		ebx, a[ecx]
mov		tmp26, ebx
invoke	printf, offset printIntArg, tmp26
mov		ebx, i
mov		tmp28, ebx
mov		ebx, i
mov		i, ebx
mov		ebx, 1
add		i, ebx
jmp		loop5entry
loop5exit:
mov		eax, 0
ret
main	endp
end		main