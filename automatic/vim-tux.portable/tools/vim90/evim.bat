@echo off
rem -- Run Vim --
rem # uninstall key: vim90 #

setlocal
set VIM_EXE_DIR=C:\Program Files\Vim\vim90
if exist "%VIM%\vim90\gvim.exe" set VIM_EXE_DIR=%VIM%\vim90
if exist "%VIMRUNTIME%\gvim.exe" set VIM_EXE_DIR=%VIMRUNTIME%

if not exist "%VIM_EXE_DIR%\gvim.exe" (
    echo "%VIM_EXE_DIR%\gvim.exe" not found
    goto :eof
)

rem check --nofork argument
set VIMNOFORK=
:loopstart
if .%1==. goto loopend
if .%1==.--nofork (
    set VIMNOFORK=1
) else if .%1==.-f (
    set VIMNOFORK=1
)
shift
goto loopstart
:loopend

if .%VIMNOFORK%==.1 (
    start "dummy" /b /wait "%VIM_EXE_DIR%\gvim.exe" -y %*
) else (
    start "dummy" /b "%VIM_EXE_DIR%\gvim.exe" -y %*
)
