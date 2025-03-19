[CPU 8086]
[BITS 16]
[ORG 7C00h]

STACK_SEG       EQU 1000h
STACK_OFF       EQU 0FFFFh

PROG_SEG 	    EQU 2000h
PROG_OFF 	    EQU 0000h

BOOT:  
        mov     [DEVICE],dl
        cli
        cld
        clc

        mov     ax,0003h
        int     10h

        mov     ah,05h
        mov     al,0000h
        int     10h

    .load:  
        mov     ax,PROG_SEG
        mov     es,ax
        mov     bx,PROG_OFF
        
        mov     ah,02h
        mov     al,40h
        mov     ch,00h
        mov     cl,02h
        mov     dh,00h
        mov     dl,[DEVICE]
        int     13h

        jc    	ERR

    .load_ok:
        mov     ax,PROG_SEG
        mov     ds,ax
        mov     es,ax

        mov     ax,STACK_SEG
        mov     ss,ax        

        mov     ax,STACK_OFF
        mov     bp,ax       
        mov     sp,ax

        sti
        jmp     PROG_SEG:PROG_OFF

ERR:
        mov     ah,0Eh
        mov     bh,00h
        mov     si,ERROR_STR

    .cycle:
        mov     al,[si]
        cmp     al,00h
        je      .end
        int     10h
        inc     si
        jmp     .cycle

    .end:
        hlt

DEVICE          db 00h
ERROR_STR       db "Disk error",00h	

TIMES 510-($-$$) DB 00h
DW 0xAA55
