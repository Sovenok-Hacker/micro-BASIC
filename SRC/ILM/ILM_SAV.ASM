ILM_SAV:
		xor		bx,bx
        mov		bl,[SBRSTACK_POINTER]
		cmp		bl,MAX_STACK
		jae		.stack_err
		add		bx,SBRSTACK_BASE
		mov		ax,[PGP]
		sub		ax,PGM
		mov		cl,COLS
		div		cl
		xor		ah,ah
		mov		[bx],ax
		inc		byte [SBRSTACK_POINTER]
		mov		al,01h
		ret
	.stack_err:
		mov		[ERROR_CODE],word ERROR_SBRSTACK_OVERFLOW
		call	ILM_ERR
		xor		al,al
		ret