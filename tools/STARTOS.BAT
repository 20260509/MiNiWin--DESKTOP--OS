@ECHO OFF
TITLE MiniWin Desktop OS
COLOR 0A

cd /d "%~dp0.."

ECHO ========================================
ECHO   MiniWin Desktop OS
ECHO   Starting QEMU...
ECHO ========================================
ECHO.

qemu-system-x86_64 -drive format=raw,file=bin\os.img

ECHO.
ECHO QEMU closed.
PAUSE