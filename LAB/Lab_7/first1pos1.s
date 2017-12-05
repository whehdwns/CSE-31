main:
	lui	$a0,0x8000
	jal	first1pos
	jal	printv0
	lui	$a0,0x0001
	jal	first1pos
	jal	printv0
	li	$a0,1
	jal	first1pos
	jal	printv0
	add	$a0,$0,$0
	jal	first1pos
	jal	printv0
	li	$v0,10
	syscall

first1pos:	# your code goes here
	slt 	$t0, $a0,$0
	bne	$t0,$0, Check
	sll	$a0, $a0, 1
	addi	$t1,$t1, 1
	add	$t2, $0, 31
	beq	$t2,$t1,Check
	
Check:	addi 	$t0, $0, 31
	sub	$v0, $t0, $t1
	jr	$ra
	
	addi 	$v0, $0, -1
	jr $ra

printv0:
	addi	$sp,$sp,-4
	sw	$ra,0($sp)
	add	$a0,$v0,$0
	li	$v0,1
	syscall
	li	$v0,11
	li	$a0,'\n'
	syscall
	lw	$ra,0($sp)
	addi	$sp,$sp,4
	jr	$ra
