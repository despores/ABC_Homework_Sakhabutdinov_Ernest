extern printf
extern fscanf

extern SPHERE
extern TETRA
extern PARAL

global InputSphere
InputSphere:
section .data
    .infmt db "%d%f",0
section .bss
    .FILE   resq    1   ; временное хранение указателя на файл
    .sphr  resq    1   ; адрес прямоугольника
section .text
push rbp
mov rbp, rsp

    mov     [.sphr], rdi          ; сохраняется адрес прямоугольника
    mov     [.FILE], rsi          ; сохраняется указатель на файл

    ; Ввод прямоугольника из файла
    mov     rdi, [.FILE]
    mov     rsi, .infmt         ; Формат - 1-й аргумент
    mov     rdx, [.sphr]       ; &x
    movsd   xmm0, [.sphr]
    add     xmm0, 4              ; &y = &x + 4
    mov     rax, 1
    call    fscanf

leave
ret

; // Ввод параметров треугольника из файла
; void InputParal(void *t, FILE *ifst) {
;     fscanf(ifst, "%d%d%d", (int*)t,
;            (int*)(t+intSize), (int*)(t+2*intSize));
; }
global InputParal
InputParal:
section .data
    .infmt db "%d%d%d%f",0
section .bss
    .FILE   resq    1   ; временное хранение указателя на файл
    .paral  resq    1   ; адрес треугольника
section .text
push rbp
mov rbp, rsp

    ; Сохранение принятых аргументов
    mov     [.paral], rdi          ; сохраняется адрес треугольника
    mov     [.FILE], rsi          ; сохраняется указатель на файл

    ; Ввод треугольника из файла
    mov     rdi, [.FILE]
    mov     rsi, .infmt         ; Формат - 1-й аргумент
    mov     rdx, [.paral]       ; &a
    mov     rcx, [.paral]
    add     rcx, 4              ; &b = &a + 4
    mov     r8, [.paral]
    add     r8, 8               ; &c = &x + 8
    mov     xmm0, [.paral]
    add     xmm0, 12
    mov     rax, 1
    call    fscanf

leave
ret

global InputTetra
InputTetra:
section .data
    .infmt db "%d%f",0
section .bss
    .FILE   resq    1   ; временное хранение указателя на файл
    .tetr  resq    1   ; адрес прямоугольника
section .text
push rbp
mov rbp, rsp

    mov     [.tetr], rdi          ; сохраняется адрес прямоугольника
    mov     [.FILE], rsi          ; сохраняется указатель на файл

    ; Ввод прямоугольника из файла
    mov     rdi, [.FILE]
    mov     rsi, .infmt         ; Формат - 1-й аргумент
    mov     rdx, [.tetr]       ; &x
    mov     xmm0, [.tetr]
    add     xmm0, 4              ; &y = &x + 4
    mov     rax, 1
    call    fscanf

leave
ret

; // Ввод параметров обобщенной фигуры из файла
; int InputFigure(void *s, FILE *ifst) {
;     int k;
;     fscanf(ifst, "%d", &k);
;     switch(k) {
;         case 1:
;             *((int*)s) = RECTANGLE;
;             InputSphere(s+intSize, ifst);
;             return 1;
;         case 2:
;             *((int*)s) = TRIANGLE;
;             InputParal(s+intSize, ifst);
;             return 1;
;         default:
;             return 0;
;     }
; }
global InputFigure
InputFigure:
section .data
    .tagFormat   db      "%d",0
    .tagOutFmt   db     "Tag is: %d",10,0
section .bss
    .FILE       resq    1   ; временное хранение указателя на файл
    .pfig     resq    1   ; адрес фигуры
    .shapeTag   resd    1   ; признак фигуры
section .text
push rbp
mov rbp, rsp

    ; Сохранение принятых аргументов
    mov     [.pfig], rdi          ; сохраняется адрес фигуры
    mov     [.FILE], rsi            ; сохраняется указатель на файл

    ; чтение признака фигуры и его обработка
    mov     rdi, [.FILE]
    mov     rsi, .tagFormat
    mov     rdx, [.pfig]      ; адрес начала фигуры (ее признак)
    xor     rax, rax
    call    fscanf

    ; Тестовый вывод признака фигуры
;     mov     rdi, .tagOutFmt
;     mov     rax, [.pfig]
;     mov     esi, [rax]
;     call    printf

    mov rcx, [.pfig]          ; загрузка адреса начала фигуры
    mov eax, [rcx]              ; и получение прочитанного признака
    cmp eax, [SPHERE]
    je .sphereInput
    cmp eax, [PARAL]
    je .paralInput
    cmp eax, [TETRA]
    je .tetraInput
    xor eax, eax    ; Некорректный признак - обнуление кода возврата
    jmp     .return
.sphereInput:
    ; Ввод сферы
    mov     rdi, [.pfig]
    add     rdi, 4
    mov     rsi, [.FILE]
    call    InputSphere
    mov     rax, 1  ; Код возврата - true
    jmp     .return
.paralInput:
    ; Ввод параллелограмма
    mov     rdi, [.pfig]
    add     rdi, 4
    mov     rsi, [.FILE]
    call    InputParal
    mov     rax, 1  ; Код возврата - true
    jmp .return
.tetraInput:
    ; Ввод треугольника
    mov     rdi, [.pfig]
    add     rdi, 4
    mov     rsi, [.FILE]
    call    InputTetra
    mov     rax, 1  ; Код возврата - true
.return:

leave
ret

; // Ввод содержимого контейнера из указанного файла
; void InputContainer(void *c, int *len, FILE *ifst) {
;     void *tmp = c;
;     while(!feof(ifst)) {
;         if(InputFigure(tmp, ifst)) {
;             tmp = tmp + shapeSize;
;             (*len)++;
;         }
;     }
; }
global InputContainer
InputContainer:
section .bss
    .pcont  resq    1   ; адрес контейнера
    .plen   resq    1   ; адрес для сохранения числа введенных элементов
    .FILE   resq    1   ; указатель на файл
section .text
push rbp
mov rbp, rsp

    mov [.pcont], rdi   ; сохраняется указатель на контейнер
    mov [.plen], rsi    ; сохраняется указатель на длину
    mov [.FILE], rdx    ; сохраняется указатель на файл
    ; В rdi адрес начала контейнера
    xor rbx, rbx        ; число фигур = 0
    mov rsi, rdx        ; перенос указателя на файл
.loop:
    ; сохранение рабочих регистров
    push rdi
    push rbx

    mov     rsi, [.FILE]
    mov     rax, 0      ; нет чисел с плавающей точкой
    call    InputFigure     ; ввод фигуры
    cmp rax, 0          ; проверка успешности ввода
    jle  .return        ; выход, если признак меньше или равен 0

    pop rbx
    inc rbx

    pop rdi
    add rdi, 24             ; адрес следующей фигуры

    jmp .loop
.return:
    mov rax, [.plen]    ; перенос указателя на длину
    mov [rax], ebx      ; занесение длины
leave
ret

