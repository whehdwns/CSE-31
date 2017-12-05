.data 

original_list: .space 100 
sorted_list: .space 100

str0: .asciiz "Enter size of list (between 1 and 25): "
str1: .asciiz "Enter one list element: \n"
str2: .asciiz "\nContent of list: "
str3: .asciiz "\nEnter a key to search for: "
strYes: .asciiz "Key found!"
strNo: .asciiz "Key not found!"
space:        .asciiz    " "
error_msg: .asciiz "\n The list size cannot be less than or equal to 0 ! \n "

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
	la $s1, original_list
	
	addi $t0,$zero,0		#it skipped 0
	#addi $t0,$zero,1		#correct invaild size
  	blt $s0,$t0, invalid_size
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
	addi $t0,$zero,0 	#print out 0
	add $sp,$s1,$zero
output_loop:		#main loop which moves one by one on the list and prints that element
	
	lw $a0,0($sp)
	li $v0, 1
	syscall
	
	addi $sp,$sp, 4
	addi $t0,$t0,1
	
	la $a0, space       # Output message is space to distinguish different elements
	li $v0, 4		      # Setting $v0 to print the message
	syscall

	blt $t0,$s0, output_loop      #if we still have elements remaining elements, we keep on printing
 	syscall

	jr $ra
	
#inSort takes in a list and it size as arguments. 
#It performs INSERTION sort in ascending order and returns a new sorted list
#You may use the pre-defined sorted_list to store the result
inSort: 

	jr $ra

	
#bSearch takes in a list, its size, and a search key as arguments.
#It performs binary search RECURSIVELY to look for the search key.
#It will return a 1 if the key is found, or a 0 otherwise.
#Note: you MUST NOT use iterative approach in this function.

#Your implementation of bSearch here	
bSearch:
	
		jr	$ra		

	
	
	
	
invalid_size:
  	la $a0, error_msg        # Output message to input numbers
  	li $v0, 4	   # Setting $v0 to print the message
  	syscall
	j Exit
