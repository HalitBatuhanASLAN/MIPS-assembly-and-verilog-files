	.data
takeNumber:
	.asciiz "Enter number : " # string 
result:
	.asciiz "\nFactorial result is " # result string
number:
	.word 0

	.text
	.globl main

#main fonksiyon
main:
	li $v0, 4 # to print string output
	la $a0, takeNumber
	syscall
	
	li $v0, 5 # to take int input
	syscall
	sw $v0, number

	li $v0, 4
	la $a0, result
	syscall
	
	la $a0, result
	jal factorial
	move $s0, $v0
	li $v0, 1
	move $a0, $s0
	syscall
	

	li $v0, 10
	syscall	
#factorial fonksyion
factorial:
	beq $a0, 1, endOfFunction

	li $v0, 1
	syscall

	addi $sp, $sp, -8
	sw $a0, 0($sp)
	sw $ra, 4($sp)
	
	addi $a0, $a0, -1
	jal factorial
	
	lw $ra, 4($sp)
	lw $a0, 0($sp)
	addi $sp, $sp, 8
	
	mult $v0, $a0
	mflo $v0
	jr $ra
	
	endOfFunction:
		li $v0, 1
		jr $ra



	
