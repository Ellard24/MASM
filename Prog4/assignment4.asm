; Author: Ellard Gerritsen van der Hoop
; Email: gerritse@oregonstate.edu
; CS271-400
; Assignment 4
; Due: 11/8/15

TITLE Assignment4   (assignment4.asm)

; Author: Ellard 
; Course / Project ID : CS271-400/Assignment 4               Date 11/8/15
; Description: Composite number calculator that displays all composite numbers up to a certain number 
;			  based on user input. Also showcases a program that is broken down into separate procedures 

INCLUDE Irvine32.inc

LowerLimit = 1
UpperLimit = 400 



.data
	intro1	BYTE	"Composite Numbers  by Ellard Gerritsen", 0
	intro2	BYTE	"Enter the numbers of composite numbers you would like to see", 0
	intro3	BYTE	"The range is between 1-400 so please keep the input valid", 0
	intro4	BYTE	"Enter the number of composites to display", 0
	ending1	BYTE	"Hopefully the results were correct. Goodbye : )", 0
	error1	BYTE	"Number is out of range. Keep it between 1-400", 0
	number	DWORD	?
	start1	DWORD	1
	inCount	DWORD	3
	div1	DWORD	2
	divC	DWORD	4
	spacing	BYTE	"   ", 0
	sCount	DWORD	0
; (insert variable definitions here)

.code
main PROC
	
	call	introduction
	call	userData
	call	composites
	call	farewell

  

	exit	; exit to operating system
main ENDP

;Procedure that displays a hello message and instructions 
; to the user 
;receives: intro1,intro2,intro3 are null-terminated strings
;returns: -
;preconditions: -
;registers changed: edx


introduction	PROC
	
	call	CrLf
	mov		edx, OFFSET intro1
	call	WriteString
	call	CrLf
	mov		edx, OFFSET intro2
	call	WriteString
	call	CrLf
	mov		edx, OFFSET intro3
	call	WriteString	
	call	CrLf
	ret


introduction	ENDP

;Procedure that receives input from user on what composite number 
;		  to go up to.
;receives: LowerLimit,UpperLimit are constants. number is global variable
;returns:  value stored in global variable number.
;preconditions: -
;registers changed: edx, eax, 

userData	PROC

GetData: 
	mov		edx, OFFSET intro4
	call	WriteString
	call	CrLf
	call	ReadInt
	mov		number, eax
	cmp		eax, LowerLimit
	jb		Error
	cmp		eax,	UpperLimit
	jg		Error
	jmp		EndBlock


Error:
	mov		edx, OFFSET error1
	call	WriteString
	call	CrLf
	jmp		GetData


EndBlock:
	

	ret
userData	ENDP




;Procedure that calculates composite numbers and then prints 
;		  them to the screen. 
;receives: All values used are from global variables
;returns:  global variable start1 
;preconditions: number must have a valid input
;registers changed: edx,ecx, ebx, eax


composites	PROC

	
	mov	ecx, number
	
	

Outer:


	push	ecx
	mov		ecx, inCount
	mov		ebx, 2
	mov		div1, ebx
	
Inner:
	mov		eax, start1
	cmp		eax, 2
	je		exitInner
	cmp		eax, 3
	je		exitInner
	cmp		eax, 5					; compares to 5 and skips if it is
	je		exitInner			
	cmp		eax, 7					; compares to 7 and skips if it is
	je		exitInner
	mov		edx, 0
	div		div1
	cmp		edx, 0	
	je		Print
	cmp		ecx, 3
	je		Skip1
	cmp		ecx,2
	je		Skip2
	;cmp		ecx, 1
	jmp		Skip3
	

Skip1:
	mov		ebx, 3						;changes value to 3
	mov		div1, ebx
	loop	Inner
Skip2:		
	mov		ebx, 5						;changes value to 5
	mov		div1, ebx
	loop	Inner
Skip3:
	mov		ebx, 7						;changes value to 7
	mov		div1, ebx
	loop	Inner
	jmp		exitInner

Exit1:
	pop		ecx							;pops value on stack and loops to outer if not 0
	loop	Outer
	jmp		End1

Print:
	mov		eax, start1
	call	WriteDec
	mov		edx, OFFSET spacing	
	call	WriteString	
	mov		eax, sCount
	inc		eax
	mov		sCount, eax
	cmp		eax, 10
	jne		exitInner
	call	CrLf
	mov		eax, 0
	mov		sCount, eax
	jmp		exitInner

exitInner:
	mov		eax, start1
	inc		eax
	mov		start1, eax
	jmp		Exit1


End1:


	ret
composites	ENDP

;Procedure that displays a goodbye message to the User
;		  
;receives: -
;returns: 
;preconditions: other procedures might be finished
;registers changed: edx

farewell	PROC
	
	call	CrLf
	mov		edx, OFFSET ending1
	call	WriteString
	call	CrLf



	ret
farewell	ENDP



END main

