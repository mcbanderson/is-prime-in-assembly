title Prime Number Program (primenum.asm)

; This program accepts a number from the user
; as input, and then determine if that number
; is prime. User must enter a negative number
; to exit.

INCLUDELIB irvine.lib               ; include the irvine library

.model small
.stack 100h
.386

.data
prompt db "Please enter a number (negative number to exit): ", 0
prime db "The number you entered is prime.", 0
notPrime db "The number you entered is not prime.", 0
number dd 00000000h

.code
extrn Readlong:proc, Writestring:proc, Crlf:proc

main proc
    mov ax, @data                   ; Setup the
    mov ds, ax                      ; Data segment

start:
    mov dx, offset prompt           ; Move offset of prompt into dx for printing
    call Writestring                ; Print prompt
    call Readlong                   ; Get 32 bit signed decimal string from user

    cmp eax, 0                      ; Compare the entered number to 0
    jl exit                         ; If user entered negative number, exit

    cmp eax, 2                      ; If the user entered 1 or 2
    jle P                           ; Then the number is prime

    mov number, eax                 ; Store the entered number in memory
    mov edx, 00000000h              ; Store 0 in edx to prepare for bitshift
    shrd eax, edx, 1                ; Shift eax right 1 bit to divide it by 2
    add eax, 1                      ; Add 1 to eax
    mov ecx, eax                    ; Ecx now contains the maximum number we will test against input to check if input is prime

L1:
    cmp ecx, 1                      ; If the loop counter reaches 1
    jz P                            ; Then the number is prime

    mov edx, 00000000h              ; Zero out edx to prep for division

    mov eax, number                 ; Restore the number the user entered to eax
    div ecx                         ; Divide eax by ecx

    cmp edx, 0                      ; Check if the remainder is 0
    jz NP                           ; If so the number is not prime
loop L1

P:
    mov dx, offset prime            ; Move offset of prime message to dx for printing
    call Writestring                ; Write the message indicating number is prime
    call Crlf                       ; Move to new line
    jmp start                       ; Ask user for another number

NP:
    mov dx, offset notPrime         ; Move offset of not prime message to dx for printing
    call Writestring                ; Write the message indicating number is not prime
    call Crlf                       ; Move to new line
    jmp start                       ; Ask user for another number

exit:
    mov ax, 4C00h                   ; End execution and return
    int 21h                         ; Control to DOS
main endp

end main
