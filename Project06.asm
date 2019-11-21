TITLE Designing low-level I/O Procedures     (Project_6A.asm)

; Author: Ricky Salinas
; Last Modified: 2 December 2018
; OSU email address: salinari@oregonstate.edu
; Course number/section: CS_271_400
; Project Number: 6A      
; Due Date: 2 December 2018
; Description: This program takes in 10 valid integers from the user and stores the numeric values in anarray. The program then displays the integers, their sum, and their average.

INCLUDE Irvine32.inc


; ------------------------------------------------------------------------------

; This macro takes in the address of a string and displays the string. 
; Uses the register edx

displayString		MACRO		address
	
	push	edx
		mov		edx, address
		call	writeString
		pop	edx
ENDM


; ------------------------------------------------------------------------------
; This macro takes in the address of a string and a value taken in by the user. 
; Uses the register edx and ecx
; This portion of the program was taken from the lectures

getString		MACRO		promptAddress, Input
	push	edx
	push	ecx

	mov		edx, promptAddress
	call	writeString
	mov		edx, OFFSET Input
	mov		ecx, (SIZEOF Input) -1
	call	ReadString
	
	pop		ecx
	pop		edx

ENDM


; ------------------------------------------------------------------------------

.data

		listNumbers			DWORD	10 DUP(?)																				; Arrray used to keep user's input
		userInput			BYTE	20 DUP(?)																				; String used to keep user's input
		averageString		BYTE	20 DUP(?)																				; String used to keep average string
		sumString			BYTE	20 DUP(?)																				; String used to keep sum string

		sum					DWORD	0																						; number used to keep sum value
		average				DWORD	0																						; number used to keep average value
		counterLoop			DWORD	0																						; number used as a counter loop
		number				DWORD	?																						; number used as a temp value
		ten					DWORD	10																						; number used toaverage and convert numbers to string 
		four				DWORD	4																						; number used to run through array
		total				DWORD	?																						; number used to keep track of values in readVal procedure

		programTitle		BYTE	"PROGRAMMING ASSIGNMENT 6: Designing low-level I/O Procedures", 0
		programedBy			BYTE	"Written by: Ricky Salinas", 0
		firstInstructions	BYTE	"Please provide 10 unsigned decimal integers.", 0
		secondInstructions	BYTE	"Each number needs to be small enough to fit inside a 32 bit register.", 0
		thirdInstructions	BYTE	"After you have finished inputting the raw numbers I will display a list", 0
		fourthInstructions	BYTE	"of the integers, their sum, and their average value.", 0
		numberPrompt		BYTE	"Please enter an unsigned number: ", 0
		errorPrompt			BYTE	"ERROR: You did not enter an unsigned number or your number was too big.", 0
		tryAgainPrompt		BYTE	"Please try again: ", 0
		userNumbersPrompt	BYTE	"You entered the following numbers: ", 0
		sumPrompt			BYTE	"The sum of these numbers is: ", 0
		averageprompt		BYTE	"The average is: ", 0
		farewellMessage		BYTE	"Thanks for playing!", 0
		spaces				BYTE	", ", 0

.code
main PROC
; ------------------------------------------------------------------------------

push	OFFSET		programTitle
push	OFFSET		programedBy
call	introduction

; ------------------------------------------------------------------------------

push	OFFSET		firstInstructions
push	OFFSET		secondInstructions
push	OFFSET		thirdInstructions
push	OFFSET		fourthInstructions
call	instructions

; ------------------------------------------------------------------------------

push				four
push				total
push				ten
push				counterLoop
push	OFFSET		tryAgainPrompt
push	OFFSET		errorPrompt
push	OFFSET		numberPrompt
push	OFFSET		userInput
push	OFFSET		listNumbers
call	readVal

; ------------------------------------------------------------------------------

push				number
push	OFFSET		averageString
push	OFFSET		sumString
push				average
push				sum
push	OFFSET		spaces
push	OFFSET		averagePrompt
push	OFFSET		sumPrompt
push	OFFSET		userNumbersPrompt
push	OFFSET		listNumbers
push				ten
call	writeVal

