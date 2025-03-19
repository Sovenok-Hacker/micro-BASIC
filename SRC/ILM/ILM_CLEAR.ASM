ILM_CLEAR:
        mov     ah,06h
        mov     al,00h
        mov     bh,BG_COLOR|FG_COLOR
        mov     ch,00h
        mov     cl,00h
        mov     dh,ROWS-1
        mov     dl,COLS-1
        int     10h                     

        mov     ah,02h
        mov     bh,00h
        mov     dx,000h
        int     10h

        ret