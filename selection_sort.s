.section .data
    vetorTxt: .asciz "vetor: "
    scanVec: .string "%d"
    v1: .int 0, 0, 0, 0, 0, 0, 0, 0

.section .text
.globl main

main:
    movl $v1, %edi
    jmp insert

insert:
    pushl %edi
    pushl $scanVec
    call scanf
    addl $4, %edi
    addl $1, cont
    addl $8, %esp
    cmp $8, cont
    jl insert 
    movl $0, cont
    movl $0, %edi
    movl $v1, %edi
    jmp printVec
    ret

printVec:
    pushl (%edi)
    pushl $vetorElemTxt
    call printf
    addl $8, %esp
    addl $4, %edi
    addl $1, cont
    cmp $8, cont
    jl printVec
    movl $0, cont
    movl $0, %edi
    movl $v1, %edi
    ret
