; file.asm - использование файлов в NASM
extern printf
extern rand

extern RECTANGLE
extern TRIANGLE


;----------------------------------------------
; // rnd.c - содержит генератор случайных чисел в диапазоне от 1 до 20
; int Random() {
;     return rand() % 20 + 1;
; }
global Random
Random:
section .data
    .i1000     dq      1000
    ;.rndNumFmt       db "Random number = %d",10,0
section .text
push rbp
mov rbp, rsp

    xor     rax, rax    ;
    call    rand        ; запуск генератора случайных чисел
    xor     rdx, rdx    ; обнуление перед делением
    idiv    qword[.i1000]       ; (/%) -> остаток в rdx
    mov     rax, rdx
    inc     rax         ; должно сформироваться случайное число

    ;mov     rdi, .rndNumFmt
    ;mov     esi, eax
    ;xor     rax, rax
    ;call    printf


leave
ret

global FRandom
FRandom:
section .data
    .mlt       dq      1000.0
    .maxint    dq      2147483647.0
section .text
push rbp
mov rbp, rsp
    mov rax, 0
    call    rand        ; запуск генератора случайных чисел
    cvtsi2sd    xmm0, eax
    divsd xmm0, [.maxint]
    mulsd xmm0, [.mlt]


leave
ret

;----------------------------------------------
;// Случайный ввод параметров прямоугольника
;void InputRandomSphere(void *r) {
    ;int x = Random();
    ;*((int*)r) = x;
    ;int y = Random();
    ;*((int*)(r+intSize)) = y;
;//     printf("    Rectangle %d %d\n", *((int*)r), *((int*)r+1));
;}
global InputRandomSphere
InputRandomSphere:
section .bss
    .sphr  resq 1   ; адрес прямоугольника
section .text
push rbp
mov rbp, rsp

    ; В rdi адрес прямоугольника
    mov     [.sphr], rdi
    ; Генерация сторон прямоугольника
    call    Random
    mov     rbx, [.sphr]
    mov     [rbx], eax
    call    FRandom
    movd    eax, xmm0
    mov     rbx, [.sphr]
    mov     [rbx+4], eax

leave
ret

;----------------------------------------------
;// Случайный ввод параметров треугольника
;void InputRandomParal(void *t) {
    ;int a, b, c;
    ;a = *((int*)t) = Random();
    ;b = *((int*)(t+intSize)) = Random();
    ;do {
        ;c = *((int*)(t+2*intSize)) = Random();
    ;} while((c >= a + b) || (a >= c + b) || (b >= c + a));
;//     printf("    Triangle %d %d %d\n", *((int*)t), *((int*)t+1), *((int*)t+2));
;}
global InputRandomParal
InputRandomParal:
section .bss
    .paral  resq 1   ; адрес треугольника
section .text
push rbp
mov rbp, rsp

    ; В rdi адрес треугольника
    mov     [.paral], rdi
    ; Генерация сторон треугольника
    call    Random
    mov     rbx, [.paral]
    mov     [rbx], eax
    call    Random
    mov     rbx, [.paral]
    mov     [rbx+4], eax
    call    Random
    mov     rbx, [.paral]
    mov     [rbx+8], eax
    call    FRandom
    movd    eax, xmm0
    mov     rbx, [.sphr]
    mov     [rbx+12], eax

leave
ret

global InputRandomTetra
InputRandomTetra:
section .bss
    .tetr  resq 1   ; адрес прямоугольника
section .text
push rbp
mov rbp, rsp

    ; В rdi адрес прямоугольника
    mov     [.tetr], rdi
    ; Генерация сторон прямоугольника
    call    Random
    mov     rbx, [.tetr]
    mov     [rbx], eax
    call    FRandom
    movd    eax, xmm0
    mov     rbx, [.tetr]
    mov     [rbx+4], eax

leave
ret

;----------------------------------------------
;// Случайный ввод обобщенной фигуры
;int InputRandomFigure(void *s) {
    ;int k = rand() % 2 + 1;
    ;switch(k) {
        ;case 1:
            ;*((int*)s) = RECTANGLE;
            ;InputRandomSphere(s+intSize);
            ;return 1;
        ;case 2:
            ;*((int*)s) = TRIANGLE;
            ;InputRandomParal(s+intSize);
            ;return 1;
        ;default:
            ;return 0;
    ;}
;}
global InputRandomFigure
InputRandomFigure:
section .data
    .i3              dq 3     
    .rndNumFmt       db "Random number = %d",10,0
section .bss
    .pfig       resq    1   ; адрес фигуры
    .key        resd    1   ; ключ
section .text
push rbp
mov rbp, rsp

    ; В rdi адрес фигуры
    mov [.pfig], rdi

    ; Формирование признака фигуры
    xor     rax, rax    ;
    call    rand        ; запуск генератора случайных чисел
    xor     rdx, rdx    ; обнуление перед делением
    idiv    qword[.i3]       ; (/%) -> остаток в rdx
    mov     rax, rdx
    inc     rax

    ;mov     [.key], eax
    ;mov     rdi, .rndNumFmt
    ;mov     esi, [.key]
    ;xor     rax, rax
    ;call    printf
    ;mov     eax, [.key]

    mov     rdi, [.pfig]
    mov     [rdi], eax      ; запись ключа в фигуру
    cmp eax, [SPHERE]
    je .sphereInputRandom
    cmp eax, [PARAL]
    je .paralInputRandom
    cmp eax, [TETRA]
    je .tetraInputRandom
    xor eax, eax        ; код возврата = 0
    jmp     .return
.sphereInputRandom:
    ; Генерация прямоугольника
    add     rdi, 4
    call    InputRandomSphere
    mov     eax, 1      ;код возврата = 1
    jmp     .return
.paralInputRandom:
    ; Генерация прямоугольника
    add     rdi, 4
    call    InputRandomParal
    mov     eax, 1      ;код возврата = 1
    jmp     .return
.tetraInputRandom:
    ; Генерация треугольника
    add     rdi, 4
    call    InputRandomTetra
    mov     eax, 1      ;код возврата = 1
.return:
leave
ret

;----------------------------------------------
;// Случайный ввод содержимого контейнера
;void InputRandomContainer(void *c, int *len, int size) {
    ;void *tmp = c;
    ;while(*len < size) {
        ;if(InputRandomFigure(tmp)) {
            ;tmp = tmp + shapeSize;
            ;(*len)++;
        ;}
    ;}
;}
global InputRandomContainer
InputRandomContainer:
section .bss
    .pcont  resq    1   ; адрес контейнера
    .plen   resq    1   ; адрес для сохранения числа введенных элементов
    .psize  resd    1   ; число порождаемых элементов
section .text
push rbp
mov rbp, rsp

    mov [.pcont], rdi   ; сохраняется указатель на контейнер
    mov [.plen], rsi    ; сохраняется указатель на длину
    mov [.psize], edx    ; сохраняется число порождаемых элементов
    ; В rdi адрес начала контейнера
    xor ebx, ebx        ; число фигур = 0
.loop:
    cmp ebx, edx
    jge     .return
    ; сохранение рабочих регистров
    push rdi
    push rbx
    push rdx

    call    InputRandomFigure     ; ввод фигуры
    cmp rax, 0          ; проверка успешности ввода
    jle  .return        ; выход, если признак меньше или равен 0

    pop rdx
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
