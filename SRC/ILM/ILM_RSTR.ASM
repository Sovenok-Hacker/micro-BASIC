ILM_RSTR:
        xor     bx,bx
        mov     bl,[SBRSTACK_POINTER]
		cmp     bl,00h
        jbe     .stack_err
        dec     bl
		add		bx,SBRSTACK_BASE
		xor		ax,ax
		mov 	al,[bx]
		mov		cl,COLS
		mul		cl
		add		ax,PGM
		mov		[PGP],ax
		dec		byte [SBRSTACK_POINTER]
		mov		al,01h
		ret

    .stack_err:
		mov		[ERROR_CODE],word ERROR_SBRSTACK_UNDERFLOW
		call	ILM_ERR
		xor		al,al
		ret