;------------------------------------------------------------------------------
; perimeter.asm - единица компиляции, вбирающая функции вычисления периметра
;------------------------------------------------------------------------------

extern RECTANGLE
extern TRIANGLE

;----------------------------------------------
; Вычисление периметра прямоугольника
;double PerimeterRectangle(void *r) {
;    return 2.0 * (*((int*)r)
;           + *((int*)(r+intSize)));
;}
global SquareSphere
SquareSphere:
section .data
    .pi dq  3.14159265359
section .text
push rbp
mov rbp, rsp

    ; В rdi адрес прямоугольника
    mov      eax, [rdi]
    mul      eax, eax
    shl      eax, 1
    cvtsi2sd xmm0, eax
    mulsd    xmm0, [.pi]

leave
ret

;----------------------------------------------
; double PerimeterTriangle(void *t) {
;    return (double)(*((int*)t)
;       + *((int*)(t+intSize))
;       + *((int*)(t+2*intSize)));
;}
global SquareTetra
SquareTetra:
section .data
    .sqrt   dq    1.73205080757
section .text
push rbp
mov rbp, rsp

    ; В rdi адрес треугольника
    mov      eax, [rdi]
    mul      eax, eax
    cvtsi2sd xmm0, eax
    mulsd    xmm0, [.sqrt]

leave
ret

global SquareParal
SquareParal:
section .text
push rbp
mov rbp, rsp

    ; В rdi адрес треугольника
    mov      eax, [rdi]
    mul      eax, [rdi + 4]
    mov      ecx, [rdi]
    mul      ecx, [rdi + 8]
    mov      edx, [rdi + 4]
    mul      edx, [rdi + 8]
    add      eax, ecx
    add      eax, edx
    shl      eax, 1
    cvtsi2sd xmm0, eax

leave
ret

;----------------------------------------------
; Вычисление периметра фигуры
;double PerimeterShape(void *s) {
;    int k = *((int*)s);
;    if(k == RECTANGLE) {
;        return PerimeterRectangle(s+intSize);
;    }
;    else if(k == TRIANGLE) {
;        return PerimeterTriangle(s+intSize);
;    }
;    else {
;        return 0.0;
;    }
;}
global SquareFigure
SquareFigure:
section .text
push rbp
mov rbp, rsp

    ; В rdi адрес фигуры
    mov eax, [rdi]
    cmp eax, [SPHERE]
    je sphereSquare
    cmp eax, [PARAL]
    je paralSquare
    cmp eax, [TETRA]
    je tetraSquare
    xor eax, eax
    cvtsi2sd    xmm0, eax
    jmp     return
sphereSquare:
    ; Вычисление периметра прямоугольника
    add     rdi, 4
    call    SquareSphere
    jmp     return
paralSquare:
    ; Вычисление периметра треугольника
    add     rdi, 4
    call    SquareParal
    jmp     return
tetraSquare:
    ; Вычисление периметра треугольника
    add     rdi, 4
    call    SquareTetra
return:
leave
ret

;----------------------------------------------
;// Вычисление суммы периметров всех фигур в контейнере
;double PerimeterSumContainer(void *c, int len) {
;    double sum = 0.0;
;    void *tmp = c;
;    for(int i = 0; i < len; i++) {
;        sum += PerimeterShape(tmp);
;        tmp = tmp + shapeSize;
;    }
;    return sum;
;}
global PerimeterSumContainer
PerimeterSumContainer:
section .data
    .sum    dq  0.0
section .text
push rbp
mov rbp, rsp

    ; В rdi адрес начала контейнера
    mov ebx, esi            ; число фигур
    xor ecx, ecx            ; счетчик фигур
    movsd xmm1, [.sum]      ; перенос накопителя суммы в регистр 1
.loop:
    cmp ecx, ebx            ; проверка на окончание цикла
    jge .return             ; Перебрали все фигуры

    mov r10, rdi            ; сохранение начала фигуры
    call PerimeterShape     ; Получение периметра первой фигуры
    addsd xmm1, xmm0        ; накопление суммы
    inc rcx                 ; индекс следующей фигуры
    add r10, 16             ; адрес следующей фигуры
    mov rdi, r10            ; восстановление для передачи параметра
    jmp .loop
.return:
    movsd xmm0, xmm1
leave
ret
