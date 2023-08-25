@ECHO OFF
CHCP 65001 >NUL
SETLOCAL ENABLEDELAYEDEXPANSION
SET "URL=%~1"
SET "FILE=%~2"
POWERSHELL -Command Import-Module BitsTransfer
SET "ERR=!ERRORLEVEL!"
IF !ERR! EQU 0 (
    POWERSHELL -Command "Start-BitsTransfer -Source '%URL%' -Destination '%FILE%'" >NUL 2>&1
    SET "ERR=!ERRORLEVEL!"
    IF !ERR! EQU 0 (
        EXIT /B 0
    ) ELSE (
        ECHO Aviso! Start-BitsTransfer indisponível, tentando com BITSADMIN.
        GOTO :BTA
    )
) ELSE GOTO :BTA
:BTA
    BITSADMIN /TRANSFER "GENERIC" /DOWNLOAD /PRIORITY NORMAL "%URL%" "%FILE%" >NUL
    SET "ERR=!ERRORLEVEL!"
    IF !ERR! EQU 0 (
        EXIT /B 0
    ) ELSE EXIT /B 1
ENDLOCAL
