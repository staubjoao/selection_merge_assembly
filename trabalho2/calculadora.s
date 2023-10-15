.section .data
    num1: .float 0
    num2: .float 0
    num_div_area: .float 0.5
    quantidade: .int 0
    opcao: .int 0
    scan_numero: .asciz "\nEscreva um float: "
    scan_quantidade: .asciz "\nDigite a quantidade de valores que deseja realizar a operação: "
    scan_base: .asciz "\nEscreva o valor da base: "
    scan_altura: .asciz "\nEscreva o valor da altura: "
    scan_raiz: .asciz "\nEscreva o valor que deseja calcular a raiz: "
    resultado: .asciz "\nResultado: %.4f\n"
    mensagem_erro: .asciz "\nOpção fora do desejado.\n"
    escolhaop: .asciz "\nQual operação deseja fazer?\n1 - Soma\n2 - Subtração\n3 - Multiplicação\n4 - Divisão\n5 - Área do triângulo\n6 - Raiz quadrada\nSelecione: "
    format_float: .asciz "%f"
    format_int: .asciz "%d"

.section .text
    .global main

main:
    finit

    # leitura da opção
    pushl $escolhaop
    call printf
    addl $4, %esp

    pushl $opcao
    pushl $format_int
    call scanf
    addl $8, %esp

    # envia a opção para o eax
    movl opcao, %eax

    # verifica se não está fora do desejado
    cmp $7, %eax
    jge imprimeerro

    cmp $0, %eax
    jle imprimeerro

    # verifica os casos que tem um número limitado de entradas
    cmp $6, %eax
    je raizquadrada

    cmp $5, %eax
    je areatriangulo

    # leitura da quantidade
    pushl $scan_quantidade
    call printf
    addl $4, %esp

    pushl $quantidade
    pushl $format_int
    call scanf
    addl $8, %esp

    movl quantidade, %ebx

    # se a quantiodade for igual a menor que 0
    cmp $0, %ebx
    jle imprimeerro

    # lê o primeiro número
    pushl $scan_numero
    call printf
    addl $4, %esp

    pushl $num1
    pushl $format_float
    call scanf
    addl $8, %esp

    flds num1

    subl $8, %esp

    movl opcao, %eax

    # opçoes da operações
    cmp $1, %eax
    je soma

    cmp $2, %eax
    je sub
    
    cmp $3, %eax
    je mult
    
    cmp $4, %eax
    je divi
    
    ret


imprimeerro:
    pushl $mensagem_erro
    call printf
    addl $4, %esp
    ret

imprimeresultado:
    fstl (%esp)
    pushl $resultado
    call printf
    addl $20, %esp
    ret

areatriangulo:
    pushl $scan_altura
    call printf
    addl $4, %esp

    pushl $num1
    pushl $format_float
    call scanf
    addl $8, %esp

    pushl $scan_base
    call printf
    addl $4, %esp

    pushl $num2
    pushl $format_float
    call scanf
    addl $8, %esp

    flds num1
    flds num2

    subl $16, %esp

    fmulp

    flds num_div_area

    fmulp
    
    jmp imprimeresultado

raizquadrada:
    pushl $scan_raiz
    call printf
    addl $4, %esp

    pushl $num1
    pushl $format_float
    call scanf
    addl $8, %esp

    flds num1 

    subl $16, %esp

    fsqrt

    jmp imprimeresultado

soma:
    subl $1, %ebx
    cmp $0, %ebx
    je imprimeresultado

    pushl $scan_numero
    call printf
    addl $4, %esp

    pushl $num1
    pushl $format_float
    call scanf

    addl $8, %esp

    flds num1

    subl $8, %esp

    faddp

    jmp soma

sub:
    subl $1, %ebx
    cmp $0, %ebx
    je imprimeresultado

    pushl $scan_numero
    call printf
    addl $4, %esp

    pushl $num1
    pushl $format_float
    call scanf
    addl $8, %esp

    flds num1

    subl $8, %esp

    fsubp

    jmp sub
mult:
    subl $1, %ebx
    cmp $0, %ebx
    je imprimeresultado

    pushl $scan_numero
    call printf
    addl $4, %esp

    pushl $num1
    pushl $format_float
    call scanf
    addl $8, %esp

    flds num1

    subl $8, %esp

    fmulp

    jmp mult

divi:
    subl $1, %ebx
    cmp $0, %ebx
    je imprimeresultado

    pushl $scan_numero
    call printf
    addl $4, %esp

    pushl $num1
    pushl $format_float
    call scanf
    addl $8, %esp

    flds num1

    subl $8, %esp

    fdivp

    jmp divi

