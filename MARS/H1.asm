	.data
str: 
	.asciiz "Enter text: "  # str bizim için metnin adresini ifade ediyor
enteredText:
	.space 200  #space for entered text
totalCharacter:
	.asciiz "\nTotal character : " # text for total number of characters
vowel:
	.asciiz "\nVowel character number is : " # vowel sayısnı bastırırken kullanılacak metin
number:
	.asciiz "\nDigits number is : " # digit sayısnı bastırırkenki stirng için	
space:
	.asciiz "\nSpace number is : " # space sayısnı bastırırkine string için
consonent:
	.asciiz "\nConsonents number is : " # consonentları yazdırırken string için
	.text
	.globl	main
main:
	li $v0, 4  # syscall çağrıldığında 4(yani string print işlemi yapılacak)
	la $a0, str  # str adresi argumen0 yazdık syscall adresi oradan alır
	syscall 
	
	li $v0, 8 #kullanıcıdan string alınacak
	la $a0, enteredText #girdinin adres
	la $a1, 200 #girdinin max boyutu
	syscall 
	
	# total character counter function
	jal characterCounters
	move $s0, $v0 # fonksyiondan gelen değeri(counter) s0 içine koyduk
	
	li, $v0, 4 # print etmek için ayarladık systemCall
	la, $a0, totalCharacter # print edilecek adresi argüman içine koyduk
	syscall
	
	li, $v0, 1 #burada integer değer print edeceğiz dedik
	move, $a0, $s0 # sayıyı tuttuğumuz değeri a0 koyduk
	syscall
	
	#vowel count function call
	la, $a0, enteredText
	jal vowelsCounter
	move, $s1, $v0 # fonksyiondan gelen değeri s0 içine koyduk
	
	li, $v0, 4 # string print edeceğimizi bildirdik
	la, $a0, vowel # print edilecek stringi belirttik
	syscall
	
	li, $v0, 1 # integer değer print edeceğimizi bildirdik
	move, $a0, $s1 # sayıyı(fonksyiondan gelen) s0 adresini verdik
	syscall
	
	#digitCounter çağrılması
	la, $a0, enteredText
	jal, digitCounter
	move, $s2, $v0 # fonksiyondan gelen değeri s0 içinde tutuyoruz
	
	li, $v0, 4 # stirng print edeceğiz
	la, $a0, number # number değişkeninin adresini verdik
	syscall
	
	li, $v0, 1 # integer print edeceğiz
	move, $a0, $s2 # print edilecek değeri taşıdık
	syscall
	
	#space için
	la, $a0, enteredText
	jal spaceCounter
	move, $s3, $v0
	
	li, $v0, 4
	la, $a0, space
	syscall
	
	li, $v0, 1
	move, $a0, $s3
	syscall
	
	# consonenet sayısı bulma
	li, $v0, 4
	la, $a0, consonent
	syscall
	
	#consonent = s0 - (s1+s2+s3) = s4
	add $t0, $s1, $s2
	add $t0, $t0, $s3
	sub, $s4, $s0, $t0
	li, $v0, 1
	move, $a0, $s4
	syscall
	
	li, $v0, 10 # programı sonlandırmak için(exit)
	syscall
	
#func for counting total number of characters
characterCounters:
	addi, $sp, $sp, -8
	sw, $s0, 0($sp) # burada stack ğzerinde counter için yer ayırdık
	sw, $s1, 4($sp) # burada string pointer için yer ayırdık
	
	move $s1, $a0 # gelen argümanın değerini s1 koyduk
	li, $s0, 0 #counter 0 olarak ayarladık
	
	# loop for character controlling
	charaterControlLoop:
		lb $t0, 0($s1) # reading 1 byte from 0th index of s1
		
		beq $t0, $zero, endOfLoopTotal # \0 controller
		
		li $t1, 10 # \n controller 
		beq $t0,$t1,endOfLoopTotal 
		
		addi $s0,$s0,1 # counter for character
		addi $s1,$s1,1 # pointer counter for keeping currnet position of text
		j charaterControlLoop # go back to loop
		
	endOfLoopTotal:
		move $v0,$s0 # countu v0 taşı
		
		lw $s0, 0($sp)
		lw $s1, 4($sp)
		addi $sp, $sp, 8
		
		jr $ra # çağrıldığın yere geri dön

	
