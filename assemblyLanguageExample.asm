; Author:	Debra Wilkie			
; Description:  A program to create an array of random generated integers.
;	The program is introduced, the user is asked to enter a number between 10 and 200.
;	The program will generate that many numbers and then display them 10 per line.
;	The program will then calculate and display the median rounded value and then sort
;	the array in descending order and print the sorted list 10 per line.

INCLUDE Irvine32.inc

;upper and lower limits used as constants
MIN = 10
MAX = 200
LO = 100
HI = 999


.data
userNum		DWORD	?				;user number 
count		DWORD	?				;counter
intArray	DWORD	200 DUP(?)		;possible 200 count array
ptrArray	DWORD	OFFSET intArray	;pointer to intarray



programName		BYTE		"Sorting Random Integers ",0
programmerName	BYTE		"Programmed by Debra Wilkie",0
instruct1		BYTE		"This program generates random numbers in the range [100 ... 999], ", 0
instruct2		BYTE		"displays the original list, sorts the list, and calculates the ", 0
instruct3		BYTE		"median value.  Finally, it displays the sorted list in descending order.", 0
prompt1			BYTE		"How many numbers should be generated?  [10 ... 200]: ",0
error2			BYTE		"Invalid input.", 0
space1			BYTE		" ", 0
space2			BYTE		"  ", 0
spaces			BYTE		"    ", 0
print1  		BYTE		"The unsorted random numbers: ", 0
print2			BYTE		"The median is  ", 0
print3			BYTE		"The sorted list: ", 0	
exit1  			BYTE		"Results certified by Debra Wilkie.  Goodbye.", 0

extraCredit		BYTE		"**EC: Descrition:  Align the output columns.", 0
extraCredit2	BYTE		"Inside the isComposite loop is another nested loop to determine extra spaces needed.", 0


.code
main PROC

	call 	introduction	;introduce the program

	push	OFFSET userNum	;pass user number address, because we don't have a value yet
	push	MIN				;pass value of max
	push	MAX				;pass value of max
	call	getUserData		;get user number and check if it is in range
	
	call	Randomize
	mov	ecx, userNum
	push	OFFSET intArray	;pass array address
	push	userNum
	call	fillArray		;call the procedure to fill an array of random numbers

	push	OFFSET intArray
	push	userNum
	mov	edx, OFFSET print1
	call	WriteString
	call	Crlf
	call	displayArray	;call to print the array	

	call	sortArray		;bubble sort
		
	push	OFFSET intArray
	push	userNum
	call	FindMedian		;call to find median

	
	push	OFFSET intArray
	push	userNum
	mov	edx, OFFSET print3
	call	WriteString
	call	Crlf
	call	displayArray	;call to print the array	

	call	farewell		;goodbye messages

	exit					;exit to operating system	
main ENDP

;*****************************************************************************************
;Procedure to display program introductions and instructions
;receives: programName, programmerName, instruct1, 2 and 3
;returns: none
;preconditions: the above prompts need to be implemented
;registers changed: edx
;*****************************************************************************************

introduction	PROC

;Display progam name
	mov	edx, OFFSET programName		;set up for call to WriteString
	call	WriteString
;Display programmer's name
	mov	edx, OFFSET programmerName
	call	WriteString
	call	Crlf
	call	Crlf

;Display directions for user
	mov	edx, OFFSET instruct1		
	call	WriteString
	call Crlf
	mov	edx, OFFSET instruct2
	call	WriteString
	call	Crlf
	mov	edx, OFFSET instruct3
	call	WriteString
	call Crlf
	call Crlf

	ret
introduction ENDP

;*****************************************************************************************
;Procedure to prompt user to input number and 
;   validate the user number is within range(10, 200)
;receives: addresses of parameters on the stack
;returns: user input value
;preconditions: none
;registers changed: eax, edx
;******************************************************************************************

getUserData	PROC

	push	ebp				;Set up stack frame
	mov	ebp,esp
 
 ;get an integer from the user

	mov	ebx,[ebp+8]			;Put address of user number into ebx.
BeginAgain:
	mov	edx, OFFSET prompt1	;display prompt for user to enter number   
	call	WriteString		
	call	ReadInt
	mov	edi, [ebp+16]		;moves address of user number into edi			
	
	cmp	eax, [ebp+12]		;compare minimum value to user number in eax
	jb	reDoInput			;if less than min begin prompt again
	cmp	eax, [ebp+8]		;compare max value to user number in ebx
	ja	reDoInput
	jmp	finishInput	

reDoInput:
	mov	edx, OFFSET error2
	call	WriteString
	call	Crlf	
	jmp	BeginAgain

finishInput:
	call	Crlf		
	mov	[edi], eax		;store the user number into the userNum address	
	pop	ebp				;restore stack
	ret	16				;clear stack
