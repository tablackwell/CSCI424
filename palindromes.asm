# rats live on no evil star #

.data # Store our prompt and other stuff
userPrompt:.asciiz "Please enter a string (limit 64 characters)\n"
message: .asciiz "\n The string: "
isPalindrome: .asciiz "\n is a palindrome"
isNotPalindrome: .asciiz "\n is not a palindrome"
isEmpty: .asciiz "\n is empty"
string: .space 65 # Sets our upper limit to 64 characters (plus the return)


Homework:.asciiz "CSCI 424 Homework 2 - part 3\n"
Name_1:.asciiz "Thomas\n"
Name_2:.asciiz "Blackwell\n\n"

# Register Assignments #
# s1 = string copy 1
# s2 = string copy 2
# s3 = counter for length of inputted string
# s4 = counter variable for palindrome-checking progress (the loop counter)
# t1 = a target byte of a string
# t2 = a target byte of a string

.text
.globl main
main:
#Get some other references to the strings	
la $s1, string
la $s2, string

# Prints some info thats nice to have
la $a0, Homework
addi $v0, $zero, 4
syscall
la $a0, Name_1
addi $v0, $zero, 4
syscall
la $a0, Name_2
addi $v0, $zero, 4
syscall

# Prompt the user
la $a0,userPrompt
addi $v0, $zero, 4
syscall

# read in a string using a syscall
addi $v0,$zero,8 #Set up syscall for input 
la $a0,string #Load string into $a0
li $a1, 65 #tell the system the length is 65
syscall

# Step through the bytes of the string to get the length
count: # Count the # of chars in the string
	lb $t2, ($s2) #load the byte from the address stored in s2
	beq $t2,$zero,exit #break from the loop if we run out of characters
	addi $s3, $s3, 1 #increment counter
	addi $s2, $s2, 1 #increment address to change byte
	j count
exit:


subi $s3,$s3,1 # Adjust length to account for end character
beq $s3,0,caseEmpty #If the length is zero
beq $s3,1,caseTrue #If its 1 or empty its automatically a palindrome (base cases)
div $s3,$s3,2 # Divide by two because we want to check the halfway point of a string for the following loop
subi $s2, $s2, 2 #Put the index for $s2 address back to where its supposed to be

# Palindrome loop. Starts at first byte ($t1) and last byte $t2, then moves those bytes
# right and left respectively, comparing the two as we go. If we wind up performing
# this loop enough times to match 1/2th the length of the string, we know that
# the string is a palindrome and we branch to caseTrue. If we get a mismatch, we branch
# to caseFalse. 	
palindrome:	
	#Load up the bytes we want to acces from their respective addresses
	lb $t1, ($s1) 
	lb $t2, ($s2)
	bne $t1, $t2, caseFalse #If we have mismatched characters

	addi $s1, $s1, 1 # Move our target byte in s1 one to the right (adjusts the address)
	addi $s2, $s2, -1 # Move our target byte in s2 one to the left (ditto)
	
	addi $s4, $s4, 1 #increment our loop counter
	beq $s3, $s4, caseTrue #if the times palindrome has run = the length of the string, we can assume its a palindrome and break
	j palindrome #go back to the start

# Branch for when a palindrome is detected
caseTrue:
	la $a0,message #the string...
	addi $v0, $zero,4
	syscall
	la $a0,string #prints out the original string
	addi $v0, $zero,4
	syscall
	la $a0,isPalindrome #is a palindrome
	addi $v0, $zero,4
	syscall
	j Exit

# Branch for when we know something isn't going to be a palindrome	
caseFalse:
	la $a0,message # the string...
	addi $v0, $zero,4
	syscall
	la $a0,string #prints out the original string
	addi $v0, $zero,4
	syscall
	la $a0,isNotPalindrome #is not a palindrome
	addi $v0, $zero,4
	syscall
	j Exit	

# In the case that the user inputs an empty string
caseEmpty:
	la $a0,message # the string...
	addi $v0, $zero,4
	syscall
	la $a0,string #prints out the original string
	addi $v0, $zero,4
	syscall
	la $a0,isEmpty #is not a palindrome
	addi $v0, $zero,4
	syscall
	j Exit	

# Exit the program (taken from part two of this homework)
.globl Exit
Exit: 
addi $v0, $zero, 10
syscall
jr $ra

# pseudocode for the program:
# palindrome = input("Please enter a string: ")
# length = len(palindrome)
# if length == 0 its an empty string
# if length == 1 return true
# palindromeChars[] = palindrome.split()
# i = 0
# j = length - 1
# count = 0
# target = length / 2
# while( count != length):
#    if palindromeChars[i] != palindromeChars[j]:
#        return false
#    else:
#        i++
#        j++
# 
# return true
      
