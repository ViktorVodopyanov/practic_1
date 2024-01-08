format binary as 'img';форматируем бин файл
org 0x7C00
jmp start
fam db "Vodopyanov", 0
name db "Viktor", 0
nomer db "NMT-313901", 0
fat db "Anatolievich", 0

;Настройка сегмента стека
start:
cli                 ;Отключить прерывания
mov ax, 0           ;Инициализация сегмента стека
mov ss, ax
mov sp, 0xFFFF      ;Установка указателя стека на верх
sti                 ;Включить прерывания
mov ax, 0x13        ; Переключение в режим 320x200 256-цвета
int 0x10
mov ax, 0x0010      ; Установка графического режима текста
int 0x10

;координаты  треугольника
    mov cx, 60
    mov dx, 60
    mov bx, 100
    call triangle
         ; цвет фона
mov ah, 0x0B
mov bl, 0x1C  ; цвет фона
int 0x10
;Вывод текста построчно
    mov ah, 0x13; Функция для вывода текста
    mov al, 0
    mov bh, 0
    mov bl, 10  ; Цвет текста
    mov dl, 68      ;Колонка
    mov dh, 21   ;Строка
    push cs
    pop es
    mov bp, nomer
    mov cx, 10  ;Длина текста
    int 0x10
    mov ah, 0x13   ; Функция для вывода текста
    mov al, 0
    mov bh, 0
    mov bl, 11    ; Цвет текста
    mov dl, 68  ;Колонка
    mov dh, 22    ;Строка
    push cs
    pop es
    mov bp, name
    mov cx, 6  ;Длина текста
    int 0x10

    mov ah, 0x13 ; Функция для вывода текста
    mov al, 0
    mov bh, 0
    mov bl, 12 ; Цвет текста
    mov dl, 68 ;Колонка
    mov dh, 23 ;Строка
    push cs
    pop es
    mov bp, fam
    mov cx, 10 ;Длина текста
    int 0x10

    mov ah, 0x13  ; Функция для вывода текста
    mov al, 0
    mov bh, 0
    mov bl, 13   ; Цвет текста
    mov dl, 68      ;Колонка
    mov dh, 24 ;Строка
    push cs
    pop es
    mov bp, fat
    mov cx, 11 ;Длина текста
    int 0x10
hang:
    jmp hang

triangle:
    pusha
    mov bp, dx ;сохраним оригинал x координаты для сравнения

    ;Цикл отрисовки треугольника
triangle1:
    push dx
    mov ax, bx  ;ax для рисования линий уменьшающейся длины по очереди
    shr ax, 1
    sub dx, ax   ;Вычитание для получения начальной x координаты
    add ax, bp   ;Сложение для получения конечной x координаты

    ;Рисование  линии
draw_line:
    cmp dx, ax     ;Проверка если начальный x (cx) меньше чем конечный x (ax)
    jae line_done    ;Если достигнут или пройден конец, линия закончена
    push ax
    push bx
    push cx

    mov ah, 0x0C     ;отрисовка пикселя
    mov al, 0x3C          ;Цвет
    int 0x10              ;Прерывание BIOS

    pop cx
    pop bx
    pop ax
    inc dx      ;Переход к следующему пикселю
    jmp draw_line   ;Повтор цикла для следующего пикселя
line_done:
    pop dx
    add cx, 1   ;на строку выше
    add dx, 1    ;Смещение начального x на один пиксель вправо
    dec bx
    jnz triangle1     ;Континуум

    popa ;Восстановление регистров
    ret
times 510-($-$$) db 0
dw 0xAA55