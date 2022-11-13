        .file   "main.c"
        .intel_syntax noprefix
        .text
        .section        .rodata
.LC0:
        .string "%d\n"
.LC1:
        .string "%c"
        .text
        .globl  main
        .type   main, @function

# сдвиг относительно rpb:
# -32  -|-  n
# -16  -|-  arr
# -20  -|-  i
# -28  -|- countUpper
# -24  -|- counrLower


main:
        push    rbp
        mov     rbp, rsp
        sub     rsp, 32        # выделение места на стеке для main
        mov     rax, QWORD PTR fs:40
        mov     QWORD PTR -8[rbp], rax
        xor     eax, eax
        lea     rax, -32[rbp]  # rax := &n  адрес по которому лежит n (вершина стека +0)
        mov     rsi, rax       # rsi := &n
        lea     rax, .LC0[rip] # rax := указатель на строку "%d\n"
        mov     rdi, rax
        mov     eax, 0
        call    __isoc99_scanf@PLT  	 # вызов scanf
        mov     eax, DWORD PTR -32[rbp]  # сохранили значение n в eax
        cdqe    			 # расширение eax до восьмибайтового
        mov     rdi, rax  		 # rdi := rax (загружаем данные для вызова malloc)
        call    malloc@PLT  		 # вызов функции malloc
        mov     QWORD PTR -16[rbp], rax  # по адресу rbp - 16 хотим хранить arr
        mov     DWORD PTR -28[rbp], 0	 # countUpper по адресу rbp - 28
        mov     DWORD PTR -24[rbp], 0    # countLower по адресу rbp - 24
        mov     DWORD PTR -20[rbp], 0    # i по адресу rbp - 20
        jmp     .L2                      # переход в метку .L2
.L5:					 	# тело цикла 
        mov     eax, DWORD PTR -20[rbp] 	# eax := i        
	movsx   rdx, eax			# копирует i в rdx с расширением знаком
        mov     rax, QWORD PTR -16[rbp]   	# в rax кладем указатель на массив
        add     rax, rdx			# в rax указатель на arr[i]
        mov     rsi, rax                        # в rsi указатель на arr[i]
        lea     rax, .LC1[rip]          	 
        mov     rdi, rax			# кладем в rdi указатель на строку "%c"
        mov     eax, 0
        call    __isoc99_scanf@PLT		# вызываем scanf для rdi и rsi
        mov     eax, DWORD PTR -20[rbp]		# eax := i
        movsx   rdx, eax			# rdx := i 
        mov     rax, QWORD PTR -16[rbp]		# в rax указатель на arr
        add     rax, rdx			# в rax указатель на arr[i]
        movzx   eax, BYTE PTR [rax]		# eax = arr[i]
        cmp     al, 64				# если arr[i] <= 'A' - 1 уходим в .L3	
        jle     .L3			
# == если arr[i] > 'Z' уходим в .L3	
        mov     eax, DWORD PTR -20[rbp]		
        movsx   rdx, eax
        mov     rax, QWORD PTR -16[rbp]
        add     rax, rdx
        movzx   eax, BYTE PTR [rax]
        cmp     al, 90
        jg      .L3
#
        add     DWORD PTR -28[rbp], 1		# countUpper++
.L3:						# второй if в цикле
#   == если arr[i] <= 'a' - 1 уходим в .L4
        mov     eax, DWORD PTR -20[rbp]		
        movsx   rdx, eax
        mov     rax, QWORD PTR -16[rbp]
        add     rax, rdx
        movzx   eax, BYTE PTR [rax]
        cmp     al, 96
        jle     .L4
#
# == если arr[i] > 'z' уходим в .L4
        mov     eax, DWORD PTR -20[rbp]
        movsx   rdx, eax
        mov     rax, QWORD PTR -16[rbp]
        add     rax, rdx
        movzx   eax, BYTE PTR [rax]
        cmp     al, 122
        jg      .L4
#
        add     DWORD PTR -24[rbp], 1		# countLower++
.L4:
        add     DWORD PTR -20[rbp], 1		# i++
.L2:    					# проверка выхода из цикла ( ; i < n;)
        mov     eax, DWORD PTR -32[rbp]   	# eax := n
        cmp     DWORD PTR -20[rbp], eax		# проверка i < n
        jl      .L5				# если ок идем в тело цикла
# free(arr)        
	mov     rax, QWORD PTR -16[rbp]
        mov     rdi, rax
        call    free@PLT
#
# printf("%d\n", countUpper) 
        mov     eax, DWORD PTR -28[rbp]
        mov     esi, eax
        lea     rax, .LC0[rip]
        mov     rdi, rax
        mov     eax, 0
        call    printf@PLT
#
# printf("%d\n", countLower) 
        mov     eax, DWORD PTR -24[rbp]
        mov     esi, eax
        lea     rax, .LC0[rip]
        mov     rdi, rax
        mov     eax, 0
        call    printf@PLT
#
        mov     eax, 0
        mov     rdx, QWORD PTR -8[rbp]
        sub     rdx, QWORD PTR fs:40
        je      .L7
        call    __stack_chk_fail@PLT
.L7:
        leave
        ret
        .size   main, .-main
        .ident  "GCC: (Ubuntu 11.2.0-19ubuntu1) 11.2.0"
        .section        .note.GNU-stack,"",@progbits
