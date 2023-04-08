section .data
vmware_reg_key db "SYSTEM\\CurrentControlSet\\Services\\vmx86", 0
virtualbox_reg_key db "SYSTEM\\CurrentControlSet\\Services\\VBoxSF", 0

section .text
global check_virtualization_artifacts
extern RegOpenKeyExA
extern RegCloseKey

; Checks for known virtualization artifacts
; Returns 1 if a virtualization artifact is found, 0 otherwise
check_virtualization_artifacts:
    push rbp
    mov rbp, rsp

    ; Check for VMware registry key
    lea rdi, [vmware_reg_key]
    call check_registry_key_presence
    test eax, eax
    jnz .artifact_found

    ; Check for VirtualBox registry key
    lea rdi, [virtualbox_reg_key]
    call check_registry_key_presence
    test eax, eax
    jnz .artifact_found

    ; No virtualization artifacts found
    xor eax, eax
    jmp .end

.artifact_found:
    mov eax, 1

.end:
    mov rsp, rbp
    pop rbp
    ret

; Check for the presence of a registry key
; RDI: address of the null-terminated string representing the registry key
; Returns 1 if the registry key is present, 0 otherwise
check_registry_key_presence:
    push rbp
    mov rbp, rsp
    sub rsp, 16

    ; Prepare arguments for RegOpenKeyExA
    xor ecx, ecx ; HKEY_LOCAL_MACHINE
    mov rdx, rdi ; Registry key
    xor r8, r8   ; Reserved
    mov r9d, 0x20019 ; KEY_READ
    lea rsi, [rbp-8] ; Handle

    ; Call RegOpenKeyExA
    call RegOpenKeyExA

    ; Check the return value
    test eax, eax
    jnz .key_not_found

    ; Close the registry key
    mov rcx, [rbp-8]
    call RegCloseKey

    ; Registry key found
    mov eax, 1
    jmp .end_function

.key_not_found:
    ; Registry key not found
    xor eax, eax

.end_function:
    mov rsp, rbp
    pop rbp
    ret