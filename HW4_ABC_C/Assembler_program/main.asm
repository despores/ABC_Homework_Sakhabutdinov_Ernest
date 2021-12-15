global SPHERE
global TETRA
global PARAL

section .data
	SPHERE	dd	1
	PARAL	dd	2
	TETRA	dd	3
	oneDouble dq 1.0
	erMsg1  db "Incorrect number of arguments = %d: ",10,0
    rndGen  db "-n",0
    fileGen  db "-f",0
    errMessage1 db  "incorrect command line!", 10,"  Waited:",10
                db  "     command -f infile outfile01 outfile02",10,"  Or:",10
                db  "     command -n number outfile01 outfile02",10,0
    errMessage2 db  "incorrect qualifier value!", 10,"  Waited:",10
                db  "     command -f infile outfile01 outfile02",10,"  Or:",10
                db  "     command -n number outfile01 outfile02",10,0
    len         dd  0

section .bss
    argc        resd    1
    num         resd    1
    sum         resq    1
    start       resq    1       ; начало отсчета времени
    delta       resq    1       ; интервал отсчета времени
    startTime   resq    2       ; начало отсчета времени
    endTime     resq    2       ; конец отсчета времени
    deltaTime   resq    2       ; интервал отсчета времени
    ifst        resq    1       ; указатель на файл, открываемый файл для чтения фигур
    ofst1       resq    1       ; указатель на файл, открываемый файл для записи контейнера
    ofst2       resq    1       ; указатель на файл, открываемый файл для записи периметра
    cont        resb    160000  ; Массив используемый для хранения данных

section .text
	global main
main:
push	rbp
mov		rbp, rsp

	mov	dword [argc], edi
	mov	r12, rdi
	mov r13, rsi
	
.printArguments:
    PrintStrLn "The command and arguments:", [stdout]
    mov rbx, 0
.printLoop:
    PrintStrBuf qword [r13+rbx*8], [stdout]
    PrintStr    10, [stdout]
    inc rbx
    cmp rbx, r12
    jl .printLoop

    cmp r12, 5
    je .next1
    PrintStrBuf errMessage1, [stdout]
    jmp .return
.next1:
    PrintStrLn "Start", [stdout]
    ; Проверка второго аргумента
    mov rdi, rndGen     ; признак для сравнения
    mov rsi, [r13+8]    ; второй аргумент командной строки
    mov rcx, 3          ; сравнение, включая нуль (обе строки завершились)
    cld                 ; обнуление флага направления (инкремент)
    repe cmpsb
    ;;call strcmp
    ;;cmp rax, 0          ; строки равны "-n"
    je .next2
    mov rdi, fileGen
    mov rsi, [r13+8]    ; второй аргумент командной строки
    ;;mov rcx, 3          ; сравнение, включая нуль (обе строки завершились)
    ;;cld                 ; обнуление флага направления (инкремент)
    ;;repe cmpsb
    call strcmp
    cmp rax, 0          ; строки равны "-f"
    je .next3
    PrintStrBuf errMessage2, [stdout]
    jmp .return
	
.next2:
    ; Генерация случайных фигур
    mov rdi, [r13+16]
    call atoi
    mov [num], eax
    PrintInt [num], [stdout]
    PrintStrLn "", [stdout]
    mov eax, [num]
    cmp eax, 1
    jl .fall1
    cmp eax, 10000
    jg .fall1
    ; Начальная установка генератора случайных чисел
    xor     rdi, rdi
    xor     rax, rax
    call    time
    mov     rdi, rax
    xor     rax, rax
    call    srand
    ; Заполнение контейнера случайными фигурами
    mov     rdi, cont   ; передача адреса контейнера
    mov     rsi, len    ; передача адреса для длины
    mov     edx, [num]  ; передача количества порождаемых фигур
    call    InputRandonContainer
    jmp .task2
	
.next3:

	FileOpen [r13+16], "r", ifst

	mov rdi, cont
	mov rsi, len
	mov rdx, [ifst]
	xor rax, rax
	call InputContainer 3 BBOM DaHHbIx
	FileClose [ifst]

.task2:

	PrintStrLn "Filled container:", [stdout]
	PrintContainer cont, [len], [stdout]

	FileOpen [r13+24], "w", ofst1
	PrintStrLn "Filled container:", [ofst1]
	PrintContainer cont, [len], [ofst1]
	FileClose [ofst1]
	; timer
	
	mov rax, 228
	xor edi, edi
	lea rsi, [startTime]
	syscall
	
	ContainerSum cont, [len], [sum]

	mov rax, 228
	xor edi, edi
	lea rsi, [endTime]
	syscall

	mov rax, [endTime]
	sub rax, [startTime]
	mov rbx, [endTime+8]
	mov rax, [startTime]
	cmp rbx, rcx

	;jge .subNanoOnly

	dec rax
	add rbx, 1000000000

.fall1:
	PrintStr "incorrect numer of figures = ", [stdout]
	PrintInt [num], [stdout]
	PrintStrLn ". Set 0 < number <= 10000", [stdout]
.return:
leave
ret