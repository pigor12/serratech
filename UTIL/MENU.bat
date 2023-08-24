@ECHO OFF
CHCP 65001 >NUL
SETLOCAL
IF EXIST ".\UTIL\REDIRECIONAMENTO.bat" (
    CALL :VER_WINDOWS
    GOTO :MENU_PRINCIPAL
) ELSE (
    ECHO ► Recursos básicos indisponíveis, gentileza verificar.
    PAUSE
    EXIT /B 1
)
:VER_WINDOWS
    FOR /F "TOKENS=4-5 DELIMS=. " %%I IN ('VER') DO SET "VERSAO=%%I.%%J"
:MENU_PRINCIPAL
    CLS
    ECHO.
    ECHO ┌───────────────────────────┐
    ECHO │   Softwares disponíveis   │
    ECHO └───────────────────────────┘
    ECHO   0  Sair                     
    ECHO   1  Zoom
    ECHO   2  7-Zip
    ECHO   3  Teams
    ECHO   4  Earth
    ECHO   5  Chrome
    ECHO   6  Firefox
    ECHO   7  PowerBI ♦
    ECHO   8  Acrobat
    ECHO   9  Onedrive
    ECHO  10  Karpersky
    ECHO  11  Whatsapp Desktop ♦
    ECHO  12  Citrix
    ECHO  13  PDFSam
    ECHO.
    ECHO   ♦ Necessário acesso à Microsoft Store.
    ECHO.
    SET /P "ESCOLHA=Escolha uma das opções acima e pressione ENTER: "
    IF %ESCOLHA% EQU 1 (
        CALL .\UTIL\REDIRECIONAMENTO.bat "ZOOM" "https://zoom.us/client/latest/ZoomInstallerFull.msi?archType=x64" "MSI"
    ) ELSE IF %ESCOLHA% EQU 2 (
        CALL .\UTIL\REDIRECIONAMENTO.bat "7ZIP" "https://www.7-zip.org/a/7z2301-x64.exe" "EXE" "/S"
    ) ELSE IF %ESCOLHA% EQU 3 (
        CALL .\UTIL\REDIRECIONAMENTO.bat "TEAMS" "https://teams.microsoft.com/downloads/desktopurl?env=production&plat=windows&arch=x64&managedInstaller=true&download=true" "MSI"
    ) ELSE IF %ESCOLHA% EQU 4 (
        CALL .\UTIL\REDIRECIONAMENTO.bat "EARTH" "https://dl.google.com/dl/earth/client/advanced/current/googleearthprowin-7.3.6-x64.exe" "EXE" "OMAHA=1"
    ) ELSE IF %ESCOLHA% EQU 5 (
        CALL .\UTIL\REDIRECIONAMENTO.bat "CHROME" "https://dl.google.com/dl/chrome/install/googlechromestandaloneenterprise64.msi" "MSI"
    ) ELSE IF %ESCOLHA% EQU 6 (
        CALL .\UTIL\REDIRECIONAMENTO.bat "FIREFOX" "https://download.mozilla.org/?product=firefox-esr-latest&os=win64&lang=pt-BR" "EXE" "/S"
    ) ELSE IF %ESCOLHA% EQU 7 (
        IF "%VERSAO%" == "10.0" (
            START /W ms-windows-store://pdp/?ProductId=9NTXR16HNW1T
        ) ELSE (
            ECHO.
            ECHO ► Erro! Microsoft PowerBI não é mais suportado pelo Windows 7 e 8.1.
            ECHO.
        )
    ) ELSE IF %ESCOLHA% EQU 8 (
        CALL .\UTIL\REDIRECIONAMENTO.bat "ACROBAT" "https://ardownload2.adobe.com/pub/adobe/reader/win/AcrobatDC/2300320269/AcroRdrDC2300320269_pt_BR.exe" "EXE" "/sAll"    ) ELSE IF %ESCOLHA% EQU 9 (
        IF "%VERSAO%" == "10.0" (
            START /W ONEDRIVE
        ) ELSE (
            ECHO.
            ECHO ► Erro! Microsoft Onedrive não é mais suportado pelo Windows 7 e 8.1.
            ECHO.
        )
    ) ELSE IF %ESCOLHA% EQU 10 (
        "\\10.1.1.92\GPOS\ANTIVIRUS\Kaspersky CIT - Desktops e Notebooks - Agente v14.0 e Endpoint v12.00.exe" /s
    ) ELSE IF %ESCOLHA% EQU 11 (
        START /W ms-windows-store://pdp/?productid=9NKSQGP7F2NH
    ) ELSE IF %ESCOLHA% EQU 12 (
        CALL .\UTIL\REDIRECIONAMENTO.bat "CITRIX" "https://downloadplugins.citrix.com/ReceiverUpdates/Prod/Receiver/Win/CitrixWorkspaceApp23.5.1.83.exe" "EXE" "/silent"
    ) ELSE IF %ESCOLHA% EQU 13 (
        CALL .\UTIL\REDIRECIONAMENTO.bat "PDFSAM" "https://github.com/torakiki/pdfsam/releases/download/v5.1.3/pdfsam-5.1.3.msi" "MSI"
    ) ELSE EXIT /B 0
    PAUSE
ENDLOCAL