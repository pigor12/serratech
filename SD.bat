@ECHO OFF
CHCP 65001 >NUL
SETLOCAL
REM Autor:  Pedro Igor Martins dos Reis
REM E-mail: pigor@fiemg.com.br
REM Data:   11/06/2023
CLS
TITLE ServiceDesk - FIEMG
IF EXIST %SYSTEMROOT%\SYSTEM32\WDI\LOGFILES (
    ECHO ♠ Permissões administrativas garantidas, prosseguindo.
    PING CETECMG.local -n 1 >NUL 2>&1
    IF %ERRORLEVEL% EQU 0 (
        ECHO ○ Conexão com o CIT disponível, prosseguindo.
        PING www.google.com -n 1 >NUL 2>&1
        IF %ERRORLEVEL% EQU 0 (
            ECHO ◊ Internet disponível, prosseguindo.
            CALL .\UTIL\MENU.bat
        ) ELSE (
            ECHO ☼ Aviso! Conexão com internet indisponível, funcionalidades reduzidas.
            PAUSE
            EXIT /B 1
        )
    ) ELSE (
        ECHO ☼ Aviso! Conexão com o CIT indisponível, saindo.
        PAUSE
        EXIT /B 1
    )
) ELSE (
    ECHO ► Erro! Permissões insuficientes, saindo.
    PAUSE
    EXIT /B 1 
)
ENDLOCAL