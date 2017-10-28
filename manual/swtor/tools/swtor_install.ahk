#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
#NoTrayIcon
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
SetTitleMatchMode, 1
SetControlDelay -1

windowFound = 0
whichwindow:
Loop, 90 
{
    ifWinExist, STAR WARS, The Old Republic was found 
    {
        WinActivate
        ControlClick, &Yes, STAR WARS
        windowFound = 1  
        break whichwindow
    }

    ifWinExist, Installer Language
    {
        WinActivate
        ControlClick, OK, %winTitle%
        windowFound = 1  
        break whichwindow
    }

    Sleep 1000
}

if %windowFound% = 0 
{
    Exit 1
}

winTitle = STAR WARS

; Welcome window
WinWait, %winTitle%, Welcome to the Star Wars,, 90
if (Errorlevel) 
{
    Exit 1
}
WinActivate
ControlClick, &Next >, %winTitle%

; License agreement window
WinWait, %winTitle%, License Agreement,, 90
if (Errorlevel) 
{
    Exit 1
}
WinActivate
Control, Check,, I &accept the terms of the License, %winTitle%
ControlClick, &Next >, %winTitle%

; Istalling
WinWait, %winTitle%, Select Install Type,, 90
if (Errorlevel) 
{
    Exit 1
}
WinActivate
ControlClick, &Install, %winTitle% 

; Installation Complete
WinWait, %winTitle%, Installation Complete,, 90
if (Errorlevel) 
{
    Exit 1
}
WinActivate
ControlClick, &Next >, %winTitle%

; Play game
WinWait, %winTitle%, Completing the Star Wars,, 90
if (Errorlevel) 
{
    Exit 1
}
WinActivate
Control, Uncheck,, Play Star Wars, %winTitle%
ControlClick, &Finish, %winTitle%