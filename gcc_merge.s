.section .data
    LC0: .ascii "Array original:"
    LC1: .ascii "%d "
    LC2: .ascii "Array ordenado:"

.section .text
.globl main

main:
	pushl	%ebp
	movl	%esp, %ebp
	pushl	%ebx
	andl	$-16, %esp
	subl	$48, %esp
	movl	$12, 24(%esp)
	movl	$11, 28(%esp)
	movl	$13, 32(%esp)
	movl	$5, 36(%esp)
	movl	$6, 40(%esp)
	movl	$7, 44(%esp)
	movl	$LC0, (%esp)
	call	printf
	movl	$0, %ebx
L23:
	cmpl	$5, %ebx
	jg	L28
	movl	24(%esp,%ebx,4), %eax
	movl	%eax, 4(%esp)
	movl	$LC1, (%esp)
	call	printf
	addl	$1, %ebx
	jmp	L23
L28:
	movl	$10, (%esp)
	call	printf
	movl	$5, 8(%esp)
	movl	$0, 4(%esp)
	leal	24(%esp), %eax
	movl	%eax, (%esp)
	call	mergeSort
	movl	$LC2, (%esp)
	call	printf
	movl	$0, %ebx
L25:
	cmpl	$5, %ebx
	jg	L29
	movl	24(%esp,%ebx,4), %eax
	movl	%eax, 4(%esp)
	movl	$LC1, (%esp)
	call	printf
	addl	$1, %ebx
	jmp	L25
L29:
	movl	$10, (%esp)
	call	printf
	movl	$0, %eax
	movl	-4(%ebp), %ebx
	leave
	ret

merge:
LFB15:
	pushl	%ebp
	movl	%esp, %ebp
	pushl	%edi
	pushl	%esi
	pushl	%ebx
	subl	$28, %esp
	movl	8(%ebp), %ebx
	movl	12(%ebp), %ecx
	movl	16(%ebp), %edi
	movl	%edi, %eax
	subl	%ecx, %eax
	leal	1(%eax), %esi
	movl	%esi, -32(%ebp)
	movl	20(%ebp), %esi
	subl	%edi, %esi
	movl	%esi, -28(%ebp)
	movl	$16, %esi
	leal	19(,%eax,4), %eax
	movl	$0, %edx
	divl	%esi
	movl	%eax, %edx
	sall	$4, %edx
	movl	%edx, %eax
	subl	%eax, %esp
	movl	%esp, -36(%ebp)
	movl	-28(%ebp), %eax
	leal	15(,%eax,4), %eax
	movl	$0, %edx
	divl	%esi
	sall	$4, %eax
	subl	%eax, %esp
	movl	%esp, %esi
	movl	$0, %eax
	movl	%esi, -40(%ebp)
	movl	-36(%ebp), %esi
	movl	-32(%ebp), %edi
L2:
	cmpl	%edi, %eax
	jge	L15
	leal	(%eax,%ecx), %edx
	movl	(%ebx,%edx,4), %edx
	movl	%edx, (%esi,%eax,4)
	addl	$1, %eax
	jmp	L2
L15:
	movl	-40(%ebp), %esi
	movl	16(%ebp), %edi
	movl	$0, %eax
	movl	%ecx, 12(%ebp)
	movl	-28(%ebp), %ecx
L4:
	cmpl	%ecx, %eax
	jge	L16
	leal	1(%eax,%edi), %edx
	movl	(%ebx,%edx,4), %edx
	movl	%edx, (%esi,%eax,4)
	addl	$1, %eax
	jmp	L4
L16:
	movl	$0, %eax
	movl	$0, %edx
	movl	%esi, -40(%ebp)
	movl	%ebx, 8(%ebp)
	jmp	L6
L7:
	movl	8(%ebp), %ecx
	movl	12(%ebp), %ebx
	movl	%esi, (%ecx,%ebx,4)
	addl	$1, %eax
L8:
	addl	$1, 12(%ebp)
L6:
	cmpl	-32(%ebp), %edx
	setl	%bl
	movl	%ebx, %edi
	cmpl	-28(%ebp), %eax
	setl	%bl
	movl	%ebx, %esi
	movl	%edi, %ebx
	movl	%esi, %ecx
	testb	%cl, %bl
	je	L17
	movl	-36(%ebp), %edi
	movl	(%edi,%edx,4), %edi
	movl	-40(%ebp), %esi
	movl	(%esi,%eax,4), %esi
	cmpl	%esi, %edi
	jg	L7
	movl	8(%ebp), %ecx
	movl	12(%ebp), %ebx
	movl	%edi, (%ecx,%ebx,4)
	addl	$1, %edx
	jmp	L8
L17:
	movl	-40(%ebp), %esi
	movl	8(%ebp), %ebx
	movl	12(%ebp), %ecx
	movl	%eax, -40(%ebp)
	movl	-32(%ebp), %eax
	movl	-36(%ebp), %edi
	movl	%esi, -32(%ebp)
	jmp	L10
L11:
	movl	(%edi,%edx,4), %esi
	movl	%esi, (%ebx,%ecx,4)
	addl	$1, %edx
	addl	$1, %ecx
L10:
	cmpl	%eax, %edx
	jl	L11
	movl	-40(%ebp), %eax
	movl	-32(%ebp), %esi
	movl	-28(%ebp), %edi
	jmp	L12
L13:
	movl	(%esi,%eax,4), %edx
	movl	%edx, (%ebx,%ecx,4)
	addl	$1, %eax
	addl	$1, %ecx
L12:
	cmpl	%edi, %eax
	jl	L13
	leal	-12(%ebp), %esp
	popl	%ebx
	popl	%esi
	popl	%edi
	popl	%ebp
	ret
    
mergeSort:
LFB16:
	pushl	%edi
	pushl	%esi
	pushl	%ebx
	subl	$16, %esp
	movl	36(%esp), %ebx
	movl	40(%esp), %edi
	cmpl	%edi, %ebx
	jl	L21
L18:
	addl	$16, %esp
	popl	%ebx
	popl	%esi
	popl	%edi
	ret
L21:
	movl	%edi, %eax
	subl	%ebx, %eax
	movl	%eax, %esi
	shrl	$31, %esi
	addl	%eax, %esi
	sarl	%esi
	addl	%ebx, %esi
	movl	%esi, 8(%esp)
	movl	%ebx, 4(%esp)
	movl	32(%esp), %eax
	movl	%eax, (%esp)
	call	mergeSort
	movl	%edi, 8(%esp)
	leal	1(%esi), %eax
	movl	%eax, 4(%esp)
	movl	32(%esp), %eax
	movl	%eax, (%esp)
	call	mergeSort
	movl	%edi, 12(%esp)
	movl	%esi, 8(%esp)
	movl	%ebx, 4(%esp)
	movl	32(%esp), %eax
	movl	%eax, (%esp)
	call	merge
	jmp	L18