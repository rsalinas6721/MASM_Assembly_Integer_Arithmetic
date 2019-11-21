TITLE Sorting Random Integers     (Project5.asm)

; Author: Ricky Salinas
; Last Modified: 18 November 2018
; OSU email address: salinari@oregonstate.edu
; Course number/section: CS271_400
; Project Number: #5                
; Due Date: 18 November 2018
; Description: This program generates random numbers in the range [100 .. 999], displays the original list, sorts the list, and calculates the median value. Finally, it displays the list sorted in descending order.

INCLUDE Irvine32.inc


; Constants are declared
; Used for array and random number limits
	MIN_LIMIT = 10
	MAX_LIMIT = 200
	LO = 100
	HI = 999

.data
		programTitle			BYTE	"Welcome to Sorting Random Integers!", 0
		programerName			BYTE	"Programmed by Ricky Salinas.", 0
		firstUserInstructions	BYTE	"This program generates random numbers in the range [100 .. 999],", 0
		secondUserInstructions	BYTE	"displays the original list, sorts the list, and calculates the", 0
		thirdUserInstructions	BYTE	"median value. Finally, it displays the list sorted in descending order.", 0
		enterNumbersPrompt		BYTE	"How many numbers should be generated? [10 .. 200]: ", 0
		errorPrompt				BYTE	"Invalid input", 0
		arraySize				DWORD	?
		list					DWORD	MAX_LIMIT	DUP(?)
		count					DWORD	0
		validated				BYTE	"Number is good!", 0
		spaces					BYTE	"   ", 0
		nextLine				DWORD	10
		unsorted				BYTE	"The unsorted random numbers: ", 0
		sorted					BYTE	"The sorted list: ", 0
		median					BYTE	"The median is ", 0
		evenNum					DWORD	2
		DWORDSize				DWORD	4

.code
	main PROC

; Procedure introduction called
		call	introduction


; Procedure Instruction called
		call	instructions
	

; Procedure Instruction called
		push	OFFSET arraySize
		call	getData


; Procedure fillArray called
		push	OFFSET list		
		push	arraySize	
		call	fillArray


; Procedure displayList called
		push	OFFSET unsorted 
		push	nextLine		
		push	OFFSET list		
		push	arraySize	
		call	displayList


; Procedure sortList called
		push	OFFSET list		
		push	arraySize		
		call	sortList


; Procedure findMedian called
		push	OFFSET median	
		push	DWORDSize		
		push	evenNum			
		push	OFFSET list		
		push	arraySize		
		call	findMedian


; Procedure displayList called
		push	OFFSET sorted
		push	nextLine		
		push	OFFSET list		
		push	arraySize		
		call	displayList

		exit
	main ENDP


; Introduction procedure uses the edx register.
; programTitle and programerName are displayed.

		introduction PROC
			mov		edx, OFFSET programTitle
			call	WriteString
			call	CrLf
			mov		edx, OFFSET programerName
			call	WriteString
			call	CrLf

; introduction procedure ends
		ret
		introduction ENDP






; Instructions procedure uses the edx register.
; Instructions for program are displayed

		instructions PROC
			mov		edx, OFFSET firstUserInstructions
			call	WriteString
			call	CrLf
			mov		edx, OFFSET secondUserInstructions
			call	WriteString
			call	CrLf
			mov		edx, OFFSET thirdUserInstructions
			call	WriteString
			call	CrLf
			call	CrLf

; instructions procedure ends	
		ret
		instructions ENDP






; getData procedure uses the edx, eax and ebx registers.
; Procedure takes in the user's input, and sets itt as the array size
; The number is validated using constant limits
	
		getData PROC
		push	ebp
		mov		ebp, esp

		retrieve: 
			mov		edx, OFFSET enterNumbersPrompt
			call	WriteString
			call	ReadInt
			cmp		eax, MIN_LIMIT
			jl		stateErrorPrompt
			cmp		eax, MAX_LIMIT
			jg		stateErrorPrompt
			jmp		numberValidated

		stateErrorPrompt:
			mov		edx, OFFSET errorPrompt
			call	WriteString
			call	CrLf
			jmp		retrieve

		numberValidated:
			mov		ebx, [ebp+8]
			mov		[ebx], eax
			pop		ebp

		ret		4
		getData ENDP






