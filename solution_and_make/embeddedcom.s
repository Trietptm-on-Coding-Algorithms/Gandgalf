org 100h
section .text

    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
loop:
    jmp loop

mov ah,03Ch        ; the open/create-a-file function
    mov cx,020h        ; file attribute - normal file
    mov dx,msg    ; address of a ZERO TERMINATED! filename string
    int 021h           ; call on Good Old Dos

jc exit

mov si,ax  ; returns a file handle (probably 5)


; ------ here decrypt file -------
    xor bx, bx
decrypt:
    mov al, [gzipf+bx]
    xor al, 0ebh
    mov [gzipf+bx], al
    inc bx
    cmp bx, 280
    jnz decrypt


mov ah,040h        ; the Write-to-a-file function for int 21h
    mov bx,si  ; the file handle goes in bx
    mov cx,280  ; number of bytes to write
    mov dx,gzipf     ; address to write from (the text we input)
    int 021h           ; call on Good Old Dos

mov ah,03Eh        ; the close-the-file function
    mov bx,si  ; the file handle
    int 021h           ; call on Good Old Dos

exit:
   mov ah,04Ch         ; terminate-program function
   int 021h            ; you guessed it!

;--------------------------------------------------
section .data
    msg db `keygen\x00`
    ; let`s fool binwalk users :)
    fool    db `\x1f\x8b\x08\x00\xb5\xcb.U\x00\x03+\xc8,\xa9L\xcb\xcf\xcf\xc9\xcb/IL\xcbIL\xe7\x02\x00~\x80D\xdf\x11\x00\x00\x00`
;--------------------------------------------------
    gzipf   db `\xf4\x60\xe3\xeb\x2f\x27\xc5\xbe\xeb\xe8\xae\xbb\xa6\xa4\x6f\xdb\xfb\x56\x18\xc0\x71\x66\xe2\xfb\xb2\xef\xb2`
            db `\x9c\xf8\xe3\xec\x2e\x1e\x8d\xd7\x93\xdb\xa1\x62\x42\x5f\x8e\xf0\x51\xff\xec\x9f\x60\x54\x35\x6a\x47\x1a\xdb`
            db `\x26\x57\x64\x25\x57\xbd\x69\xd2\x79\x8a\xf1\x63\xd1\x1d\xed\xad\x29\x4b\x12\x25\x0f\xa7\xfd\xdb\x1e\x48\xe2`
            db `\xe0\x3e\xf4\xef\x17\x22\x5c\x10\x0c\x27\x82\x2e\xcf\x7e\xfd\x12\x07\xc6\x08\xc1\x78\x71\xde\x52\xa0\x0a\x69`
            db `\xb1\x9d\x98\x1e\xa9\x46\x8f\x3f\x3d\xde\x5e\xe9\xa0\xad\x2e\x6f\x0c\x7d\x31\x73\x00\xa4\x9f\x87\x82\xac\xc6`
            db `\xac\x27\xd2\x19\xe2\x51\xdd\x83\x60\x9c\x84\x43\xa2\xaf\xb3\x97\x18\x91\x29\x85\x9c\x75\x29\x36\x27\xd2\x42`
            db `\x1a\xab\xa7\xc4\xd1\x04\x57\xd6\xb3\x2a\x21\xcc\x87\xcb\x46\xa7\xf6\x49\x99\x3e\x66\x35\xf9\x03\x51\x19\xd8`
            db `\x16\xe4\x78\x21\x9c\xe3\xf8\xa8\x65\x3a\x28\xa5\x77\x57\xbd\x6d\xcb\xf3\x1c\x17\xb9\x4e\x01\xb9\xbc\x2a\xc7`
            db `\xd7\xd5\x36\x04\x34\x60\x50\xc9\x9b\x92\x3c\xcf\x8b\x55\x6d\x64\x13\x0c\xea\xc9\x85\xb7\x57\x55\xd7\xfb\x8c`
            db `\x6f\xb7\x3f\x18\x44\x93\xd8\x6a\x97\xe4\x53\x8d\xba\x20\xc3\x3e\x73\x86\x0a\x3c\xed\x13\x39\x7e\x00\x53\x19`
            db `\x40\xb4\x06\x83\xf1\x63\x89\xea\xeb\xeb`
section .bss