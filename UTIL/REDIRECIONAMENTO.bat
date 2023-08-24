@ECHO OFF
CHCP 65001 >NUL
SET "NOME_SOFTWARE=%~1"
SET "URL_DOWNLOAD=%~2"
SET "TIPO=%~3"
SET "PARAMETROS=%~4"
ECHO Verificando disponibilidade do software....
IF EXIST "%HOMEDRIVE%\%HOMEPATH%\DOWNLOADS\%NOME_SOFTWARE%.%TIPO%" (
    ECHO Instalador disponível localmente, prosseguindo...
    SET "LOCAL_INST=%HOMEDRIVE%\%HOMEPATH%\DOWNLOADS\%NOME_SOFTWARE%.%TIPO%"
    GOTO :SOLICITAR_INSTALACAO
) ELSE IF EXIST "\\10.1.1.92\GPOS\%NOME_SOFTWARE%\%NOME_SOFTWARE%.%TIPO%" (
    ECHO Instalador disponível na rede CIT, prosseguindo...
    SET "LOCAL_INST=\\10.1.1.92\GPOS\%NOME_SOFTWARE%\%NOME_SOFTWARE%.%TIPO%"
    GOTO :SOLICITAR_INSTALACAO
) ELSE (
    ECHO Aviso! Instalador indisponível. Baixando arquivos...
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
            ECHO ► Erro no download dos arquivos, saindo.
            EXIT /B 1
        )
    ) ELSE (
        ECHO ► Erro! Script de Download indisponível.
        EXIT /B 1
    )
:SOLICITAR_INSTALACAO
    IF EXIST ".\UTIL\INSTALADOR.bat" (
        CALL .\UTIL\INSTALADOR.bat "%LOCAL_INST%" "%TIPO%" "%PARAMETROS%"
        IF %ERRORLEVEL% EQU 0 (
            ECHO Instalação concluída.
            EXIT /B 0
        ) ELSE (
            ECHO ► Erro na instalação do software, saindo.
            EXIT /B 1
        )
    ) ELSE (
        ECHO ► Erro! Script de instalação indisponível.
        EXIT /B 1
    )