section .data
path1 db "C:\\Users\\Sandbox\\Desktop", 0
path2 db "C:\\ProgramData\\Sandboxie", 0
INVALID_HANDLE_VALUE equ -1

section .text
global check_files_and_directories
extern FindFirstFileA
extern GetLastError

check_files_and_directories:
    ; Save registers and set up stack frame
    push rbp
    mov rbp, rsp
    sub rsp, 32

    ; Check for path1
    lea rdx, [path1]
    mov rcx, rdx
    call FindFirstFileA
    cmp rax, INVALID_HANDLE_VALUE
    jne .sandbox_detected

    ; Check for path2
    lea rdx, [path2]
    mov rcx, rdx
    call FindFirstFileA
    cmp rax, INVALID_HANDLE_VALUE
    jne .sandbox_detected

    ; No sandbox files or directories found
    xor eax, eax
    jmp .end

.sandbox_detected:
    ; Sandbox files or directories found
    mov eax, 1

.end:
    ; Restore registers and return
    add rsp, 32
    pop rbp
    ret