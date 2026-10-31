@echo off
title AetherStudio Elite - Desktop Launcher
echo ====================================================================
echo 🎨 Launching AetherStudio Elite on Windows (Cyberpunk Drawing Studio)
echo ====================================================================

set CURRENT_DIR=%~dp0
set HTML_PATH=%CURRENT_DIR%index.html

:: Try launching Microsoft Edge in standalone App Mode
if exist "%ProgramFiles(x86)%\Microsoft\Edge\Application\msedge.exe" (
    echo Launching with Microsoft Edge App Mode...
    start "" "%ProgramFiles(x86)%\Microsoft\Edge\Application\msedge.exe" --app="file:///%HTML_PATH:\=/%"
    goto end
)
if exist "%ProgramFiles%\Microsoft\Edge\Application\msedge.exe" (
    echo Launching with Microsoft Edge App Mode...
    start "" "%ProgramFiles%\Microsoft\Edge\Application\msedge.exe" --app="file:///%HTML_PATH:\=/%"
    goto end
)

:: Try Google Chrome in standalone App Mode
if exist "%ProgramFiles%\Google\Chrome\Application\chrome.exe" (
    echo Launching with Google Chrome App Mode...
    start "" "%ProgramFiles%\Google\Chrome\Application\chrome.exe" --app="file:///%HTML_PATH:\=/%"
    goto end
)
if exist "%ProgramFiles(x86)%\Google\Chrome\Application\chrome.exe" (
    echo Launching with Google Chrome App Mode...
    start "" "%ProgramFiles(x86)%\Google\Chrome\Application\chrome.exe" --app="file:///%HTML_PATH:\=/%"
    goto end
)

:: Fallback to default system browser
echo Launching with default browser...
start "" "%HTML_PATH%"

:end
echo Enjoy creating with AetherStudio Elite!
