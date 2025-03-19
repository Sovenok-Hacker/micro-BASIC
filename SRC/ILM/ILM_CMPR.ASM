ILM_CMPR:
		xor		ax,ax
        xor     si,si

        add     si,[AESTACK_POINTER]

		cmp     si,03h
        jb     	.stack_err

        dec     si
		shl		si,1
		add		si,AESTACK_BASE

		mov		dx,[si]

		dec		si
		dec		si

		mov		cx,[si]
		
		dec		si
		dec		si

		mov		bx,[si]

		sub		[AESTACK_POINTER],byte 03h

	.switch:
		cmp		cx,00h
		je		.e
		cmp		cx,01h
		je		.ne
		cmp		cx,02h
		je		.le
		cmp		cx,03h
		je		.ge
		cmp		cx,04h
		je		.l
		cmp		cx,05h
		je		.g

	.e:
		cmp		bx,dx
		je		.done_true
		ret

	.ne:
		cmp		bx,dx
		jne		.done_true
		ret

	.le:
		cmp		bx,dx
		jle		.done_true
		ret

	.ge:
		cmp		bx,dx
		jge		.done_true
		ret

	.l:
		cmp		bx,dx
		jl		.done_true
		ret

	.g:
		cmp		bx,dx
		jg		.done_true
		ret

	.done_true:
		mov		al,1
		ret

    .stack_err:
		mov		[ERROR_CODE],word ERROR_AESTACK_UNDERFLOW		
		call	ILM_ERR						
		mov		al,-1
		ret