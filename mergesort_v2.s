.section .data
    welcomeTxt: .asciz "Bem-vindo, este programa realiza o Merge Sort. \nDigite 8 números para começar: "

    left: .int 0
    right: .int 0
    mid: .long 0
    vetorTxtInit: .asciz "\nVetor Inicial: "
    vetorTxtFinish: .asciz "\nVetor Ordenado: "
    vetorElemTxt: .string "%d, "
    vetorElemF: .string "%d\n"
    scanVec: .string "%d"
    cont_i: .int 0              # Contador para loops (loop interno)
    cont_j: .int 0              # Contador para loops (loop externo)
    vector: .int  8, 2, 6, 5, 4, 3, 7, 1
    vectorAux: .int 0, 0, 0, 0, 0, 0, 0, 0

.section .text
.globl main

main:
    # Printa mensagem inicial        
    pushl $welcomeTxt
    call printf
    addl $4, %esp

    movl $vector, %edi

    call printVecInit

    pushl $vectorAux # vetAux
    pushl $8 # tamanho
    pushl $0 # meio
    pushl $vector # vet
    call mergeSort
    addl $16, %esp

    call printVecFinish
    ret


printVecInit:
    pushl $vetorTxtInit
    call printf
    addl $4, %esp
    jmp printVecAux

printVecFinish:
    pushl $vetorTxtFinish
    call printf
    addl $4, %esp
    jmp printVecAux

printVecAux:
    pushl (%edi)
    pushl $vetorElemTxt
    call printf
    addl $8, %esp
    addl $4, %edi
    addl $1, cont_i
    cmp $8, cont_i
    jl printVecAux
    # Zera o contador e volta pra edi[0]
    movl $0, cont_i
    movl $0, %edi
    movl $vector, %edi
    ret

#pushl $vectorAux           24
#pushl $8 # fim         20
#pushl $0 # mid        16
#pushl $0 # ini         12
#pushl $vector              8
merge:
    pushl %ebp
    movl %esp, %ebp
    movl 12(%ebp), %ebx
    movl 16(%ebp), %eax
    movl %ebx, left
    movl %eax, right
    jmp .mergeLoop

#pushl $vectorAux           24
#pushl $8 # fim         20
#pushl $0 # mid        16
#pushl $0 # ini         12
#pushl $vector              8
.mergeLoop:
    cmp 20(%ebp), %ebx
    jge exitmergeLoop
    movl left, %ecx
    imul $4, %ecx
    movl 8(%ebp), %eax
    addl %ecx, %eax
    movl (%eax), %ecx # vetor[left]

    movl right, %edx
    imul $4, %edx
    movl 8(%ebp), %eax
    addl %edx, %eax
    movl (%eax), %edx # vetor[right]

    pushl %edx
    pushl %ecx
    pushl 20(%ebp)
    pushl right
    pushl 16(%ebp)
    pushl left
    call .isLeftVec
    addl $24, %esp
    cmp $1, %eax
    je .leftVec
    movl %ebx, %ecx
    imul $4, %ecx
    movl 24(%ebp), %eax #vectoraux
    addl %ecx, %eax
    movl %edx, (%eax)
    incl right
    incl %ebx
    jmp .mergeLoop


exitmergeLoop:
    pushl $vectorAux
    pushl $vector
    pushl 20(%ebp)
    pushl 12(%ebp)
    call .copyVec
    addl $16, %esp
    movl %ebp, %esp
    popl %ebp
    ret

.leftVec:
    movl %ebx, %edx
    imul $4, %edx
    movl 24(%ebp), %eax #vectoraux
    addl %edx, %eax
    movl %ecx, (%eax)
    incl left
    incl %ebx
    jmp .mergeLoop

# vectorAux 20
# vector    16
# fim   12
# i     8
.copyVec:
    pushl %ebp
    movl %esp, %ebp
    movl 8(%ebp), %ebx
    jmp .copyVecLoop

.copyVecLoop:
    cmp 12(%ebp), %ebx
    je .exitCopyVecLoop
    movl %ebx, %eax
    imul $4, %eax
    movl 20(%ebp), %ecx # vectorAux
    movl 16(%ebp), %edx # vector
    addl %eax, %ecx
    addl %eax, %edx
    movl (%ecx), %ecx
    movl %ecx, (%edx)
    incl %ebx
    jmp .copyVecLoop

.exitCopyVecLoop:
    movl %ebp, %esp
    popl %ebp
    ret

# vetor[right] 28
# vetor[left] 24
# fim        20
# right        16
# mid       12
# left        8
.isLeftVec:
    # ((left < mid) && (right >= fim) || (vetor[left] < vetor[right])
    pushl %ebp
    movl %esp, %ebp

    movl 8(%ebp), %eax
    cmp 12(%ebp), %eax
    jge exitIsLeftVecFalse

    movl 16(%ebp), %eax
    cmp 20(%ebp), %eax
    jge exitIsLeftVecTrue

    movl 24(%ebp), %eax
    cmp 28(%ebp), %eax
    jl exitIsLeftVecTrue

    jmp exitIsLeftVecFalse

exitIsLeftVecTrue:
    movl $1, %eax
    movl %ebp, %esp
    popl %ebp
    ret

exitIsLeftVecFalse:
    movl $0, %eax
    movl %ebp, %esp
    popl %ebp
    ret

#pushl $vectorAux           20
#pushl $8 # tamanho     16
#pushl $0 # inicio      12
#pushl $vector              8
mergeSort:
    pushl %ebp
    movl %esp, %ebp
    subl $20, %esp
    movl 16(%ebp), %eax # tamanho
    movl 12(%ebp), %ebx # inicio
    subl %ebx, %eax
    cmp $2, %eax
    jl exitMerge
    movl 16(%ebp), %eax
    movl 12(%ebp), %ebx
    addl %ebx, %eax
    movl $2, %ebx
    xor %edx, %edx
    divl %ebx
    movl %eax, -12(%ebp)
    subl $16, %esp
    pushl 20(%ebp)
    pushl -12(%ebp)
    pushl 12(%ebp)
    pushl 8(%ebp)
    call mergeSort
    addl $16, %esp

    subl $16, %esp
    pushl 20(%ebp)
    pushl 16(%ebp)
    pushl -12(%ebp)
    pushl 8(%ebp)
    call mergeSort
    addl $16, %esp

    pushl 20(%ebp)
    pushl 16(%ebp)
    pushl -12(%ebp)
    pushl 12(%ebp)
    pushl 8(%ebp)
    call merge
    addl $20, %esp
    leave
    ret

exitMerge:
    leave
    ret

