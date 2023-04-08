section .data
performance_data_key db "HKEY_DYN_DATA\\PerfStats\\StartStat", 0
performance_data_value db "KERNEL\\CPUUsage", 0
INVALID_HANDLE_VALUE equ -1

section .text
global check_system_behavior_and_resource_usage
extern RegOpenKeyA
extern RegQueryValueA
extern RegCloseKey

check_system_behavior_and_resource_usage:
    ; Save registers and set up stack frame
    push rbp
    mov rbp, rsp
    sub rsp, 64

    ; Open the performance data registry key
    lea rdx, [performance_data_key]
    xor rcx, rcx
    call RegOpenKeyA
    cmp eax, 0
    jne .cleanup_and_return

    ; Store the registry key handle
    mov [rbp - 8], rax

    ; Query the performance data value
    lea rdx, [performance_data_value]
    lea r8, [rbp - 64]
    mov r9, 8
    mov rcx, [rbp - 8]
    call RegQueryValueA
    cmp eax, 0
    jne .cleanup_and_return

    ; Check the CPU usage value
    mov ecx, [rbp - 64]
    cmp ecx, 10
    jle .sandbox_detected

    ; No suspicious system behavior or resource usage detected
    xor eax, eax
    jmp .cleanup_and_return

.sandbox_detected:
    ; Suspicious system behavior or resource usage detected
    mov eax, 1

.cleanup_and_return:
    ; Close the registry key handle and return
    mov rcx, [rbp - 8]
    call RegCloseKey
    add rsp, 64
    pop rbp
    ret