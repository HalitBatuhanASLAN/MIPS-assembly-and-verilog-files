	.data
str:
	.asciiz "Enter text: "
enteredText:
	.space 200
character:
	.asciiz "\nTotal character : "
vowel:
	.asciiz "\nTotal vowel character : "
digit:
	.asciiz "\nTotal digit character : "
space:
	.asciiz "\nTotal space character : "
consonent:
	.asciiz "\nTotal consonent character : "
	.text
.globl main

main:
	# to print taking input text
	li $v0, 4
	la $a0, str
	syscall
	
	#taking input
	li $v0, 8
	la $a0, enteredText
	la $a1, 200
	syscall
	
	#call for counting total characters number
	jal characterCounter
	move $s0, $v0 #s0 has total character number
	#printing character string
	li $v0, 4
	la $a0, character
	syscall
	#printing character number
	li $v0, 1
	move $a0, $s0
	syscall
	
	#vowelCounter calling
	la $a0, enteredText
	jal vowelCounter
	move $s1, $v0 #keeps total vowel count
	li $v0, 4
	la $a0, vowel
	syscall
	li $v0, 1
	move $a0, $s1
	syscall
	
	#digit counter calling
	la $a0, enteredText
	jal digitCounter
	move $s2, $v0 # keeps digit number
	li $v0, 4
	la $a0, digit
	syscall
	li $v0, 1
	move $a0, $s2
	syscall 
	
	#space counter calling
	la $a0, enteredText
	jal spaceCounter
	move $s3, $v0
	li $v0, 4
	la $a0, space
	syscall
	li $v0, 1
	move $a0, $s3
	syscall
	
	#consonenetCalculator
	jal consonentCounter
	li $v0, 4
	la $a0, consonent
	syscall
	li $v0, 1
	move $a0, $s4
	syscall
	
	#consonentLoop
	la $a0, enteredText
	jal consonentCounterLoop
	move $s5, $v0
	li $v0, 4
	la $a0, consonent
	syscall
	li $v0, 1
	move $a0, $s5
	syscall
	
	#exitting from terminal
	li $v0, 10
	syscall
characterCounter:
	move $t0, $a0
	li $t2, 0
	
	loopCharacter:
		lb $t1, 0($t0)
		beq $t1, '\0', endCharacter
		beq $t1, '\n', endCharacter
		addi $t2, $t2, 1
		addi $t0, $t0, 1
		j loopCharacter
	endCharacter:
		move $v0, $t2	
		jr $ra
	
vowelCounter:
	move $t0, $a0
	li $t1, 0
	
	loopVowel:
		lb $t2, 0($t0)
		beq $t2, '\0', endVowel
		beq $t2, '\n', endVowel

		beq $t2, 'a', isVowel	
		beq $t2, 'A', isVowel
		beq $t2, 'e', isVowel
		beq $t2, 'E', isVowel
		beq $t2, 'u', isVowel
		beq $t2, 'U', isVowel
		beq $t2, 'i', isVowel
		beq $t2, 'I', isVowel
		beq $t2, 'o', isVowel
		beq $t2, 'O', isVowel

		addi $t0, $t0, 1
		j loopVowel
		isVowel:
			addi $t1, $t1, 1
		addi $t0, $t0, 1
		j loopVowel		
		endVowel:
			move $v0, $t1		
			jr $ra
		
digitCounter:
	move $t0, $a0
	li $t1, 0
	
	loopDigit:
		lb $t2, 0($t0)
		beq $t2, '\0', endDigit
		beq $t2, '\n', endDigit

		beq $t2, '0', isDigit
		beq $t2, '1', isDigit
		beq $t2, '2', isDigit
		beq $t2, '3', isDigit
		beq $t2, '4', isDigit
		beq $t2, '5', isDigit
		beq $t2, '6', isDigit
		beq $t2, '7', isDigit
		beq $t2, '8', isDigit
		beq $t2, '9', isDigit
		
		addi $t0, $t0, 1
		j loopDigit
		isDigit:
			addi $t1, $t1, 1
		addi $t0, $t0, 1
		j loopDigit
		endDigit:
			move $v0, $t1
			jr $ra
		
spaceCounter:
	move $t0, $a0
	li $t1, 0
	
	loopSpace:
		lb $t2, 0($t0)
		
		beq $t2, '\0', endSpace
		beq $t2, '\n', endSpace
		
		beq $t2, ' ', isSpace
		addi $t0, $t0, 1
		j loopSpace
		isSpace:
			addi $t1, $t1, 1
		addi $t0, $t0, 1
		j loopSpace
		endSpace:
			move $v0, $t1
			jr $ra
		
consonentCounter:
	add $t0, $s1, $s2
	add $t0, $t0, $s3
	sub $s4, $s0, $t0
	jr $ra
	
consonentCounterLoop:
	move $t0, $a0
	li $t1, 0
	
	consonentLoop:
		lb $t2, 0($t0)
		
		beq $t2, '\0', endConsonent
		beq $t2, '\n', endConsonent
		blt $t2, 'Z', upperCaseConsonentControl
		blt $t2, 'z', lowerCaseConsonentControl
		add $t0, $t0, 1
		j consonentLoop
		lowerCaseConsonentControl:
			bge $t2, 'a', littleVowelControl
			add $t0, $t0, 1
			j consonentLoop
		upperCaseConsonentControl:
			bge $t2, 'A', bigVowelControl
			add $t0, $t0, 1
			j consonentLoop
		littleVowelControl:
			beq $t2, 'a', isVowel2
			beq $t2, 'e', isVowel2
			beq $t2, 'u', isVowel2
			beq $t2, 'i', isVowel2
			beq $t2, 'o', isVowel2
			add $t0, $t0, 1
			add $t1, $t1, 1
			j consonentLoop
		bigVowelControl:
			beq $t2, 'A', isVowel2
			beq $t2, 'E', isVowel2
			beq $t2, 'U', isVowel2
			beq $t2, 'I', isVowel2
			beq $t2, 'O', isVowel2
			add $t0, $t0, 1
			add $t1, $t1, 1
			j consonentLoop
		isVowel2:
			add $t0, $t0, 1
			j consonentLoop
		endConsonent:
			move $v0, $t1
			jr $ra	
	