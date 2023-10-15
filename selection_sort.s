.section .data
    welcomeTxt: .asciz "Bem-vindo, este programa realiza o Selection Sort. \nDigite 8 números para começar: "
    minValue: .int 99999        # Inicializa o valor mínimo 
    minTemp: .int 0             # Variável temporária para armazenar um valor durante a troca
    minIdx: .int 0              # Índice do valor mínimo no vetor
    vetorTxtInit: .asciz "\nVetor Inicial: "
    vetorTxtFinish: .asciz "\nVetor Ordenado: "

    vetorElemTxt: .string "%d, "
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
    # Printa vetor inicial
    call printVecInit
    # Chama a função que ordena o vetor
    call selectionSort
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

# Guarda a pos do menor em minIdx e o valor do menor em minValue
selectionSort:
    cmp $7, cont_i
    jle selectionSort_aux
    jmp finishSort

selectionSort_aux:
    addl $1, cont_i
    movl minValue, %eax
    cmp %eax, (%edi)
    jge skipUpdate

    # Se o valor atual é maior, atualiza minValue e minIdx
    movl (%edi), %eax
    movl %eax, minValue
    movl cont_i, %eax
    movl %eax, minIdx

# Não atualiza minValue e minIdx, só pula de edi[N] para edi[N+1]
skipUpdate:
    addl $4, %edi
    call selectionSort
    ret

finishSort:
    subl $1, minIdx
    call swapPos
    addl $1, cont_j
    # Printa o vetor atual
    movl $vector, %edi
    movl $0, cont_i

    # Muda o valor inicial do cont_i
    # 4 * cont_i pra pegar o endereço do elemento atual
    movl cont_j, %eax
    movl $4, %ebx
    movl %eax, cont_i
    imul %ebx, %eax
    movl $vector, %edi
    addl %eax, %edi

    # Restaura o valor minimo e o indice minimo
    movl $9999, minValue
    movl $0, minIdx
    cmp $8, cont_j
    jl selectionSort
    
    # Acabou, printa o vetor final
    movl $0, cont_i
    movl $vector, %edi
    call printVecFinish
    ret


# Muda o valor de edi[minIdx] com edi[cont_j]
swapPos:
    # Guarda 4 * o minIdx para usar como endereço
    movl minIdx, %eax
    movl $4, %ebx
    imul %ebx, %eax

    # Guarda 4 * o cont_j para usar como endereço
    movl cont_j, %ecx
    movl $4, %ebx
    imul %ebx, %ecx

    # Faz o swap
    movl $vector, %edi
    addl %ecx, %edi
    movl (%edi), %edx
    movl %edx, minTemp
    movl minValue, %edx
    movl %edx, (%edi)
    movl $vector, %edi
    addl %eax, %edi
    movl minTemp, %edx
    movl %edx, (%edi)
    
    ret
