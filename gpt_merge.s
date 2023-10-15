TITLE Program 7

; This program takes an unsorted array and sorts

; it using mergesort.

INCLUDE Irvine32.inc

.data

ProgInfo BYTE "CPSC 232 - Mergesort Program", 0

unSortList DWORD 1000, 501, 100, 51, 0, 1, 1, 0, 50, 101, 500, 1001

;unSortList DWORD 0,1,0,1,0,0,0,1,1,1,0,1,0

;unSortList DWORD 27,10,12,20,25,13,44,15,22,10,44,50,10

;unSortList DWORD 27,1000,12,20,25,13,44,15,22,10,44,50,10

;unSortList DWORD 100,99,98,97,96,95,94,93,92,91,90,50,51,52,53,54,55,56,57,59,59,10,9,8,7,6,5,4,3,2,1,0

tempList DWORD (LENGTHOF unsortList) DUP(0)

List1 BYTE "The unsorted list is: ", 0

List2 BYTE 10,"The sorted list is: ", 0

comma BYTE ", "

.code

Display PROC

 movl eax,[esi]

 addl esi, 4

 call writedec

 dec ecx

DisplayLoop:

 lea edx, comma

 call writestring

 movl eax,[esi]

 addl esi, 4

 call writedec

 loop DisplayLoop

 ret

Display ENDP

Merge proc

L1:

 cmp ebx, 0

 je AddlArray2

 cmp ecx, 0

 je AddlArray1

 movl eax,[esi]

 cmp eax,[edi]

 jl AddlArray1 ;Jump if less

 jmp AddlArray2 ;Jump if greater or equal

AddlArray1:

 cmp ebx, 0

 je EndJump

 movl eax,[esi]

 movl [edx],ax

 addl esi,4

 addl edx,4

 dec ebx

 jmp L1

AddlArray2:

 cmp ecx, 0

 je EndJump

 movl eax,[edi]

 movl [edx],ax

 addl edi,4

 addl edx,4

 dec ecx

 jmp L1

 EndJump:

 ret

Merge ENDP

; Sorts using mergesort,

; requires esi = array to sort, edi = temporary array, ecx = array length

 MergeSort PROC

 push ecx ; save length

 push esi ; save array

 push edi ; save temp array

 cmp ecx, 1 ; if length is 1, it's sorted

 jle endSort

 push ecx

 shr ecx,1 ; divide length by 2

 call MergeSort ; sort the half array

 movl eax, ecx

 pop ecx

 push esi

 push eax

 sub ecx, eax ; get length of second half of array

 shl eax, 2 ; multiply first array length by 4

 addl esi, eax ; advance pointer

 call MergeSort ; sort the half array

 movl edx, edi

 movl edi, esi

 pop ebx ; load length of first array

 pop esi ; load addlress of first array

 call Merge

 movl esi,[esp] ; load addlress of temp array

 movl edi,[esp + 4] ; load addlress of initial array

 movl ecx, [esp+8] ; load number of elements

 ; copy from temp to initial array

copy:

 movl eax,[esi]

 movl [edi], eax

 addl esi, 4

 addl edi, 4

 loop copy

endSort:

 pop edi ; restore registers

 pop esi

 pop ecx

 ret

MergeSort ENDP

main PROC

 movl edx, OFFSET Proginfo

 call WriteString

 call Crlf

 call Crlf

 movl edx, offset List1

 call writestring

 movl ecx,lengthof unsortList

 movl esi,offset unsortList

 call Display

 movl esi,OFFSET unsortList

 movl edi,OFFSET tempList

 movl ecx,LENGTHOF unsortList ; elements in list

 call MergeSort

 movl edx, offset List2

 call writestring

 movl ecx,lengthof unsortList

 movl esi,offset unsortList

 call Display

 call Crlf

 exit

 main ENDP

 END main