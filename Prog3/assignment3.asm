; Author: Ellard Gerritsen van der Hoop
; Email: gerritse@oregonstate.edu
; CS271-400
; Assignment 3
; Due: 11/15/15



TITLE Integer Accumulator   (assignment3.asm)

; Author: Ellard 
; Course / Project ID : CS271-400 / Assignment 3              Date 11/1/15
; Description: Integer Accumulator program that takes in negative numbers until a positive one is input 
;				and then finds the total amount of numbers, the sum of the numbers, and the average.
;				This is all then displayed to the user.

INCLUDE Irvine32.inc

LowerLimit = -100
UpperLimit = -1 


.data
	result	DWORD	?
	intro_1	BYTE	"Welcome to the Integer Accumulator by Ellard Gerritsen", 0
	intro_2	BYTE	"What is your name?", 0
	intro_3 BYTE	"Greetings, ", 0
	user1	DWORD	33 DUP(0)    ;Username
	instr1	BYTE	"Please enter numbers between [-100, -1 ].", 0
	instr2	BYTE	"Enter a non-negative number when you are finished to see results", 0
	instr3	BYTE	"Enter a number: ", 0
	error1	BYTE	"Please keep numbers between above -100", 0 
	tracker DWORD	0
	number	DWORD	?
	ending1	BYTE	"And now the program is ending :( , Goodbye " , 0
	sum		DWORD	0
	div1	DWORD	?
	mess1	BYTE	"You have managed to enter 0 negative numbers. Impressive", 0 

	show1	BYTE	"You have entered ", 0
	show2	BYTE	" numbers", 0

	show3	BYTE	"The sum of your valid numbers is ", 0
	show4	BYTE	"The rounded average is ",0





; (insert variable definitions here)

.code
main PROC

;Display Title and Programmer

	mov		edx, OFFSET intro_1
	call	WriteString
	call	CrLf



;userName input
	mov		edx, OFFSET intro_2
	call	WriteString
	call	CrLf
	mov		edx, OFFSET user1
	mov		ecx, 32
	call	ReadString


;Greeting the User
	mov		edx, OFFSET intro_3
	call	WriteString
	mov		edx, OFFSET user1
	call	WriteString
	call	CrLf

;Display Instructions 
	mov		edx, OFFSET instr1
	call	WriteString
	call	CrLf
	mov		edx, OFFSET instr2
	call	WriteString
	call	CrLf



; Count and accumulate the valid user numbers until non negative is entered
	mov		ecx, 0			;to let the program loop

GetNumbers:
	mov		eax, tracker
	inc		eax
	mov		tracker, eax
	mov		edx, OFFSET instr3			
	call	WriteString
	call	ReadInt						
	mov		number, eax				
	

;Compare to both limits and jump if need be 	
	cmp		eax, UpperLimit
	jg		Calculate
	cmp		eax, LowerLimit
	jb		Error
	
	
	add		eax, sum
	mov		sum, eax
	loop	GetNumbers



Error:
	mov		eax, tracker
	dec		eax
	mov		tracker, eax
	mov		edx, OFFSET error1
	call	WriteString
	call	CrLf
	
	jg		GetNumbers

Skip:						    ;If no negative numbers were entered then it will skip to ending
	mov		edx, OFFSET mess1
	call	WriteString
	call	CrLf
	jmp		Ending


  
 Calculate:
	;Calculate the total number of numbers and compares the tracker to 0 to see if any valid number was input 
	
	mov		eax, tracker
	dec		eax
	mov		tracker, eax
	cmp		eax, 0
	je		Skip
	
	mov		edx, OFFSET show1
	call	WriteString
	mov		eax, tracker			
	call	WriteDec
	mov		edx, OFFSET show2
	call	WriteString
	call	CrLf



	;Showing sum of all numbers

	mov		edx, OFFSET show3
	call	WriteString
	mov		eax, sum
	call	WriteInt
	call	CrLf

	;Find the average of the numbers
	mov		edx, OFFSET show4
	call	WriteString
	mov		edx, 0
	mov		eax, sum 
	cdq
	mov		ebx, tracker
	idiv	ebx
	
	

	;Displays the average calculated before
	mov		div1, eax
	call	WriteInt
	call	CrLf






; Says goodbye to the user and shows their name
Ending:
	mov		edx, OFFSET ending1;
	call	WriteString
	mov		edx, OFFSET user1;
	call	WriteString	
	call	CrLf

	exit	; exit to operating system
main ENDP


END main