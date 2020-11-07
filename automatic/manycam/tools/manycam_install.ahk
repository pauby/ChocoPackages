#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
#NoTrayIcon
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
SetTitleMatchMode, 1
SetControlDelay -1
CoordMode, Mouse, Window

winTitle = Windows Security
winText = You should only install driver software from publishers you trust

WinWait, %winTitle%, %winText%, 300
if (Errorlevel)
{
    ExitApp
}

WinActivate %winTitle%, %winText%
ControlClick, X29 Y161, %winTitle%, %winText%
ControlClick, &Install, %winTitle%, %winText%

ExitApp