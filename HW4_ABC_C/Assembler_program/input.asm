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
    .FILE   resq    1   ; ��������� �������� ��������� �� ����
    .sphr  resq    1   ; ����� ��������������
section .text
push rbp
mov rbp, rsp

    mov     [.sphr], rdi          ; ����������� ����� ��������������
    mov     [.FILE], rsi          ; ����������� ��������� �� ����

    ; ���� �������������� �� �����
    mov     rdi, [.FILE]
    mov     rsi, .infmt         ; ������ - 1-� ��������
    mov     rdx, [.sphr]       ; &x
    movsd   xmm0, [.sphr]
    add     xmm0, 4              ; &y = &x + 4
    mov     rax, 1
    call    fscanf

leave
ret

; // ���� ���������� ������������ �� �����
; void InputParal(void *t, FILE *ifst) {
;     fscanf(ifst, "%d%d%d", (int*)t,
;            (int*)(t+intSize), (int*)(t+2*intSize));
; }
global InputParal
InputParal:
section .data
    .infmt db "%d%d%d%f",0
section .bss
    .FILE   resq    1   ; ��������� �������� ��������� �� ����
    .paral  resq    1   ; ����� ������������
section .text
push rbp
mov rbp, rsp

    ; ���������� �������� ����������
    mov     [.paral], rdi          ; ����������� ����� ������������
    mov     [.FILE], rsi          ; ����������� ��������� �� ����

    ; ���� ������������ �� �����
    mov     rdi, [.FILE]
    mov     rsi, .infmt         ; ������ - 1-� ��������
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
    .FILE   resq    1   ; ��������� �������� ��������� �� ����
    .tetr  resq    1   ; ����� ��������������
section .text
push rbp
mov rbp, rsp

    mov     [.tetr], rdi          ; ����������� ����� ��������������
    mov     [.FILE], rsi          ; ����������� ��������� �� ����

    ; ���� �������������� �� �����
    mov     rdi, [.FILE]
    mov     rsi, .infmt         ; ������ - 1-� ��������
    mov     rdx, [.tetr]       ; &x
    mov     xmm0, [.tetr]
    add     xmm0, 4              ; &y = &x + 4
    mov     rax, 1
    call    fscanf

leave
ret

; // ���� ���������� ���������� ������ �� �����
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
    .FILE       resq    1   ; ��������� �������� ��������� �� ����
    .pfig     resq    1   ; ����� ������
    .shapeTag   resd    1   ; ������� ������
section .text
push rbp
mov rbp, rsp

    ; ���������� �������� ����������
    mov     [.pfig], rdi          ; ����������� ����� ������
    mov     [.FILE], rsi            ; ����������� ��������� �� ����

    ; ������ �������� ������ � ��� ���������
    mov     rdi, [.FILE]
    mov     rsi, .tagFormat
    mov     rdx, [.pfig]      ; ����� ������ ������ (�� �������)
    xor     rax, rax
    call    fscanf

    ; �������� ����� �������� ������
;     mov     rdi, .tagOutFmt
;     mov     rax, [.pfig]
;     mov     esi, [rax]
;     call    printf

    mov rcx, [.pfig]          ; �������� ������ ������ ������
    mov eax, [rcx]              ; � ��������� ������������ ��������
    cmp eax, [SPHERE]
    je .sphereInput
    cmp eax, [PARAL]
    je .paralInput
    cmp eax, [TETRA]
    je .tetraInput
    xor eax, eax    ; ������������ ������� - ��������� ���� ��������
    jmp     .return
.sphereInput:
    ; ���� �����
    mov     rdi, [.pfig]
    add     rdi, 4
    mov     rsi, [.FILE]
    call    InputSphere
    mov     rax, 1  ; ��� �������� - true
    jmp     .return
.paralInput:
    ; ���� ���������������
    mov     rdi, [.pfig]
    add     rdi, 4
    mov     rsi, [.FILE]
    call    InputParal
    mov     rax, 1  ; ��� �������� - true
    jmp .return
.tetraInput:
    ; ���� ������������
    mov     rdi, [.pfig]
    add     rdi, 4
    mov     rsi, [.FILE]
    call    InputTetra
    mov     rax, 1  ; ��� �������� - true
.return:

leave
ret

; // ���� ����������� ���������� �� ���������� �����
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
    .pcont  resq    1   ; ����� ����������
    .plen   resq    1   ; ����� ��� ���������� ����� ��������� ���������
    .FILE   resq    1   ; ��������� �� ����
section .text
push rbp
mov rbp, rsp

    mov [.pcont], rdi   ; ����������� ��������� �� ���������
    mov [.plen], rsi    ; ����������� ��������� �� �����
    mov [.FILE], rdx    ; ����������� ��������� �� ����
    ; � rdi ����� ������ ����������
    xor rbx, rbx        ; ����� ����� = 0
    mov rsi, rdx        ; ������� ��������� �� ����
.loop:
    ; ���������� ������� ���������
    push rdi
    push rbx

    mov     rsi, [.FILE]
    mov     rax, 0      ; ��� ����� � ��������� ������
    call    InputFigure     ; ���� ������
    cmp rax, 0          ; �������� ���������� �����
    jle  .return        ; �����, ���� ������� ������ ��� ����� 0

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

