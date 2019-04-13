#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
#NoTrayIcon
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
SetTitleMatchMode, 1
SetControlDelay -1

winTitle = Windows Security

; Welcome window
WinWait, %winTitle%, You should only install driver software from publishers you trust,, 120
if (Errorlevel) 
{
    Exit 1
}
WinActivate
SendInput !a !i
;ControlClick, &Install, %winTitle%
