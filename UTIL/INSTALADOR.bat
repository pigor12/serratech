@ECHO OFF
SETLOCAL
REM Autor:  Pedro Igor Martins dos Reis
REM E-mail: pigor@fiemg.com.br
REM Data:   11/06/2023
SET "ARQUIVO=%~1"
SET "TIPO=%~2"
SET "PARAMETROS=%~3"
SET "ERR=!ERRORLEVEL!"
IF EXIST "%ARQUIVO%" (
    IF "%TIPO%" == "EXE" (
        START /WAIT %ARQUIVO% %PARAMETROS%
        IF !ERR! EQU 0 (
            EXIT /B 0
        ) ELSE EXIT /B 1
    ) ELSE IF "%TIPO%" == "MSI" (
        START /WAIT MSIEXEC /I "%ARQUIVO%" /QUIET /QN /NORESTART
        IF !ERR! EQU 0 (
            EXIT /B 0
        ) ELSE EXIT /B 1
    )  ELSE (
        POWERSHELL -Command "Write-Host ' >> Erro! Formato não suportado.' -ForegroundColor Red"
        EXIT /B 1
    )
) ELSE (
    POWERSHELL -Command "Write-Host ' >> Erro! Arquivo removido ou alterado.' -ForegroundColor Red"
    EXIT /B 1
)
ENDLOCAL
