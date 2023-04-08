section .data
process1 db "vmtoolsd.exe", 0
process2 db "vboxservice.exe", 0
TH32CS_SNAPPROCESS equ 0x2

section .text
global check_processes
extern CreateToolhelp32Snapshot
extern Process32First
extern Process32Next
extern CloseHandle

check_processes:
    ; Save registers and set up stack frame
    push rbp
    mov rbp, rsp
    sub rsp, 256

    ; Create a snapshot of running processes
    mov ecx, TH32CS_SNAPPROCESS
    xor edx, edx
    call CreateToolhelp32Snapshot
    cmp rax, INVALID_HANDLE_VALUE
    je .cleanup_and_return

    ; Store the snapshot handle
    mov [rbp - 8], rax

    ; Set up the PROCESSENTRY32 structure
    mov dword [rbp - 256], 296
    lea rdx, [rbp - 256]

    ; Iterate through the processes in the snapshot
    .process_loop:
    mov rcx, [rbp - 8]
    call Process32Next
    test eax, eax
    je .cleanup_and_return

    ; Compare the process name with known sandbox process names
    lea rsi, [process1]
    lea rdi, [rbp - 244]
    call strcmp
    test eax, eax
    je .sandbox_detected

    lea rsi, [process2]
    lea rdi, [rbp - 244]
    call strcmp
    test eax, eax
    je .sandbox_detected

    ; Continue with the next process
    jmp .process_loop

.sandbox_detected:
    ; Sandbox process found
    mov eax, 1
    jmp .cleanup_and_return

.cleanup_and_return:
    ; Close the snapshot handle and return
    mov rcx, [rbp - 8]
    call CloseHandle
    ; If eax is still 0, no sandbox processes were found
    add rsp, 256
    pop rbp
    ret

strcmp:
    push rbx
    .loop:
    mov bl, [rsi]
    mov cl, [rdi]
    cmp bl, cl
    jne .done
    test bl, bl
    je .done
    inc rsi
    inc rdi
    jmp .loop
    .done:
    sub ecx, ebx
    mov eax, ecx
    pop rbx
    ret