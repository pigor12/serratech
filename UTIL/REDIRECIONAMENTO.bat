@ECHO OFF
REM Author:  Pedro Igor Martins dos Reis
REM E-mail: pigor@fiemg.com.br
REM Date:   11/06/2023
SETLOCAL ENABLEDELAYEDEXPANSION
SET "SOFTWARE_NAME=%~1"
SET "DOWNLOAD_URL=%~2"
SET "TYPE=%~3"
SET "PARAMETERS=%~4"
SET "OPTION=%~5"
SET "SCRIPT_PATH=%~DP0"
CLS
ECHO :: OPTION: %SOFTWARE_NAME%
CALL :SETUP_ENVIRONMENT
IF "%OPTION%" NEQ "MS" (
    ECHO ^>^> Checking software availability.  
    IF EXIST "%HOMEDRIVE%\TEMP\%SOFTWARE_NAME%.%TYPE%" (
        ECHO ^>^> Installer found in TEMP folder, proceeding.  
        SET "INSTALL_LOCATION=%HOMEDRIVE%\TEMP\%SOFTWARE_NAME%.%TYPE%"
        GOTO :REQUEST_INSTALLATION
    ) ELSE (
        IF !ERRORLEVEL! EQU 0 (
            IF EXIST "\\!REPO_PATH!\%SOFTWARE_NAME%\%SOFTWARE_NAME%.%TYPE%" (
                ECHO ^>^> Installer available on network !REPO_NAME!, proceeding.
                SET "INSTALL_LOCATION=\\!REPO_PATH!\%SOFTWARE_NAME%\%SOFTWARE_NAME%.%TYPE%"
                GOTO :REQUEST_INSTALLATION
            ) ELSE (
                ECHO :: Warning, Installer unavailable on network !REPO_NAME!
                IF "%OPTION%" == "T" (
                    GOTO :REQUEST_DOWNLOAD
                ) ELSE IF "%OPTION%" == "L" (
                    ECHO XX Error, this software is not available online, exiting.  
                    PAUSE
                ) ELSE (
                    ECHO XX Error, option unknow..
                    PAUSE
                )
            )
        ) ELSE (
            ECHO :: No server found.
            IF "%OPTION%" == "T" (
                GOTO :REQUEST_DOWNLOAD
            ) ELSE IF "%OPTION%" == "L" (
                ECHO XX Error, this software is not available online, exiting.  
            ) ELSE (
                ECHO XX Error, option unknow..
                PAUSE
            )
        )
    )
) ELSE (
    CALL :CHECK_WINDOWS
    IF "!VERSION!" == "10.0" (
        ECHO ^>^> Software available on Microsoft Store.
        START /W %DOWNLOAD_URL%
        CALL :GENERATE_LOG
        EXIT /B 0
    ) ELSE (
        ECHO XX Microsoft Store is not available on Windows 7 and 8.1
        PAUSE
        EXIT /B 1
    )
)
:REQUEST_DOWNLOAD
    IF EXIST "%SCRIPT_PATH%DOWNLOAD.bat" (
        IF NOT EXIST "%HOMEDRIVE%\TEMP" (
            MKDIR "%HOMEDRIVE%\TEMP"
        )
        ECHO ^>^> Downloading, please wait...  
        CALL %SCRIPT_PATH%DOWNLOAD.bat "%DOWNLOAD_URL%" "%HOMEDRIVE%\TEMP\%SOFTWARE_NAME%.%TYPE%"
        IF !ERRORLEVEL! EQU 0 (
            ECHO ^>^> Download completed, installing software, please wait...  
            SET "INSTALL_LOCATION=%HOMEDRIVE%\TEMP\%SOFTWARE_NAME%.%TYPE%"
            GOTO :REQUEST_INSTALLATION
        ) ELSE (
            ECHO XX Error, Could not complete the transfer, exiting.  
            PAUSE
            EXIT /B 1
        )
    ) ELSE (
        ECHO XX Error, Download script unavailable.
        PAUSE
        EXIT /B 1
    )
:REQUEST_INSTALLATION
    IF EXIST "%SCRIPT_PATH%INSTALADOR.bat" (
        CALL %SCRIPT_PATH%INSTALADOR.bat "%INSTALL_LOCATION%" "%TYPE%" "%PARAMETERS%"
        IF !ERRORLEVEL! EQU 0 (
            ECHO ^>^> Installation completed.  
            IF EXIST "%HOMEDRIVE%\TEMP\%SOFTWARE_NAME%.%TYPE%" (
                DEL /Q "%HOMEDRIVE%\TEMP\%SOFTWARE_NAME%.%TYPE%"
                IF !ERRORLEVEL! EQU 0 (
                    ECHO ^>^> Installer successfully removed.
                ) ELSE (
                    ECHO XX Error, Could not remove the installer.
                    PAUSE
                )
            )
            CALL :GENERATE_LOG
            IF !ERRORLEVEL! EQU 0 (
                ECHO ^>^> LOG successfully generated.
            ) ELSE (
                ECHO XX Error, LOG could not be generated.
                PAUSE
            )
        ) ELSE (
            ECHO XX Error, Could not install the software, exiting.  
            PAUSE
            EXIT /B 1
        )
    ) ELSE (
        ECHO XX Error, Installation script unavailable.  
        PAUSE
        EXIT /B 1
    )
:SETUP_ENVIRONMENT
    IF EXIST "%SCRIPT_PATH%REPOS.TXT" (
        FOR /F "TOKENS=1-3 DELIMS=;" %%A IN (%SCRIPT_PATH%REPOS.TXT) DO (
            PING -n 1 %%B >NUL 2>&1
            IF !ERRORLEVEL! EQU 0 (
                SET "REPO_NAME=%%A"
                SET "REPO_HOSTNAME=%%B"
                SET "REPO_PATH=%%C"
                EXIT /B 0
            )
        )
        EXIT /B 1
    ) ELSE (
        ECHO XX Error, Repositories file unavailable, exiting.  
        PAUSE
        EXIT /B 1
    )
:CHECK_WINDOWS
    FOR /F "TOKENS=4-5 DELIMS=. " %%I IN ('VER') DO SET "VERSION=%%I.%%J"
    EXIT /B 0
:GENERATE_LOG
    IF NOT EXIST "%SCRIPT_PATH%..\LOGS" (
        ECHO ^>^> Creating LOGS folder on network "%REPO_NAME%".  
        MKDIR "%SCRIPT_PATH%..\LOGS"
        IF !ERRORLEVEL! NEQ 0 (
            ECHO XX Error, Could not create LOGS folder.  
            EXIT /B 1
        ) 
    ) ELSE ECHO :: LOGS folder already exists.
    ECHO ^>^> Generating logs file.
    FOR /F "TOKENS=2 DELIMS==" %%I IN ('WMIC OS GET LOCALDATETIME /VALUE') DO SET "DATETIME=%%I"
    SET "LOGFILE=%SCRIPT_PATH%..\LOGS\install_%DATETIME:~0,14%.log"
    ECHO ============================= > "%LOGFILE%"
    ECHO Software: %SOFTWARE_NAME% >> "%LOGFILE%"
    ECHO Date: %DATE% >> "%LOGFILE%"
    ECHO Time: %TIME% >> "%LOGFILE%"
    ECHO User: %USERNAME% >> "%LOGFILE%"
    ECHO Computer name: %COMPUTERNAME% >> "%LOGFILE%"
    EXIT /B 0
ENDLOCAL
