[BITS 16]
[ORG 0000h]

%INCLUDE "SRC/UTILS.ASM"
%INCLUDE "SRC/ILM/ILM_ADD.ASM"
%INCLUDE "SRC/ILM/ILM_CLEAR.ASM"
%INCLUDE "SRC/ILM/ILM_CMPR.ASM"
%INCLUDE "SRC/ILM/ILM_DIV.ASM"
%INCLUDE "SRC/ILM/ILM_DONE.ASM"
%INCLUDE "SRC/ILM/ILM_ERR.ASM"
%INCLUDE "SRC/ILM/ILM_GETLINE.ASM"
%INCLUDE "SRC/ILM/ILM_IND.ASM"
%INCLUDE "SRC/ILM/ILM_INIT.ASM"
%INCLUDE "SRC/ILM/ILM_INNUM.ASM"
%INCLUDE "SRC/ILM/ILM_INSERT.ASM"
%INCLUDE "SRC/ILM/ILM_LIT.ASM"
%INCLUDE "SRC/ILM/ILM_LST.ASM"
%INCLUDE "SRC/ILM/ILM_MUL.ASM"
%INCLUDE "SRC/ILM/ILM_NEG.ASM"
%INCLUDE "SRC/ILM/ILM_NLINE.ASM"
%INCLUDE "SRC/ILM/ILM_NXT.ASM"
%INCLUDE "SRC/ILM/ILM_PRN.ASM"
%INCLUDE "SRC/ILM/ILM_PRS.ASM"
%INCLUDE "SRC/ILM/ILM_RSTR.ASM"
%INCLUDE "SRC/ILM/ILM_SAV.ASM"
%INCLUDE "SRC/ILM/ILM_SPC.ASM"
%INCLUDE "SRC/ILM/ILM_STORE.ASM"
%INCLUDE "SRC/ILM/ILM_SUB.ASM"
%INCLUDE "SRC/ILM/ILM_TST.ASM"
%INCLUDE "SRC/ILM/ILM_TSTL.ASM"
%INCLUDE "SRC/ILM/ILM_TSTN.ASM"
%INCLUDE "SRC/ILM/ILM_TSTV.ASM"
%INCLUDE "SRC/ILM/ILM_XPER.ASM"
%INCLUDE "SRC/ILM/ILM_XINIT.ASM"

STACK_SEG       EQU 1000h
STACK_OFF       EQU 0FFFFh

ROWS            EQU 25
COLS            EQU 80

FG_COLOR        EQU 0Fh
BG_COLOR        EQU 10h

DIRECT          EQU 0
RUN             EQU 1

MAX_STACK       EQU 128

START:
		call	ILM_CLEAR
		mov		dx,STR_WELCOME
		call	PRINT_STR
		mov     dx,STR_SEP
		call    PRINT_STR
		mov		dx,STR_DOC
		call	PRINT_STR
		mov     dx,STR_SEP
		call    PRINT_STR
		call	ILM_INIT
		call	ILM_NLINE

CO:     
		mov		sp,STACK_OFF
		mov		ax,PGM
		mov		[PGP],ax
		mov		[CURSOR],ax
		mov		[MODE],byte 00h
		mov		al,3Eh
		call	ILM_GETLINE
		call	ILM_NLINE
		cmp		[LBUF],byte 00h
		je		CO
		call	ILM_TSTL
		cmp		al,-1
		je		CO
		call	ILM_INSERT
		cmp		al,00h
		jne		CO

XEC:    
		call	ILM_XINIT
STMT:   
		mov		dx,STR_REM
		call	ILM_TST
		cmp		al,00h
		je		S0
		call	ILM_NXT
		cmp		al,00h
		je		CO
		cmp		al,01h
		je		XEC 
		
S0:
		mov		dx,STR_LET
		call	ILM_TST
		cmp		al,00h
		je		S1
		call	ILM_TSTV
		cmp		al,-1
		je		CO
		cmp		al,00h
		je		ERROR
		mov		dx,STR_ASSIGN
		call	ILM_TST
		cmp		al,00h
		je		ERROR
		call	EXPR
		call	ILM_DONE
		cmp		al,00h
		je		CO
		call	ILM_STORE
		cmp		al,00h
		je		CO
		call	ILM_NXT
		cmp		al,00h
		je		CO
		cmp		al,01h
		je		XEC

