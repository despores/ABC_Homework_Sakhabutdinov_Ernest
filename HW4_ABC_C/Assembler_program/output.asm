; file.asm - использование файлов в NASM
extern printf
extern fprintf

extern SquareSphere
extern SquareTetra
exterm SquareParal

;----------------------------------------------
;// Вывод параметров прямоугольника в файл
;void PrintSphere(void *r, FILE *ofst) {
;    fprintf(ofst, "It is Rectangle: x = %d, y = %d. Perimeter = %g\n",
;            *((int*)r), *((int*)(r+intSize)), SquareSphere(r));
;}
global PrintSphere
PrintSphere:
section .data
    .outfmt db "Sphere with radius = %d, density = %f and surface area = %f",10,0
section .bss
    .sphr  resq  1
    .FILE   resq  1       ; временное хранение указателя на файл
    .s      resq  1       ; вычисленный периметр прямоугольника
section .text
push rbp
mov rbp, rsp

    ; Сохранени принятых аргументов
    mov     [.sphr], rdi          ; сохраняется адрес прямоугольника
    mov     [.FILE], rsi          ; сохраняется указатель на файл

    ; Вычисление периметра прямоугольника (адрес уже в rdi)
    call    SquareSphere
    movsd   [.s], xmm1          ; сохранение (может лишнее) периметра

    ; Вывод информации о прямоугольнике в консоль
;     mov     rdi, .outfmt        ; Формат - 1-й аргумент
;     mov     rax, [.sphr]       ; адрес прямоугольника
;     mov     esi, [rax]          ; x
;     mov     edx, [rax+4]        ; y
;     movsd   xmm0, [.s]
;     mov     rax, 1              ; есть числа с плавающей точкой
;     call    printf

    ; Вывод информации о прямоугольнике в файл
    mov     rdi, [.FILE]
    mov     rsi, .outfmt        ; Формат - 2-й аргумент
    mov     rax, [.sphr]        ; адрес прямоугольника
    mov     edx, [rax]          ; x
    mov     xmm0, [rax+4]        ; y
    movsd   xmm1, [.s]
    mov     rax, 2              ; есть числа с плавающей точкой
    call    fprintf

leave
ret

;----------------------------------------------
; // Вывод параметров треугольника в файл
; void PrintParal(void *t, FILE *ofst) {
;     fprintf(ofst, "It is Triangle: a = %d, b = %d, c = %d. Perimeter = %g\n",
;            *((int*)t), *((int*)(t+intSize)), *((int*)(t+2*intSize)),
;             SquareTetra(t));
; }
global PrintParal
PrintParal:
section .data
    .outfmt db "Parallelepiped with sides x = %d, y = %d, z = %d, density = %f and surface area = %f",10,0
section .bss
    .paral  resq  1
    .FILE   resq  1       ; временное хранение указателя на файл
    .s      resq  1       ; вычисленный периметр треугольника
section .text
push rbp
mov rbp, rsp

    ; Сохранени принятых аргументов
    mov     [.paral], rdi        ; сохраняется адрес треугольника
    mov     [.FILE], rsi          ; сохраняется указатель на файл

    ; Вычисление периметра треугольника (адрес уже в rdi)
    call    SquareTetra
    movsd   [.s], xmm1          ; сохранение (может лишнее) периметра

    ; Вывод информации о треугольнике в консоль
;     mov     rdi, .outfmt        ; Формат - 1-й аргумент
;     mov     rax, [.paral]       ; адрес треугольника
;     mov     esi, [rax]          ; a
;     mov     edx, [rax+4]        ; b
;     mov     ecx, [rax+8]        ; c
;     movsd   xmm0, [.s]
;     mov     rax, 1              ; есть числа с плавающей точкой
;     call    printf

    ; Вывод информации о треугольнике в файл
    mov     rdi, [.FILE]
    mov     rsi, .outfmt        ; Формат - 2-й аргумент
    mov     rax, [.paral]      ; адрес треугольника
    mov     edx, [rax]          ; x
    mov     ecx, [rax+4]        ; b
    mov      r8, [rax+8]        ; c
    movsd   xmm0, [rax+12]
    movsd   xmm1, [.s]
    mov     rax, 2              ; есть числа с плавающей точкой
    call    fprintf

leave
ret

global PrintTetra
PrintTetra:
section .data
    .outfmt db "Tetrahedron with side = %d, density = %f and surface area = %f",10,0
section .bss
    .tetr  resq  1
    .FILE   resq  1       ; временное хранение указателя на файл
    .s      resq  1       ; вычисленный периметр прямоугольника
