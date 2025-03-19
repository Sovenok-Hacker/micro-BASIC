ILM_ADD:
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

        add     [bx],ax
        jo      .number_err

        dec     byte [AESTACK_POINTER]

        mov     al,1

        ret

    .stack_err:
        mov     [ERROR_CODE],word ERROR_AESTACK_UNDERFLOW
        jmp     .err

    .number_err:
        mov     [ERROR_CODE],word ERROR_NUMBER_OVERFLOW

    .err:
        call    ILM_ERR
        xor     al,al
        ret