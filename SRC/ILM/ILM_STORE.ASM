ILM_STORE:
        xor     bx,bx
        mov     bl,[AESTACK_POINTER]
        cmp     bl,02h
        jb      .stack_err
        dec     bl
        shl     bl,1
        add     bx,AESTACK_BASE
        mov     ax,[bx]
        dec     bx
        dec     bx
        mov     di,[bx]
        shl     di,1
        add     di,VARIABLES
        mov     [di],ax
        dec     byte [AESTACK_POINTER]
        dec     byte [AESTACK_POINTER]
        mov     al,1
        ret

.stack_err:
        mov     [ERROR_CODE],word ERROR_AESTACK_UNDERFLOW
        call    ILM_ERR
        xor     al,al
        ret