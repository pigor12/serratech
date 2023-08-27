@ECHO OFF
CHCP 65001 >NUL
SETLOCAL ENABLEDELAYEDEXPANSION
REM Autor:  Pedro Igor Martins dos Reis
REM E-mail: pigor@fiemg.com.br
REM Data:   11/06/2023
IF EXIST "%USERPROFILE%\ServiceDesk\UTIL\REDIRECIONAMENTO.bat" (
    CALL :VER_WINDOWS
    CALL :VER_SOFTWARE
    IF %ERRORLEVEL% EQU 0 (
        GOTO :MENU_PRINCIPAL
    ) ELSE EXIT /B 1
) ELSE (
    ECHO Recursos básicos indisponíveis, gentileza verificar.
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
    SET /P "ESCOLHA=Escolha uma das opções acima e pressione ENTER: "
    CALL %USERPROFILE%\ServiceDesk\UTIL\REDIRECIONAMENTO.bat "!SOFTWARE_%ESCOLHA%!" "!URL_%ESCOLHA%!" "!TIPO_%ESCOLHA%!" "!PARAMETROS_%ESCOLHA%!" "!OP_%ESCOLHA%!"
    EXIT /B 0
:VER_WINDOWS
    FOR /F "TOKENS=4-5 DELIMS=. " %%I IN ('VER') DO SET "VERSAO=%%I.%%J"
:VER_SOFTWARE
    IF EXIST "%USERPROFILE%\ServiceDesk\UTIL\BD.TXT" (
        SET "CONTADOR=0"
        FOR /F "TOKENS=1-6 DELIMS=;" %%A IN (%USERPROFILE%\ServiceDesk\UTIL\BD.txt) DO (
            SET "NOME_!CONTADOR!=%%A"
            SET "SOFTWARE_!CONTADOR!=%%B"
            SET "URL_!CONTADOR!=%%C"
            SET "TIPO_!CONTADOR!=%%D"
            SET "PARAMETROS_!CONTADOR!=%%E"
            SET "OP_!CONTADOR!=%%F"
            SET /A "CONTADOR+=1"
        )
    ) ELSE (
        ECHO Erro! Banco de dados indisponível, saindo.
        EXIT /B 1
    )
ENDLOCAL