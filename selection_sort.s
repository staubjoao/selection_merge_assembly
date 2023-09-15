.section .data
    welcomeTxt: .asciz "Bem vindo, este programa realiza o Selection Sort. \nDigite 8 números para começar: "
    vetorTxt: .asciz "Vetor: "      # String de formatação para print
    vectorElement: .string "%d, "    # String de formatação para print
    teste: .string "menor: %d, indice: %d\n"    
    teste1: .string "valor: %d\n"    
    scanVec: .string "%d"           # String de formatação para scanf
    cont: .int 0                    # Variável pra contar número de elemntos
    vector: .int 0, 0, 0, 0, 0, 0, 0, 0 # Vetor inicializado com 0
    min: .int 0 # Variável para guardar o mínimo

.section .text
.globl main

main:
    # Printa mensagem inicial        
    pushl $welcomeTxt
    call printf
    addl $4, %esp
    movl $vector, %edi
    call insert

    # inicia o eax com o menor valor atualmente, o primeiro
    # e ebx com o indice
    movl (%edi), %eax # Guarda o primeiro valor do vetor no eax
    movl $0, %ebx # Guarda o menor indice no ebx
    movl $0, %ecx # Guarda o indice atual no ecx

    call findMin
    ret

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

imprimeValores:
    pushl %ebx
    pushl %eax
    pushl $teste
    call printf
    addl $12, %esp
    movl $0, cont
    ret

findMin:
    addl $1, cont
    cmp $8, cont 
    je imprimeValores
    addl $4, %edi # posição edi[N] para posição edi[N+1],
    addl $1, %ecx
    cmp (%edi), %eax
    jle atualizaMin
    ret
    
atualizaMin:
    movl (%edi), %eax
    addl %ecx, %ebx
    addl $4, %edi
    pushl %eax
    pushl $teste1
    call printf
    addl $8, %esp
    jmp findMin

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
