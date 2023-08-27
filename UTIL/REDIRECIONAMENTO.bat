@ECHO OFF
REM Autor:  Pedro Igor Martins dos Reis
REM E-mail: pigor@fiemg.com.br
REM Data:   11/06/2023
SETLOCAL ENABLEDELAYEDEXPANSION
SET "NOME_SOFTWARE=%~1"
SET "URL_DOWNLOAD=%~2"
SET "TIPO=%~3"
SET "PARAMETROS=%~4"
SET "OPC=%~5"
CALL :CONFIGURAR_AMBIENTE
IF %ERRORLEVEL% EQU 0 (
    ECHO Repositório "%REPO_NOME%" definido.
) ELSE (
    ECHO Aviso! Nenhum repositório disponível.
    PAUSE
)
IF "%OPC%" NEQ "MS" (
    ECHO Verificando disponibilidade do software....
    IF EXIST "%USERPROFILE%\DOWNLOADS\%NOME_SOFTWARE%.%TIPO%" (
        ECHO Instalador disponível localmente, prosseguindo...
        SET "LOCAL_INST=%USERPROFILE%\DOWNLOADS\%NOME_SOFTWARE%.%TIPO%"
        GOTO :SOLICITAR_INSTALACAO
    ) ELSE IF EXIST "\\%REPO_CAMINHO%\%NOME_SOFTWARE%\%NOME_SOFTWARE%.%TIPO%" (
        ECHO Instalador disponível na rede, prosseguindo...
        SET "LOCAL_INST=\\%REPO_CAMINHO%\%NOME_SOFTWARE%\%NOME_SOFTWARE%.%TIPO%"
        GOTO :SOLICITAR_INSTALACAO
    ) ELSE (
        ECHO Aviso! Instalador indisponível localmente.
        IF "%OPC%" == "T" (
            ECHO Baixando arquivos, aguarde...
            GOTO :SOLICITAR_DOWNLOAD
        ) ELSE (
            ECHO Erro, este software não é disponibilizado na internet, saindo.
            PAUSE
            EXIT /B 1
        )
    )
) ELSE (
    CALL :VER_WINDOWS
    IF "%VERSAO%" == "10.0" (
        ECHO Software disponível na Microsoft Store.
        START /W %URL_DOWNLOAD%
        PAUSE
        EXIT /B 0
    ) ELSE (
        ECHO Microsoft Store não está disponível no Windows 7 e 8.1
        PAUSE
        EXIT /B 1
    )
)
:SOLICITAR_DOWNLOAD
    IF EXIST "%USERPROFILE%\ServiceDesk\UTIL\DOWNLOAD.bat" (
        CALL %USERPROFILE%\ServiceDesk\UTIL\DOWNLOAD.bat "%URL_DOWNLOAD%" "%USERPROFILE%\DOWNLOADS\%NOME_SOFTWARE%.%TIPO%"
        IF !ERRORLEVEL! EQU 0 (
            ECHO Download concluído, instalando software, aguarde...
            SET "LOCAL_INST=%USERPROFILE%\DOWNLOADS\%NOME_SOFTWARE%.%TIPO%"
            GOTO :SOLICITAR_INSTALACAO
        ) ELSE (
            ECHO Erro no download dos arquivos, saindo.
            PAUSE
            EXIT /B 1
        )
    ) ELSE (
        ECHO Erro! Script de download indisponível.
        PAUSE
        EXIT /B 1
    )
:SOLICITAR_INSTALACAO
    IF EXIST "%USERPROFILE%\ServiceDesk\UTIL\INSTALADOR.bat" (
        CALL %USERPROFILE%\ServiceDesk\UTIL\INSTALADOR.bat "%LOCAL_INST%" "%TIPO%" "%PARAMETROS%"
        IF !ERRORLEVEL! EQU 0 (
            ECHO Instalação concluída.
            PAUSE
            IF EXIST %LOCAL_INST% (
                DEL /Q %LOCAL_INST%
                IF !ERRORLEVEL! EQU 0 (
                    ECHO Instalador removido com sucesso.
                ) ELSE ECHO Erro ao remover o arquivo na pasta 'Downloads'.
            )
            EXIT /B 0
        ) ELSE (
            ECHO Erro na instalação do software, saindo.
            PAUSE
            EXIT /B 1
        )
    ) ELSE (
        ECHO Erro! Script de instalação indisponível.
        PAUSE
        EXIT /B 1
    )
:CONFIGURAR_AMBIENTE
    IF EXIST "%USERPROFILE%\ServiceDesk\UTIL\REPOS.TXT" (
        FOR /F "TOKENS=1-3 DELIMS=;" %%A IN (%USERPROFILE%\ServiceDesk\UTIL\REPOS.TXT) DO (
            PING %%B >NUL 2>&1
            IF !ERRORLEVEL! EQU 0 (
                SET "REPO_NOME=%%A"
                SET "REPO_HOSTNAME=%%B"
                SET "REPO_CAMINHO=%%C"
                EXIT /B 0
            )
        )
    ) ELSE (
        ECHO Arquivo de repositórios indisponível, saindo.
        PAUSE
        EXIT /B 1
    )
:VER_WINDOWS
    FOR /F "TOKENS=4-5 DELIMS=. " %%I IN ('VER') DO SET "VERSAO=%%I.%%J"
ENDLOCAL