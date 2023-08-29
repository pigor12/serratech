@ECHO OFF
REM Autor:  Pedro Igor Martins dos Reis
REM E-mail: pigor@fiemg.com.br
REM Data:   11/06/2023
CHCP 65001 >NUL
SETLOCAL
CLS
TITLE HelpDesk - CIT
POWERSHELL -Command "Write-Host ' >> Verificando permissão de administrador.' -ForegroundColor Cyan"
IF EXIST %SYSTEMROOT%\SYSTEM32\WDI\LOGFILES (
    POWERSHELL -Command "Write-Host ' >> Permissões administrativas garantidas, prosseguindo.' -ForegroundColor Green"
    POWERSHELL -Command "Write-Host ' >> Verificando conexão com a internet.' -ForegroundColor Cyan"
    PING www.microsoft.com >NUL 2>&1
    IF %ERRORLEVEL% EQU 0 (
        POWERSHELL -Command "Write-Host ' >> Internet disponível, prosseguindo.' -ForegroundColor Green"
        GOTO :MENU
    ) ELSE (
        POWERSHELL -Command "Write-Host ' >> Aviso, conexão com internet indisponível, funcionalidades reduzidas.' -ForegroundColor Yellow"
        PAUSE
        GOTO :MENU
    )
) ELSE (
    POWERSHELL -Command "Write-Host ' >> Erro! Permissões insuficientes, saindo.' -ForegroundColor Red"
    PAUSE
    EXIT /B 1 
)
:MENU
    IF EXIST "\\10.1.1.50\ftp\suporte\SCRIPT\SERRATECH\Util\Menu.bat" (
        CALL "\\10.1.1.50\ftp\suporte\SCRIPT\SERRATECH\Util\Menu.bat"
    ) ELSE (
        POWERSHELL -Command "Write-Host ' >> Erro! Arquivos necessários indisponíveis, gentileza verificar.' -ForegroundColor Red"
        PAUSE
        EXIT /B 1
    )
ENDLOCAL