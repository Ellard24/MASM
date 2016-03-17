; Ellard Gerritsen van der Hoop 
; gerritse@oregonstate.edu
; CS271-400
; Assignment 2
; Due: 10/18/2015

TITLE Assignment 2    (assignment2.asm)

; Author: Ellard 
; Course / Project ID : CS271/ Assignment 2            Date 10/18/15
; Description: Displays Fibonacci numbers based on user input via a Counted and Post Test loop. No more than 46 numbers will be displayed. 

INCLUDE Irvine32.inc

MAX = 46	

; (insert constant definitions here)

.data
	title1		BYTE	"Fibonacci Numbers", 0
	author1		BYTE	"Made by Ellard Gerritsen van der Hoop", 0
	
	intro_1		BYTE	"What's your name?", 0
	intro_2		BYTE	"Hello, ", 0
	intro_3		BYTE	"Enter the number of Fibonacci terms to be displayed", 0
	intro_4		BYTE	"Give the number as an integer in the range [1...46]", 0
	intro_5		BYTE	"How many Fibonacci terms do you want?", 0 
	error1		BYTE	"Out of range. Enter a number in [1...46]", 0
	prompt_1	BYTE	33 DUP(0)      ;User name
	fib			DWORD	?    ; the number requested by user
	space		BYTE	"     ", 0

	ending1		BYTE	"Hopefully these results are correct. : )", 0
	goodBye		BYTE	"Good bye ", 0


.code
main PROC

;Introduction
	mov		edx, OFFSET title1
	call	WriteString
	call	CrLf
	mov		edx, OFFSET author1
	call	WriteString
	call	CrLf

;userInstructions	
	mov		edx, OFFSET intro_1
	call	WriteString
	call	CrLf	
	mov		edx, OFFSET prompt_1
	mov		ecx, 32
	call	ReadString
	mov		edx, OFFSET intro_2
	call	WriteString
	mov		edx, OFFSET prompt_1
	call	WriteString
	call	CrLf

	mov		edx, OFFSET intro_3
	call	WriteString
	call	CrLf
	mov		edx, OFFSET intro_4
	call	WriteString
	call	CrLf


;getUserData 
InputLoop:
	mov		edx, OFFSET intro_5
	call	WriteString
	call	CrLf

	call	ReadInt
	mov		fib, eax
	cmp		eax, MAX
	jg		Error
	jle		Display
	
Error:
	;if user enters a false number jumps to here and then jumps back to Input 
	mov		edx, OFFSET error1
	call	WriteString
	call	CrLf
	jg		InputLoop

Display:
	call	CrLf
	call	CrLf
;displayFibs   1, 1, 2, 3, 5, 8, 13
;Fibb must be done via MASM Loop feature
	
	mov		ebx, 1
	mov		edi, 0
	mov		ecx, fib   ;counter for fib numbers displaying
	mov		ebp, 0     ;counter for spacing
	
fibLoop:
	cmp		ebp, 5
	je		Clear		;if counter = 5 , call CrLf
	inc		ebp       	
	mov		eax, ebx
	add		eax, edi 
	mov		ebx, edi
	mov		edi, eax
	call	WriteDec
	mov		edx, OFFSET space
	call	WriteString
	loop	fibLoop			  ; fib was moved to ecx which is being reduced to 0 
	cmp		ecx, 0
	je		Ending

Clear:
	call	CrLf
	mov		ebp, 0
	jg		fibLoop

Ending:
;Farewell
	call	CrLf
	call	CrLf
	mov		edx, OFFSET ending1
	call	WriteString
	call	CrLf
	mov		edx, OFFSET goodBye
	call	WriteString
	mov		edx, OFFSET prompt_1
	call	WriteString
	call	CrLf

  

	exit	; exit to operating system
main ENDP


END main