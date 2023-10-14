.section .data
    num1: .float 0
    num2: .float 0
    scan: .asciz "\nInsert float number: "
    sum: .asciz "\n\nResult: %.4f\n"
    format: .asciz "%f"

.section .text
    .global main

main:
    finit

    pushl $scan
    call printf
    addl $4, %esp

    pushl $num1
    pushl $format
    call scanf
    addl $8, %esp

    pushl $scan
    call printf
    addl $4, %esp

    pushl $num2
    pushl $format
    call scanf
    addl $8, %esp

    flds num1
    flds num2
    
    subl $16, %esp

    fadd %st(1), %st(0)
    
    fstl (%esp)
    pushl $sum
    call printf
    addl $20, %esp
