.section .data
    welcomeTxt: .asciz "Bem-vindo, este programa realiza o Merge Sort. \nDigite 8 números para começar: "

    left: .int 0
    right: .int 0
    debug_l_r: .asciz "\nleft %d rigth %d\n"

    mid: .long 0
    vetorTxtInit: .asciz "\nVetor Inicial: "
    vetorTxtFinish: .asciz "\nVetor Ordenado: "
    vetorElemTxt: .string "%d, "
    vetorElemF: .string "%d\n"
    scanVec: .string "%d"
    debug: .string "\nteste\n"
    cont_i: .int 0              # Contador para loops (loop interno)
    cont_j: .int 0              # Contador para loops (loop externo)
    vector: .int 8, 7, 6, 5, 4, 3, 2, 1  # Inicializa o vetor com zeros
    vector_aux: .int 0, 0, 0, 0, 0, 0, 0, 0
    vector_size: .int 8

.section .text
.globl main

main:
    # Printa mensagem inicial        
    pushl $welcomeTxt
    call printf
    addl $4, %esp

    # Insere os valores no vetor
    movl $vector, %edi
    movl vector_size, %edx
    call printVecInit

    pushl $vector_aux
    pushl $8         
    pushl $0
    pushl $vector
    call mergeSort
    addl $16, %esp

    movl $vector, %edi
    movl vector_size, %edx
    call printVecFinish

    ret

#pushl $vector_aux      24 # vetor
#pushl $8 # fim         20 # vetor_aux
#pushl $0 # meio        16 # esquerda
#pushl $0 # ini         12 # meio
#pushl $vector           8 # direita
merge:
    pushl %ebp
    movl %esp, %ebp
    movl 12(%ebp), %ebx
    movl 16(%ebp), %eax
    movl %ebx, left
    movl %eax, right
    jmp .mergeLoop
    ret

#pushl $vector_aux           24
#pushl $8 # fim         20
#pushl $0 # meio        16
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
    movl 24(%ebp), %eax #vector_aux
    addl %ecx, %eax
    movl %edx, (%eax)
    incl right
    incl %ebx
    jmp .mergeLoop


exitmergeLoop:
    pushl $vector_aux
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
    movl 24(%ebp), %eax #vector_aux
    addl %edx, %eax
    movl %ecx, (%eax)
    incl left
    incl %ebx
    jmp .mergeLoop

# vector_aux 20
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
    movl 20(%ebp), %ecx # vector_aux
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
# meio       12
# left        8
.isLeftVec:
    # ((left < meio) && (right >= fim) || (vetor[left] < vetor[right])
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

# vetor        8 ->  20
# vetor_aux   20 ->  16 
# esquerda    12 ->  12
# direita     16 ->   8

#    pushl $vector_aux # 20   pushl $vector      # 20
#    pushl $8          # 16   pushl $vector_aux  # 16
#    pushl $0          # 12   pushl $0           # 12  
#    pushl $vector     #  8   pushl $8           #  8

mergeSort:
    pushl %ebp
    movl %esp, %ebp
    subl $20, %esp
    # Pega o tamanho do vetor e coloca em %eax
    movl 16(%ebp), %eax 
    # Pega o inicio do vetor e coloca em %ebx
    movl 12(%ebp), %ebx     
    subl %ebx, %eax
    
    cmp $2, %eax
    jl finishMergeSort

    # Calcula o meio do vetor   
    movl 16(%ebp), %eax    # Pega o tamanho do vetor e coloca em %eax
    movl 12(%ebp), %ebx    # Pega o inicio do vetor e coloca em %ebx
    addl %ebx, %eax        # Soma inicio com tamanho
    sarl $1, %eax          # Da um shift de 1 bit pra direita (divide por 2)
    movl %eax, -12(%ebp)   # Guarda o valor de %eax em -12(%ebp) (meio)


    # Chama mergeSort para primeira metade
    # MergeSort(vetor, inicio, meio, vetorAux);

    pushl 20(%ebp) 
    pushl -12(%ebp) 
    pushl 12(%ebp) 
    pushl 8(%ebp)
    call mergeSort

    # Chama mergeSort para segunda metade
    pushl 20(%ebp)
    pushl 16(%ebp)
    pushl -12(%ebp)
    pushl 8(%ebp)
    call mergeSort


    # Chama o Merge nas duas metades
    pushl 20(%ebp)
    pushl 16(%ebp)
    pushl -12(%ebp)
    pushl 12(%ebp)
    pushl 8(%ebp)
    call merge

    leave
    ret


finishMergeSort:
    leave
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
