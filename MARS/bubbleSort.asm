	.data
numArray:
	.word 12, 10, 3, 25, 0, 34
size:
	.word 6
outputMessage:
	.asciiz "Sorted array is : "
	
	.text
	.globl main
main:
	la $a0, numArray
	lw $a1, size
	jal sortArray
	
	li $v0, 4
	la $a0, outputMessage
	syscall

	la $a0, numArray
	lw $a1, size
	jal printArray
	li $v0, 10
	syscall

printArray:
	move $t0, $a0
	li $t1, 0
	move $t2, $a1


	loop:
		beq $t1, $t2, endLoop
		lb $t3, 0($t0)
		
		li $v0, 1
		move $a0, $t3
		syscall
		
		li $v0, 11
		li $a0, ','
		syscall
		
		add $t0, $t0, 4
		add $t1, $t1, 1
		j loop
	endLoop:
		jr $ra
sortArray:
	move $t0, $a0 #taking array 
	move $t1, $a1 #keeping size
	li $t2, -1 #i index
	li $t3, 0 #j index
	outherLoop:
		add $t2, $t2, 1
		beq $t2, $t1, endLoop2
		move $t0, $a0
		
		li $t3, 0
		j innerLoop
	innerLoop:
		addi $t4, $t1, -1           # ✅ $t4 = size - 1 = 5
		beq $t3, $t4, outherLoop
		lw $t9, 0($t0)
		lw $t8, 4($t0)
		ble $t8, $t9, change
		add $t0, $t0, 4
		add $t3, $t3, 1
		j innerLoop
		change:
			move $t7, $t8
			move $t8, $t9
			move $t9, $t7
			
			sw $t9, 0($t0)
			sw $t8, 4($t0)
		add $t0, $t0, 4
		add $t3, $t3, 1
		j innerLoop
	endLoop2:
		jr $ra
