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
CLS
IF "%OPTION%" NEQ "MS" (
    ECHO Checking software availability.  
    IF EXIST "%HOMEDRIVE%\TEMP\%SOFTWARE_NAME%.%TYPE%" (
        ECHO Installer found in TEMP folder, proceeding.  
        SET "INSTALL_LOCATION=%HOMEDRIVE%\TEMP\%SOFTWARE_NAME%.%TYPE%"
        GOTO :REQUEST_INSTALLATION
    ) ELSE (
        CALL :SETUP_ENVIRONMENT
        IF !ERRORLEVEL! EQU 0 (
            ECHO Network "!REPO_NAME!" found.
            IF EXIST "\\!REPO_PATH!\%SOFTWARE_NAME%\%SOFTWARE_NAME%.%TYPE%" (
                ECHO Installer available on network !REPO_NAME!, proceeding.
                SET "INSTALL_LOCATION=\\!REPO_PATH!\%SOFTWARE_NAME%\%SOFTWARE_NAME%.%TYPE%"
                GOTO :REQUEST_INSTALLATION
            ) ELSE (
                ECHO Warning, Installer unavailable on network !REPO_NAME!
                IF "%OPTION%" == "T" (
                    GOTO :REQUEST_DOWNLOAD
                ) ELSE IF "%OPTION%" == "L" (
                    ECHO Error, this software is not available online, exiting.  
                    PAUSE
                    GOTO :RESTART
                ) ELSE (
                    ECHO Error, option unknow..
                    PAUSE
                    GOTO :RESTART
                )
            )
        ) ELSE (
            ECHO No server found.
            IF "%OPTION%" == "T" (
                GOTO :REQUEST_DOWNLOAD
            ) ELSE IF "%OPTION%" == "L" (
                ECHO Error, this software is not available online, exiting.  
                GOTO :RESTART
            ) ELSE (
                ECHO Error, option unknow..
                PAUSE
                GOTO :RESTART
            )
        )
    )
) ELSE (
    CALL :CHECK_WINDOWS
    IF "!VERSION!" == "10.0" (
        ECHO Software available on Microsoft Store.
        START /W %DOWNLOAD_URL%
        CALL :GENERATE_LOG
        PAUSE
    ) ELSE (
        ECHO Microsoft Store is not available on Windows 7 and 8.1
        PAUSE
    )
    GOTO :RESTART
)
:REQUEST_DOWNLOAD
    IF EXIST "\\10.1.1.50\ftp\suporte\SCRIPT\SERRATECH\UTIL\DOWNLOAD.bat" (
        IF NOT EXIST "%HOMEDRIVE%\TEMP" (
            MKDIR "%HOMEDRIVE%\TEMP"
        )
        ECHO Downloading, please wait...  
        CALL \\10.1.1.50\ftp\suporte\SCRIPT\SERRATECH\UTIL\DOWNLOAD.bat "%DOWNLOAD_URL%" "%HOMEDRIVE%\TEMP\%SOFTWARE_NAME%.%TYPE%"
        IF !ERRORLEVEL! EQU 0 (
            ECHO Download completed, installing software, please wait...  
            SET "INSTALL_LOCATION=%HOMEDRIVE%\TEMP\%SOFTWARE_NAME%.%TYPE%"
            GOTO :REQUEST_INSTALLATION
        ) ELSE (
            ECHO Error! Could not complete the transfer, exiting.  
            PAUSE
            EXIT /B 1
        )
    ) ELSE (
        ECHO Error! Download script unavailable.
        PAUSE
        EXIT /B 1
    )
