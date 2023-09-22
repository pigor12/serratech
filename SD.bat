@ECHO OFF >NUL
REM Author:  Pedro Igor Martins dos Reis
REM E-mail: pigor@fiemg.com.br
REM Date:   11/06/2023
SETLOCAL
SET "SCRIPT_PATH=%~DP0"
CLS
TITLE HelpDesk
ECHO ^>^> Checking administrator permissions.
IF EXIST %SYSTEMROOT%\SYSTEM32\WDI\LOGFILES (
    ECHO ^>^> Checking internet connection.
    PING -n 1 www.microsoft.com >NUL 2>&1
    IF %ERRORLEVEL% EQU 0 ( 
        GOTO :MENU
    ) ELSE (
        ECHO :: Warning, internet connection unavailable, reduced functionalities.
        PAUSE
        GOTO :MENU
    )
) ELSE (
    ECHO XX Error, Insufficient permissions, exiting.
    PAUSE
    EXIT /B 1
)
:MENU
    IF EXIST "%SCRIPT_PATH%Util\Menu.bat" (
        CALL "%SCRIPT_PATH%Util\Menu.bat"
        IF %ERRORLEVEL% NEQ 0 (
            ECHO XX Error, Failed to execute the script.
            PAUSE
        ) ELSE (
            ECHO ^>^> Script terminated
            PAUSE
            EXIT /B 0
        )
    ) ELSE (
        ECHO XX Error, Required files unavailable, please check.
        PAUSE
        EXIT /B 1
    )
ENDLOCAL
