	.data
string:
	.asciiz "\nEnter a text to reverse: "
revesed:
	.asciiz "\nReversed text is : "
enteredText:
	.space 50
size:
	.word 0
	.text
	.globl main
main:
	li $v0, 4
	la $a0, string
	syscall
	
	li $v0, 8
	la $a0, enteredText
	li $a1, 50
	syscall
	
	jal characterCount
	move $s0, $v0
	sw $s0, size
	#total character counter
	li $v0, 1
	lw $a0, size
	syscall

	jal reverseFunc
	li $v0, 4
	la $a0, revesed
	syscall
	li $v0, 4
	la $a0, enteredText
	syscall
	
	li $v0, 10
	syscall
	
	
	
reverseFunc:
	li $t0, 0 #starting index
	lw $t1, size #end index
	add $t1, $t1, -1
	la $t4, enteredText
	la $t5, enteredText
	add $t5, $t5, $t1
	
	loop:
		bge $t0, $t1, endLoop
		lb $t2, 0($t4)
		lb $t3, 0($t5)
		j change
	change:
		move $t9, $t2
		move $t2, $t3
		move $t3, $t9
		
		sb $t2, 0($t4)
		sb $t3, 0($t5)
		add $t0, $t0, 1
		add $t1, $t1, -1
		
		add $t4, $t4, 1
		add $t5, $t5, -1
		j loop
	endLoop:
		
		jr $ra
characterCount:
	move $t0, $a0
	li $t1, 0
	countLoop:
		lb $t2, 0($t0)
		beq $t2, '\0', endLoopCounter
		beq $t2, '\n', endLoopCounter
		add $t1, $t1, 1
		add $t0, $t0, 1
		j countLoop
	endLoopCounter:
		move $v0, $t1
		jr $ra
	
	
	
