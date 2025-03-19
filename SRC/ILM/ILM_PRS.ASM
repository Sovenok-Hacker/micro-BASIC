ILM_PRS:
        mov		si,[CURSOR]

	.cycle:
		cmp		[si],byte 00h
		je		.err

		cmp		[si],byte 22h
		je		.done

		mov		al,[si]
		mov     ah,0Eh
        mov     bh,00h
		int		10h
		inc 	si
		jmp		.cycle

	.err:
		mov		[ERROR_CODE],word ERROR_QUOTES
		call	ILM_ERR
		xor		al,al
		ret

	.done:
		inc		si
		mov		[CURSOR],si
		mov		al,01h
        ret