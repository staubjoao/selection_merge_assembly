.section .data
    debug: .asciz "\n%d\n"

.section .text
    .global main

main:
    movl $4, %eax        # Define %eax como 4
    pushl %eax           # Salva o valor original de %eax na pilha
    pushl $debug         # Prepara o argumento para o primeiro print
    call printf         # Chama printf
    addl $8, %esp        # Libera os argumentos da pilha

    popl %eax            # Restaura o valor original de %eax
    pushl %eax           # Coloca novamente o valor de %eax na pilha
    pushl $debug         # Prepara o argumento para o segundo print
    call printf         # Chama printf novamente
    addl $8, %esp        # Libera os argumentos da pilha
    
    ret
