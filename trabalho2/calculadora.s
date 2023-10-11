.section .data
    num1: .float 0
    num2: .float 0
    opcao: .int 0
    scan: .asciz "\nEscreva um float: "
    sum: .asciz "\nResultado: %.4f\n"
    escolhaop: .asciz "\nQual operação deseja fazer?\n1 - Soma\n2 - Subtração\n3 - Multiplicação\n4 - Divisão\nSelecione: "
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

    # leitura dos valores
    pushl $scan
    call printf

    addl $4, %esp

    pushl $num1
    pushl $format_float
    call scanf

    addl $8, %esp

    pushl $scan
    call printf

    addl $4, %esp

    pushl $num2
    pushl $format_float
    call scanf

    addl $8, %esp

    flds num1
    flds num2

    movl opcao, %eax

    # operacao
    cmp $1, %eax
    je soma

    cmp $2, %eax
    je sub
    
    cmp $3, %eax
    je mult
    
    cmp $4, %eax
    je divi
    
    ret

soma:
    subl $16, %esp

    fadd %st(1), %st(0)
    
    fstl (%esp)

    pushl $sum
    call printf
    addl $20, %esp
    ret

sub:
    subl $16, %esp

    fsub %st(1), %st(0)
    
    fstl (%esp)

    pushl $sum
    call printf
    addl $20, %esp
    ret
mult:
    subl $16, %esp

    fmul %st(1), %st(0)
    
    fstl (%esp)

    pushl $sum
    call printf
    addl $20, %esp
    ret

divi:
    subl $16, %esp

    fdiv %st(1), %st(0)
    
    fstl (%esp)

    pushl $sum
    call printf
    addl $20, %esp
    ret