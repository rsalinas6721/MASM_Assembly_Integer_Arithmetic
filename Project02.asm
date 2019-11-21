TITLE Fibonacci Numbers    (Projecct02.asm)

; Author: Ricky Salinas
; Last Modified: 14 October 2018
; OSU email address: salinari@oregonstate.edu
; Course number/section: CS271
; Project Number: #2
; Due Date: 14 October 2018
; Description: This program calculates Fibonacci numbers

INCLUDE Irvine32.inc

	FIBONACCI_MAX_LIMIT = 46 ; Constant Fibonacci Limit Maximum Is Set
	FIBONACCI_MIN_LIMIT = 1 ; Constant Fibonacci Limit Minimum Is Set

.data
	programerName		BYTE	"This program was written by Ricky Salinas.", 0
	namePrompt			BYTE	"What is your name? ", 0
	introduction		BYTE	"Welcome, this programs calculates Fibonacci Numbers!", 0
	userInstructions	BYTE	"How many number of Fibonacci numbers would you like? Enter a number between 1 and 46!", 0
	count				DWORD	?
	prevNum				DWORD	0
	currNum				DWORD	1
	space				BYTE	"     ", 0
	farewell			BYTE	"This program will now end, goodbye ", 0
	divisible			DWORD	5
	output				DWORD	0
	userName			BYTE	33 DUP(0)	;string to be entered by user
	byteCount			DWORD	?
	greeting			BYTE	"Hello, ",0
	highError			BYTE	"The number you entered is too high!", 0
	lowError			BYTE	"The number you entered is too low!", 0


.code
	main PROC

	; Introduction Is Displayed. 
	; Programer Name IS Displayed
	; User Is Asked For Name
		mov		edx, OFFSET introduction
		call	WriteString
		call	CrLf
		mov		edx, OFFSET programerName
		call	WriteString
		call	CrLf
		mov		edx, OFFSET namePrompt
		call	WriteString
		call	CrLf

	; User Anser Is Initialized To userName
		mov		edx, OFFSET userName
		mov		ecx, 32
		call	ReadString

	; User Is Greeted
		mov		edx, OFFSET greeting
		call	WriteString
		mov		edx, OFFSET userName
		call	WriteString
		call	CrLf

	; Instructions Are Displayed
	; The Number Entered By The User Is Compered To Constants
	; A High Number Will Jump To maxError
	; A Low Number Will Jump To min Error
	; JMP Location Instructions Is Initialized
	instructions:
		mov		edx, OFFSET userInstructions
		call	WriteString
		call	CrLf
		call	ReadInt
		mov		count, eax
		cmp		eax, FIBONACCI_MAX_LIMIT
		jg		maxError
		cmp		eax, FIBONACCI_MIN_LIMIT
		jl		minError

	; Number Enterd By User Is Set To Count And Moved To ECX For Loop
	; prevNum Is Set To 0
	; currNum Is Set To 1
	; This Will Be USed To Initiate Fibonacci Numbers
		mov		ecx, count
		mov		prevNum, 0
		mov		currNum, 1

	; Jump Location displayFibs Is Set 
	; Fibonacci Numbers Are Displayed Using A Loop
	; Loop Is Terminated When ECX Equals To 0 
	; Variable 
	displayFibs:
		mov		eax, currNum
		call	WriteDec
		mov		edx, OFFSET space
		call	WriteString
		inc		output
		add		eax, prevNum
		mov		ebx, currNum
		mov		prevNum, ebx
		mov		currNum, eax

	; div Operator Is Used To Skip Line After Every 5th Element
	; Variable Output Calculates Already Displayed
	; If The Number Is Not Divisible By 5, The Program Skips The Extra Line Using skip 
		mov		edx, 0   
		mov		eax, output
		mov		ebx, divisible
		div		ebx
		mov		eax, edx
		cmp		eax , 0
		jne		skip
		call	CrLF
	
	; Program Loops To displayFibs
	; After Loop Ends, The Program Jumps To endProgram
	skip:
		loop	displayFibs
		jmp		endProgram
	
	; maxError Message Is Displayed
	; Program Jumps To Instructions
	maxError:
		mov		edx, OFFSET highError
		call	WriteString
		call	CrLF
		jmp		instructions

	; minError Message Is Displayed
	; Program Jumps To Instructions
	minError:
		mov		edx, OFFSET lowError
		call	WriteString
		call	CrLF
		jmp		instructions

	; Program Ends
	; User IS Told Goodbye
	endProgram:
		call	CrLf
        call	CrLf
		mov		edx, OFFSET farewell
		call	WriteString
		mov		edx, OFFSET userName
		call	WriteString
		call	CrLf

	exit	; exit to operating system
main ENDP
END main
