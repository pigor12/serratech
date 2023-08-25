@ECHO OFF
SETLOCAL ENABLEDELAYEDEXPANSION
IF EXIST ".\UTIL\REDIRECIONAMENTO.bat" (
    CALL :VER_WINDOWS
    CALL :VER_SOFTWARE
    IF %ERRORLEVEL% EQU 0 (
        GOTO :MENU_PRINCIPAL
    ) ELSE EXIT /B 1
) ELSE (
    ECHO Recursos basicos indisponiveis, gentileza verificar.
    PAUSE
    EXIT /B 1
)
:MENU_PRINCIPAL
    CLS
    ECHO.
    ECHO        Softwares disponiveis
    ECHO.
    SET /A "CONTADOR-=1"
    FOR /L %%I IN (0,1,%CONTADOR%) DO (
        ECHO        %%I   !NOME_%%I!
    )
    ECHO.
    SET /P "ESCOLHA=Escolha uma das opcoes acima e pressione ENTER: "
    CALL .\UTIL\REDIRECIONAMENTO.bat "!SOFTWARE_%ESCOLHA%!" "!URL_%ESCOLHA%!" "!TIPO_%ESCOLHA%!" "!PARAMETROS_%ESCOLHA%!" "!OP_%ESCOLHA%!"
    EXIT /B 0
:VER_WINDOWS
    FOR /F "TOKENS=4-5 DELIMS=. " %%I IN ('VER') DO SET "VERSAO=%%I.%%J"
:VER_SOFTWARE
    IF EXIST ".\UTIL\BD.TXT" (
        SET "CONTADOR=0"
        FOR /F "TOKENS=1-6 DELIMS=;" %%A IN (.\UTIL\BD.txt) DO (
            SET "NOME_!CONTADOR!=%%A"
            SET "SOFTWARE_!CONTADOR!=%%B"
            SET "URL_!CONTADOR!=%%C"
            SET "TIPO_!CONTADOR!=%%D"
            SET "PARAMETROS_!CONTADOR!=%%E"
            SET "OP_!CONTADOR!=%%F"
            SET /A "CONTADOR+=1"
        )
    ) ELSE (
        ECHO Erro! Banco de dados indisponivel, saindo.
        EXIT /B 1
    )
ENDLOCAL