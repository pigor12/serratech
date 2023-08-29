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
IF "%OPC%" NEQ "MS" (
    POWERSHELL -Command "Write-Host ' >> Verificando disponibilidade do software.' -ForegroundColor Cyan" 
    IF EXIST "%HOMEDRIVE%\TEMP\%NOME_SOFTWARE%.%TIPO%" (
        POWERSHELL -Command "Write-Host ' >> Instalador encontrado na pasta TEMP, prosseguindo.' -ForegroundColor Green"
        SET "LOCAL_INST=%HOMEDRIVE%\TEMP\%NOME_SOFTWARE%.%TIPO%"
        GOTO :SOLICITAR_INSTALACAO
    ) ELSE (
        CALL :CONFIGURAR_AMBIENTE
        IF !ERRORLEVEL! EQU 0 (
            POWERSHELL -Command "Write-Host ' >> Servidor !REPO_HOSTNAME! encontrado.' -ForegroundColor Cyan"
            IF EXIST "\\!REPO_CAMINHO!\%NOME_SOFTWARE%\%NOME_SOFTWARE%.%TIPO%" (
                POWERSHELL -Command "Write-Host ' >> Instalador disponível na rede !REPO_NOME!.' -ForegroundColor Green"
                SET "LOCAL_INST=\\!REPO_CAMINHO!\%NOME_SOFTWARE%\%NOME_SOFTWARE%.%TIPO%"
                GOTO :SOLICITAR_INSTALACAO
            ) ELSE (
                POWERSHELL -Command "Write-Host ' >> Aviso, Instalador indisponível na rede !REPO_NOME!' -ForegroundColor Yellow"
                IF "%OPC%" == "T" (
                    GOTO :SOLICITAR_DOWNLOAD
                ) ELSE (
                    POWERSHELL -Command "Write-Host ' >> Erro, este software não é disponibilizado na internet, saindo.' -ForegroundColor Red"
                    PAUSE
                    EXIT /B 1
                )
            )
        ) ELSE (
            POWERSHELL -Command "Write-Host ' >> Nenhum servidor encontrado.' -ForegroundColor Yellow" 
        )
    )
) ELSE (
    CALL :VER_WINDOWS
    IF "%VERSAO%" == "10.0" (
        POWERSHELL -Command "Write-Host ' >> Software disponível na Microsoft Store.' -ForegroundColor Cyan"
        START /W %URL_DOWNLOAD%
        PAUSE
        EXIT /B 0
    ) ELSE (
        POWERSHELL -Command "Write-Host ' >> Microsoft Store não está disponível no Windows 7 e 8.1' -ForegroundColor Red"
        PAUSE
        EXIT /B 1
    )
)
:SOLICITAR_DOWNLOAD
    IF EXIST "\\10.1.1.50\ftp\suporte\SCRIPT\SERRATECH\UTIL\DOWNLOAD.bat" (
        IF NOT EXIST "%HOMEDRIVE%\TEMP" (
            MKDIR "%HOMEDRIVE%\TEMP"
        )
        POWERSHELL -Command "Write-Host ' >> Realizando download, aguarde...' -ForegroundColor Cyan"
        CALL \\10.1.1.50\ftp\suporte\SCRIPT\SERRATECH\UTIL\DOWNLOAD.bat "%URL_DOWNLOAD%" "%HOMEDRIVE%\TEMP\%NOME_SOFTWARE%.%TIPO%"
        IF !ERRORLEVEL! EQU 0 (
            POWERSHELL -Command "Write-Host ' >> Download concluído, instalando software, aguarde...' -ForegroundColor Green"
            SET "LOCAL_INST=%HOMEDRIVE%\TEMP\%NOME_SOFTWARE%.%TIPO%"
            GOTO :SOLICITAR_INSTALACAO
        ) ELSE (
            POWERSHELL -Command "Write-Host ' >> Erro! Não foi possível completar a transferência, saindo.' -ForegroundColor Red"
            PAUSE
            EXIT /B 1
        )
    ) ELSE (
        POWERSHELL -Command "Write-Host ' >> Erro! script de download indisponível.' -ForegroundColor Red"
        PAUSE
        EXIT /B 1
    )
:SOLICITAR_INSTALACAO
    IF EXIST "\\10.1.1.50\ftp\suporte\SCRIPT\SERRATECH\UTIL\INSTALADOR.bat" (
        CALL \\10.1.1.50\ftp\suporte\SCRIPT\SERRATECH\UTIL\INSTALADOR.bat "%LOCAL_INST%" "%TIPO%" "%PARAMETROS%"
        IF !ERRORLEVEL! EQU 0 (
            POWERSHELL -Command "Write-Host ' >> Instalação concluída.' -ForegroundColor Green"
            IF EXIST %LOCAL_INST% (
                DEL /Q %LOCAL_INST%
                IF !ERRORLEVEL! EQU 0 (
                    POWERSHELL -Command "Write-Host ' >> Instalador removido com sucesso.' -ForegroundColor Green"
                ) ELSE (
                    POWERSHELL -Command "Write-Host ' >> Erro! Não foi possível remover o instalador.' -ForegroundColor Red"
                )
            )
            PAUSE
            EXIT /B 0
        ) ELSE (
            POWERSHELL -Command "Write-Host ' >> Erro! Não foi possível instalar o software, saindo.' -ForegroundColor Red"
            PAUSE
            EXIT /B 1
        )
    ) ELSE (
        POWERSHELL -Command "Write-Host ' >> Erro! Script de instalação indisponível.' -ForegroundColor Red"
        PAUSE
        EXIT /B 1
    )
:CONFIGURAR_AMBIENTE
    IF EXIST "\\10.1.1.50\ftp\suporte\SCRIPT\SERRATECH\UTIL\REPOS.TXT" (
        FOR /F "TOKENS=1-3 DELIMS=;" %%A IN (\\10.1.1.50\ftp\suporte\SCRIPT\SERRATECH\UTIL\REPOS.TXT) DO (
            PING %%B >NUL 2>&1
            IF !ERRORLEVEL! EQU 0 (
                SET "REPO_NOME=%%A"
                SET "REPO_HOSTNAME=%%B"
                SET "REPO_CAMINHO=%%C"
                EXIT /B 0
            )
        )
        EXIT /B 1
    ) ELSE (
        POWERSHELL -Command "Write-Host ' >> Erro! Arquivo de repositórios indisponível, saindo.' -ForegroundColor Red"
        PAUSE
        EXIT /B 1
    )
:VER_WINDOWS
    FOR /F "TOKENS=4-5 DELIMS=. " %%I IN ('VER') DO SET "VERSAO=%%I.%%J"
ENDLOCAL