section .data
; Constants for GetSystemInfo and GetPhysicallyInstalledSystemMemory
SYSTEM_INFO_SIZE equ 52

section .text
global check_system_information
extern GetSystemInfo
extern GetPhysicallyInstalledSystemMemory

; Checks for discrepancies in system information
; Returns 1 if a discrepancy is found, 0 otherwise
check_system_information:
    push rbp
    mov rbp, rsp
    sub rsp, SYSTEM_INFO_SIZE

    ; Call GetSystemInfo
    lea rdi, [rbp - SYSTEM_INFO_SIZE]
    call GetSystemInfo

    ; Check the number of processors
    movzx eax, word [rbp - SYSTEM_INFO_SIZE + 20] ; dwNumberOfProcessors
    cmp eax, 1
    jle .discrepancy_found

    ; Call GetPhysicallyInstalledSystemMemory
    sub rsp, 8
    lea rdi, [rbp - 8]
    call GetPhysicallyInstalledSystemMemory

    ; Check the amount of physical memory
    cmp eax, 0
    jnz .no_discrepancy_found
    mov rax, [rbp - 8]
    cmp rax, 2048 ; 2048 MB = 2 GB
    jl .discrepancy_found

.no_discrepancy_found:
    ; No discrepancy found
    xor eax, eax
    jmp .end

.discrepancy_found:
    ; Discrepancy found
    mov eax, 1

.end:
    add rsp, SYSTEM_INFO_SIZE
    mov rsp, rbp
    pop rbp
    ret