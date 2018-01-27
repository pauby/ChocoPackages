#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
#NoTrayIcon
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
SetTitleMatchMode, 1
SetControlDelay -1
CoordMode, Mouse, Window

winTitle = LogiOptions Installer

WinWait, %winTitle%,, 90
if (Errorlevel) 
{
    ExitApp
}

; Wait until button appears
found = 0
Welcome:
Loop, 30 
{
    WinActivate, %winTitle%
    PixelGetColor, colour, 525, 425, RGB
    if (colour = "0x222425" || colour = "0x444646") {
        found = 1
        break, Welcome
    }
    Sleep, 1000
}

if (found = 1)
{
    WinActivate, %winTitle%
    Click 525 425
}
else
{
    ExitApp
}

found = 0
NoShareData:
Loop, 30 
{
    WinActivate, %winTitle%
    PixelGetColor, colour, 625, 420, RGB
    if (colour = "0x222425" || colour = "0x444646") {
        found = 1
        break, NoShareData
    }
    Sleep, 1000
}

if (found = 1)
{
    WinActivate %winTitle%
    Click 700 425
}
else
{
    ExitApp
}

found = 0
CloseInstaller:
Loop, 300 
{
    WinActivate, %winTitle%
    PixelGetColor, colour, 510, 405, RGB
    if (colour = "0x222425" || colour = "0x444646") {
        found = 1
        break, CloseInstaller
         
    }
    Sleep, 1000
}

if (found = 1)
{
    WinClose %winTitle%
}
else
{
    ExitApp
}