; file.asm - ������������� ������ � NASM
extern printf
extern rand

extern RECTANGLE
extern TRIANGLE


;----------------------------------------------
; // rnd.c - �������� ��������� ��������� ����� � ��������� �� 1 �� 20
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
    call    rand        ; ������ ���������� ��������� �����
    xor     rdx, rdx    ; ��������� ����� ��������
    idiv    qword[.i1000]       ; (/%) -> ������� � rdx
    mov     rax, rdx
    inc     rax         ; ������ �������������� ��������� �����

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
    call    rand        ; ������ ���������� ��������� �����
    cvtsi2sd    xmm0, eax
    divsd xmm0, [.maxint]
    mulsd xmm0, [.mlt]


leave
ret

;----------------------------------------------
;// ��������� ���� ���������� ��������������
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
    .sphr  resq 1   ; ����� ��������������
section .text
push rbp
mov rbp, rsp

    ; � rdi ����� ��������������
    mov     [.sphr], rdi
    ; ��������� ������ ��������������
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
;// ��������� ���� ���������� ������������
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
    .paral  resq 1   ; ����� ������������
section .text
push rbp
mov rbp, rsp

    ; � rdi ����� ������������
    mov     [.paral], rdi
    ; ��������� ������ ������������
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
    .tetr  resq 1   ; ����� ��������������
section .text
push rbp
mov rbp, rsp

    ; � rdi ����� ��������������
    mov     [.tetr], rdi
    ; ��������� ������ ��������������
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
;// ��������� ���� ���������� ������
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
    .pfig       resq    1   ; ����� ������
    .key        resd    1   ; ����
section .text
push rbp
mov rbp, rsp

    ; � rdi ����� ������
    mov [.pfig], rdi

    ; ������������ �������� ������
    xor     rax, rax    ;
    call    rand        ; ������ ���������� ��������� �����
    xor     rdx, rdx    ; ��������� ����� ��������
    idiv    qword[.i3]       ; (/%) -> ������� � rdx
    mov     rax, rdx
    inc     rax

    ;mov     [.key], eax
    ;mov     rdi, .rndNumFmt
    ;mov     esi, [.key]
    ;xor     rax, rax
    ;call    printf
    ;mov     eax, [.key]

    mov     rdi, [.pfig]
    mov     [rdi], eax      ; ������ ����� � ������
    cmp eax, [SPHERE]
    je .sphereInputRandom
    cmp eax, [PARAL]
    je .paralInputRandom
    cmp eax, [TETRA]
    je .tetraInputRandom
    xor eax, eax        ; ��� �������� = 0
    jmp     .return
.sphereInputRandom:
    ; ��������� ��������������
    add     rdi, 4
    call    InputRandomSphere
    mov     eax, 1      ;��� �������� = 1
    jmp     .return
.paralInputRandom:
    ; ��������� ��������������
    add     rdi, 4
    call    InputRandomParal
    mov     eax, 1      ;��� �������� = 1
    jmp     .return
.tetraInputRandom:
    ; ��������� ������������
    add     rdi, 4
    call    InputRandomTetra
    mov     eax, 1      ;��� �������� = 1
.return:
leave
ret

;----------------------------------------------
;// ��������� ���� ����������� ����������
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
    .pcont  resq    1   ; ����� ����������
    .plen   resq    1   ; ����� ��� ���������� ����� ��������� ���������
    .psize  resd    1   ; ����� ����������� ���������
section .text
push rbp
mov rbp, rsp

    mov [.pcont], rdi   ; ����������� ��������� �� ���������
    mov [.plen], rsi    ; ����������� ��������� �� �����
    mov [.psize], edx    ; ����������� ����� ����������� ���������
    ; � rdi ����� ������ ����������
    xor ebx, ebx        ; ����� ����� = 0
.loop:
    cmp ebx, edx
    jge     .return
    ; ���������� ������� ���������
    push rdi
    push rbx
    push rdx

    call    InputRandomFigure     ; ���� ������
    cmp rax, 0          ; �������� ���������� �����
    jle  .return        ; �����, ���� ������� ������ ��� ����� 0

    pop rdx
    pop rbx
    inc rbx

    pop rdi
    add rdi, 24             ; ����� ��������� ������

    jmp .loop
.return:
    mov rax, [.plen]    ; ������� ��������� �� �����
    mov [rax], ebx      ; ��������� �����
leave
ret
