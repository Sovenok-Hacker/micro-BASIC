ILM_GETLINE:

	.prompt:							
		mov     ah,0Eh                  
        mov     bh,00h                  
        int     10h 

	.init:
		mov     al,00h            		
        mov		di,LBUF       			
        mov		cx,COLS		          	
		rep		stosb                   

		mov		si,00h					

	.cycle:
		xor     ax,ax                   
        int     16h					

		cmp		al,0Dh					
		je		.done					

		cmp		al,08h 					
		je		.backspace

		cmp		si,COLS-2               
		jge		.cycle                  

		cmp		al,20h					
		jb		.cycle
		cmp		al,7Eh
		ja		.cycle

		mov		bx,LBUF
		mov		[bx+si],al				
		inc		si

		mov     ah,0Eh                  
        mov     bh,00h                  
        int     10h 

		jmp		.cycle

	.backspace:
		cmp		si,0					
		jle		.cycle					

		dec		si						
		mov		bx,LBUF
		mov		[bx+si],byte 00h
		
		mov		bh,00h      			

		mov		ah,03h					
		int		10h

		dec		dl						
		mov		ah,02h					
		int		10h

		mov     ah,0Ah                  
		mov		al,20h					
        int     10h

		jmp		.cycle
		
	.done:
		ret
