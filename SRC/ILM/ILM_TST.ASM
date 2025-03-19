ILM_TST:
		mov		ax,[CURSOR]
		mov		si,ax

	.skip_blanks:
		cmp		[si],byte 00h
		je		.nomatch
		cmp		[si],byte 20h
		ja		.compare
		inc		si
		jmp		.skip_blanks

	.compare:
		xor		cx,cx
		mov		bx,dx

	.strlen:
		cmp		[bx],byte 00h
		je		.strcmp
		inc 	bx
		inc		cx
		jmp		.strlen

	.strcmp:
		mov     di,dx
        repe    cmpsb
        jne     .nomatch

	.match:
		mov		[CURSOR],si
		mov		al,01h
		ret

	.nomatch:
		mov		[CURSOR],ax
		xor		al,al
		ret