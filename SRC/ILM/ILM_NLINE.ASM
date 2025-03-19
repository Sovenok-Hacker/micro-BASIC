ILM_NLINE:
		mov     ah,0Eh
        mov 	al,0Dh
        mov     bh,00h
        int     10h
		
		mov		al,0Ah
		int     10h

		ret