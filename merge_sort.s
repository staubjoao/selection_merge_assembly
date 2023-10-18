.section .data
    welcomeTxt: .asciz "Bem-vindo, este programa realiza o Merge Sort. \nDigite 8 números para começar: "

    esq: .int 0
    dir: .int 0
    debug_l_r: .asciz "\nesq %d rigth %d\n"

    mid: .long 0
    vetorTxtInit: .asciz "\nVetor Inicial: "
    vetorTxtFinish: .asciz "\nVetor Ordenado: "
    vetorElemTxt: .string "%d, "
    vetorElemF: .string "%d\n"
    scanVec: .string "%d"
    debug: .string "\nteste %d\n"
    cont_i: .int 0              # Contador para loops (loop interno)
    cont_j: .int 0              # Contador para loops (loop externo)
    vector: .int 0, 0, 0, 0, 0, 0, 0, 0  # Inicializa o vetor com zeros
    vector_aux: .int 0, 0, 0, 0, 0, 0, 0, 0

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

    # Printa vetor inicial
    movl $vector, %edi
    call printVecInit

    # Chamada Inicial da função
    # MergeSort(vetor, 0, 8, vector_aux);
    pushl $vector_aux # vetor_aux
    pushl $8  # fim       
    pushl $0 # inicio
    pushl $vector # vetor
    call mergeSort
    addl $16, %esp

    # Printa o vetor ordenado
    movl $vector, %edi
    call printVecFinish

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

# vector_aux  24 
# direita     20 
# meio        16 
# esquerda    12 
# vector       8
merge:
    pushl %ebp
    movl %esp, %ebp
    movl 12(%ebp), %ebx # Coloca o inicio do vetor em %ebx
    movl 16(%ebp), %eax # Coloca o meio do vetor em %eax
    movl %ebx, esq
    movl %eax, dir
    jmp mergeLoop
    

# vector_aux  24 
# direita     20 
# meio        16 
# esquerda    12 
# vector       8
mergeLoop:
    # For (i = ini; i < 8; i++)
    cmp $8, %ebx
    jge finishmergeLoop

    movl esq, %ecx # Move o valor de esq para %ecx
    shll $2, %ecx  # Bit Shift = Multiplicar %ecx por 4 para obter o endereço
    movl 8(%ebp), %eax # Carrega o endereço de vector em %eax
    addl %ecx, %eax # Adiciona %ecx a %eax (calcula vetor[esq])
    movl (%eax), %ecx # Move o valor para %ecx

    movl dir, %edx # Move o valor de dir para %edx
    shll $2, %edx #  Bit Shift = Multiplicar %edx por 4 para obter o endereço
    movl 8(%ebp), %eax # Carrega o endereço de vector em %eax
    addl %edx, %eax # Adiciona %edx a %eax (calcula vetor[dir])
    movl (%eax), %edx # Move o valor para %edx

    # Coloca variáveis na pilha para chamar a função mergeIf
    pushl %edx # vetor[dir]
    pushl %ecx # vetor[esq]
    pushl 20(%ebp) # fim
    pushl dir # dir
    pushl 16(%ebp) # meio
    pushl esq # esq
    call mergeIf

    # O If foi True, tem que fazer troca
    cmp $1, %eax
    je if

    # Caiu no Else
    cmp $0, %eax
    je else 

# Parte do If
# vetAux[i] = vetor[esq];
# ++esq;
if:
    movl %ebx, %edx
    shll $2, %edx 
    movl 24(%ebp), %eax 
    addl %edx, %eax
    movl %ecx, (%eax)
    addl $1, esq 
    addl $1, %ebx
    jmp mergeLoop

# Parte do Else    
# etAux[i] = vetor[dir];
# ++dir;
 else:      
    movl %ebx, %ecx
    imul $4, %ecx
    movl 24(%ebp), %eax 
    addl %ecx, %eax
    movl %edx, (%eax)
    addl $1, dir
    addl $1, %ebx
    jmp mergeLoop


# Saiu do loop tem que copiar o vetor auxiliar para o vetor original
finishmergeLoop:
    pushl $vector_aux # vetor_aux
    pushl $vector # vetor
    pushl 20(%ebp) # fim
    pushl 12(%ebp) # Tamanho
    call copyVec
    leave
    ret

# vector_aux  20
# vector      16
# fim         12
# cout            8
copyVec:
    pushl %ebp
    movl %esp, %ebp
    movl 8(%ebp), %ebx 
    jmp copyVecLoop

copyVecLoop:
    cmp $8, %ebx
    je finishCopyVecLoop # Copiou tudo, sai do loop
    movl %ebx, %eax # Salva o valor de count em %eax
    shll $2, %eax # Bit shift para salvar o endereço no eax
    movl 20(%ebp), %ecx # Coloca vetor_aux[i] em %ecx	
    movl 16(%ebp), %edx # Coloca vetor[i] em %edx	
    addl %eax, %ecx # Soma com a posição do endereço
    addl %eax, %edx # Soma com a posição do endereço
    # ----- SWAP -------
    movl (%ecx), %ecx # Move o valor de vetor_aux[i] para %ecx
    movl %ecx, (%edx) # Move o valor de %ecx para vetor[i]
    # ------------------
    addl $1, %ebx
    jmp copyVecLoop

finishCopyVecLoop:
    leave
    ret

# vector[direita]  28
# vector[esquerda] 24
# fim              20
# direita          16
# meio             12
# esquerda          8
mergeIf:
    pushl %ebp
    movl %esp, %ebp
    # Verifica se esq >= meio
    movl 8(%ebp), %eax
    cmp 12(%ebp), %eax
    jae finishmergeIfFalse    

    # Verifica se dir >= fim
    movl 16(%ebp), %eax
    cmp 20(%ebp), %eax
    jae finishmergeIfTrue

    # Verifica se vetor[dir] >= vetor[esq]
    movl 24(%ebp), %eax
    cmp 28(%ebp), %eax
    jge finishmergeIfFalse

finishmergeIfTrue:
    movl $1, %eax
    leave # Restora a pilha
    ret

finishmergeIfFalse:
    movl $0, %eax
    leave # Restora a pilha
    ret

# vector_aux 20
# direita 16
# esquerda 12
# vector 8
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
    pushl 20(%ebp) # VetorAux
    pushl -12(%ebp) # Meio
    pushl 12(%ebp) # Inicio
    pushl 8(%ebp) # Vetor
    call mergeSort

    # Chama mergeSort para segunda metade
    # MergeSort(vetor, meio, fim, vetorAux);
    pushl 20(%ebp) # VetorAux
    pushl 16(%ebp) # Fim
    pushl -12(%ebp) # Meio
    pushl 8(%ebp) # Vetor
    call mergeSort


    # Chama o Merge nas duas metades
    # Merge(vetor, inicio, meio, fim, vetorAux);
    pushl 20(%ebp) # VetorAux
    pushl 16(%ebp) # Fim
    pushl -12(%ebp) # Meio
    pushl 12(%ebp) # Inicio
    pushl 8(%ebp) # Vetor
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
