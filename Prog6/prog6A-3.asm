;Author: Ellard Gerritsen van der Hoop
;Email: gerritse@oregonstate.edu
;CS271-400
;Assignment 6A
;Due: 12/6/15




TITLE Programming Assignment #6A Designing Low-Level I/O Procedures   (prog6A.asm)

; Author: Ellard Gerritsen
;Course: / Project ID: CS271- 400 / Assignment 6A         Date: 12/6/15
;Description: Allows user to enter 15 numbers which will then be validated and stored into a array.  The values will then be summed up,
;			averaged, and printed to screen. The program also uses macros to display strings as well as get user input. 




MIN = 48
MAX = 57

INCLUDE Irvine32.inc

.data

intro1					   BYTE	  "PROGRAMMING ASSIGNMENT 6A: Designing low-level I/O procedures", 0
intro2					   BYTE   "Written by: Ellard Gerritsen", 0
instruct1				   BYTE	  "Please enter 15 unsigned decimal integers.",0 
instruct2				   BYTE   "Each number needs to be small enough to fit inside a 32 bit register.", 0
instruct3				   BYTE	  "After you have finished inputting the raw numbers I will display a list of the integers, their sum, and their average value."

prompt1					   BYTE   "Please enter an unsigned integer: ", 0

error1					   BYTE	  "ERROR: You did not enter an unsigned number or your number was too big.", 0
spacing					   BYTE	  ", ", 0
goodbye					   BYTE	  "Last project of the semester. Guess this is goodbye :( ", 0
listNumbers				   BYTE   "You entered the following numbers: ", 0
sumResults				   BYTE   "The sum is: ", 0
averageResults			   BYTE	  "The average is: ",0


number					   DWORD  10 DUP(0)
listSize				   DWORD  15


list					   DWORD 10 DUP(?)  
list2					   BYTE 10 DUP(?)







getString MACRO	buffer1, buffer2, buffer3
	
pushad	
			
		mov		ecx, 15				;15
		mov		edx,  buffer1
		call	WriteString
		mov		edx,   buffer3
		call	ReadString
		mov		buffer2, eax
			
popad
		
ENDM



displayString MACRO  buffer				;code from Lecture CS271-400
	pushad
	mov		edx, buffer
	call	WriteString
	popad
ENDM

.code
 main PROC


	push	OFFSET intro1					; ebp + 24
	push	OFFSET intro2					;ebp + 20
	push	OFFSET instruct1			    ; ebp + 16
	push	OFFSET instruct2				; ebp + 12
	push	OFFSET instruct3				; ebp + 8 
	call	Introduction				
	call	CrLf

	push	OFFSET prompt1
	push	OFFSET error1					;ebp + 20
	push	OFFSET number						;ebp + 16
	push	OFFSET list					;ebp + 12
	push	OFFSET listSize					; ebp+ 8
	call	readVal						
	call	CrLf
	
	
	push	OFFSET spacing					;ebp + 20
	push	OFFSET listNumbers				;ebp + 16
	push	OFFSET list2					;ebp + 12
	push	OFFSET list						;ebp + 8
	call	writeVal
	call	CrLf
	
	
	push	OFFSET averageResults			;ebp + 16
	push	OFFSET sumResults				;ebp + 12
	push	OFFSET list						;ebp + 8
	call	findAverage
	call	CrLf





	call	CrLf
	push	OFFSET goodbye
	call	farewell

	exit
main ENDP





; Procedure: Introduction
; Description :	 Displays intro and instruction information to user
; Receives:			intro1, intro2, instruct1, instruct2, instruct3
; Returns:		     -
; Preconditions:	 strings need to be passed to procedure
; Registers Changed: - 

Introduction PROC
	push	ebp
	mov		ebp, esp


	displayString	[ebp+24]	;intro1
	call	CrLf
	
	displayString [ebp + 20]		;;intro2
	call	CrLf

	displayString	[ebp+16]		;instruct1
	call	CrLf

	displayString	[ebp+12]			;instruct2
	call	CrLf

	displayString	[ebp+8]				;instruct3
	call	CrLf

CleanStack:
	pop		ebp
	ret		20
	
Introduction ENDP




; Procedure: readVal
; Description :	Gets user input for integers and then stores them in list
; Receives:			 error1, number, list, listSize
; Returns:			 list is filled with values
; Preconditions:	 a list needs to exist and needs to be passed to procedure
; Registers Changed: edx, eax, ecx, ebx

