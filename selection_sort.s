.section .data
    welcomeTxt: .asciz "Bem vindo, este programa realiza o Selection Sort. \nDigite 8 números para começar: "
    vetorTxt: .asciz "Vetor: "      # String de formatação para print
    vectorElement: .string "%d, "    # String de formatação para print
    scanVec: .string "%d"           # String de formatação para scanf
    cont: .int 0                    # Variável pra contar número de elemntos
    vector: .int 0, 0, 0, 0, 0, 0, 0, 0 # Vetor inicializado com 0

.section .text
.globl main

main:
        
    pushl $welcomeTxt
    call printf
    addl $4, %esp

    movl $vector, %edi
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
    movl $vector, %edi
    jmp printVec
    ret

printVec:
    pushl (%edi)
    pushl $vectorElement
    call printf
    addl $8, %esp
    addl $4, %edi
    addl $1, cont
    cmp $8, cont
    jl printVec
    movl $0, cont
    movl $0, %edi
    movl $vector, %edi
    ret
