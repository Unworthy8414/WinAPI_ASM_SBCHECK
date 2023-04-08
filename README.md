Sandbox Detection Framework for Windows
=======================================

This repository contains an efficient and comprehensive sandbox detection framework for Windows, implemented in assembly language. The framework is divided into several assembly files, each handling a specific aspect of sandbox detection. This modular approach makes it easier to maintain and update the code. However, note this is a template and contains only some base and more common virtualization environments. You will need to update this to your specific requirements before implementation.

Modules
-------

-   **main.asm**: The main assembly file that coordinates the execution of different detection techniques and combines their results to make the final decision.
-   **file_and_directory_checks.asm**: Contains functions that check for the presence of known sandbox files and directories.
-   **process_checks.asm**: Contains functions that check for the presence of known sandbox processes.
-   **system_behavior_and_resource_usage.asm**: Contains functions that monitor system behavior and resource usage patterns, which may indicate a sandbox environment.
-   **virtualization_artifacts.asm**: Contains functions that analyze the execution environment for known virtualization artifacts, such as specific registry keys or hardware configurations.
-   **system_information_checks.asm**: Contains functions that look for discrepancies in system information that may indicate the presence of a sandbox.
-   **hardware_and_software_configuration_checks.asm**: Contains functions that identify specific hardware or software configurations that are unlikely to be found in a real user's environment.

How to use
----------

1.  Clone the repository.
2.  Assemble and link the assembly files using your preferred assembler and linker (e.g., NASM and GoLink). **You will need the following:**
    1.  kernel32.lib: Contains most of the Windows API functions, including:

        -   GetLastError
        -   Sleep
        -   GetTickCount64
        -   CreateToolhelp32Snapshot
        -   Process32First
        -   Process32Next
        -   CloseHandle
    2.  user32.lib: Contains user interface related functions, such as:

        -   GetCursorPos
    3.  advapi32.lib: Contains functions related to the Windows registry and security, including:

        -   RegOpenKeyA
        -   RegQueryValueA
        -   RegCloseKey
        -   RegOpenKeyExA
    4.  sysinfoapi.lib: Contains functions related to system information, such as:

        -   GetSystemInfo
        -   GetPhysicallyInstalledSystemMemory
    5.  mincore.lib: Contains functions related to file management, such as:

        -   FindFirstFileA
        
3.  Execute the compiled binary to check if it's running in a sandboxed environment.

Developing and maintaining
--------------------------

The modular design of the framework allows you to develop and maintain each aspect of sandbox detection independently. When new sandbox evasion techniques are discovered, you can easily update individual components.

Combining the results of these techniques should provide a more comprehensive and accurate assessment of whether the code is running in a sandboxed environment.

Contributing
------------

Contributions are welcome! If you have any improvements, bug fixes, or new detection techniques, feel free to create a pull request or open an issue.

License
-------

This project is released under the GNU License. See `LICENSE` file for more information.
