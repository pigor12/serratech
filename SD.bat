@ECHO OFF
REM Autor:  Pedro Igor Martins dos Reis
REM E-mail: pigor@fiemg.com.br
REM Data:   11/06/2023
CHCP 65001 >NUL
SETLOCAL
CLS
TITLE ServiceDesk - FIEMG
IF EXIST %SYSTEMROOT%\SYSTEM32\WDI\LOGFILES (
    ECHO Permissões administrativas garantidas, prosseguindo.
    PING www.microsoft.com >NUL 2>&1
    IF %ERRORLEVEL% EQU 0 (
        ECHO Internet disponível, prosseguindo.
        GOTO :MENU
    ) ELSE (
        ECHO Aviso! Conexão com internet indisponível, funcionalidades reduzidas.
        PAUSE
        GOTO :MENU
    )
) ELSE (
    ECHO Erro! Permissões insuficientes, saindo.
    PAUSE
    EXIT /B 1 
)
:MENU
    IF EXIST "%USERPROFILE%\ServiceDesk\Util\Menu.bat" (
        CALL "%USERPROFILE%\ServiceDesk\Util\Menu.bat"
    ) ELSE (
        ECHO Arquivos necessários indisponíveis, gentileza verificar.
        PAUSE
        EXIT /B 1
    )
ENDLOCAL