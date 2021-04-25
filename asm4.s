# Omar R. Gebril

.data
line:		.asciiz	"----------------\n"
newline:	.asciiz "\n"
colonspace:	.asciiz ": "
other:		.asciiz "<other>: "

.text

# Counts and prints the occurences of each letter and characters in a string
.globl countLetters
countLetters:
	# standard prologue
	addiu	$sp, $sp, -24 		# increase stack space
	sw   	$fp, 0($sp) 		# save caller’s frame pointer
	sw    	$ra, 4($sp) 		# save return address
	addiu 	$fp, $sp, 20 		# setup frame pointer
	
	add	$t9, $zero, $a0		# t9 = *str, to be used later
	
	# 27-word array on stack, 108 bytes
	addiu	$sp, $sp, -108
	
	# for loop
	addi	$t0, $zero, 0		# i = 0
	addi	$t1, $zero, 27		# t1 = 27, used for branch
fill_for:
	beq	$t0, $t1, fill_done	# break after 27 iterations
	sll	$t2, $t0, 2		# t2 = 4i
	add	$t2, $t2, $sp		# t2 = 4i + $sp
	
	sw	$zero, 0($t2)		# letters[i] = 0
	addi	$t0, $t0, 1		# i++
	j	fill_for		# loop again

fill_done:
	# print ("----------------\n%s\n----------------\n", str)
	
	# print dashes
	la	$a0, line
	addi	$v0, $zero, 4		
	syscall
	
	# print string
	add	$a0, $zero, $t9		
	addi	$v0, $zero, 4		
	syscall
	
	# print newline
	la	$a0, newline
	addi	$v0, $zero, 4
	syscall
	
	# print dashes
	la	$a0, line		
	addi	$v0, $zero, 4		
	syscall
	
	
	add	$t0, $zero, $t9		# t0 = *str = cur
	lb	$t1, 0($t0)		# t1 = str[cur]

	# while loop
while1:
	beq	$t1, $zero, while1_done # if null terminator branch out
	
	# check cur >= a
	slti	$t2, $t1, 97		
	bne	$t2, $zero, elif1	
	
	# check cur <= z
	addi	$t3, $zero, 122		
	slt	$t2, $t3, $t1		
	bne	$t2, $zero, elif1	
	
	# find index of stackArray
	addi 	$t2, $t1, -97		# t2 = cur - 'a'
	sll	$t2, $t2, 2		#
	add	$t2, $t2, $sp		
	
	# increment letters and write values
	lw	$t3, 0($t2)		# t3 = letters[cur-a]
	addi	$t3, $t3, 1		# t3 ++
	sw	$t3, 0($t2)		
	
	j	while1_inc		# back to loop
	
elif1:	
	# check cur >= A
	slti	$t2, $t1, 65		# if cur < A..
	bne	$t2, $zero, elif2	
	
	# check cur <= z
	addi	$t3, $zero, 90		# t3 = 90 = Z
	slt	$t2, $t3, $t1		
	bne	$t2, $zero, elif2	
	
	# find index of stackArray
	addi 	$t2, $t1, -65		# t2 = cur - 'A'
	sll	$t2, $t2, 2		
	add	$t2, $t2, $sp		
	
	# increment letters[cur-A]
	lw	$t3, 0($t2)		# t3 = letters[cur-A]
	addi	$t3, $t3, 1		# t3 ++
	sw	$t3, 0($t2)		# write value back into letters
	
	j	while1_inc		# prep for next loop

elif2:
	addi	$t2, $sp, 104		# t2 = other
	lw	$t3, 0($t2)		# t3 = curr
	addi	$t3, $t3, 1		# t3 ++
	sw	$t3, 0($t2)		# write value back into letters

while1_inc:
	# prep for next iteration
	addi	$t0, $t0, 1		# cur++
	lb	$t1, 0($t0)		# t1 = str[cur}
	j	while1			

while1_done:
	addi	$t0, $zero, 0		# i = 0
	addi	$t4, $zero, 26		# x = 26
print_for:
	beq	$t0, $t4, print_done	# if i = 26, branch out

	# print
	addi	$a0, $t0, 97		# a0 = a + i
	addi	$v0, $zero, 11		# print a char
	syscall
	
	# print(': ")
	la	$a0, colonspace
	addi	$v0, $zero, 4		# print a string
	syscall
	
	# put letters[i] into a0
	sll	$t1, $t0, 2		
	add	$t1, $t1, $sp		
	lw	$a0, 0($t1)		
	
	# print
	addi	$v0, $zero, 1		# print an int
	syscall
	
	# print a newline
	la	$a0, newline
	addi	$v0, $zero, 4		# print a string
	syscall
	
	addi	$t0, $t0, 1		# i++
	j	print_for		# loop again