; ------------------------------------------------------------------------------

	push	OFFSET farewellMessage
	call	goodbye

	exit
main ENDP

; ------------------------------------------------------------------------------  introduction PROC
; The introduction procedure displays the programer's name and program title.
; Registeres used: edx

		introduction PROC
			push	ebp
			mov		ebp, esp

			mov		edx, [ebp+12]
			call	WriteString
			call	CrLf
			mov		edx, [ebp+8]
			call	WriteString
			call	CrLf
			call	CrLf
		pop ebp

		ret 8
		introduction ENDP

; ------------------------------------------------------------------------------  introduction PROC



; ------------------------------------------------------------------------------  instructions PROC

; The instructions procedure displays the instructions of the program.
; Registeres used: edx

		instructions PROC
			push	ebp
			mov		ebp, esp

			mov		edx, [ebp+20]
			call	WriteString
			call	CrLf
			mov		edx, [ebp+16]
			call	WriteString
			call	CrLf
			mov		edx, [ebp+12]
			call	WriteString
			call	CrLf
			mov		edx, [ebp+8]
			call	WriteString
			call	CrLf
			call	CrLf

			pop ebp
		ret 16
		instructions ENDP

; ------------------------------------------------------------------------------  instructions PROC



; ------------------------------------------------------------------------------  readVal PROC

; The readVal procedure requests 10 integers from the user and convverts the numbers into strings. 
; The user's entered values are validated to make sure they are not too large and are an unsigned integer
; The program then converts each number into its cooresponding string value
; Carry flag is used to check integer size
; The numbers are then loaded into an array named ListNumbers for to keep track of the 10 numbers
; The procedure continues to run using a loop counter of 10 and the ebx register
; The conditions for this prcedure to run correctly is the correct input of the 10 unsigned integers
; Registeres used: eax, ebx, ecx, edx, esi


		readVal PROC
		
			push	ebp
			mov		ebp, esp

; The initial portion of the loop uses the getString macro to retrieve the user's input
; The program then jumps to validation after the macro retrieves the user's value

topLoop:
			getString	[ebp+16], userInput
			mov		ebx, 0
			mov		[ebp+36], ebx
			jmp		validate

; The rerun loop is used whenever avalue is either not an integer or too large
; The getstring macro is used again along with the location where the user's input sill be located
runAgainLoop:
			mov		edx, [ebp+20]
			call	writeString
			call	CrLf
			getString	[ebp+24], userInput
			mov		ebx, 0
			mov		[ebp+36], ebx

; The program then validates the user's input after recieving the values from getstring
; ESI is used to point to the user's input before running through the validateNumber loop
; lodsb is used to pull each byte from user input and convert it to a numeric number
; If the number fails to validate, it jumps to the runAgainLoop label where an error prompt is displayed.
; Once a number passes the validation, it is added to the listNumbers array where the numeric values are located. 

validate:

			mov		ecx, eax
			mov		ebx, eax
			mov		esi, [ebp+12]

validateNumber:
				lodsb
				cmp		eax, 48
				jl		failValidation
				cmp		eax, 57
				jg		failValidation
				sub 	eax, 48
				mov		ebx, eax
				mov		eax, [ebp+36]
				mov		edx, [ebp+32]
				mul		edx
				jc		failValidation
				add		eax, ebx
				jc		failValidation
				mov		[ebp+36], eax
				mov		eax, 0
			loop	validateNumber
			mov		eax, [ebp+36]
			jmp		passValidation

failValidation:
			jmp	runAgainLoop

passValidation:
			mov		edx, OFFSET userInput
			mov		esi, [ebp+8]
			mov		eax, [ebp+28]
			mov		edx, [ebp+40]
			mul		edx
			mov		ebx, [ebp+36]
			mov		[esi+eax], ebx

; Validation complete, Number is loaded into ListNumbers array
; A loop counter runs through entire procedure ten times.
; EBX is used to keep this count

			mov			ebx, 0
			mov			ebx, [ebp+28]
			add			ebx, 1
			cmp			ebx, 10
			je			endLoop
			mov			[ebp+28], ebx

