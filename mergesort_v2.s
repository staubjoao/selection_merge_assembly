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
    vector: .int 0, 0, 0, 0, 0, 0, 0, 0  # Inicializa o vetor com zeros

.section .text
.globl main

main:
    # Printa mensagem inicial        
    pushl $welcomeTxt
    call printf
    addl $4, %esp
    # Insere os valores no vetor
    movl $vector, %edi
    call insert

    call printVecInit
    # void mergeSort(int arr[], int left, int right)
    # mergeSort(arr, 0, arr_size - 1);
    pushl $7
    pushl $0
    pushl $vector
    call mergeSort
    addl $16, %esp

    ret

mergeSort:
    pushl %ebp
    movl %esp, %ebp
    subl $20, %esp
    movl 16(%ebp), %eax # right
    movl 12(%ebp), %ebx # left

    pushl %eax
    call vetorElemTxt
    addl $4, %esp
    pushl %ebx
    call vetorElemTxt
    addl $4, %esp
    ret
insert:
    pushl %edi
    # Entrada de dados
    pushl $scanVec
    call scanf 
    addl $8, %esp
    # i + 1
    addl $1, cont_i
    addl $4, %edi # posição edi[N] para posição edi[N+1]
    # i < 8
    cmp $8, cont_i
    jl insert
    # Zera o contador e volta pra edi[0]
    movl $0, cont_i
    movl $0, %edi
    movl $vector, %edi
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
