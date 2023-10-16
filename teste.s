.section .data
    num1: .float 0
    num2: .float 0
    maior: .asciz "\nmaior\n"
    menor: .asciz "\nmenor\n"

.section .text
    .global main

main:
    movl $4, %eax
    movl $3, %ebx

    cmpl %ebx, %eax
    jnl maior_teste
    
    
    ret

maior_teste:
    pushl $maior
    call printf
    addl $4, %esp
    ret
