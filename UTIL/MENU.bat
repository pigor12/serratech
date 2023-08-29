@ECHO OFF
CHCP 65001 >NUL
SETLOCAL ENABLEDELAYEDEXPANSION
REM Autor:  Pedro Igor Martins dos Reis
REM E-mail: pigor@fiemg.com.br
REM Data:   11/06/2023
IF EXIST "\\10.1.1.50\ftp\suporte\SCRIPT\SERRATECH\UTIL\REDIRECIONAMENTO.bat" (
    CALL :VER_SOFTWARE
    IF %ERRORLEVEL% EQU 0 (
        GOTO :MENU_PRINCIPAL
    ) ELSE EXIT /B 1
) ELSE (
    POWERSHELL -Command "Write-Host ' >> Erro! Recursos básicos indisponíveis, gentileza verificar.' -ForegroundColor Red"
    PAUSE
    EXIT /B 1
)
:MENU_PRINCIPAL
    CLS
    ECHO.
    ECHO      %CONTADOR% softwares disponíveis
    ECHO.
    SET /A "CONTADOR-=1"
    FOR /L %%I IN (0,1,%CONTADOR%) DO (
        ECHO        %%I     !NOME_%%I!
    )
    ECHO.
    SET /P "ESCOLHA=  >> Escolha uma das opções acima e pressione ENTER: "
    IF DEFINED SOFTWARE_%ESCOLHA% (
        CALL \\10.1.1.50\ftp\suporte\SCRIPT\SERRATECH\UTIL\REDIRECIONAMENTO.bat "!SOFTWARE_%ESCOLHA%!" "!URL_%ESCOLHA%!" "!TIPO_%ESCOLHA%!" "!PARAMETROS_%ESCOLHA%!" "!OP_%ESCOLHA%!"
    ) ELSE (
        POWERSHELL -Command "Write-Host ' >> Erro, opção indisponível.' -ForegroundColor Red"
        PAUSE
        GOTO :MENU_PRINCIPAL
        EXIT /B 1
    )
    EXIT /B 0
:VER_SOFTWARE
    IF EXIST "\\10.1.1.50\ftp\suporte\SCRIPT\SERRATECH\UTIL\BD.TXT" (
        SET "CONTADOR=0"
        FOR /F "TOKENS=1-6 DELIMS=;" %%A IN (\\10.1.1.50\ftp\suporte\SCRIPT\SERRATECH\UTIL\BD.txt) DO (
            SET "NOME_!CONTADOR!=%%A"
            SET "SOFTWARE_!CONTADOR!=%%B"
            SET "URL_!CONTADOR!=%%C"
            SET "TIPO_!CONTADOR!=%%D"
            SET "PARAMETROS_!CONTADOR!=%%E"
            SET "OP_!CONTADOR!=%%F"
            SET /A "CONTADOR+=1"
        )
    ) ELSE (
        POWERSHELL -Command "Write-Host ' >> Erro! Banco de dados indisponível, saindo.' -ForegroundColor Red"
        EXIT /B 1
    )
ENDLOCAL