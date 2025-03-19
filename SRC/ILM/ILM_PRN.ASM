ILM_PRN:
        xor     bx,bx
        mov     bl,[AESTACK_POINTER]
		cmp     bl,01h
        jl     	.stack_err
        dec     bl
		shl		bl,1
		add		bx,AESTACK_BASE
		mov		dx,[bx]
		call	PRINT_NUMBER
		dec		byte [AESTACK_POINTER]
		mov		al,1
		ret

    .stack_err:
		mov		[ERROR_CODE],word ERROR_AESTACK_UNDERFLOW
		call	ILM_ERR
		xor		al,al
		ret
