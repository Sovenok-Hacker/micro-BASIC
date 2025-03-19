ILM_NXT:
        
        cmp		[MODE],byte 00h
		je		.collection

		mov		bx,[PGP]
	
	.cycle:
		add		bx,COLS

		cmp		bx,PGM+(256*80)
		jge		.err

		cmp		[bx],byte 00h
		je		.cycle

	.done:	
		mov		[PGP],bx
		mov		[CURSOR],bx
		mov		al,01h
		ret

	.err:
		sub		bx,COLS
		mov		[PGP],bx

		mov		[ERROR_CODE],word ERROR_PGP
		call	ILM_ERR

	.collection:
		xor		al,al
		ret
