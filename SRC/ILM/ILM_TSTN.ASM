ILM_TSTN:
		xor		ch,ch
		xor		ax,ax
		mov		bx,10
		mov		di,0

		mov		si,[CURSOR]

.skip_blanks:
		cmp		[si],byte 00h
		je		.not_found

		cmp 	[si],byte 20h
		ja		.check_sign
		
		inc		si
		jmp		.skip_blanks
		
.check_sign:
		cmp		[si],byte 2Bh
		je		.skip_sign

		cmp		[si],byte 2Dh
		jne		.get_number
	
		mov		di,1

	.skip_sign:
		inc		si

	.check_number:
		cmp 	[si],byte 30h
		jl		.not_found
		cmp 	[si],byte 39h
		jg		.not_found

	.get_number:
		mov		cl,[si]

		cmp 	cl,30h
		jl		.fix_sign

		cmp 	cl,39h
		jg		.fix_sign

		sub 	cl,30h
		mul 	bx
		jo		.number_err
		add		ax,cx
		jo		.number_err
		
		inc 	si
	
		jmp		.get_number 

	.fix_sign:
		cmp		di,00h
		je		.done
		neg		ax
						
	.done:
		mov		dx,ax
		call	ILM_LIT
		cmp		al,00h
		jne		.done_ok
		mov		al,-1
		ret

	.done_ok:
		mov		[CURSOR],si
		mov		al,01h
		ret

	.number_err:
		mov		[ERROR_CODE],word ERROR_NUMBER_OVERFLOW
		call	ILM_ERR
		mov		al,-1
		ret

	.not_found:
		xor		al,al
		ret
