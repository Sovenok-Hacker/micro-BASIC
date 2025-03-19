ILM_ERR:									
		
		call	ILM_NLINE

	.mode:
		cmp		[MODE],byte 00h
		je		.err_direct

	.err_at_line:
		mov		dx,ERROR_STR_AT_LINE	;
		call	PRINT_STR

	.line:
		mov		ax,[PGP]
		sub		ax,PGM					
		mov		bl,COLS
		div		bl

	.num:
		mov		dx,ax
		call	PRINT_NUMBER
		
		jmp		.err_code

	.err_direct:
		mov		dx,ERROR_STR
		call	PRINT_STR

	.err_code:								
		mov		dx,[ERROR_CODE]
		call	PRINT_STR

		call	ILM_NLINE

		ret