S1:     
		mov		dx,STR_GOTO
		call	ILM_TST
		cmp		al,00h
		je		S2
		call	EXPR
		call	ILM_DONE
		cmp		al,00h
		je		CO
		call	ILM_XPER
		cmp		al,0
		je		CO
		jmp		XEC

S2:     
		mov		dx,STR_GOSUB
		call	ILM_TST
		cmp		al,00h
		je		S3
		call	EXPR
		call	ILM_DONE
		cmp		al,00h
		je		CO
		call	ILM_SAV
		cmp		al,00h
		je		CO
		call	ILM_XPER
		cmp		al,0
		je		CO

S3:     
		mov		dx,STR_PRINT
		call	ILM_TST
		cmp		al,00h
		je		S8

S4:     
		mov		dx,STR_QUOTES
		call	ILM_TST
		cmp		al,00h
		je		S7
		call	ILM_PRS
		cmp		al,00h
		je		CO

S5:     
		mov		dx,STR_COMMA
		call	ILM_TST
		cmp		al,00h
		je		S6
		call	ILM_SPC
		jmp		S4

S6:     
		call	ILM_DONE
		cmp		al,00h
		je		CO
        call	ILM_NLINE
        call	ILM_NXT
		cmp		al,00h
		je		CO
		cmp		al,01h
		je		XEC

S7:     
		call	EXPR
		call	ILM_PRN
		cmp		al,00h
		je		CO
		jmp		S5

S8:     
		mov		dx,STR_IF
		call	ILM_TST
		cmp		al,00h
		je		S9
		call	EXPR
		call	RELOP
		call	EXPR
        mov		dx,STR_THEN
		call	ILM_TST
		cmp		al,00h
		je		ERROR
		call	ILM_CMPR
		cmp		al,-1
		je		CO
		cmp		al,00h
		jne		XEC
		call	ILM_NXT
		cmp		al,00h
		je		CO
		cmp		al,01h
		je		XEC

S9:      
		mov		dx,STR_INPUT
		call	ILM_TST
		cmp		al,00h
		je		S12

S10:    
		call	ILM_TSTV
		cmp		al,-1
		je		CO
		cmp		al,00h
		je		ERROR
		call	ILM_INNUM
		cmp		al,00h
		je		CO
        call	ILM_STORE
		cmp		al,00h
		je		CO
        mov		dx,STR_COMMA
		call	ILM_TST
		cmp		al,00h
		je		S11
        jmp		S10			

S11:    
		call	ILM_DONE
		cmp		al,00h
		je		CO
        call	ILM_NXT
		cmp		al,00h
		je		CO
		cmp		al,01h
		je		XEC

S12:    
		mov		dx,STR_RETURN
		call	ILM_TST
		cmp		al,00h
		je		S13
		call	ILM_DONE
		cmp		al,00h
		je		CO
		call	ILM_RSTR
		cmp		al,00h
		je		CO
		call	ILM_NXT
		cmp		al,00h
		je		CO
		cmp		al,01h
		je		XEC

S13:    
		mov		dx,STR_END
		call	ILM_TST
		cmp		al,00h
		je 		S14
		call	ILM_DONE
        jmp		CO

S14:    
		mov		dx,STR_LIST
		call	ILM_TST
		cmp		al,00h
		je		S15
		call	ILM_DONE
		cmp		al,00h
		je		CO
		cmp		byte [MODE],DIRECT
		je		S14A
		mov		[ERROR_CODE],word ERROR_MODE
		call	ILM_ERR
		jmp		CO

S14A:		
        call	ILM_LST
		jmp		CO

S15:    
		mov		dx,STR_RUN
		call	ILM_TST
		cmp		al,00h
		je		S16
        call	ILM_DONE
		cmp		al,00h
		je		CO
		cmp		byte [MODE],DIRECT
		je		S15A
		mov		[ERROR_CODE],word ERROR_MODE
		call	ILM_ERR
		jmp		CO

