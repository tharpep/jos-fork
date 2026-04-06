/* See COPYRIGHT for copyright information. */

#include <inc/mmu.h>
#include <inc/memlayout.h>
#include <inc/trap.h>

#include <kern/picirq.h>


###################################################################
# exceptions/interrupts
###################################################################

/* TRAPHANDLER defines a globally-visible function for handling a trap.
 * It pushes a trap number onto the stack, then jumps to _alltraps.
 * Use TRAPHANDLER for traps where the CPU automatically pushes an error code.
 *
 * You shouldn't call a TRAPHANDLER function from C, but you may
 * need to _declare_ one in C (for instance, to get a function pointer
 * during IDT setup).  You can declare the function with
 *   void NAME();
 * where NAME is the argument passed to TRAPHANDLER.
 */
#define TRAPHANDLER(name, num)						\
	.globl name;		/* define global symbol for 'name' */	\
	.type name, @function;	/* symbol type is function */		\
	.align 2;		/* align function definition */		\
	name:			/* function starts here */		\
	pushl $(num);							\
	jmp _alltraps

/* Use TRAPHANDLER_NOEC for traps where the CPU doesn't push an error code.
 * It pushes a 0 in place of the error code, so the trap frame has the same
 * format in either case.
 */
#define TRAPHANDLER_NOEC(name, num)					\
	.globl name;							\
	.type name, @function;						\
	.align 2;							\
	name:								\
	pushl $0;							\
	pushl $(num);							\
	jmp _alltraps

.text

/*
 * Lab 3: Your code here for generating entry points for the different traps.
 */

// HINT 1 : TRAPHANDLER_NOEC(t_divide, T_DIVIDE);
//          Do something like this if there is no error code for the trap
// HINT 2 : TRAPHANDLER(t_dblflt, T_DBLFLT);
//          Do something like this if the trap includes an error code..
// HINT 3 : READ Intel's manual to check if the trap includes an error code
//          or not...

# LLM-Assisted code
TRAPHANDLER_NOEC(handler0, T_DIVIDE)    /* Divide error */
TRAPHANDLER_NOEC(handler1, T_DEBUG)     /* Debug */
TRAPHANDLER_NOEC(handler2, T_NMI)      /* NMI */
TRAPHANDLER_NOEC(handler3, T_BRKPT)    /* Breakpoint */
TRAPHANDLER_NOEC(handler4, T_OFLOW)    /* Overflow */
TRAPHANDLER_NOEC(handler5, T_BOUND)    /* Bound Range */
TRAPHANDLER_NOEC(handler6, T_ILLOP)    /* Invalid Opcode */
TRAPHANDLER_NOEC(handler7, T_DEVICE)   /* Device Not Available */
TRAPHANDLER(handler8, T_DBLFLT)        /* Double Fault */
TRAPHANDLER_NOEC(handler9, 9)          /* Coprocessor Segment */
TRAPHANDLER(handler10, T_TSS)          /* Invalid TSS */
TRAPHANDLER(handler11, T_SEGNP)        /* Segment Not Present */
TRAPHANDLER(handler12, T_STACK)        /* Stack Fault */
TRAPHANDLER(handler13, T_GPFLT)        /* General Protection */
TRAPHANDLER(handler14, T_PGFLT)        /* Page Fault */
TRAPHANDLER_NOEC(handler15, 15)        /* Reserved */
TRAPHANDLER_NOEC(handler16, T_FPERR)   /* x87 FP */
TRAPHANDLER(handler17, T_ALIGN)        /* Alignment Check */
TRAPHANDLER_NOEC(handler18, T_MCHK)    /* Machine Check */
TRAPHANDLER_NOEC(handler19, T_SIMDERR) /* SIMD FP */

TRAPHANDLER_NOEC(handler48, T_SYSCALL) /* Syscall */

/*
 * Lab 3: Your code here for _alltraps
 */

 _alltraps:
    pushl %ds
    pushl %es
    pushal
    movw $GD_KD, %ax
    movw %ax, %ds
    movw %ax, %es
    pushl %esp
    call trap


