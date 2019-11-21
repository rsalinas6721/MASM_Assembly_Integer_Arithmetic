TITLE Integer Accumulator    (Project3.asm)

; Author: Ricky Salinas
; Last Modified: 28 October 2018
; OSU email address: salinari@oregonstate.edu
; Course number/section: CS271
; Project Number: #3
; Due Date: 28 October 2018
; Description: This Program Accumulates A List Of Numbers Entered By The User. Numbers Are Then Added, and Averaged Out.

INCLUDE Irvine32.inc

		MIN_LIMIT = -100 ; Constant Limit Minimum Is Set
		MAX_LIMIT = -1 ; Constant Limit Maximum Is Set

.data
		programTitle			BYTE	"Welcome to Integer Accumulator!", 0
		programerName			BYTE	"This program was written by Ricky Salinas.", 0
		namePrompt				BYTE	"What is your name? ", 0
		userInstructionsOne		BYTE	"Please enter numbers in [-100, -1].", 0
		userInstructionsTwo		BYTE	"Enter a non-negative number when you are finished to see results.", 0
		userName				BYTE	33 DUP(0)	;string to be entered by user
		greeting				BYTE	"Hello ", 0
		farewell				BYTE	"Thank you for playing Integer Accumulator! It's been a pleasure to meet you, ", 0
		numbers					DWORD	0
		addNumber				BYTE	"Enter number: ", 0
		input					DWORD	?
		sumTotal				BYTE	"The sum of your valid numbers is ", 0
		total					DWORD	?
		count					DWORD	0
		currentNumbers			BYTE	"Current Numbers:" , 0
		average					DWORD	?
		remainder				DWORD	?
		numAverage				BYTE	"The rounded average is ", 0
		entered					BYTE	"You entered ", 0
		valid					BYTE	" valid numbers. ", 0
		extraCredit				BYTE	"**EC:Calculate and display the average as a floating-point number, rounded to the nearest .001.", 0
		averageFloating			BYTE	"Average as floating point number:    ", 0
		period					BYTE	".", 0
		floatingPoint			DWORD	?


.code
	main PROC

; Program Name And Programer Name is Displayed. 
			mov		edx, OFFSET programTitle
			call	WriteString
			call	CrLf
			mov		edx, OFFSET programerName
			call	WriteString
			call	CrLf
			mov		edx, OFFSET extraCredit
			call	WriteString
			call	CrLf

; User Name IS Requested
			mov		edx, OFFSET namePrompt
			call	WriteString
			call	CrLf

; User Answer Is Initialized To userName
			mov		edx, OFFSET userName
			mov		ecx, 32
			call	ReadString
	
; User Is Greeted
			mov		edx, OFFSET greeting
			call	WriteString
			mov		edx, OFFSET userName
			call	WriteString
			call	CrLf

;			mov		ecx, 0

; Introductions For Program Are Displayed. 
			mov		edx, OFFSET userInstructionsOne	
			call	WriteString
			call	CrLf
			mov		edx, OFFSET userInstructionsTwo	
			call	WriteString
			call	CrLf
			
; Loop User Numbers Is Created To Retrieve user Numbers
; Numbers Are Compared To Max And Min Limits
; If Values Pass, They Are Added To Total Vatiable
; Loop Ends Once A Non-Negative Number Is Entered
; Program Jumps To Display Totals 
; While Loop Runs, The Number Count Is Calculated For Average

	userNumbers:
			mov		edx, OFFSET addNumber
			call	WriteString
			call	ReadInt
			mov		input, eax
			cmp		eax, MIN_LIMIT
			jb		displayTotal
			cmp		eax, MAX_LIMIT
			jg		displayTotal
			add		eax, total
			mov		total, eax
			mov		eax, count
			add		eax, 1
			mov		count, eax
			loop	userNumbers

; DisplayTotal Is Created To Display The Final Totals For User
	displayTotal:		
; User Entered # Is Displayed
			mov		edx, OFFSET entered
			call	WriteString
			mov		eax, count
			call	WriteDec
			mov		edx, OFFSET valid
			call	WriteString
			call	CrLf

;Sum Of Total Is Displayed
			mov		edx, OFFSET sumTotal
			call	WriteString
			mov		eax, total
			call	WriteInt
			call	CrLf

; Total Is Divided By Count
; Set To NumberAverage
; Results Are Displayed
			mov		edx, OFFSET numAverage
			call	WriteString
			mov		edx, 0
			mov		eax, total
			cdq
			mov		ebx, count
			cdq
			idiv	ebx
			mov		average, eax
			mov		remainder, edx
			call	WriteInt
			call	CrLf
		
; Average As Floating Point Number Is Identified And Displayed
			mov		remainder, edx
			mov		edx, OFFSET averageFloating
			call	WriteString
			call	WriteInt
			mov		edx, OFFSET period
			call	WriteString
			fld		remainder
			fist	floatingPoint
			mov		eax, floatingPoint
			call	WriteDec
			call	CrLf

; Program Ends
; User Is Told Goodbye
			mov		edx, OFFSET farewell
			call	WriteString
			mov		edx, OFFSET userName
			call	WriteString
			mov		edx, OFFSET period
			call	WriteString
			call	CrLf

	exit	; exit to operating system
main ENDP
END main
