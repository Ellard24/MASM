;Ellard Gerritsen van der Hoop
;gerritse@oregonstate.edu
; CS271-400 
;Assignment 5
; 11/22/15



TITLE Sorting Random Integers   (assignment5.asm)

; Author: Ellard 
; Course / Project ID : CS271-400/Program 5             Date 11/22/15
; Description: This program prompts user for number of elements in array, fills the array with random integers, sorts the array, finds the median, then prints out the array.

INCLUDE Irvine32.inc

MIN = 10
MAX = 200
LO = 100
HI = 999


; (insert constant definitions here)

.data
	intro1	BYTE	"Sorting Random Integers                     Programmed by Ellard Gerritsen", 0
	intro2	BYTE	"This program generates random numbers in the range [100-999], displays the original list, sorts the list(descending order), and calculates the median value.", 0


	prompt1	BYTE	"How many numbers should be generated? [10...200]", 0
	error1	BYTE	"Input was Invalid. Try again", 0 
	array1	BYTE	"The unsorted list:", 0
	median1 BYTE	"The median is ", 0
	array2	BYTE	"The sorted list:", 0
	bye1	BYTE	"And that's that. Goodbye :D ", 0
	request	DWORD	?
	list	DWORD	MAX DUP(?)
	range	DWORD	?
	spacing	BYTE	"   ",0

; (insert variable definitions here)

.code
main PROC


	call introduction
	call Randomize
	
	push OFFSET request
	call getData

	push request			;by value
	push OFFSET list
	call fillArray

	push request
	push OFFSET list
	push OFFSET array1
	call displayList
	
	push request
	push OFFSET list
	call sortList

	push request
	push OFFSET list
	push OFFSET	array2
	call displayList		;to show sorted list


	push request
	push OFFSET list
	call displayMedian	
	
	call farewell


	exit	; exit to operating system
main ENDP



;Procedure greets user and displays instructions 
;receives: All values used are from global variables
;returns:  
;preconditions: Program started
;registers changed: edx
introduction PROC
	mov		edx, OFFSET intro1
	call	WriteString
	call	CrLf
	mov		edx, OFFSET intro2
	call	WriteString
	call	CrLf



	ret
introduction ENDP


;Procedure that gets user input on how many elements they want in array
;receives: list and request
;returns:  request's new value
;preconditions: 
;registers changed: ebx, eax, edx
getData	PROC
	
	push	ebp				;set up the stack frame 
	mov		ebp, esp 
	

Data1:	
	mov		ebx, [ebp+8]				; request is at ebp +8
	mov		edx, OFFSET prompt1
	call	WriteString
	call	CrLf
	call	ReadInt
	cmp		eax, MIN
	jb		Error	
	cmp		eax, MAX
	ja		Error
	jmp		Valid

Error:
	mov		edx, OFFSET error1
	call	WriteString
	call	CrLf
	jmp		Data1

Valid:
	mov		[ebx], eax 
	pop		ebp					;return Base Pointer to what it was before procedure

	ret		4					;4 bytes
getData	ENDP



;Procedure that fills the list array with random values between the limits 
;receives: list and request 
;returns:  The array list with values 
;preconditions: Size of array must be declared by user
;registers changed: esi, ecx, eax, 
fillArray PROC
	push	ebp
	mov		ebp, esp
	mov		esi, [ebp+8]		;list
	mov		ecx, [ebp+12]		; request acts as the counter 

	mov		eax, HI
	sub		eax, LO
	inc		eax
	mov		range, eax        ;range = hi - lo + 1  (Lecture 20)
	

Fill:
	mov		eax, range
	call	RandomRange
	add		eax, LO
	mov		[esi], eax
	add		esi, 4
	loop	Fill


	pop		ebp
	ret		8

fillArray ENDP


;Procedure that sorts the array in descending order
;receives: List and request are received
;returns:  Sorted list values
;preconditions: Array must be filled.
;registers changed: ecx, eax, esi
sortList	PROC										;Bubble sort algorithm frm Irvine Chapter 9
	push	ebp
	mov		ebp, esp 
		
	mov		ecx, [ebp+12]
	dec		ecx

L1: push	ecx
	mov		esi, [ebp+8]

L2: mov		eax,[esi]
	cmp		[esi+4], eax
	jb		L3
	xchg	eax,[esi+4]
	mov		[esi],eax


L3:	add		esi, 4
	loop	L2

	pop		ecx
	loop	L1

L4:	
	pop		ebp
	ret		8

sortList	ENDP


;Procedure that displays the values in the array
;receives: list and request and array1
;returns:  Displayed list
;preconditions: Array should be filled with values 
;registers changed: edx,ecx, ebx, eax, esi
displayList		PROC
	push	ebp
	mov		ebp, esp

	mov		esi, [ebp+12]		;list
	mov		ecx, [ebp+16]		; request acts as the counter 
	mov		ebx, 1				;tracks newline requirements	


	mov		edx, [ebp+8]
	call	WriteString
	call	CrLf



Display:
	mov		eax, [esi]
	call	WriteDec


	mov		edx, OFFSET spacing
	call	WriteString


	cmp		ebx, 10
	je		Newline
	inc		ebx
	add		esi, 4
	loop	Display
	jmp		End1


NewLine:
	mov		ebx, 1
	call	CrLf
	add		esi,4
	loop	Display

End1:
	pop		ebp
	call	CrLf
	call	CrLf
	call	CrLf
	ret		12

displayList		ENDP



;Procedure that calculates the median of the array values. 
;receives: list and request are received 
;returns: The median value of the array 
;preconditions: Array must be filled and sorted. 
;registers changed: eax, esi, edx, ebx, ecx



displayMedian PROC
	push	ebp
	mov		ebp, esp
	mov		edx, OFFSET median1
	call	WriteString
	
	mov		eax, [ebp+12]			;request
	mov		esi, [ebp+8]			;list
	mov		edx, 0
	mov		ebx, 2
	div		ebx

	cmp		edx, 0
	je		EvenNum
	jmp		OddNum
	
EvenNum:
	mov		ecx, eax
	dec		ecx
	
Loop1:
	add		esi, 4
	loop	Loop1

	mov		eax, [esi]
	mov		ebx, [esi+4]
	add		eax, ebx
	mov		ebx, 2
	mov		edx, 0
	div		ebx
	call	WriteDec
	call	CrLf
	jmp		continue

OddNum:
	mov		ecx, eax

Loop2:
	add		esi,4
	loop	Loop2

	
	mov		eax, [esi]
	call	WriteDec	
	call	CrLf


continue:
	pop		ebp
	ret		8
displayMedian	ENDP






;Procedure thats a farewell message 
;receives: All values used are from global variables
;returns:  Farewell message
;preconditions: All other procedures should have called already 
;registers changed: edx


farewell PROC
	mov		edx, OFFSET bye1
	call	WriteString
	call	CrLf

	ret
farewell ENDP



END main