;Author information
;  Author name: shaochenren
;  Author email: renleo@csu.fullerton.edu
;
;Program information
;  Program name: Integer Arithmetic
;  Programming languages: One modules in C and one module in X86
;  Date program began:     2020-Sep-14
;  Date program completed: 2020-Sep
;  Files in this program: integerdriver.c, arithmetic.asm, r.sh
;  Status: Complete.  No errors found after extensive testing.
;
;References for this program
;  Jorgensen, X86-64 Assembly Language Programming with Ubuntu, Version 1.1.40.
;  Robert Plantz, X86 Assembly Programming.  [No longer available as a free download]
;
;Purpose
;  Show how to perform arithmetic operations on two operands both of type long integer.
;  Show how to handle overflow of multiplication.
;
;This file
;   File name: arithmetic.asm
;   Language: X86-64 with Intel syntax
;   Max page width: 132 columns
;   Assemble: nasm -f elf64 -l arithmetic.lis -o arithmetic.o arithmetic.asm
;   Link: gcc -m64 -no-pie -o current.out driver.o arithmetic.o        ;Ref Jorgensen, page 226, "-no-pie"
;   Optimal print specification: 132 columns width, 7 points, monospace, 8½x11 paper

extern printf                                     ;Reference: Jorgensen book 1.1.40, page48
extern scanf
null equ 0                                        ;Reference: Jorgensen book 1.1.40, page 34.
newline equ 10
global arithmetic 
segment .data 
  
welcome db "Welcome to your friendly circle circumference calculator.", newline, null

The db "The main program will now call the circle function.", newline, null

This db "This circle function is brought to you by shaochen.", newline, null

please db "please enter the radius of a circle in a whole number of meters: ", null

outputformat1 db "The number %ld was received", 10, 0

quotient db "The circumference of a circle with this radius is %ld and ", 0
remainderformat db "%ld / 7", 10, 0

quotient1 db "The main received this integer: %ld",10,0

farewell db "The integer part of the area will be returned to the main program. Please enjoy your circle.  Bye.", 10, 0

nice db "Have a nice day.", 10, 0
stringoutputformat db "%s", 0
signedintegerinputformat db "%ld", null

segment .bss 
segment .text                                     ;Instructions are placed in this segment
arithmetic:
push rbp                                               ;Backup rbp
mov  rbp,rsp                                                ;The base pointer now points to top of stack
push rdi                                                    ;Backup rdi
push rsi                                                    ;Backup rsi
push rdx                                                    ;Backup rdx
push rcx                                                    ;Backup rcx
push r8                                                     ;Backup r8
push r9                                                     ;Backup r9
push r10                                                    ;Backup r10
push r11                                                    ;Backup r11
push r12                                                    ;Backup r12
push r13                                                    ;Backup r13
push r14                                                    ;Backup r14
push r15                                                    ;Backup r15
push rbx                                                    ;Backup rbx
pushf 


push qword -1  
;Output the welcome message                       ;This is a group of instructions jointly performing one task.
mov qword rdi, stringoutputformat
mov qword rsi, welcome
mov qword rax, 0
call printf

;output the second sentence
mov qword rdi, stringoutputformat
mov qword rsi, The
mov qword rax, 0
call printf

;output the thrid sentence
mov qword rdi, stringoutputformat
mov qword rsi, This
mov qword rax, 0
call printf

;output the thrid sentence
mov qword rdi, stringoutputformat
mov qword rsi, please
mov qword rax, 0
call printf

;Input the first integer
mov qword rdi, signedintegerinputformat
push qword -1                                     ;Place an arbitrary value on the stack; -1 is ok, any quad value will work
mov qword rsi, rsp                                ;Now rsi points to that dummy value on the stack
mov qword rax, 0                                  ;No vector registers
call scanf                                        ;Call the external function; the new value is placed into the location that rsi points to
pop qword r14                                     ;First inputted integer is saved in r14

;Output the value previously entered
mov qword rdi, outputformat1
mov rsi, r14
mov qword rdx, r14                                ;Both rsi and rdx hold the inputted value as well as r14
mov qword rax, 0
call printf  

;product of 44                        
mov qword rax, r14                                ;Copy the first factor (operand) to rax
mov qword rdx, 44                                ;rdx contains no data we wish to save.
imul rdx

mov qword r12, rdx                                ;High order bits are saved in r12
mov qword r13, rax

mov qword rax, r13
mov qword rbx, 7
idiv rbx
mov r13, rdx

mov qword rdi, quotient
mov qword rsi, rax                                ;Copy the quotient to rsi
mov qword rdx, rax                                ;Copy the quotient to rdx
mov qword rax, 0
mov r12, rdx
call printf


;show the remainderformat
mov qword rdi, remainderformat
mov qword rsi, r13                                ;Copy the remainder to rsi
mov qword rdx, r13                                ;Copy the remainder to rdx
mov qword rax, 0
call printf



;Output the farewell message
mov qword rdi, stringoutputformat
mov qword rsi, farewell                           ;The starting address of the string is placed into the second parameter.
mov qword rax, 0
call printf

mov qword rdi, quotient1
mov qword rsi, r12                                ;Copy the quotient to rsi
mov qword rdx, r12                                ;Copy the quotient to rdx
mov qword rax, 0
call printf

;Output the farewell message
mov qword rdi, stringoutputformat
mov qword rsi, nice                           ;The starting address of the string is placed into the second parameter.
mov qword rax, 0
call printf

pop rax                                                     ;Remove the extra -1 from the stack
popf                                                        ;Restore rflags
pop rbx                                                     ;Restore rbx
pop r15                                                     ;Restore r15
pop r14                                                     ;Restore r14
pop r13                                                     ;Restore r13
pop r12                                                     ;Restore r12
pop r11                                                     ;Restore r11
pop r10                                                     ;Restore r10
pop r9                                                      ;Restore r9
pop r8                                                      ;Restore r8
pop rcx                                                     ;Restore rcx
pop rdx                                                     ;Restore rdx
pop rsi                                                     ;Restore rsi
pop rdi                                                     ;Restore rdi
pop rbp                                                     ;Restore rbp

mov qword rax, 0                                  ;Return value 0 indicates successful conclusion.
ret                                               ;Pop the integer stack and jump to the address represented by the popped value.
