#NoTrayIcon
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
SetTitleMatchMode, 1
SetControlDelay -1
CoordMode, Mouse, Window

winTitle = Installing Adobe Digital Editions

WinWait, %winTitle%, Get powerful Norton, 15
if !(Errorlevel) {
    ifWinExist, %winTitle%
    {
        WinActivate, %winTitle%
        Click, 255, 255
    }
}