; fillArray procedure uses the ecx and eax registers.
; Procedure takes the array size value and array as reference
; The procedure runs throught the array, adding random numbers to array.

		fillArray PROC
		push	ebp
		mov		ebp, esp
		call	Randomize
		mov		esi, [ebp+12]
		mov		ecx, [ebp+8]
		mov		eax, HI
		sub		eax, LO
		inc		eax

		addNumbers:
			call	RandomRange
			add		eax, LO
			mov		[esi], eax
			add		esi, 4
			loop	addNumbers
			pop		ebp

		ret		8
		fillArray ENDP






; displayList procedure uses the ecx, ebx, edx, and eax registers.
; Procedure takes the array size value and array as reference.
; The procedure runs throught the array, and displays the numbers of the array.

		displayList PROC
		push	ebp
		mov		ebp, esp
		mov		esi, [ebp+12]
		mov		ecx, [ebp+8]
		mov		ebx, 1

; Title is declared
		call	CrLf
		mov		edx, [ebp+20]
		call	WriteString
		call	CrLf

; Numbers are displayed
; Output in ebx is compared to value 10.
; Skips line if greater
		displayNumber:
			cmp		ebx, [ebp+16]
			jg		skipLine
			mov		eax, [esi]
			call	WriteDec
			mov		edx, OFFSET spaces
			call	WriteString
			add		esi, 4
			add		ebx, 1
			loop	displayNumber
			jmp		done

; Program goes to next line. 
; ebx is set to 1, and jumps back to beggining of loop
		skipLine:
			call	Crlf
			mov		ebx, 1
			jmp		displayNumber

		done:
			call	CrLf
			pop		ebp
		
		ret		16
		displayList ENDP






; sortList procedure uses the ecx, ebx, edx, and eax registers.
; Procedure sorts the array from largest to smallest
; The procedure uses two loops, one using ecx, and another using ebx.
; Procedure uses bubble sorting method to compare two values throughout the array.
	
		sortList PROC
		push	ebp
		mov		ebp, esp
		mov		esi, [ebp+12]
; ecx is decreased by one considering to take account the number of comparisons
		mov		ecx, [ebp+8]
		dec		ecx

; current value of ecx is compied to ebx
		outerLoop:
			mov		ebx, ecx

; Two values are compared. 
; If the second value is larger than the first, they are swaped. 
; 4 is added to esi and sent back to the beggining of the loop to run through the array.
		compareValues:
			mov		eax, [esi]
			cmp		eax, [esi+4]
			jg		runThrough
			xchg	eax, [esi+4]
			mov		[esi], eax									

; Loop cotinues until ebx is equal to 0
; Inner loop ends
		runThrough:
			add		esi, 4
			dec		ebx
			cmp		ebx, 0
			je		skip
			jmp		compareValues

; Beggining of the array is copied to esi and the loop is run again until all of the values have been sorted.
		skip:
		mov		esi, [ebp+12]
		loop	outerLoop

		pop		ebp
		ret		8
		sortList ENDP






; findMedian procedure uses the ecx, ebx, edx, and eax registers.
; Procedure takes the array size value and array as reference.
; The procedure identifies whether the array size is even or odd. 
; If the array is odd, it displays the number in the center
; If array is even, the average of the two centermost values are calculated and displayed. 

			findMedian PROC

		push	ebp
		mov		ebp, esp
		mov		esi, [ebp+12]

; Title is displayed
		call	CrLf
		mov		edx, [ebp+24]
		call	WriteString

; ecx and edx registers are cleared
		mov		ecx, 0
		mov		edx, 0

; Array Size is divided by two.
; Remainder is compared to 0.
; Jumps to either even or odd labels
		mov		eax, [ebp+8]
		mov		ebx, [ebp+16]
		div		ebx
		cmp		edx , 0
		je		evenNumber
	
; Number in center is identified and displayed
; This is done using value of at eax after the previous division
		oddNumber:
			mov		ebx, [ebp+20]
			mul		ebx
			mov		ecx, [esi+eax]
			mov		eax, ecx
			call	WriteDec
			jmp		done

; Two centermost numbers are averaged out and displayed
; eax is used with the DWORDSize to run differenciate between two vaulues within the array
		evenNumber:
			mov		ebx, [ebp+20]
			mul		ebx
			mov		ecx, [esi+eax]
			sub		eax, [ebp+20]
			add		ecx, [esi+eax]
			mov		eax, ecx
			mov		ebx, [ebp+16]
			div		ebx
			call	WriteDec
			
		done:
			call	CrLf
			pop		ebp
		
		ret		20
		findMedian ENDP

END main
