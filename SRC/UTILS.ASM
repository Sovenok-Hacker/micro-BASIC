PRINT_STR:                       

        mov     si,dx 
        mov     ah,0Eh        
        mov     bh,00h            

    .next: 
        mov     al,[si]           
        cmp     al,00h    
        jz      .done  
        int     10h  
        inc     si   
        jmp     .next   

    .done:
        ret

PRINT_WORD:                     

        mov     ch,04h
        mov     cl,04h
        mov     ah,0Eh
        mov     bh,00h 

    .cycle:
        mov     al,dh 
        and     al,0F0h
        shr     al,cl
        
        add     al,30h
        cmp     al,39h
        jbe     .print
        add     al,07h      

    .print:
        int     10h    

        dec     ch      
        jz      .done
        shl     dx,cl
        jmp     .cycle

    .done:
        ret

PRINT_NUMBER:

        mov     ax,dx
        cmp     ax,00h
        je      .zero

        or 		ax,ax          
		jns 	.positive     
	
    .negative:                             
                                        
        mov     ah,0EH         
        mov     al,2Dh                  
        mov     bh,00h    
        int     10h
                                        
        mov     ax,dx
    	not 	ax                     
		inc 	ax                      

    .positive:
        
        mov     bx,10 
        xor     cx,cx
        xor     dx,dx 

    .pusher:  
            
        cmp     ax,0 
        je      .popper 
            
        div     bx
            
        push    dx             
            
        inc     cx   
            
        xor     dx,dx   
        
        jmp     .pusher          
    
    .popper:          
            
        cmp     cx,00h
        je      .done 
            
        pop     ax
            
        mov     ah,0EH
        add     al,30h  
        mov     bh,00h      
        int     10h      

        dec     cx         

        jmp     .popper             
    
    .zero:                             
        mov     ah,0EH
        mov     al,30h
        mov     bh,00h    
        int     10h

    .done:
        ret


WAIT_KEY:  
        xor     ax,ax
        int     16h
        ret
        
