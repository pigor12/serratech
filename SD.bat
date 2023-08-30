@ECHO OFF >NUL
REM Author:  Pedro Igor Martins dos Reis
REM E-mail: pigor@fiemg.com.br
REM Date:   11/06/2023
SETLOCAL
CLS
TITLE HelpDesk - CIT
ECHO Checking administrator permissions.
IF EXIST %SYSTEMROOT%\SYSTEM32\WDI\LOGFILES (
    ECHO Administrative permissions granted, proceeding.  
    ECHO Checking internet connection.
    PAUSE
    PING www.microsoft.com >NUL 2>&1
    IF %ERRORLEVEL% EQU 0 (
        ECHO Internet available, proceeding.  
        GOTO :MENU
    ) ELSE (
        ECHO Warning, internet connection unavailable, reduced functionalities.
        PAUSE
        GOTO :MENU
    )
) ELSE (
    ECHO Error! Insufficient permissions, exiting.
    PAUSE
    EXIT /B 1 
)
:MENU
    IF EXIST "\\10.1.1.50\ftp\suporte\SCRIPT\SERRATECH\Util\Menu.bat" (
        CALL "\\10.1.1.50\ftp\suporte\SCRIPT\SERRATECH\Util\Menu.bat"
        IF %ERRORLEVEL% NEQ 0 (
            ECHO Error! Failed to execute the script.
            PAUSE
        )
    ) ELSE (
        ECHO Error! Required files unavailable, please check.
        PAUSE
        EXIT /B 1
    )
ENDLOCAL
