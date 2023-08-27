@ECHO OFF
REM Autor:  Pedro Igor Martins dos Reis
REM E-mail: pigor@fiemg.com.br
REM Data:   11/06/2023
CHCP 65001 >NUL
IF NOT EXIST "%USERPROFILE%\ServiceDesk" (
    MKDIR "%USERPROFILE%\ServiceDesk"
    IF %ERRORLEVEL% EQU 0 (
        ATTRIB +H "%USERPROFILE%\ServiceDesk"
        MKDIR "%USERPROFILE%\ServiceDesk\Util"
        XCOPY /S /Y ".\UTIL\*" "%USERPROFILE%\ServiceDesk\Util\"
        COPY ".\SD.bat" "%USERPROFILE%\ServiceDesk\"
        COPY ".\ServiceDesk.lnk" "%USERPROFILE%\OneDrive\Área de Trabalho\"
        PAUSE
        EXIT /B 0
    ) ELSE (
        ECHO Erro ao criar a pasta ServiceDesk.
        PAUSE
        EXIT /B 1
    )
) ELSE (
    ECHO Pasta ServiceDesk já existe.
    PAUSE
    EXIT /B 0
)