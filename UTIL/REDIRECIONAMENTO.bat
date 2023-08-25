@ECHO OFF
CHCP 65001 >NUL
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
ECHO Verificando disponibilidade do software....
IF EXIST "%HOMEDRIVE%%HOMEPATH%\DOWNLOADS\%NOME_SOFTWARE%.%TIPO%" (
    ECHO Instalador disponível localmente, prosseguindo...
    SET "LOCAL_INST=%HOMEDRIVE%%HOMEPATH%\DOWNLOADS\%NOME_SOFTWARE%.%TIPO%"
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
        EXIT /B 1
    )
)
:SOLICITAR_DOWNLOAD
    IF EXIST ".\UTIL\DOWNLOAD.bat" (
        CALL .\UTIL\DOWNLOAD.bat "%URL_DOWNLOAD%" "%HOMEDRIVE%%HOMEPATH%\DOWNLOADS\%NOME_SOFTWARE%.%TIPO%"
        IF %ERRORLEVEL% EQU 0 (
            ECHO Download concluído, instalando software, aguarde...
            SET "LOCAL_INST=%HOMEDRIVE%%HOMEPATH%\DOWNLOADS\%NOME_SOFTWARE%.%TIPO%"
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
            IF EXIST %LOCAL_INST% (
                DEL /Q %LOCAL_INST%
                IF %ERRORLEVEL% EQU 0 (
                    ECHO Instalador removido com sucesso.
                ) ELSE ECHO Erro na remoção do arquivo na pasta Downloads.
            )
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