print_done:
	la	$a0, other		# print other
	addi	$v0, $zero, 4		
	syscall
	
	lw	$a0, 104($sp)		
	addi	$v0, $zero, 1		
	syscall
	
	la	$a0, newline		# print newline
	addi	$v0, $zero, 4		
	syscall


	addiu	$sp, $sp, 108		# restore sp
	
	# standard epilogue
	lw	$fp, 0($sp)		# restore fp
	lw	$ra, 4($sp)		# restore ra
	addiu	$sp, $sp, 24		# free stack space
	jr	$ra			# return to caller

# Returns the length of a string
.globl strlen
strlen:
	# standard prologue
	addiu	$sp, $sp, -24 		# increase stack space
	sw   	$fp, 0($sp) 		# save caller’s frame pointer
	sw    	$ra, 4($sp) 		# save return address
	addiu 	$fp, $sp, 20 		# setup frame pointer
	
	addi	$t0, $zero, 0		# i = 0
	addi	$t2, $zero, 0		# len = 0
	lb	$t1, 0($a0)		# t1 = str[i]
str_while:
	beq	$t1, $zero, len_done	# if str[i] = 0 (null terminator), branch out
	addi	$t2, $t2, 1		# increment i and len
	addi	$t0, $t0, 1		
	add	$t1, $a0, $t0		
	lb	$t1, 0($t1)		
	j	str_while		# back to loop

len_done:
	add	$v0, $zero, $t2		# return len
	# standard epilogue
	lw	$fp, 0($sp)		# restore fp
	lw	$ra, 4($sp)		# restore ra
	addiu	$sp, $sp, 24		# free stack space
	jr	$ra			# return to caller
	
# Creates a substitution cipher for a string using a table
.globl subsCipher
subsCipher:
	# standard prologue
	addiu	$sp, $sp, -24 		# increase stack space
	sw   	$fp, 0($sp) 		# save caller’s frame pointer
	sw    	$ra, 4($sp) 		# save return address
	addiu 	$fp, $sp, 20 		# setup frame pointer
	
	# store *str and *map for later
	addiu	$sp, $sp, -8		# allocate space for 2 words
	sw	$a0, 0($sp)		# store *str
	sw	$a1, 4($sp)		# store *map
	
	# int len = strlen(str) + 1
	jal	strlen			
	add	$t2, $v0, $zero		# len = strlen(str)
	addi	$t2, $t0, 1		# len = strlen(str) + 1
	
	# get *str and *map from the stack
	lw	$t0, 0($sp)		# t0 = *str
	lw	$t1, 4($sp)		# t1 = *map
	addiu	$sp, $sp, 8		# restore stack pointer
	
	# len_roundUp = (len+3) & ~0x3
	addi	$t3, $t2, 3		# t3 = len + 3
	addi	$t9, $zero, -4		# t3 will be ANDed with 11..100, which is 2s complement -4
	and	$t3, $t3, $t9		# set bottom 2 bits to 0
	
	# create an array on the stack that is len_roundUp bytes in size
	sub	$t9, $zero, $t3		# allocate stack space
	addu	$sp, $sp, $t9		# stack has len_roundUp bytes available
	
	# for loop
	
	addi	$t4, $zero, 0		# t4 = i = 0
cipher_for:
	addi	$t9, $t2, -1		# t9 = len - 1
	beq	$t4, $t9, cipher_done	# if i == len-1, done
	
	# get str[i]
	add	$t5, $t0, $t4		# t5 = start of str + i
	lb	$t5, 0($t5)		# t5 = byte at str[i]
	
	# get map[str[i]]
	add	$t6, $t1, $t5		# t6 = *map + int(str[i])
	lb	$t6, 0($t6)		# t6 = byte at map[str[i]]
	
	# store byte on stack
	add	$t7, $sp, $t4		# t7 = address of dup[i] = sp + i
	sb	$t6, 0($t7)		# store the byte at dup[i]
	
	# prep for next iteration
	addi	$t4, $t4, 1		# i++
	j	cipher_for		# loop again
	
cipher_done:
	# dup[len-1] = '\0'
	addi	$t9, $t2, -1		# t9 = len -1
	add	$t9, $t9, $sp		# t9 = address of dup[len-1]
	sb	$zero, 0($t9)		# dup[len-1] = 0 = '\0'

	# save t3, which is len_roundUp, before calling another function
	addiu	$sp, $sp, -4
	sw	$t3, 0($sp)
	
	# printSubstitutedString(dup)
	addi	$a0, $sp, 4		# point a0 to beginning of dup, which is just above t3 on stack
	jal	printSubstitutedString
	
	
	# restore t3 from the stack
	lw	$t3, 0($sp)
	addiu	$sp, $sp, 4
	
	addu	$sp, $sp, $t3		# restore stack pointer
	
	# standard epilogue
	lw	$fp, 0($sp)		# restore fp
	lw	$ra, 4($sp)		# restore ra
	addiu	$sp, $sp, 24		# free stack space
	jr	$ra			# return to caller