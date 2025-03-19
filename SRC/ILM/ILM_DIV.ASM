ILM_DIV:
        xor     bx,bx
        mov     bl,[AESTACK_POINTER]
        cmp     bl,02h
        jb     	.stack_err
        dec     bl
        shl		bl,1
        add		bx,AESTACK_BASE
        mov		cx,[bx]
        cmp		cx,0
        je		.div_zero_err
        dec		bx
        dec		bx
        mov		ax,[bx]
        cwd
        idiv	cx
        mov		[bx],ax
        dec		byte [AESTACK_POINTER]
        mov		al,01h
        ret

.stack_err:
		mov		[ERROR_CODE],word ERROR_AESTACK_UNDERFLOW
		jmp		.err

.div_zero_err:
		mov		[ERROR_CODE],word ERROR_DIVIDE_ZERO

.err:
		call	ILM_ERR
		xor		al,al
		ret
