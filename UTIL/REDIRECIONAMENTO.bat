@ECHO OFF
CHCP 65001 >NUL
SETLOCAL ENABLEDELAYEDEXPANSION
SET "NOME_SOFTWARE=%~1"
SET "URL_DOWNLOAD=%~2"
SET "TIPO=%~3"
SET "PARAMETROS=%~4"
CALL :CONFIGURAR_AMBIENTE
IF %ERRORLEVEL% EQU 0 (
    ECHO Repositório "%REPO_NOME%" definido.
) ELSE (
    ECHO Erro, nenhum repositório FIEMG disponível.
    PAUSE
)

ECHO Verificando disponibilidade do software....
ECHO.
ECHO Buscando em: "\\%REPO_CAMINHO%\%NOME_SOFTWARE%\%NOME_SOFTWARE%.%TIPO%"
IF EXIST "%HOMEDRIVE%\%HOMEPATH%\DOWNLOADS\%NOME_SOFTWARE%.%TIPO%" (
    ECHO Instalador disponível localmente, prosseguindo...
    SET "LOCAL_INST=%HOMEDRIVE%\%HOMEPATH%\DOWNLOADS\%NOME_SOFTWARE%.%TIPO%"
    GOTO :SOLICITAR_INSTALACAO
) ELSE IF EXIST "\\%REPO_CAMINHO%\%NOME_SOFTWARE%\%NOME_SOFTWARE%.%TIPO%" (
    ECHO Instalador disponível na rede FIEMG, prosseguindo...
    SET "LOCAL_INST=\\%REPO_CAMINHO%\%NOME_SOFTWARE%\%NOME_SOFTWARE%.%TIPO%"
    GOTO :SOLICITAR_INSTALACAO
) ELSE (
    ECHO Aviso! Instalador indisponível. Baixando arquivos...
    PAUSE
    GOTO :SOLICITAR_DOWNLOAD
)
:SOLICITAR_DOWNLOAD
    IF EXIST ".\UTIL\DOWNLOAD.bat" (
        CALL .\UTIL\DOWNLOAD.bat "%URL_DOWNLOAD%" "%HOMEDRIVE%\%HOMEPATH%\DOWNLOADS\%NOME_SOFTWARE%.%TIPO%"
        IF %ERRORLEVEL% EQU 0 (
            CLS
            ECHO.
            ECHO Download concluído, instalando software, aguarde...
            SET "LOCAL_INST=%HOMEDRIVE%\%HOMEPATH%\DOWNLOADS\%NOME_SOFTWARE%.%TIPO%"
            GOTO :SOLICITAR_INSTALACAO
        ) ELSE (
            ECHO Erro no download dos arquivos, saindo.
            EXIT /B 1
        )
    ) ELSE (
        ECHO Erro! Script de Download indisponível.
        EXIT /B 1
    )
:SOLICITAR_INSTALACAO
    IF EXIST ".\UTIL\INSTALADOR.bat" (
        CALL .\UTIL\INSTALADOR.bat "%LOCAL_INST%" "%TIPO%" "%PARAMETROS%"
        IF %ERRORLEVEL% EQU 0 (
            ECHO Instalação concluída.
            EXIT /B 0
        ) ELSE (
            ECHO Erro na instalação do software, saindo.
            EXIT /B 1
        )
    ) ELSE (
        ECHO Erro! Script de instalação indisponível.
        EXIT /B 1
    )
:CONFIGURAR_AMBIENTE
    IF EXIST ".\UTIL\REPOS.TXT" (
        FOR /F "TOKENS=1-3 DELIMS=;" %%A IN (.\UTIL\REPOS.TXT) DO (
            ECHO Testando conexão com %%A...
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
        EXIT /B 1
    )
ENDLOCAL