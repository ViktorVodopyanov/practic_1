format binary as 'img';����������� ��� ����
org 0x7C00
jmp start
fam db "Vodopyanov", 0
name db "Viktor", 0
nomer db "NMT-313901", 0
fat db "Anatolievich", 0

;��������� �������� �����
start:
cli                 ;��������� ����������
mov ax, 0           ;������������� �������� �����
mov ss, ax
mov sp, 0xFFFF      ;��������� ��������� ����� �� ����
sti                 ;�������� ����������
mov ax, 0x13        ; ������������ � ����� 320x200 256-�����
int 0x10
mov ax, 0x0010      ; ��������� ������������ ������ ������
int 0x10

;����������  ������������
    mov cx, 60
    mov dx, 60
    mov bx, 100
    call triangle
         ; ���� ����
mov ah, 0x0B
mov bl, 0x1C  ; ���� ����
int 0x10
;����� ������ ���������
    mov ah, 0x13; ������� ��� ������ ������
    mov al, 0
    mov bh, 0
    mov bl, 10  ; ���� ������
    mov dl, 68      ;�������
    mov dh, 21   ;������
    push cs
    pop es
    mov bp, nomer
    mov cx, 10  ;����� ������
    int 0x10
    mov ah, 0x13   ; ������� ��� ������ ������
    mov al, 0
    mov bh, 0
    mov bl, 11    ; ���� ������
    mov dl, 68  ;�������
    mov dh, 22    ;������
    push cs
    pop es
    mov bp, name
    mov cx, 6  ;����� ������
    int 0x10

    mov ah, 0x13 ; ������� ��� ������ ������
    mov al, 0
    mov bh, 0
    mov bl, 12 ; ���� ������
    mov dl, 68 ;�������
    mov dh, 23 ;������
    push cs
    pop es
    mov bp, fam
    mov cx, 10 ;����� ������
    int 0x10

    mov ah, 0x13  ; ������� ��� ������ ������
    mov al, 0
    mov bh, 0
    mov bl, 13   ; ���� ������
    mov dl, 68      ;�������
    mov dh, 24 ;������
    push cs
    pop es
    mov bp, fat
    mov cx, 11 ;����� ������
    int 0x10
hang:
    jmp hang

triangle:
    pusha
    mov bp, dx ;�������� �������� x ���������� ��� ���������

    ;���� ��������� ������������
triangle1:
    push dx
    mov ax, bx  ;ax ��� ��������� ����� ������������� ����� �� �������
    shr ax, 1
    sub dx, ax   ;��������� ��� ��������� ��������� x ����������
    add ax, bp   ;�������� ��� ��������� �������� x ����������

    ;���������  �����
draw_line:
    cmp dx, ax     ;�������� ���� ��������� x (cx) ������ ��� �������� x (ax)
    jae line_done    ;���� ��������� ��� ������� �����, ����� ���������
    push ax
    push bx
    push cx

    mov ah, 0x0C     ;��������� �������
    mov al, 0x3C          ;����
    int 0x10              ;���������� BIOS

    pop cx
    pop bx
    pop ax
    inc dx      ;������� � ���������� �������
    jmp draw_line   ;������ ����� ��� ���������� �������
line_done:
    pop dx
    add cx, 1   ;�� ������ ����
    add dx, 1    ;�������� ���������� x �� ���� ������� ������
    dec bx
    jnz triangle1     ;���������

    popa ;�������������� ���������
    ret
times 510-($-$$) db 0
dw 0xAA55