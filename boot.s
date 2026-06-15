/* Multiboot header */
.set ALIGN,    1<<0             /* align loaded modules on page boundaries */
.set MEMINFO,  1<<1             /* provide memory map */
.set FLAGS,    ALIGN | MEMINFO  /* this is the Multiboot 'flag' field */
.set MAGIC,    0x1BADB002       /* 'magic number' lets bootloader find the header */
.set CHECKSUM, -(MAGIC + FLAGS) /* checksum of above, to prove we are multiboot */

.section .multiboot
.align 4
.long MAGIC
.long FLAGS
.long CHECKSUM

/* 
Stack allocation. 
The bootloader (GRUB or QEMU) leaves us in a 32-bit protected mode.
We need a stack to execute C code.
*/
.section .bss
.align 16
stack_bottom:
.skip 16384 # 16 KiB
stack_top:

/*
Entry point of the kernel.
*/
.section .text
.global _start
.type _start, @function
_start:
    /* Set up the stack pointer */
    mov $stack_top, %esp
    
    /* Call the C main function */
    call kernel_main
    
    /* If kernel_main returns, halt the CPU */
    cli
1:  hlt
    jmp 1b
.size _start, . - _start
