@ECHO OFF
SETLOCAL
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
        START /WAIT MSIEXEC /I "%ARQUIVO%" /QUIET /QN /NORESTART /LOG "%ARQUIVO%.txt"
        IF !ERR! EQU 0 (
            EXIT /B 0
        ) ELSE EXIT /B 1
    )  ELSE (
        ECHO Erro! Formato nao suportado.
        EXIT /B 1
    )
) ELSE (
    ECHO Erro! Arquivo removido ou alterado.
    EXIT /B 1
)
ENDLOCAL
