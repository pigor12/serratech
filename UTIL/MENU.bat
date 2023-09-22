@ECHO OFF
SETLOCAL ENABLEDELAYEDEXPANSION
REM Author:  Pedro Igor Martins dos Reis
REM E-mail: pigor@fiemg.com.br
REM Date:   11/06/2023
SET "SCRIPT_PATH=%~DP0"
IF EXIST "%SCRIPT_PATH%REDIRECIONAMENTO.bat" (
    CALL :CHECK_SOFTWARE
    IF %ERRORLEVEL% EQU 0 (
        GOTO :MAIN_MENU
    ) ELSE EXIT /B 1
) ELSE (
    ECHO XX Error,  Basic resources unavailable, please check.
    PAUSE
    EXIT /B 1
)
:MAIN_MENU
    CLS
    ECHO.
    ECHO      %COUNTER% software available
    ECHO.
    FOR /L %%I IN (1,1,%COUNTER%) DO (
        ECHO        %%I     !NAME_%%I!
    )
    ECHO.
    ECHO ^>^> Type all your selections separated by spaces or just F to exit. Example: 1 2 3
    ECHO.
    SET /P "CHOICES=>> Enter your choices: "
    SET "SELECTION_LIST="
    FOR /L %%N IN (1,1,%COUNTER%) DO SET "SELECTED_%%N=NO"
    FOR %%A IN (%CHOICES%) DO (
        IF /I "%%A"=="F" (
            ECHO You decided to exit. Goodbye!
            PAUSE
            EXIT /B 0
        ) ELSE IF DEFINED SOFTWARE_%%A (
            IF "!SELECTED_%%A!"=="YES" (
                ECHO Warning, you've already selected software %%A.
                PAUSE
                GOTO :MAIN_MENU
            ) ELSE (
                SET "SELECTION_LIST=!SELECTION_LIST! %%A"
                SET "SELECTED_%%A=YES"
            )
        ) ELSE (
            ECHO Error, %%A is an unavailable option. 
            PAUSE
            GOTO :MAIN_MENU
        )
    )
    IF NOT DEFINED SELECTION_LIST (
        ECHO No valid selections made.
        PAUSE
        GOTO :MAIN_MENU
    )
    GOTO :INSTALL_SELECTIONS
:INSTALL_SELECTIONS
    FOR %%A IN (%SELECTION_LIST%) DO (
        CALL %SCRIPT_PATH%REDIRECIONAMENTO.bat "!SOFTWARE_%%A!" "!URL_%%A!" "!TYPE_%%A!" "!PARAMETERS_%%A!" "!OP_%%A!"
    )
    EXIT /B 0
:CHECK_SOFTWARE
    IF EXIST "%SCRIPT_PATH%BD.TXT" (
        SET "COUNTER=1"
        FOR /F "TOKENS=1-6 DELIMS=;" %%A IN (%SCRIPT_PATH%BD.txt) DO (
            SET "NAME_!COUNTER!=%%A"
            SET "SOFTWARE_!COUNTER!=%%B"
            SET "URL_!COUNTER!=%%C"
            SET "TYPE_!COUNTER!=%%D"
            SET "PARAMETERS_!COUNTER!=%%E"
            SET "OP_!COUNTER!=%%F"
            SET /A "COUNTER+=1"
        )
        SET /A "COUNTER-=1"
    ) ELSE (
        ECHO XX Error, Database unavailable, exiting. 
        PAUSE
        EXIT /B 1
    )
ENDLOCAL
