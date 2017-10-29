#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
#NoTrayIcon
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
SetTitleMatchMode, 1
SetControlDelay -1

winTitle = Iris Application Uninstall

WinWait, %winTitle%,, 90
if (Errorlevel) 
{
    Exit 1
}

WinActivate
; Click the OK button
ControlClick, OK, %winTitle%