:REQUEST_INSTALLATION
    IF EXIST "\\10.1.1.50\ftp\suporte\SCRIPT\SERRATECH\UTIL\INSTALADOR.bat" (
        CALL \\10.1.1.50\ftp\suporte\SCRIPT\SERRATECH\UTIL\INSTALADOR.bat "%INSTALL_LOCATION%" "%TYPE%" "%PARAMETERS%"
        IF !ERRORLEVEL! EQU 0 (
            ECHO Installation completed.  
            IF EXIST "%HOMEDRIVE%\TEMP\%SOFTWARE_NAME%.%TYPE%" (
                DEL /Q "%HOMEDRIVE%\TEMP\%SOFTWARE_NAME%.%TYPE%"
                IF !ERRORLEVEL! EQU 0 (
                    ECHO Installer successfully removed.
                ) ELSE (
                    ECHO Error! Could not remove the installer.
                    PAUSE
                )
            )
            CALL :GENERATE_LOG
            IF !ERRORLEVEL! EQU 0 (
                ECHO LOG successfully generated.
            ) ELSE (
                ECHO ERROR! LOG could not be generated.
                PAUSE
            )
            GOTO :RESTART
        ) ELSE (
            ECHO Error! Could not install the software, exiting.  
            PAUSE
            EXIT /B 1
        )
    ) ELSE (
        ECHO Error! Installation script unavailable.  
        PAUSE
        EXIT /B 1
    )
:SETUP_ENVIRONMENT
    IF EXIST "\\10.1.1.50\ftp\suporte\SCRIPT\SERRATECH\UTIL\REPOS.TXT" (
        FOR /F "TOKENS=1-3 DELIMS=;" %%A IN (\\10.1.1.50\ftp\suporte\SCRIPT\SERRATECH\UTIL\REPOS.TXT) DO (
            PING %%B >NUL 2>&1
            IF !ERRORLEVEL! EQU 0 (
                SET "REPO_NAME=%%A"
                SET "REPO_HOSTNAME=%%B"
                SET "REPO_PATH=%%C"
                EXIT /B 0
            )
        )
        EXIT /B 1
    ) ELSE (
        ECHO Error! Repositories file unavailable, exiting.  
        PAUSE
        EXIT /B 1
    )
:CHECK_WINDOWS
    FOR /F "TOKENS=4-5 DELIMS=. " %%I IN ('VER') DO SET "VERSION=%%I.%%J"
    EXIT /B 0
:GENERATE_LOG
    IF NOT EXIST "\\10.1.1.50\ftp\suporte\SCRIPT\SERRATECH\LOGS" (
        ECHO Creating LOGS folder on network "%REPO_NAME%".  
        MKDIR "\\10.1.1.50\ftp\suporte\SCRIPT\SERRATECH\LOGS"
        IF !ERRORLEVEL! NEQ 0 (
            ECHO Error! Could not create LOGS folder.  
            EXIT /B 1
        ) ELSE ECHO Folder successfully created.  
    ) ELSE ECHO LOGS folder already exists.
    ECHO Generating logs file.
    FOR /F "TOKENS=2 DELIMS==" %%I IN ('WMIC OS GET LOCALDATETIME /VALUE') DO SET "DATETIME=%%I"
    SET "LOGFILE=\\10.1.1.50\ftp\suporte\SCRIPT\SERRATECH\LOGS\install_%DATETIME:~0,14%.log"
    ECHO ============================= > "%LOGFILE%"
    ECHO Software: %SOFTWARE_NAME% >> "%LOGFILE%"
    ECHO Date: %DATE% >> "%LOGFILE%"
    ECHO Time: %TIME% >> "%LOGFILE%"
    ECHO User: %USERNAME% >> "%LOGFILE%"
    ECHO Computer name: %COMPUTERNAME% >> "%LOGFILE%"
    EXIT /B 0
:RESTART
    CHOICE /C SN /M ">> Do you want to install any more software? "
    IF ERRORLEVEL 2 (
        EXIT /B 0
    ) ELSE IF ERRORLEVEL 1 (
        CALL "\\10.1.1.50\ftp\suporte\SCRIPT\SERRATECH\Util\Menu.bat"
    )
ENDLOCAL
