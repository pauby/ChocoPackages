#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
#NoTrayIcon
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
SetTitleMatchMode, 1
SetControlDelay -1
CoordMode, Mouse, Window

winTitle = Onetastic

WinWait, %winTitle%,, 90
if (Errorlevel) 
{
    ExitApp
}

; Wait until button appears
Welcome:
Loop, 60 
{
    WinActivate, %winTitle%
    ControlClick, &Close, %winTitle%
    if !WinExist(%winTitle%) {
        break, Welcome
    }
    Sleep, 1000
}