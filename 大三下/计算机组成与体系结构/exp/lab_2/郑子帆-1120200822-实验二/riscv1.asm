.data
list:
	.word 4, 2, 5, 1, 3

.text
bsort:
	xor t2, t2, t2
	addi s0, t2, 20
	ori t0, t2, 0
	jal end1
L1:
	addi t1, t2, 16
	jal end2
L2:
	lw a0, (t1)
	lw a1, -4(t1)
	bge a0, a1, endif
	sw a1, (t1)
	sw a0, -4(t1)
endif:
	addi t1, t1, -4
end2:
	blt t0, t1, L2
	addi t0, t0, 4
end1:
	blt t0, s0, L1