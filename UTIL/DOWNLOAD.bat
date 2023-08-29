@ECHO OFF
CHCP 65001 >NUL
REM Autor:  Pedro Igor Martins dos Reis
REM E-mail: pigor@fiemg.com.br
REM Data:   11/06/2023
SETLOCAL ENABLEDELAYEDEXPANSION
SET "URL=%~1"
SET "FILE=%~2"
POWERSHELL -Command "(New-Object Net.WebClient).DownloadFile('%URL%', '%FILE%')" >NUL 2>&1
    SET "ERR=!ERRORLEVEL!"
    IF !ERR! EQU 0 (
        EXIT /B 0
    ) ELSE (
        POWERSHELL -Command "Write-Host ' >> Aviso, WebClient indisponível, tentando com Start-BitsTransfer.' -ForegroundColor Yellow"
        GOTO :STB
    )
:STB
    POWERSHELL -Command Import-Module BitsTransfer
    SET "ERR=!ERRORLEVEL!"
    IF !ERR! EQU 0 (
        POWERSHELL -Command "Start-BitsTransfer -Source '%URL%' -Destination '%FILE%'" >NUL 2>&1
        SET "ERR=!ERRORLEVEL!"
        IF !ERR! EQU 0 (
            EXIT /B 0
        ) ELSE (
            POWERSHELL -Command "Write-Host ' >> Aviso, Start-BitsTransfer indisponível, tentando com BITSADMIN.' -ForegroundColor Yellow"
            GOTO :BTA
        )
    ) ELSE GOTO :BTA
:BTA
    BITSADMIN /TRANSFER "GENERIC" /DOWNLOAD /PRIORITY NORMAL "%URL%" "%FILE%" >NUL 2>&1
    SET "ERR=!ERRORLEVEL!"
    IF !ERR! EQU 0 (
        EXIT /B 0
    ) ELSE GOTO :WGET
:WGET
    IF EXIST "\\10.1.1.50\ftp\SUPORTE\SCRIPT\SERRATECH\UTIL\WGET.EXE" (
        POWERSHELL -Command "Write-Host ' >> Aviso, BITSADMIN indisponível, tentando com Wget.' -ForegroundColor Yellow"
        \\10.1.1.50\ftp\SUPORTE\SCRIPT\SERRATECH\UTIL\WGET.EXE "%URL%" -O "%FILE%" >NUL 2>&1
    ) ELSE EXIT /B 1
ENDLOCAL
