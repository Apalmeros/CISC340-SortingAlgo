.data
	array: .space 40
	array_size: .asciiz "Enter array size: "
	array_element: .asciiz "Enter array element: "
	sorted_array: .asciiz "\nSorted Array: "
	space_comma: .asciiz ", "
	unsorted_array: .asciiz "\nUnsorted Array: "
.text

main:
size_check:
	la $a0, array_size		# $a0= array_size address          
	li $v0,4			# code to print string					
	syscall				# command to do print

	li $v0,5			# code to get user input array_size prompt
	syscall				# command to get user input
	
	li $t5, 3			# $t5 = 3
	li $t6, 10			# $t6 = 10
	
	move $t7, $v0			# $t7 = $v0  ($t7 = array_size)
	blt $t7, $t5, size_check	# checks if array_size inputed is at least 3 if not, asks for prompt again
	bgt $t7, $t6, size_check	# checks if array size inputed is no greater than 10 if not, asks for prompt again
	
	move $v0, $t7			#$v0 = $t7  (moves array_size into $v0)
	
	move $s1, $v0                 	# movres array_size into $s1
	sub $s1,$s1,1                   # subtracts 1 from array size so it passes size_check   

get_all_ints: # loops through user input to store data in the array

	la $a0,array_element    	# loads array_elements into $a0               
	li $v0,4			# code to print string
	syscall				#command to do print

	li $v0,5        		# code to get user input for array_element prompt
	syscall				# command to get user input

	move $t3,$v0       		# saves input data into $t3                 
	add $t1,$zero,$zero		# makes $t1 = 0   
	sll $t1,$t0,2                   # word offset i * 4

	sw $t3, array( $t1 )		# store array elements in $t1 of array address             
	addi $t0,$t0,1                  # increment counter i++
	slt $t1,$s1,$t0                 # increment index [i+1]
	beq $t1,$zero,get_all_ints	# while( $t1 !== 0)
					
	la $a0, unsorted_array		# loads unsorted_array prompt into $a0
	li $v0, 4			# $v0 = 4
	syscall
	
	la $t0, array			# loads array into $t0
	li $t1, 0			# $t1 = 0
print_unsorted: # prints unsorted array
	lw $a0,0($t0)     		# loads array elements into $a0                
	li $v0,1			# code to print array
	syscall
	
	la $a0, space_comma		#loads comma character into $a0
	li $v0, 4			#prints comma
	syscall				#this part is for formatting, adds comma in between each of the numbers 

	addi $t0,$t0,4                  # [i+1]   
	addi $t1,$t1,1                  # i++
					# if ($s1 < $t1)  
	slt $t2,$s1,$t1                 # 	$t2 = 1 
					#	else
					#	$t2 = 0
	beq $t2,$zero,print_unsorted	# while( $t2 !== 0)           

	la $a0,array               	#loads #a0 into array         
	addi $a1,$s1,1           	#adds 1 to $s1
	jal sort                        # jumps to sort function  

	la $a0,sorted_array 		# loads sorted array into $a0
	li $v0,4			# code to print string
	syscall

	la $t9,array                    # loads array into $t9   
	li $t1,0                        # $t1 = 0    

print_sorted: #prints sorted array
	lw $a0,0($t9)                   # loads array into $a0  
	li $v0,1			# code to print array
	syscall
	
	la $a0, space_comma		#
	li $v0, 4			# formatting to print commas between numbers
	syscall				#

	addi $t9,$t9,4                  #[i+1]   
	addi $t1,$t1,1                  # i++    
	slt $t2,$s1,$t1                 # if( $s1 < $t1)
					#	$t2 = 1
				        #	else           
					#       $t2 = 0
	beq $t2,$zero,print_sorted 	# while( $t2 !== 0)		
	jal exit			# finishes program		

sort:
	li $t0,0                        # $t0 = 0   resets register    

for1tst:				# outer loop
	addi $t0,$t0,1                 	# i++   
	bgt $t0,$a1,end                 # finish loop if ($t0 > $a1)
	add $t1,$a1,$zero               # $t1 = $a1 + 0

for2tst:				# inner loop
	bge $t0,$t1,for1tst             # finish loop if ($t0 > $t1)    
	sub $t1,$t1, 1                  # $t1 = $t1 - 1    
	sll $t4, $t1, 2                 # grab next index  $t4 = j * 4  
	subi $t3, $t4, 4                # [j * 4]   
	add $t4,$t4,$a0                 # $t4 = v + (j *4)   
	add $t3,$t3,$a0                     
	lw $t5,0($t4)			# $t5 = v[j]
	lw $t6,0($t3)			# $t6 = v[j+1]

swap:
	bgt $t5,$t6,for2tst             # exit loop if ($t5 > $t6)     
	sw $t5,0($t3)                   # temp variables to swap   
	sw $t6,0($t4)
	j for2tst			# jump to inner loop

end:					#ends sort
	jr $ra
exit:					#code to end program
	li $v0, 10
	syscall
