; file.asm - ������������� ������ � NASM
extern printf
extern fprintf

extern SquareSphere
extern SquareTetra
exterm SquareParal

;----------------------------------------------
;// ����� ���������� �������������� � ����
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
    .FILE   resq  1       ; ��������� �������� ��������� �� ����
    .s      resq  1       ; ����������� �������� ��������������
section .text
push rbp
mov rbp, rsp

    ; ��������� �������� ����������
    mov     [.sphr], rdi          ; ����������� ����� ��������������
    mov     [.FILE], rsi          ; ����������� ��������� �� ����

    ; ���������� ��������� �������������� (����� ��� � rdi)
    call    SquareSphere
    movsd   [.s], xmm1          ; ���������� (����� ������) ���������

    ; ����� ���������� � �������������� � �������
;     mov     rdi, .outfmt        ; ������ - 1-� ��������
;     mov     rax, [.sphr]       ; ����� ��������������
;     mov     esi, [rax]          ; x
;     mov     edx, [rax+4]        ; y
;     movsd   xmm0, [.s]
;     mov     rax, 1              ; ���� ����� � ��������� ������
;     call    printf

    ; ����� ���������� � �������������� � ����
    mov     rdi, [.FILE]
    mov     rsi, .outfmt        ; ������ - 2-� ��������
    mov     rax, [.sphr]        ; ����� ��������������
    mov     edx, [rax]          ; x
    mov     xmm0, [rax+4]        ; y
    movsd   xmm1, [.s]
    mov     rax, 2              ; ���� ����� � ��������� ������
    call    fprintf

leave
ret

;----------------------------------------------
; // ����� ���������� ������������ � ����
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
    .FILE   resq  1       ; ��������� �������� ��������� �� ����
    .s      resq  1       ; ����������� �������� ������������
section .text
push rbp
mov rbp, rsp

    ; ��������� �������� ����������
    mov     [.paral], rdi        ; ����������� ����� ������������
    mov     [.FILE], rsi          ; ����������� ��������� �� ����

    ; ���������� ��������� ������������ (����� ��� � rdi)
    call    SquareTetra
    movsd   [.s], xmm1          ; ���������� (����� ������) ���������

    ; ����� ���������� � ������������ � �������
;     mov     rdi, .outfmt        ; ������ - 1-� ��������
;     mov     rax, [.paral]       ; ����� ������������
;     mov     esi, [rax]          ; a
;     mov     edx, [rax+4]        ; b
;     mov     ecx, [rax+8]        ; c
;     movsd   xmm0, [.s]
;     mov     rax, 1              ; ���� ����� � ��������� ������
;     call    printf

    ; ����� ���������� � ������������ � ����
    mov     rdi, [.FILE]
    mov     rsi, .outfmt        ; ������ - 2-� ��������
    mov     rax, [.paral]      ; ����� ������������
    mov     edx, [rax]          ; x
    mov     ecx, [rax+4]        ; b
    mov      r8, [rax+8]        ; c
    movsd   xmm0, [rax+12]
    movsd   xmm1, [.s]
    mov     rax, 2              ; ���� ����� � ��������� ������
    call    fprintf

leave
ret

global PrintTetra
PrintTetra:
section .data
    .outfmt db "Tetrahedron with side = %d, density = %f and surface area = %f",10,0
section .bss
    .tetr  resq  1
    .FILE   resq  1       ; ��������� �������� ��������� �� ����
    .s      resq  1       ; ����������� �������� ��������������
section .text
push rbp
mov rbp, rsp

    ; ��������� �������� ����������
    mov     [.tetr], rdi          ; ����������� ����� ��������������
    mov     [.FILE], rsi          ; ����������� ��������� �� ����

    ; ���������� ��������� �������������� (����� ��� � rdi)
    call    SquareTetra
    movsd   [.s], xmm1          ; ���������� (����� ������) ���������

    ; ����� ���������� � �������������� � �������
;     mov     rdi, .outfmt        ; ������ - 1-� ��������
;     mov     rax, [.tetr]       ; ����� ��������������
;     mov     esi, [rax]          ; x
;     mov     edx, [rax+4]        ; y
;     movsd   xmm0, [.s]
;     mov     rax, 1              ; ���� ����� � ��������� ������
;     call    printf

    ; ����� ���������� � �������������� � ����
    mov     rdi, [.FILE]
    mov     rsi, .outfmt        ; ������ - 2-� ��������
    mov     rax, [.tetr]        ; ����� ��������������
    mov     edx, [rax]          ; x
    mov     xmm0, [rax+4]        ; y
    movsd   xmm1, [.s]
    mov     rax, 2              ; ���� ����� � ��������� ������
    call    fprintf

leave
ret

;----------------------------------------------
; // ����� ���������� ������� ������ � ����
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

    ; � rdi ����� ������
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
    ; ����� ��������������
    add     rdi, 4
    call    PrintSphere
    jmp     return
paralPrint:
    ; ����� ������������
    add     rdi, 4
    call    PrintParal
    jmp     return
tetraPrint:
    ; ����� ������������
    add     rdi, 4
    call    PrintTetra
return:
leave
ret

;----------------------------------------------
; // ����� ����������� ���������� � ����
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
    .scont  resq    1   ; ����� ����������
    .len    resd    1   ; ����� ��� ���������� ����� ��������� ���������
    .FILE   resq    1   ; ��������� �� ����
section .text
push rbp
mov rbp, rsp

    mov [.scont], rdi   ; ����������� ��������� �� ���������
    mov [.len],   esi     ; ����������� ����� ���������
    mov [.FILE],  rdx    ; ����������� ��������� �� ����

    ; � rdi ����� ������ ����������
    mov rbx, rsi            ; ����� �����
    xor ecx, ecx            ; ������� ����� = 0
    mov rsi, rdx            ; ������� ��������� �� ����
.loop:
    cmp ecx, ebx            ; �������� �� ��������� �����
    jge .return             ; ��������� ��� ������

    push rbx
    push rcx

    ; ����� ������ ������
    mov     rdi, [.FILE]    ; ������� ��������� �� ����
    mov     rsi, numFmt     ; ������ ��� ������ ������
    mov     edx, ecx        ; ������ ������� ������
    xor     rax, rax,       ; ������ ������������� ��������
    call fprintf

    ; ����� ������� ������
    mov     rdi, [.scont]
    mov     rsi, [.FILE]
    call PrintFigure     ; ��������� ��������� ������ ������

    pop rcx
    pop rbx
    inc ecx                 ; ������ ��������� ������

    mov     rax, [.scont]
    add     rax, 24         ; ����� ��������� ������
    mov     [.scont], rax
    jmp .loop
.return:
leave
ret