#func for counting vowels(sesli)
vowelsCounter:
	addi, $sp, $sp, -8 # stackte değişkenleri tutmak için yer açtık
	sw, $s0, 0($sp) 
	sw, $s1, 4($sp)
	
	move, $s0, $a0 #burada gelen metni s0 geçici dğeişkenine atadık
	li, $s1, 0 # burada s1 yerinde vowel sayısını tutacağız, şimdilik 0 atadık
	
	#loop başlıyoruz
	countLoop:
		lb, $t0, 0($s0) # stringten sırayla karakter alacağız hep ilk karakteri ama s0 hep sonraki karakteri gösterecek
		
		beq, $t0, $zero, endOfLoopVowel # eğer \0 ise loop bitimine atla
		
		li, $t1, 10 # \n asciide bu şekilde
		beq, $t0, $t1, endOfLoopVowel # eğer new line ise bitir

		beq, $t0, 'a', isVowel
		beq, $t0, 'A', isVowel
		beq, $t0, 'e', isVowel
		beq, $t0, 'E', isVowel
		beq, $t0, 'i', isVowel
		beq, $t0, 'I', isVowel
		beq, $t0, 'o', isVowel
		beq, $t0, 'O', isVowel
		beq, $t0, 'u', isVowel
		beq, $t0, 'U', isVowel
		
		addi, $s0, $s0, 1
		j countLoop #go back to beginning of loop
		isVowel:
			addi, $s1, $s1, 1
		addi, $s0, $s0, 1
		j countLoop #go back to beginning of loop
	
	#loop bitince yapılacaklar
	endOfLoopVowel:
		move, $v0, $s1 #vowel sayısnı geri döndürmek için tuttuk
		 
		lw, $s0, 0($sp) # sp0 içinde geçici değişken vardı
		lw, $s1, 4($sp) #s1 içinde toplam vowel sayısını tuttuk
		addi, $sp, $sp, 8
		
		jr $ra # çağrıldığı yere gönderir

#stirng içindeki sayıların sayısını tutmak için olan func
digitCounter:
	addi, $sp, $sp, -8 # gelen metni ve digit sayısnı tutmak için yer ayırdık
	sw, $s0, 0($sp) # bunu gelen değiken için
	sw, $s1, 4($sp) # bunu digit sayısını tutmak için

	move, $s0, $a0 # gelen argümanı s0 koyduk
	li, $s1, 0 # başlangıç olarak sıfıra ayarladık

	loopStarting:
		lb, $t0, 0($s0) # s0 bir karakter alıyoruz
	
		beq, $t0, $zero, endOfLoopDigit # \0 ise çıkıyoruz looptan
		beq, $t0, '\n', endOfLoopDigit # \n ise sonraki satıra geçiyoruz
	
		beq, $t0, '0', isDigit # digitse ilgili layer gidiyoruz
		beq, $t0, '1', isDigit # digitse ilgili layer gidiyoruz
		beq, $t0, '2', isDigit # digitse ilgili layer gidiyoruz
		beq, $t0, '3', isDigit # digitse ilgili layer gidiyoruz
		beq, $t0, '4', isDigit # digitse ilgili layer gidiyoruz
		beq, $t0, '5', isDigit # digitse ilgili layer gidiyoruz
		beq, $t0, '6', isDigit # digitse ilgili layer gidiyoruz
		beq, $t0, '7', isDigit # digitse ilgili layer gidiyoruz
		beq, $t0, '8', isDigit # digitse ilgili layer gidiyoruz
		beq, $t0, '9', isDigit # digitse ilgili layer gidiyoruz
		
		addi, $s0, $s0, 1
		j loopStarting
		isDigit:
			addi, $s1, $s1, 1 # counter++
			addi, $s0, $s0, 1 #sonraki karakteri gösterir pointer
			j loopStarting
	#loop bitince yapılacaklar
	endOfLoopDigit:
		move, $v0, $s1 # toplam digit değerini geri döndürüyoruz
		
		lw, $s0, 0($sp) # geçici dğeişken
		lw, $s1, 4($sp) # s1(toplam digit sayısını) kapattık
		addi, $sp, $sp, 8

		jr $ra # çağrıldığı yere geri dönüş

#funct to count spaces
spaceCounter:
	addi, $sp, $sp, -8 # 2 wordlük yer ayırdık
	sw, $s0, 0($sp) # sp ilk yer s0 olacak
	sw, $s1, 4($sp) # sp ikinci yer s1 olacak
	
	move, $s0, $a0 #gelen argümanı s0 içine koyduk
	li, $s1, 0 # ilk başta 0 space var
	
	startLoopSpace:
		lb, $t0, 0($s0) # s0 ilk karakteri artık t0 içinde
		
		beq, $t0, '\0', endOfLoopSpace # bittiyse
		beq, $t0, '\n', endOfLoopSpace #yeni satırsa
	
		addi, $s0, $s0, 1 # sonraki karakter geçiş
	
		beq, $t0, ' ', isSpace # space ise
		
		j, startLoopSpace #loop tekrar dön
		
		isSpace:
			addi, $s1, $s1, 1 # counter++
		j, startLoopSpace # loop başına döner
	
	endOfLoopSpace:
		move, $v0, $s1
		
		lw, $s0, 0($sp)
		lw, $s1, 4($sp)
		addi, $sp, $sp, 8
		
		jr, $ra # çağrıldığı yere dönmek için
	
	
	
