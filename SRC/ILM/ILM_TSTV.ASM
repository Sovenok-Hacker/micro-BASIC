ILM_TSTV:
        mov     si,[CURSOR]

.skip_blanks:
        cmp     [si],byte 00h
        je      .nomatch

        cmp     [si],byte 20h
        ja      .check

        inc     si
        jmp     .skip_blanks

.check:
        cmp     [si],byte 41h
        jb      .nomatch

        cmp     [si],byte 5Ah
        ja      .nomatch

        xor     dh,dh
        mov     dl,byte [si]
        sub     dl,41h

.done:
        call    ILM_LIT
        cmp     al,00h
        jne     .done_ok
        mov     al,-1
        ret

.done_ok:
        inc     si
        mov     [CURSOR],si
        mov     al,1
        ret

.nomatch:
        xor     al,al
        ret
