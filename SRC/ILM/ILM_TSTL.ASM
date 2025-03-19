ILM_TSTL:
    xor     ax, ax
    mov     ch, 10
    mov     bx, LBUF
    mov     si, 00h

.skip_blanks:
    mov     cl, [bx + si]
    cmp     cl, 00h
    je      .done

    cmp     cl, byte 20h
    jg      .get_number
    inc     si
    jmp     .skip_blanks

.get_number:
    mov     cl, [bx + si]
    cmp     cl, 30h
    jl      .done

    cmp     cl, 39h
    jg      .done

    sub     cl, 30h
    mul     ch
    jc      .err
    add     al, cl
    jc      .err

    inc     si
    jmp     .get_number

.done:
    cmp     ax, 00h
    jne     .blank
    ret

.blank:
    cmp     [bx + si], byte 20h
    jg      .err
    ret

.err:
    mov     [ERROR_CODE], word ERROR_LINE_NUMBER
    call    ILM_ERR
    mov     al, -1
    ret
