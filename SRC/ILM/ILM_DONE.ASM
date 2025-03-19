ILM_DONE:

		mov		si,[CURSOR]

	.skip_blanks:

		cmp		[si],byte 00h
		je		.done

		cmp		[si],byte 20h
		ja		.err
		
		inc		si
		jmp		.skip_blanks

	.err:
		mov		[ERROR_CODE],word ERROR_SYNTAX
		call	ILM_ERR
		xor		al,al
		ret

	.done:
		mov		al,01h
		ret