S15A:
		mov		byte [MODE],RUN
        call	ILM_NXT
		cmp		al,00h
		je		CO
		cmp		al,01h
		je		XEC

S16:    
		mov		dx,STR_RESET
		call	ILM_TST
		cmp		al,00h
		je		ERROR
		call	ILM_DONE
		cmp		al,00h
		je		CO
		cmp		byte [MODE],DIRECT
		je		S16A
		mov		[ERROR_CODE],word ERROR_MODE
		call	ILM_ERR
		jmp		CO

S16A:
        jmp		START

ERROR:    
		mov		[ERROR_CODE],word ERROR_SYNTAX
		call	ILM_ERR             	
		jmp		CO

EXPR:   
		mov		dx,STR_MINUS
		call	ILM_TST
		cmp		al,00h
		je		E0
		call	TERM
		call	ILM_NEG
		cmp		al,00h
		je		CO
		jmp		E1

E0:     
		mov		dx,STR_PLUS
		call	ILM_TST
		cmp		al,00h
		je		E1A

E1A:   
		call	TERM
E1:     
		mov		dx,STR_PLUS
		call	ILM_TST
		cmp		al,00h
		je		E2
		call	TERM
		call	ILM_ADD
		cmp		al,00h
		je		CO
		jmp		E1

E2:     
		mov		dx,STR_MINUS
		call	ILM_TST
		cmp		al,00h
		je		E3
		call	TERM
		call	ILM_SUB
		cmp		al,00h
		je 		CO
		jmp		E1

E3:
		ret

TERM:   
		call	FACT
T0:     
		mov		dx,STR_MUL
		call	ILM_TST
		cmp		al,00h
		je		T1
		call	FACT
		call 	ILM_MUL
		cmp		al,00h
		je		CO
		jmp		T0

T1:     
		mov		dx,STR_DIV
		call	ILM_TST
		cmp		al,00h
		je		T2
		call    FACT
        call	ILM_DIV
		cmp		al,00h
		je		CO
        jmp   	T0

T2:  
		ret

FACT:  
		call	ILM_TSTV
		cmp		al,-1
		je		CO
		cmp		al,00h
		je		F0
		call	ILM_IND
		cmp		al,00h
		je		CO
		ret

F0:     
		call	ILM_TSTN
		cmp		al,-1					
		je		CO
		cmp		al,00h					
		je		F1
		ret

F1:    
		mov		dx,STR_LPAREN
		call	ILM_TST
		cmp		al,00h
		je		F2
		call	EXPR
		mov		dx,STR_RPAREN
		call	ILM_TST
		cmp		al,00h
		je		F2
        ret

F2:     
		mov		[ERROR_CODE],word ERROR_SYNTAX
		call	ILM_ERR                 
		jmp		CO

RELOP:  
		mov		dx,STR_OP_E
		call	ILM_TST
		cmp		al,00h
		je		R0
		mov		dx,0
		jmp		R5

R0:  
		mov		dx,STR_OP_NE
		call	ILM_TST
		cmp		al,00h
		je		R1
		mov		dx,1
		jmp		R5

R1:     
		mov		dx,STR_OP_LE
		call	ILM_TST
		cmp		al,00h
		je		R2
		mov		dx,2
		jmp		R5

R2: 
		mov		dx,STR_OP_GE
		call	ILM_TST
		cmp		al,00h
		je		R3
		mov		dx,3
		jmp		R5

R3:   
		mov		dx,STR_OP_L
		call	ILM_TST
		cmp		al,00h
		je		R4
		mov		dx,4
		jmp		R5        

R4:     
		mov		dx,STR_OP_G
		call	ILM_TST
		cmp		al,00h
		je		R6
		mov		dx,5

R5:	
		call	ILM_LIT
		cmp		al,00h
		je		CO
		ret

R6:     
        mov		[ERROR_CODE],word ERROR_OPERATOR
		call	ILM_ERR
		jmp		CO

END:
		cli
        hlt

; ========================================Data section===================================================

