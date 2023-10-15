.section .data
    welcomeTxt: .asciz "Bem vindo, este programa realiza o Selection Sort. \nDigite 8 números para começar: "
    vetorTxt: .asciz "Vetor: "      # String de formatação para print
    vectorElement: .string "%d, "    # String de formatação para print
    teste: .string "\nmenor: %d, indice: %d\n"    
    teste3: .string "\nMin: %d, Atual: %d\n"    

    teste1: .string "teste!!\n"    
    scanVec: .string "%d"           # String de formatação para scanf
    cont: .int 0                    # Variável pra contar número de elemntos
    vector: .int 0, 0, 0, 0, 0, 0, 0, 0 # Vetor inicializado com 0
    minValue: .int 99999 # Variável para guardar o mínimo
    minIdx: .int 0
    currentValue: .int 99999
    currentIdx: .int 0

.section .text
.globl main

main:
    # Printa mensagem inicial        
    pushl $welcomeTxt
    call printf
    addl $4, %esp
    movl $vector, %edi
    call insert

    movl (%edi), %eax # Guarda o primeiro valor do vetor no min - pt1
    movl %eax, minValue # Guarda o primeiro valor do vetor no min - pt2

    movl $0, minIdx # Guarda o menor indice no ebx
    movl $0, currentIdx # Guarda o indice atual 

    movl $0, %ecx # Guarda o indice atual no ecx
    movl $0, cont 
    call printVec
    jmp findMin
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
    # jmp printVec
    ret

imprimeValores:
    pushl minIdx
    pushl minValue
    pushl $teste
    call printf
    addl $12, %esp
    movl $0, cont
    jmp printVec
    ret

findMin:
    addl $1, cont
    cmp $8, cont 
    je imprimeValores
    addl $4, %edi # posição edi[N] para posição edi[N+1],
    addl $1, currentIdx
    
    movl (%edi), %eax
    movl %eax, currentValue

    #  Imprime pra comparar
    pushl currentValue
    pushl minValue
    pushl $teste3
    call printf
    addl $12, %esp

    # edx é o atual, eax é o menor
    movl currentValue, %edx
    movl minValue, %eax
    
    cmp %eax, %edx 
    jl atualizaMin
    jmp findMin

    
atualizaMin:
    # tem um menor, atualiza o eax
    movl (%edi), %eax
    movl %eax, minValue

    movl currentIdx, %eax
    movl %eax, minIdx  
    call printVec
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
