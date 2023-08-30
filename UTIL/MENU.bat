@ECHO OFF
SETLOCAL ENABLEDELAYEDEXPANSION
REM Author:  Pedro Igor Martins dos Reis
REM E-mail: pigor@fiemg.com.br
REM Date:   11/06/2023
IF EXIST "\\10.1.1.50\FTP\SUPORTE\SCRIPT\SERRATECH\UTIL\REDIRECIONAMENTO.bat" (
    CALL :CHECK_SOFTWARE
    IF %ERRORLEVEL% EQU 0 (
        GOTO :MAIN_MENU
    ) ELSE EXIT /B 1
) ELSE (
    ECHO Error! Basic resources unavailable, please check.
    PAUSE
    EXIT /B 1
)
:MAIN_MENU
    CLS
    ECHO.
    ECHO      %COUNTER% software available
    ECHO.
    SET /A "COUNTER-=1"
    FOR /L %%I IN (0,1,%COUNTER%) DO (
        ECHO        %%I     !NAME_%%I!
    )
    ECHO.
    SET /P "CHOICE=>> Choose one of the options above and press ENTER: "
    IF DEFINED SOFTWARE_%CHOICE% (
        CALL \\10.1.1.50\ftp\suporte\SCRIPT\SERRATECH\UTIL\REDIRECIONAMENTO.bat "!SOFTWARE_%CHOICE%!" "!URL_%CHOICE%!" "!TYPE_%CHOICE%!" "!PARAMETERS_%CHOICE%!" "!OP_%CHOICE%!"
    ) ELSE (
        ECHO Error, unavailable option. 
        PAUSE
        GOTO :MAIN_MENU
        EXIT /B 1
    )
    EXIT /B 0
:CHECK_SOFTWARE
    IF EXIST "\\10.1.1.50\ftp\suporte\SCRIPT\SERRATECH\UTIL\BD.TXT" (
        SET "COUNTER=0"
        FOR /F "TOKENS=1-6 DELIMS=;" %%A IN (\\10.1.1.50\ftp\suporte\SCRIPT\SERRATECH\UTIL\BD.txt) DO (
            SET "NAME_!COUNTER!=%%A"
            SET "SOFTWARE_!COUNTER!=%%B"
            SET "URL_!COUNTER!=%%C"
            SET "TYPE_!COUNTER!=%%D"
            SET "PARAMETERS_!COUNTER!=%%E"
            SET "OP_!COUNTER!=%%F"
            SET /A "COUNTER+=1"
        )
    ) ELSE (
        ECHO Error! Database unavailable, exiting. 
        EXIT /B 1
    )
ENDLOCAL