STR_WELCOME		db "micro BASIC programing language", 0Dh, 0Ah, "PRoX development", 0Dh, 0Ah,00h
STR_SEP         db "------------------------------------", 0Dh, 0Ah,00h

;=========================================Documentation==================================================
STR_DOC		    db "Documentation for micro BASIC syntax:", 0Dh, 0Ah, \
					"   REM - Comment", 0Dh, 0Ah, \
					"   LET - Assign a value to a variable", 0Dh, 0Ah, \
					"   GOTO - Jump to a specific line number", 0Dh, 0Ah, \
					"   GOSUB - Call a subroutine", 0Dh, 0Ah, \
					"   END - End the program", 0Dh, 0Ah, \
					"   PRINT - Output a value", 0Dh, 0Ah, \
					"   LIST - Show the program code", 0Dh, 0Ah, \
					"   RUN - Execute the program", 0Dh, 0Ah, \
					"   INPUT - Get input from user", 0Dh, 0Ah, \
					"   IF - Conditional execution", 0Dh, 0Ah, \
					"   THEN - Follow-up for IF", 0Dh, 0Ah, \
					"   RESET - Reset the environment", 0Dh, 0Ah, \
					"   RETURN - Return from a subroutine", 0Dh, 0Ah, \
					"All commands must be followed by a line number or appropriate syntax.",0Dh, 0Ah, 00h

STR_REM			db "REM",00h
STR_LET			db "LET",00h
STR_GOTO		db "GOTO",00h	
STR_GOSUB		db "GOSUB",00h	
STR_END			db "END",00h	
STR_PRINT		db "PRINT",00h				
STR_LIST		db "LIST",00h				
STR_RUN			db "RUN",00h
STR_RESET		db "RESET",00h
STR_RETURN		db "RETURN",00h
STR_INPUT		db "INPUT",00h
STR_IF			db "IF",00h
STR_THEN		db "THEN",00h
STR_COMMA		db ',',00h
STR_QUOTES		db '"',00h
STR_ASSIGN		db '=',00h
STR_MINUS		db '-',00h
STR_PLUS		db '+',00h
STR_MUL			db '*',00h
STR_DIV			db '/',00h
STR_LPAREN		db '(',00h
STR_RPAREN		db ')',00h

STR_OP_E		db "==",00h
STR_OP_NE		db "!=",00h
STR_OP_LE		db "<=",00h
STR_OP_GE		db ">=",00h
STR_OP_L		db "<",00h
STR_OP_G		db ">",00h

;================================Errors========================================
ERROR_CODE					dw 0000h
ERROR_STR					db "ERROR",00h
ERROR_STR_AT_LINE			db "ERROR at line ",00h
ERROR_SYNTAX				db ": Syntax error",00h					
ERROR_LINE_NUMBER			db ": Invalid line number",00h
ERROR_EMPTY_LINE			db ": Empty line",00h
ERROR_PGP 					db ":PGP out of range",00h
ERROR_QUOTES				db ": Missing quotes",00h
ERROR_INVALID_NUMBER		db ":Number invalid",00h
ERROR_NOT_NUMBER			db ": Not a number",00h
ERROR_NUMBER_OVERFLOW		db ": Number out of range",00h
ERROR_AESTACK_OVERFLOW		db ": Arithmetic stack overflow",00h
ERROR_AESTACK_UNDERFLOW		db ": Arithmetic stack underflow",00h
ERROR_SBRSTACK_OVERFLOW		db ": Subroutines stack overflow",00h
ERROR_SBRSTACK_UNDERFLOW	db ": Subroutines stack underflow",00h
ERROR_DIVIDE_ZERO			db ": Divide by zero",00h
ERROR_OPERATOR				db ": Invalid operator",00h
ERROR_MODE					db ": Unavailable for current mode",00h

MODE			db 00h
VARIABLES		times 26 dw 0000h
AESTACK_BASE	times MAX_STACK dw 0000h
AESTACK_POINTER db 00h
SBRSTACK_BASE	times MAX_STACK db 00h
SBRSTACK_POINTER db 00h
LBUF 			times COLS db 00h
CURSOR			dw	0000h
PGP				dw	0000h
PGM				dw	0000h
