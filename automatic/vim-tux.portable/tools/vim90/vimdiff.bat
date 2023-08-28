@echo off
rem -- Run Vim --
rem # uninstall key: vim90 #

setlocal
set VIM_EXE_DIR=C:\Program Files\Vim\vim90
if exist "%VIM%\vim90\vim.exe" set VIM_EXE_DIR=%VIM%\vim90
if exist "%VIMRUNTIME%\vim.exe" set VIM_EXE_DIR=%VIMRUNTIME%

if not exist "%VIM_EXE_DIR%\vim.exe" (
    echo "%VIM_EXE_DIR%\vim.exe" not found
    goto :eof
)

"%VIM_EXE_DIR%\vim.exe" -d %*
