; Ellard Gerritsen van der Hoop 
; gerritse@oregonstate.edu
; CS271-400
; Assignment 1
; Due: 10/11/2015





TITLE Elementary Arithmetic    (week1.asm)

; Author: Ellard Gerritsen van der Hoop
; Course / Project ID : CS271 Programming Assignment 1              Date 10/11/15
; Description: A MASM program that displays name,program title on output screen as well as displays instructions to the user. Prompts user to enter two numbers and then calculates sum, difference, product, quotient and remainder of the numbers. Then displays a terminating message.



INCLUDE Irvine32.inc






.data
progTitle	BYTE	"Elementary Arithmetic", 0
userName	BYTE	"Author: Ellard Gerritsen van der Hoop", 0
number_1	DWORD	?			;string to be entered by user
number_2	DWORD	?			;string to be entered by user
intro_1		BYTE	"Enter 2 numbers, and I'll show you the sum, difference, product, quotient, and remainder", 0
intro_2		BYTE	"**EC: Program verifies second number less than first.", 0
intro_3		BYTE	"**EC: Program will repeat at the end of if answer is 1 to the input", 0
prompt_1	BYTE	"First number:", 0
prompt_2	BYTE	"Second number: ", 0
sum			DWORD	?
diff		DWORD	?
result_3	DWORD	?
result_4	DWORD	?
remainder	DWORD	?
prompt_3	BYTE	"The summation of integers ", 0
prompt_4	BYTE	" and ", 0
prompt_5	BYTE	" is ", 0
prompt_6	BYTE	"The difference of ", 0
prompt_7	BYTE	"The product of ", 0
prompt_8	BYTE	"The division of ", 0
prompt_9	BYTE	"The remainder of the division of ", 0
extra1		BYTE	"The second number must be less than the first", 0
extra2		BYTE	"Do you want to try again? Type 1 for Yes or 0 for No please", 0
answer		DWORD	?

goodBye		BYTE	"Not bad for a first assignment, right? ", 0




; (insert variable definitions here)

.code
main PROC

Beginning:
; Introduce Program Title
	mov		edx, OFFSET progTitle
	call	WriteString
	call	CrLf

;Introduce Programmer
	mov		edx, OFFSET	userName
	call	WriteString
	call	CrLf

; Introduce Extra Credit
	mov		edx, OFFSET intro_2
	call	WriteString
	call	CrLf

; Introduce Extra Credit 2
	mov		edx, OFFSET intro_3
	call	WriteString
	call	CrLf

; Get Number 1
	mov		edx, OFFSET prompt_1
	call	WriteString
	call	ReadInt
	mov		number_1, eax

; Get Number 2
	mov		edx, OFFSET prompt_2
	call	WriteString
	call	ReadInt
	mov		number_2, eax

; Checks to see if second number is bigger than first
	mov		eax, number_2
	cmp		eax, number_1
	jg		Error
	jle		Calculations

Error:
	mov		edx, OFFSET extra1
	call	WriteString
	call	CrLf
	jg		Ending

Calculations:
; Calculate Addition
	mov		eax, number_1
	add		eax, number_2
	mov		sum, eax



; Calculate Subtraction
	mov		eax, number_1
	sub		eax, number_2
	mov		diff, eax

; Calculate Multiplication
	mov		eax, number_1
	mov		ebx, number_2
	mul		ebx
	mov		result_3, eax

; Calculate Division and Remainder
	mov		eax, number_1
	cdq
	mov		ebx, number_2
	div		ebx
	mov		result_4, eax
	mov		remainder, edx

; Report results
	mov		edx, OFFSET prompt_3			
	call	WriteString						;The summation of 
	mov		eax, number_1
	call	WriteDec						; number1
	mov		edx, OFFSET prompt_4
	call	WriteString						; and
	mov		eax, number_2
	call	WriteDec						; number 2
	mov		edx, OFFSET prompt_5
	call	WriteString						;is
	mov		eax, sum
	call	WriteDec
	call	CrLf
	
	mov		edx, OFFSET prompt_6
	call	WriteString						;The difference of
	mov		eax, number_1
	call	WriteDec						; number_1
	mov		edx, OFFSET prompt_4
	call	WriteString						; and
	mov		eax, number_2
	call	WriteDec						; number_2
	mov		edx, OFFSET	prompt_5
	call	WriteString						; is
	mov		eax, diff
	call	WriteDec						; difference
	call	CrLf

	mov		edx, OFFSET prompt_7
	call	WriteString						;The product of
	mov		eax, number_1
	call	WriteDec						; number_1
	mov		edx, OFFSET prompt_4
	call	WriteString						; and
	mov		eax, number_2
	call	WriteDec						; number_2
	mov		edx, OFFSET prompt_5
	call	WriteString						; is
	mov		eax, result_3
	call	WriteDec						; product
	call	CrLf

	mov		edx, OFFSET prompt_8
	call	WriteString
	mov		eax, number_1

	call	WriteDec
	mov		edx, OFFSET prompt_4
	call	WriteString
	mov		eax, number_2
	call	WriteDec
	mov		edx, OFFSET prompt_5
	call	WriteString
	mov		eax, result_4
	call	WriteDec
	call	CrLf
	
	; Division
	mov		edx, OFFSET prompt_9
	call	WriteString					;The division of the numbers 
	mov		eax, number_1
	call	WriteDec					; nunber 1
	mov		edx, OFFSET prompt_4
	call	WriteString					; and 
	mov		eax, number_2
	call	WriteDec					; number 2
	mov		edx, OFFSET prompt_5
	call	WriteString					; is
	mov		eax, remainder
	call	WriteDec
	call	CrLf

;Option to repeat
	mov		edx, OFFSET extra2
	call	WriteString
	call	ReadInt
	mov		answer, eax
	cmp		eax, 1
	je		Beginning

Ending:	
; Say goodbye
	mov		edx, OFFSET	goodBye
	call	WriteString
	call	CrLF

	exit	; exit to operating system
main ENDP



END main