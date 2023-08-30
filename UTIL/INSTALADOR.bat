@ECHO OFF
SETLOCAL
REM Author:  Pedro Igor Martins dos Reis
REM E-mail: pigor@fiemg.com.br
REM Date:   11/06/2023
SET "FILE=%~1"
SET "TYPE=%~2"
SET "PARAMETERS=%~3"
SET "ERR=!ERRORLEVEL!"
IF EXIST "%FILE%" (
    IF "%TYPE%" == "EXE" (
        START /WAIT %FILE% %PARAMETERS%
        IF !ERR! EQU 0 (
            EXIT /B 0
        ) ELSE EXIT /B 1
    ) ELSE IF "%TYPE%" == "MSI" (
        START /WAIT MSIEXEC /I "%FILE%" /QUIET /QN /NORESTART
        IF !ERR! EQU 0 (
            EXIT /B 0
        ) ELSE EXIT /B 1
    )  ELSE (
        ECHO Error! Unsupported format. 
        EXIT /B 1
    )
) ELSE (
    ECHO Error! File removed or changed. 
    EXIT /B 1
)
ENDLOCAL
