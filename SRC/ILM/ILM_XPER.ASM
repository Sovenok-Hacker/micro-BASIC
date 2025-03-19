ILM_XPER:

		mov		dl,COLS
        xor     bx,bx
        mov     bl,[AESTACK_POINTER]
		cmp     bl,00h
        jbe     .stack_err
        dec     bl
		shl		bl,1
		add		bx,AESTACK_BASE
		mov		ax,[bx]
		cmp		ax,00h
		jle     .pgp_err
		cmp		ax,0FFh
		jg		.pgp_err
		xor		ah,ah
		mul		dl
		add		ax,PGM
		mov		si,ax
		cmp		[si],byte 00h
        je      .empty_err
		mov		[PGP],si
		mov		[CURSOR],si
		mov		al,01h
		ret

	.stack_err:
		mov		[ERROR_CODE],word ERROR_AESTACK_UNDERFLOW
		jmp		.err

	.pgp_err:
		mov		[ERROR_CODE],word ERROR_PGP
		jmp		.err

	.empty_err:
		mov		[ERROR_CODE],word ERROR_EMPTY_LINE

	.err:
		call	ILM_ERR
		xor		al,al
		ret