getUserData	ENDP


;*****************************************************************************************
;Procedure to fill and array with user specified amount of random numbers
;   the random numbers must be within range(100, 999)
;   utilizing the demo5.asm code 
;receives: addresses of parameters on the stack, user input value
;returns: array of numbers
;preconditions: userNum
;registers changed: eax, ebx, ecx
;******************************************************************************************

fillArray		PROC
	
	;filling an array with random numbers
	push	ebp
	mov	ebp, esp
	mov	ecx, [ebp+8]		;userNum to use as a counter
	mov	edi, [ebp+12]		;address of the array
	
arrayLoop:
	mov	eax, 900			;setting the range for the random number
	call	RandomRange
	add	eax, 100		
	mov	[edi], eax
	add	edi, 4			;move to the next place in array
	cmp	ecx, 1			;compare counter to zero
	jle	arrayComplete
	loop	arrayLoop

arrayComplete:
	pop	ebp
	ret	8
fillArray		ENDP


;*****************************************************************************************
;Procedure to sort array with user specified amount of random numbers
;   array will be sorted in descending order.
;   utilizing the bubble sort code 
;receives: addresses of parameters on the stack, user input value
;returns: array of numbers
;preconditions: userNum
;registers changed: eax, ebx, ecx
;******************************************************************************************

sortArray		PROC
	
	mov ecx, UserNum
	dec	ecx					;outer loop counter, userNum-1

OuterLoop:
	push	ecx
	mov	esi, ptrArray		;address of array
			 
InnerLoop:
	mov	eax,[esi]			;move first number in array to eax
	cmp	[esi+4], eax		;compare first number with second
	jl	L3					;jump if less than, no swap
	xchg	eax, [esi+4]
	mov	[esi], eax			;make esi the next value in the array

L3:
	add	esi, 4				;move both pointers forward
	loop	InnerLoop

	pop	ecx					;get outer loop count
	loop	OuterLoop

LoopEnd:
	ret	
sortArray		ENDP

;*****************************************************************************************
;Procedure to search the array for and print the median 
;   utilizing the binary search code 
;receives: addresses of parameters on the stack, user input value
;returns: median
;preconditions: userNum
;registers changed: eax, ebx, ecx
;******************************************************************************************

FindMedian	PROC

	push	ebp
	mov	ebp, esp
	mov	edi, [ebp+12]	;address of the array
	mov	eax, [ebp+8]	;userNum to use as number of elements in the array
	cdq					
	mov	ebx, 2
	div	ebx				;divide by 2 to find the middle of the numbers
	shl	eax, 2			
	add	edi, eax			
	cmp	edx, 0			;if odd number the median is the middle number
	je	EvenNumber
	mov	eax, [edi]
	jmp	printMedian	

EvenNumber:
	mov	eax, [edi]		;even number take two values in the middle
	mov	eax, [edi-4]	;second value in the middle
	cdq
	mov	ebx, 2			;divide to find median
	div	ebx
		
printMedian:
	mov	edx,	OFFSET print2
	call	WriteString
	call	WriteDec
	call	Crlf
	call	Crlf

	pop	ebp
	ret 8
FindMedian	ENDP
	
;*****************************************************************************************
;Procedure to display array of random numbers
;   in unsorted and then sorted order
;   utilizing the demo5.asm code 
;receives: addresses of parameters on the stack, array
;returns: array of numbers
;preconditions: array
;registers changed: eax, 
;******************************************************************************************

displayArray		PROC

	push	ebp
	mov	ebp, esp
	mov	ebx, [ebp+8]		;userNum to use as a counter
	mov	edi, [ebp+12]		;address of the array
	mov	ecx, 0

Compare:
	mov	eax,	[edi]		
	call	WriteDec
	inc	ecx
	cmp	ecx, 10
	je	PrintNewLine
	mov	edx, OFFSET spaces	;inserting 3 spaces between numbers
	call	WriteString
	add	edi, 4
	dec	ebx
	cmp	ebx, 1
	jle	EndLoop
	jmp	Compare			;loop if more composites are needed
	
PrintNewLine:
	call	Crlf		;inserting new line
	mov	ecx, 0			;reset the print count to 0 for next print line
	jmp	Compare			;jump to compare loop to align output
				
EndLoop:
	call Crlf
	call	Crlf
	pop	ebp
	ret	8
displayArray		ENDP


;********************************************************************************************
;Procedure to display goodbye message
;receives: exit prompt
;returns: nothing
;preconditions: the above prompt need to be implemented
;registers changed: none
;*********************************************************************************************

farewell	PROC

	;Display goodbye with programmer's name
	mov	edx, OFFSET exit1
	call	WriteString
	call	Crlf
	call Crlf
	
	ret
farewell	ENDP

END main	
