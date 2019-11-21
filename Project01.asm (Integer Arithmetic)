TITLE Project 1     (Projecct01.asm)

; Author: Ricky Salinas
; Last Modified: 7 October 2018
; OSU email address: salinari@oregonstate.edu
; Course number/section: CS 271_400
; Project Number: #1               
; Due Date: 7 October 2018
; Description: Write and test a MASM program to perform the following tasks:
	; 1. Display your name and program title on the output screen.
	; 2. Display instructions for the user.
	; 3. Prompt the user to enter two numbers.
	; 4. Calculate the sum, difference, product, (integer) quotient and remainder of the numbers.
	; 5. Display a terminating message. 
; I decided to go with option 2 and option 1 for practice

INCLUDE Irvine32.inc

.data 
; Data Used For Program Is Initialized

		programName			BYTE	"Hi, my name is Ricky.", 0
		programTitle		BYTE	"This program will calculate the sum, difference, product, (integer) quotient and remainder of two numbers!", 0
		instructions		BYTE	"You will now be asked for two numbers to find the required calculations.", 0
		rule				BYTE	"Please make sure the first number is larger than the second number.", 0
		instructionsOne		BYTE	"Please enter the first number: ", 0
		instructionsTwo		BYTE	"Please enter the second number: ", 0
		impressed			BYTE	"Impressed? Bye!", 0
		extraCredit			BYTE	"**EC: Program verifies second number less than first, and repeats until the user chooses to quit.", 0
		numberOne			DWORD	?
		numberTwo			DWORD	?
		sum                 DWORD   ?
		difference			DWORD   ?
		product				DWORD   ?
		quotient			DWORD   ?
		remainder           DWORD   ?
		userInput			DWORD	?
		equalsSign			BYTE   " = ", 0
		sumSign		        BYTE	" + ",0
		differenceSign		BYTE	" - ",0
		productSign			BYTE	" * ",0
		quotientSign		BYTE	" / ",0
		remainderSign		BYTE	" Remainder ",0
		terminatingMessage	BYTE	"Goodbye! Please Run This Program Again Anytime!", 0
		errorMessage		BYTE	"The Second Number Cannot Be Greater Than The First!", 0
		continueRunning		BYTE	"Please Enter A 1 To Run Program Again Or A 0 To Exit.", 0

.code
main PROC
		; Programer Is Introduced
		; 
		; Instructions Are Displayed
			mov		edx, OFFSET programName		; Programer Introduced
			call	WriteString
			call	CrLf
			mov		edx, OFFSET extraCredit		; Extra Credit Information Is Displayed
			call	WriteString
			call	CrLf
			mov		edx, OFFSET programTitle	; Program Title And Purpose Is Stated
			call	WriteString
			call	CrLf
			mov		edx, OFFSET instructions	; Program Instructions Are Displayed
			call	WriteString
			call	CrLf
			mov		edx, OFFSET rule			; Program Rule Is Displayed
			call	WriteString
			call	CrLf


loopTop: ; Jump loopTop Is Initialized In Case User Wants To Run Program Again

		; User Is Prompted For Two Numbers.
		; These Numbers Are Then Initialized As Variables
			mov		edx, OFFSET instructionsOne
			call	WriteString
			call	ReadInt
			mov		numberOne, eax				; First Number Is Recieved And Initialized as numberOne
			mov		edx, OFFSET instructionsTwo 
			call	WriteString
			call	ReadInt
			mov		numberTwo, eax				; Second Number Is Recieved And Initialized as numberTwo

		; Numbers Are Compared
		; If The Seond Number Is Less Than The First, The Program Jumps To calculations And The Code Following Is Ignored
		; Else, The Program Produces An Error Message
		; 
			mov		eax, numberTwo
			cmp		eax, numberOne
			jle		calculations
			mov		edx, OFFSET errorMessage
			call	WriteString
			call	CrLf
			jmp		programEnd					; Program Jumps To programEnds Where User Is Asked To ReRun Program
	
calculations: ; Jump calculations Is Initialized
		; Sum Is Calculated
		    mov		eax, numberOne
			mov		ebx, numberTwo
			add		eax, ebx
			mov     sum, eax					; sum Is Calculated, Moved To sum
	
		; Difference Is Calculated
		    mov		eax, numberOne
			mov		ebx, numberTwo
			neg		ebx
			add		eax, ebx
			mov     difference, eax				; difference Is Calculated, Moved To difference
	
		; Product Is Calculated
			mov		eax, numberOne
			mov		ebx, numberTwo
			mul		ebx
			mov		product, eax				; product Is Calculated, Moved To product
	
		; Quotient Is Calculated
			mov		edx, 0
			mov		eax, numberOne
			mov		ebx, numberTwo
			div		ebx
			mov		quotient, eax
			mov		remainder, edx				; quotient Is Calculated, Moved To quotient
	
		; Sum Is Displayed             
			mov     eax, numberOne
			call	WriteDec              
			mov     edx, OFFSET sumSign
			call	WriteString              
			mov     eax, numberTwo
			call	WriteDec
			mov     edx, OFFSET equalsSign              
			call	WriteString
			mov     eax, sum              
			call	WriteDec
			call	CrLf
		
		; Difference Is Displayed               
			mov		eax, numberOne
			call	WriteDec              
			mov		edx, OFFSET differenceSign
			call	WriteString              
			mov		eax, numberTwo
			call	WriteDec
			mov		edx, OFFSET equalsSign              
			call	WriteString
			mov		eax, difference             
			call	WriteDec	
			call	CrLf

		; Product Is Displayed              
			mov		eax, numberOne
			call	WriteDec              
			mov		edx, OFFSET productSign
			call	WriteString              
			mov		eax, numberTwo
			call	WriteDec
			mov		edx, OFFSET equalsSign              
			call	WriteString
			mov		eax, product             
			call	WriteDec
			call	CrLf

		; Division Is Displayed               
			mov		eax, numberOne
			call	WriteDec              
			mov		edx, OFFSET quotientSign
			call	WriteString              
			mov		eax, numberTwo
			call	WriteDec
			mov		edx, OFFSET equalsSign              
			call	WriteString
			mov		eax, quotient             
			call	WriteDec
			mov		edx, OFFSET remainderSign
			call	WriteString
			mov		eax, remainder
			call	WriteDec
			call	CrLf

			mov		edx, OFFSET impressed			; Impressed? Prompt IS Displayed
			call	WriteString
			call	CrLf

programEnd: ; Jump programEnd Is Initialized
		; User Is Asked To Run Program Again
		; If User Selects 1, The Program Jumps to loopTop, Else, Program Continues End Ends
			mov		edx, OFFSET continueRunning
			call	WriteString
			call	ReadInt
			mov		userInput, eax
			cmp		eax, 1
			je		loopTop

		; Display Terminating Message
		; Program Says Goodbye
			mov		edx, OFFSET terminatingMessage
			call	WriteString
			call	CrLf
	
exit	; exit to operating system

main ENDP

END main
