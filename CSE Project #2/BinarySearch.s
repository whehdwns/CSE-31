#GROUP
#Dongjun Cho
#(Chi Hong Kou)
#CSE 31 Project #2
.data 

original_list: .space 100 
sorted_list: .space 100

str0: .asciiz "Enter size of list (between 1 and 25): "
str1: .asciiz "Enter one list element: \n"
str2: .asciiz "Content of list: "
str3: .asciiz "Enter a key to search for: "
strYes: .asciiz "Key found!"
strNo: .asciiz "Key not found!"
space: .asciiz " "
nozero: .asciiz "\n The list size should be greater than 0! \n"
nonegative: .asciiz "\n The list size should not be negative! \n"
error_msg: .asciiz "\n The list size cannot be greater than 25 ! \n "
nextline: .asciiz "\n"

.text 

#This is the main program.
#It first asks user to enter the size of a list.
#It then asks user to input the elements of the list, one at a time.
#It then calls printList to print out content of the list.
#It then calls inSort to perform insertion sort
#It then asks user to enter a search key and calls bSearch on the sorted list.
#It then prints out search result based on return value of bSearch
main: 
	addi $sp, $sp -8		#number of caller saved register
	sw $ra, 0($sp)			#store needed registers
	
	li $v0, 4 			#system call code for print_str0
	la $a0, str0 			#print "Enter size of list (between 1 and 25): "
	syscall 
				#print the string	
	li $v0, 5	#Read size of list from user
	syscall		#print
	
	move $s0, $v0	#save
	move $t0, $0	
	move $t9, $0
	la $s1, original_list
	
	addi $t9,$zero,25		#it skipped 0
	#addi $t0,$zero,1		#correct invaild size
	#blez $s0, invalid_size
	beqz $s0, NoZero
	bltz $s0, negative
  	bgtu $s0, $t9, invalid_size

loop_in:
	li $v0, 4 		#system call code for print_str1
	la $a0, str1 		#print "Enter one list element: \n"
	syscall 
	
	sll $t1, $t0, 2		#shift left $t1=$t0<<2
	add $t1, $t1, $s1	#$t1=$t1+$s1
	      
	
	li $v0, 5		#Read elements from user
	syscall
	
	sw $v0, 0($t1)		#store integer in $t1
	       
	addi $t0, $t0, 1	#increment loop counter by 1
	blt $t0, $s0, loop_in	#go to loop_in
	
	la $a0, str2 		#print "Content of list"	
	li $v0, 4 		#system call code for print_str2			
	
	syscall 
	
	move $a0, $s1		#$a0= $s1
	move $a1, $s0		#$a1= $s0
	
	jal printList	#Call print original list
	
	jal inSort	#Call inSort to perform insertion sort in original list
	sw $v0, 4($sp)
	
	li $v0, 4 		#system call code for print_str2
	la $a0, str2 		#print 
	syscall 
	
	lw $a0, 4($sp)		#restore $a0 from stack
	jal printList	#Print sorted list
	
	li $v0, 4 		#system call code for print_str3
	la $a0, str3 		#print "Enter a key to search for: "
	syscall 
	
	li $v0, 5	#Read search key from user
	syscall
	
	move $a2, $v0
	lw $a0, 4($sp)		#restore $a0 from stack
	jal bSearch	#Call bSearch to perform binary search
	
	beq $v0, $0, notFound
	
	li $v0, 4 		# system call code for print_strYes
	la $a0, strYes 		#print "Key found!"
	syscall 
	j end
	
notFound:
	li $v0, 4 		#system call code for print_strNo
	la $a0, strNo 		#print "Key not found!"
	syscall 
end:
	lw $ra, 0($sp)		#restore $ra 
	addi $sp, $sp 8		#adjust $sp back 
	li $v0, 10 		#system call code for exit
	syscall

Exit:   
   # Exit program
   li $v0, 10
   syscall
	
	
#printList takes in a list and its size as arguments. 
#It prints all the elements in one line.
printList:
	addi $sp, $sp, -4
	sw $a0, 0($sp)
	move $t0, $a0
	move $t1, $a1
	li $t2, 0
loop:
	beq $t2, $t1, exit
	li $v0, 1
	lw $a0, 0($t0)
	syscall
	
	li $v0, 4
	la $a0, space
	syscall
	
	addi $t0, $t0, 4
	addi $t2, $t2, 1
	j loop
exit:
	li $v0, 4
	la $a0, nextline
	syscall
	
	lw $a0, 0($sp)
	addi $sp, $sp, 4
	jr $ra
#inSort takes in a list and it size as arguments. 
#It performs INSERTION sort in ascending order and returns a new sorted list
#You may use the pre-defined sorted_list to store the result
inSort:
	move $t0, $a0 #elements
	move $t1, $a1 #size of array
	li $t2, 1 #loop counter starting from 1

sort1:
	move $t0, $a0	#set t0 to contains of a0
	beq $t2, $t1, sortE2 #if t2 is equal to t1 then go to finish
	move $t3, $t2 	#set t3 to contains of t2

sort2:
	move $t0, $a0 #elemnts
	mul $t4, $t3, 4 
	add $t0, $t0, $t4 #t0=t0+$t4
	beq $t3, 0, next #i t3 is equal to 0 then go to next
	lw $t5, 0($t0) #set t5 to 0 address of t0
	lw $t6, -4($t0)	#set t6 to -4 address of t0
	bge $t5, $t6, next #if t5 is greater than t6 then go to next
	lw $t7, 0($t0)
	sw $t6, 0($t0)
	sw $t7, -4($t0)
	addi $t3, $t3, -1
	j sort2
next:
	addi $t2, $t2, 1#increment counter by 1
	j sort1		#go to sort1
sortE2:
	la $v0, 0($a0)
	jr $ra
	
#bSearch takes in a list, its size, and a search key as arguments.
#It performs binary search RECURSIVELY to look for the search key.
#It will return a 1 if the key is found, or a 0 otherwise.
#Note: you MUST NOT use iterative approach in this function.
bSearch:
	#Your implementation of bSearch here
	add $t2, $t2, $ra
	move $t0, $0
	move $t1, $0
	sll $t1, $t0, 2
	add $t1, $t1, $s1
	
	move $a3, $0
	add $t6, $0, 1
	add $s2, $0, $a2
	move $v0, $0
	add $s4, $s0, $a3	#s4= 
	div $s4, $s4, 2		#$s4=$s4/2
	j binaryloop
	
binaryloop:	
	beq $t6, $0, nokey
	move $t6, $0
	sll $t2, $s4, 2
	add $t1, $0, $s1
	add $t1, $t2, $t1
	lw $t6, ($t1)
	beq $t6, $s2, key
	slt $t8, $t6, $s2		
	beq $t8, $0, searchtoleft
	j searchtoright
	
searchtoleft:
	addi $s4, $s4, -1
	add $s0, $s4, $0
	j binaryloop	
searchtoright:
	addi $s4, $s4, 1
	add $a3, $0, $s4
	#j bSearch
	j binaryloop
key: 
	add $v0, $0, 1
	jr $ra	
nokey:
	jr $ra

	
NoZero:
	la $a0, nozero       # Output message to input numbers
  	li $v0, 4	   # Setting $v0 to print the message
  	syscall
	j Exit
negative:
	la $a0, nonegative        # Output message to input numbers
  	li $v0, 4	   # Setting $v0 to print the message
  	syscall
	j Exit
invalid_size:
  	la $a0, error_msg        # Output message to input numbers
  	li $v0, 4	   # Setting $v0 to print the message
  	syscall
	j Exit