readVal PROC

		push  ebp
		mov	  ebp, esp
		mov	  ecx, 15								
		mov	  edi, [ebp+12]							;list2

L1: 	
	
	mov		eax, 0
	mov		ebx, 0				
					
	getString [ebp+24], [ebp+8], [ebp+16]

	;ebp+8 list size, ebp + 24 prompt1, ebp+16 number

	
	mov		esi, [ebp+16]						
	mov		edx, [ebp+8]						
	push	ecx
	mov		ecx, edx				
	
					
	
	
L2:
	mov	eax, 0
	lodsb					;start of lodsb stosd cycle
	
	
Compare:							
	
	cmp		eax, MIN			;48	min
	jb		error		
	cmp		eax, MAX		    ;57  max
	ja		error		
							
	sub		eax, MIN			
	push	eax

	
	mov		eax, ebx
	mov		ebx, 10
	mul		ebx
	mov		ebx, eax
	pop		eax
	add		ebx, eax
	mov		eax, ebx
											

	loop	L2


EndInner:
		mov		eax,ebx 
		stosd							
		add		esi, 4					


		pop		ecx						
		loop	L1
		jmp		CleanStack
		
	error:
		pop		ecx
		displayString [ebp + 20]
		call	CrLf
		jmp		L1

CleanStack:
		pop ebp			
		ret 20					;16								
readVal ENDP




; Procedure: writeVal
; Description :		 Display values in list after converting to ascii
; Receives:			 list, list2, spacing, listNumbers
; Returns:			 -
; Preconditions:	 list needs to exist with values 
; Registers Changed: eax, ecx, ebx, edx,esi,edi


writeVal PROC
	push	ebp
	mov		ebp, esp
	
	mov		esi, [ebp + 12]				; list 2
	mov		edi, [ebp + 8]				; list1
	mov		ecx, 15		
	
	displayString [ebp+16]
	call	CrLf

	
	
	
L1:	
	mov		eax, [edi]
	push	ecx
	mov		ecx, 10    ;10        
	mov		ebx, 0 

;Converting to ASCI: keep dividing number by 10 and use the remainder as result then add ASCII 'O'/48/MIN

RemainderDiv:
	mov		edx, 0       ;get ready for remainder in edx			
	div		ecx						
	push	edx			; push remainder 
	inc		ebx						
	cmp		eax, 0				
	jnz		RemainderDiv				
	

	
	mov		ecx, ebx				  ;loop counter for filling list2
L2:
	pop		ebx
	add		ebx, MIN					  ; pop value from remainder convert each number to ASCII
	mov		[esi], ebx				  ; then write to list2  (value from original list) edi,esi exchange essentially
	


Display:
	displayString	[ebp +12]
	loop	L2
			
	
	
	pop		ecx
	displayString [ebp + 20]		;spacing between numbers


	add		edi, 4
	loop	L1
	
	
	


CleanStack:

	pop		ebp			
	ret		20									
writeVal ENDP


; Procedure:  findAverage
; Description :		Uses the values from early and sums them up, displays sum, and then displays average
; Receives:		 List, sumResults, averageResults, 
; Returns:			 No returns
; Preconditions:	 List needs to have actual values 
; Registers Changed: eax, ebx, ecx,esi

findAverage PROC
	push ebp
	mov  ebp, esp
	
	
	mov  esi, [ebp + 8]  					;list	
	mov	 eax, 0
	mov  ebx, 0 
	mov	 ecx, 15						; 10 was the total number of numbers entered
	

	summation:
		add		eax, [esi]									;looping through entire list summing up values
		add		esi, 4
		loop	summation
		
		displayString	[ebp+12]			;sumResults
		call	WriteDec
		call	CrLf
	

	
	average:
		mov		edx, 0
		mov		ebx, 10
		div		ebx
		displayString	[ebp+16]			;averageResults
		call	WriteDec
		call	CrLf

CleanStack:
		pop		ebp
		ret		12

findAverage  ENDP



; Procedure:   farewell
; Description : Display an ending message
; Receives:	 goodbye is received as a parameter
; Returns:			 -
; Preconditions: all other produres need to be finished
; Registers Changed: edx


farewell PROC
	
	push	ebp
	mov		ebp, esp
	
	displayString  [ebp+8]
	call	CrLf
	
	pop		ebp
	ret		4
	
farewell ENDP

exit
END main