section .text
push rbp
mov rbp, rsp

    ; Сохранени принятых аргументов
    mov     [.tetr], rdi          ; сохраняется адрес прямоугольника
    mov     [.FILE], rsi          ; сохраняется указатель на файл

    ; Вычисление периметра прямоугольника (адрес уже в rdi)
    call    SquareTetra
    movsd   [.s], xmm1          ; сохранение (может лишнее) периметра

    ; Вывод информации о прямоугольнике в консоль
;     mov     rdi, .outfmt        ; Формат - 1-й аргумент
;     mov     rax, [.tetr]       ; адрес прямоугольника
;     mov     esi, [rax]          ; x
;     mov     edx, [rax+4]        ; y
;     movsd   xmm0, [.s]
;     mov     rax, 1              ; есть числа с плавающей точкой
;     call    printf

    ; Вывод информации о прямоугольнике в файл
    mov     rdi, [.FILE]
    mov     rsi, .outfmt        ; Формат - 2-й аргумент
    mov     rax, [.tetr]        ; адрес прямоугольника
    mov     edx, [rax]          ; x
    mov     xmm0, [rax+4]        ; y
    movsd   xmm1, [.s]
    mov     rax, 2              ; есть числа с плавающей точкой
    call    fprintf

leave
ret

;----------------------------------------------
; // Вывод параметров текущей фигуры в файл
; void PrintFigure(void *s, FILE *ofst) {
;     int k = *((int*)s);
;     if(k == RECTANGLE) {
;         PrintSphere(s+intSize, ofst);
;     }
;     else if(k == TRIANGLE) {
;         PrintParal(s+intSize, ofst);
;     }
;     else {
;         fprintf(ofst, "Incorrect figure!\n");
;     }
; }
global PrintFigure
PrintFigure:
section .data
    .erfigure db "Incorrect figure!",10,0
section .text
push rbp
mov rbp, rsp

    ; В rdi адрес фигуры
    mov eax, [rdi]
    cmp eax, [SPHERE]
    je spherePrint
    cmp eax, [PARAL]
    je paralPrint
    cmp eax, [TETRA]
    je tetraPrint
    mov rdi, .erfigure
    mov rax, 0
    call fprintf
    jmp     return
spherePrint:
    ; Вывод прямоугольника
    add     rdi, 4
    call    PrintSphere
    jmp     return
paralPrint:
    ; Вывод треугольника
    add     rdi, 4
    call    PrintParal
    jmp     return
tetraPrint:
    ; Вывод треугольника
    add     rdi, 4
    call    PrintTetra
return:
leave
ret

;----------------------------------------------
; // Вывод содержимого контейнера в файл
; void OutContainer(void *c, int len, FILE *ofst) {
;     void *tmp = c;
;     fprintf(ofst, "Container contains %d elements.\n", len);
;     for(int i = 0; i < len; i++) {
;         fprintf(ofst, "%d: ", i);
;         PrintFigure(tmp, ofst);
;         tmp = tmp + shapeSize;
;     }
; }
global OutContainer
OutContainer:
section .data
    numFmt  db  "%d: ",0
section .bss
    .scont  resq    1   ; адрес контейнера
    .len    resd    1   ; адрес для сохранения числа введенных элементов
    .FILE   resq    1   ; указатель на файл
section .text
push rbp
mov rbp, rsp

    mov [.scont], rdi   ; сохраняется указатель на контейнер
    mov [.len],   esi     ; сохраняется число элементов
    mov [.FILE],  rdx    ; сохраняется указатель на файл

    ; В rdi адрес начала контейнера
    mov rbx, rsi            ; число фигур
    xor ecx, ecx            ; счетчик фигур = 0
    mov rsi, rdx            ; перенос указателя на файл
.loop:
    cmp ecx, ebx            ; проверка на окончание цикла
    jge .return             ; Перебрали все фигуры

    push rbx
    push rcx

    ; Вывод номера фигуры
    mov     rdi, [.FILE]    ; текущий указатель на файл
    mov     rsi, numFmt     ; формат для вывода фигуры
    mov     edx, ecx        ; индекс текущей фигуры
    xor     rax, rax,       ; только целочисленные регистры
    call fprintf

    ; Вывод текущей фигуры
    mov     rdi, [.scont]
    mov     rsi, [.FILE]
    call PrintFigure     ; Получение периметра первой фигуры

    pop rcx
    pop rbx
    inc ecx                 ; индекс следующей фигуры

    mov     rax, [.scont]
    add     rax, 24         ; адрес следующей фигуры
    mov     [.scont], rax
    jmp .loop
.return:
leave
ret

