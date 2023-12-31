@ECHO OFF
REM Author:  Pedro Igor Martins dos Reis
REM E-mail: pigor@fiemg.com.br
REM Date:   11/06/2023
SETLOCAL ENABLEDELAYEDEXPANSION
SET "URL=%~1"
SET "FILE=%~2"
SET "SCRIPT_PATH=%~DP0"
ECHO :: Trying to download with BitsTransfer.
POWERSHELL -Command "Import-Module BitsTransfer"
IF !ERRORLEVEL! EQU 0 (
    POWERSHELL -Command "Start-BitsTransfer -Source '%URL%' -Destination '%FILE%'" >NUL 2>&1
    IF !ERRORLEVEL! EQU 0 (
        EXIT /B 0
    ) ELSE GOTO :NWC
) ELSE GOTO :NWC
:NWC
    ECHO :: Trying to download with Net.WebClient.
    POWERSHELL -Command "(New-Object Net.WebClient).DownloadFile('%URL%', '%FILE%')" >NUL 2>&1
    IF %ERRORLEVEL% EQU 0 ( 
        EXIT /B 0
    ) ELSE GOTO :IWR
:IWR
    ECHO :: Trying to download with Invoke-WebRequest.
    POWERSHELL -Command "Invoke-WebRequest -URI '%URL%' -Outfile '%FILE%'" >NUL 2>&1
    IF %ERRORLEVEL% EQU 0 (
        EXIT /B 0
    ) ELSE GOTO :BTA
:BTA
    ECHO :: Trying to download with BitsAdmin.
    BITSADMIN /TRANSFER "GENERIC" /DOWNLOAD /PRIORITY NORMAL "%URL%" "%FILE%" >NUL 2>&1
    IF %ERRORLEVEL% EQU 0 (
        EXIT /B 0
    ) ELSE GOTO :WGET
:WGET
    ECHO :: Trying to download with Wget.
    IF EXIST "%SCRIPT_PATH%WGET.EXE" (
        %SCRIPT_PATH%WGET.EXE "%URL%" -O "%FILE%" >NUL 2>&1
        IF !ERRORLEVEL! EQU 0 (
            EXIT /B 0
        ) ELSE EXIT /B 1
    ) ELSE EXIT /B 1
ENDLOCAL