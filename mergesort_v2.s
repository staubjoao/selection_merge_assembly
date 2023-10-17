.section .data
    welcomeTxt: .asciz "Bem-vindo, este programa realiza o Merge Sort. \nDigite 8 números para começar: "

    aux: .int 0
    left: .int 0
    right: .int 0
    mid: .long 0
    debug_r: .asciz "\nright: %d\n"
    debug_l: .asciz "\left: %d\n"
    debug_m: .asciz "\mid: %d\n"
    teste: .asciz "\nTeste\n"

    vetorTxtInit: .asciz "\nVetor Inicial: "
    vetorTxtFinish: .asciz "\nVetor Ordenado: "
    vetorElemTxt: .string "%d, "
    vetorElemF: .string "%d\n"
    scanVec: .string "%d"
    cont_i: .int 0              # Contador para loops (loop interno)
    cont_j: .int 0              # Contador para loops (loop externo)
    vector: .int 8, 7, 6, 5, 4, 3, 2, 1  # Inicializa o vetor com zeros
    cont : .int 0
.section .text
.globl main

main:
    # Printa mensagem inicial        
    pushl $welcomeTxt
    call printf
    addl $4, %esp
    # Insere os valores no vetor
    movl $vector, %edi
    # call insert
    call printVecInit



    # void mergeSort(int arr[], int left, int right)
    # mergeSort(arr, 0, arr_size - 1);
    movl $vector, %edi
    movl $0, %esi
    movl $8, %edx
    # subl $1, %edx
    call mergeSort
    # addl $12, %esp

    ret
mergeSort:
    # Check if left < right
    # edx = right > esi = left
    cmp %edx, %esi
    jge done

    pushl %esi
    pushl $debug_r
    call printf
    addl $8, %esp

    pushl %esi
    pushl $debug_r
    call printf
    addl $8, %esp

    pushl %edx
    pushl $debug_r
    call printf
    addl $8, %esp

    pushl %edx
    pushl $debug_r
    call printf
    addl $8, %esp
    # Calculate mid
    movl %esi, %eax
    addl %edx, %eax
    sarl $1, %eax

done:
    pushl %esi
    pushl $debug_l
    call printf
    addl $8, %esp
    ret

mergeSort2:
    cmp $3, cont
    je finishMergeSort
    addl $1, cont

    pushl %ebp
    movl %esp, %ebp
    subl $16, %esp
    movl 12(%ebp), %eax # right
    movl 8(%ebp), %ebx # left
    # left >= right
    # imprimir 

    pushl 12(%ebp)
    pushl $debug_r
    call printf
    addl $8, %esp

    pushl 8(%ebp)
    pushl $debug_l
    call printf
    addl $8, %esp
    
    cmpl %ebx, %eax
    jnl finishMergeSort




    movl 12(%ebp), %eax # right
    movl 8(%ebp), %ebx # left

    subl %eax, %ebx # right - left
    movl 8(%ebp), %ebx # left
    addl %eax, %ebx # left + (left - right)
    sarl $1, %ebx # mid

    pushl %ebx
    pushl $debug_m
    call printf
    addl $8, %esp

    movl %eax, -8(%ebp)
    subl $12, %esp
    pushl 16(%ebp)
    pushl -8(%ebp)
    pushl 4(%ebp) # arr
    pushl 8(%ebp) # left
    pushl %ebx # mid
    call mergeSort
    addl $12, %esp 

    addl $1, %ebx # mid + 1

    pushl 4(%ebp) # arr
    pushl %ebx # left
    pushl 12(%ebp) # mid
    call mergeSort
    addl $12, %esp 


    pushl $vector
    pushl $0
    pushl $7
    call mergeSort
    addl $12, %esp  

    addl $12, %esp
    leave
    ret

finishMergeSort:
    pushl $teste
    call printf
    addl $4, %esp
    leave
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
