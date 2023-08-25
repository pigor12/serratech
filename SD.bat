@ECHO OFF
SETLOCAL
REM Autor:  Pedro Igor Martins dos Reis
REM E-mail: pigor@fiemg.com.br
REM Data:   11/06/2023
CLS
TITLE ServiceDesk - FIEMG
IF EXIST %SYSTEMROOT%\SYSTEM32\WDI\LOGFILES (
    ECHO Permissoes administrativas garantidas, prosseguindo.
    PING www.microsoft.com >NUL 2>&1
    IF %ERRORLEVEL% EQU 0 (
        ECHO Internet disponivel, prosseguindo.
        CALL .\UTIL\MENU.bat
    ) ELSE (
        ECHO Aviso! Conexao com internet indisponivel, funcionalidades reduzidas.
        PAUSE
        CALL .\UTIL\MENU.bat
    )   
) ELSE (
    ECHO Erro! Permissoes insuficientes, saindo.
    PAUSE
    EXIT /B 1 
)
ENDLOCAL