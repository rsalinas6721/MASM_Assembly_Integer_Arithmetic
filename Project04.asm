TITLE Composite Numbers    (Project4.asm)

; Author: Ricky Salinas
; Last Modified: 4 November October 2018
; OSU email address: salinari@oregonstate.edu
; Course number/section: CS271
; Project Number: #4
; Due Date: 4 November 2018
; Description: This Program Prints Out A Requested Number Of Composite Numbers  1-400.

INCLUDE Irvine32.inc

		MIN_LIMIT = 1 ; Constant Limit Minimum Is Set
		MAX_LIMIT = 400 ; Constant Limit Maximum Is Set

.data
		programTitle			BYTE	"Welcome to Composite Numbers!", 0
		programerName			BYTE	"This program was written by Ricky Salinas.", 0
		userInstructionsOne		BYTE	"Enter the number of composite numbers you would like to see.", 0
		userInstructionsTwo		BYTE	"I'll accept orders for up to 400 composites.", 0
		enterNumbersPrompt		BYTE	"Enter the number of composites to display [1 .. 400]: ", 0
		errorPrompt				BYTE	"Out of range. Try again.", 0
		goodbye					BYTE	"Results certified by Ricky. Goodbye.", 0
		input					DWORD	?
		currentNumber			DWORD	4
		otherNumber				DWORD	?
		space					BYTE	"     ", 0
		divisible				DWORD	10
		output					DWORD	0
		singleSpace				BYTE	" ", 0

.code
	main PROC

; The four requried procedures are called

		call	introduction
		call	getUserData
		call	showComposites
		call	farewell
		exit

	main ENDP

; Introduction procedure begins with the message prompting the user to the title of the program and the programmer's name.
; Instructions for the program are then displayed. 

	introduction PROC

; programTitle and programerName are displayed.
			mov		edx, OFFSET programTitle
			call	WriteString
			call	CrLf
			mov		edx, OFFSET programerName
			call	WriteString
			call	CrLf

; Instructions are displayed
			mov		edx, OFFSET userInstructionsOne
			call	WriteString
			call	CrLf
			mov		edx, OFFSET userInstructionsTwo
			call	WriteString
			call	CrLf

; introduction procedure ends	
		ret
	introduction ENDP

; getUserData procedure begins with the message prompting the user to enter a number between 1 and 400.
; The number is then validated to make sure it is less than or equal to 400. 
; If number passes that validation, it procedes through another form of validation to make sure the number is greater than 1. 
; If at any point, the user fails to enter the orrect number, an error message is displayed and the user is sent back to the promptUser label.
	getUserData PROC

		prompt:
			mov		edx, OFFSET enterNumbersPrompt
			call	WriteString
			call	ReadInt
			mov		input, eax
			call	CrLf

; Maximum Limit Checked
			mov		ebx, MAX_LIMIT
			cmp		eax, ebx						
			jle		maxLimit
			mov		edx, OFFSET errorPrompt
			call	WriteString
			call	CrLf
			jmp		prompt

; Minimum Limit Checked
		maxLimit:
			mov		ebx, MIN_LIMIT
			mov		eax, input
			cmp		eax, ebx
			jge		inputPass
			mov		edx, OFFSET errorPrompt	
			call	WriteString
			call	CrLf
			jmp		prompt

; Validation Complete
		inputPass:

; End getUserData Procedure
		ret
	getUserData ENDP


; showComposites Procedure is initialized
	showComposites PROC
			
; This procedure takes the user input and sets it as ecx for a loop count. 
; The setNumbers label is then created and currentNumber 4 is initialized. 
; The procedure then sets otherNumber as (currentNumber-1)
; Program then divides currentNumber by otherNumber to dind a remainder of 0.
; If the result does not equal to 0, otherNumber is subtracted by 1 and once again divides currentNumber
; This continues until otherNumber reaches 1. 
; If no value with a remainder of 0 was found, the number is a prime and discarded. 
; current Number is incremented by 1 and the process is continued again. 
; If a composite number is found, the number is displayed, and currentNumber is incremented. 
; Loop continues until the number specified by the user is displayed.

			mov		ecx, input

; Sets currentNumber and otherNumber
		setNumbers:
			mov		eax, currentNumber
			mov		otherNumber, eax
			mov		ebx, otherNumber
			jmp		isComposite			
		
; otherNumber is subtracted by 1.
; pprogram searches for remainder of 0.
; program jumps to increaseCurrentNumber label if unsuccessful.
		isComposite:
			mov		eax, otherNumber
			sub		ebx, 1
			cmp		ebx, 1
			je		increaseCurrentNumber
			mov		edx, 0
			div		ebx
			cmp		edx, 0
			je		printComposite
			jmp		isComposite

; Composite number is printed if found.
		printComposite:

			mov		eax, currentNumber
			call	WriteDec
			mov		edx, OFFSET space	
			call	WriteString

; A new line is set after 10 composite numbers are displayed.
			mov		edx, 0   
			add		output, 1
			mov		eax, output
			mov		ebx, divisible
			div		ebx
			;mov	eax, edx
			cmp		edx , 0
			jne		skip
			call	CrLF
		skip:
			add		currentNumber, 1
			jmp		endloop

; currentNumber is added by one in search of composite number.
		increaseCurrentNumber:
			add		currentNumber, 1
			jmp		setNumbers

; loop ends
		endloop:
			loop setNumbers

; showComposites procedure ends
		ret
	
	showComposites ENDP


; farewell PROC Procedure is initialized
	farewell PROC

; User is told goodbye
			call CrLf
			mov	edx, OFFSET goodbye
			call Writestring
			call CrLf

; farewell procedure ends	
		ret
	
	farewell ENDP

	END main