jmp topLoop

endLoop:
		call	CrLf
		pop ebp
		ret 36

		readVal ENDP


; ------------------------------------------------------------------------------  readVal PROC
		
			   
     
; ------------------------------------------------------------------------------  writeVal PROC

; The writeVal procedure convverts the SUM and AVGERAGE of the user's 10 numbers into strings. 
; Registeres used: eax, ebx, ecx, edx, esi
; The first part of this procedure calculates the SUM and AVERAGE for the values
; The values are also displayed with a comma between the values
; The SUM and AVG are then converted to String values and displayed using the display String macro. 
; The conditions for the procedure to run correctly retrieving the 10 unsigned integers into the cooresponding array.
; The procedure takes the array of values and runs through its process. 


	writeVal PROC
		push	ebp
		mov		ebp, esp
			
				mov		esi, [ebp+12]
				mov		ecx, [ebp+8]
				displayString [ebp+16]
				call	CrLf
	
; Numbers are Displayed
				displayNumber:
				mov		eax, [esi]
				call	WriteDec
				cmp		ecx, 1
				je		endLine
; Comma is used
; After 9 values are displayed, comma is not used
; Program jumps to endLine
				displayString [ebp+28]
				endLine:	
				add		esi, 4
				loop	displayNumber

; Calculations are made
; SUM and AVG are found
				mov		eax, 0
				mov		ebx, 0
				mov		esi, [ebp+12]
				mov		ecx, [ebp+8]

				calculations:
				mov		eax, [esi]
				add		ebx, eax
				add		esi, 4
				loop calculations

; Sum is found
				mov	eax, ebx
				mov [ebp+32], eax
				mov		ebx, 0
				mov		ebx, [ebp+8]
				div		ebx
; AVG is found
				mov [ebp+36], eax
				call	CrLf
				call	CrLf

; The procedure then continues to convert the numbers to a string
; The process is used for the SUm and dislayed, 
; The same process is then used for AVG and displayed
; The procedure uses stosb to divide the values by 10
; Since the numbers have to be reversed, when converting a string, the push/pop process had to be used
; The calculations were made, and the remainder edx was pushed for later, increasing ecx each time
; The numbers were then popped looping through the process using the ecx register. 

;  SUM CONVERSION
				mov	eax, [ebp+32]
				mov	ebx, 10
				mov	ecx, 0
				divisionSum:
				cdq
				div		ebx
				push	edx
				inc		ecx
				cmp		eax, 0
				je		skipSum
				jmp		divisionSum
		
				skipSum:
				mov	edi, [ebp + 40]

				convertSum:
				pop	[ebp+48]
				mov	eax, [ebp+48]
				add	eax, 48
				stosb
				loop	convertSum

				displayString [ebp+20]
				displayString [ebp+40] 
				call	CrLf

;  SUM CONVERSION

;  AVG CONVERSION
				mov	eax, [ebp+36]
				mov	ebx, 10
				mov	ecx, 0
				mov	edx, 0
				divisionAVG:
				cdq
				div		ebx
				push	edx
				inc		ecx
				cmp		eax, 0
				je		skipAVG
				jmp		divisionAVG
		
				skipAVG:
				mov	edi, [ebp + 44]

				convertAVG:
				pop	[ebp+48]
				mov	eax, [ebp+48]
				add	eax, 48
				stosb
				loop	convertAVG

				displayString [ebp+24]
				displayString [ebp+44] 
				call	CrLf
;  AVG CONVERSION


		pop		ebp
		ret		44
		writeVal ENDP  


; ------------------------------------------------------------------------------  writeVal PROC


 
; ------------------------------------------------------------------------------  goodbye PROC

; Program says goodbye
; PRocedure uses edx register

goodbye		PROC
			push	ebp
			mov		ebp, esp
				mov		edx, [ebp+8]
				call	WriteString
				call	CrLf

			pop ebp
	ret 4

goodbye		ENDP
; ------------------------------------------------------------------------------  goodbye PROC


; (insert additional procedures here)

END main
