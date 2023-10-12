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

    movl opcao, %eax

    # operacao
    cmp $5, %eax
    je areatriangulo
    
    cmp $6, %eax
    je raizquadrada

    # leitura da quantidade
    pushl $scan_quantidade
    call printf

    addl $4, %esp

    pushl $quantidade
    pushl $format_int
    call scanf

    cmp $1, %eax
    je soma

    cmp $2, %eax
    je sub
    
    cmp $3, %eax
    je mult
    
    cmp $4, %eax
    je divi

    
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

    fmulp

    flds num_div_area

    fmulp
    
    fstl (%esp)

    pushl $resultado
    call printf
    addl $20, %esp

    subl $16, %esp

    ret

raizquadrada:
    pushl $scan_raiz
    call printf
    addl $4, %esp

    pushl $num1
    pushl $format_float
    call scanf
    addl $8, %esp

    flds num1 

    fsqrt

    fstl (%esp)

    pushl $resultado
    call printf
    addl $20, %esp

    subl $16, %esp

    ret

soma:
    pushl $scan_numero
    call printf

    addl $4, %esp

    pushl $num1
    pushl $format_float
    call scanf

    addl $8, %esp

    flds num1

    subl $16, %esp

    fadd %st(1), %st(0)
    
    fstl (%esp)

    pushl $resultado
    call printf
    addl $20, %esp
    ret

# soma_loop:


sub:
    subl $16, %esp

    fsub %st(1), %st(0)
    
    fstl (%esp)

    pushl $resultado
    call printf
    addl $20, %esp
    ret
mult:
    subl $16, %esp

    fmul %st(1), %st(0)
    
    fstl (%esp)

    pushl $resultado
    call printf
    addl $20, %esp
    ret

divi:
    subl $16, %esp

    fdiv %st(1), %st(0)
    
    fstl (%esp)

    pushl $resultado
    call printf
    addl $20, %esp
    ret