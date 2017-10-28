#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
#NoTrayIcon
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
SetTitleMatchMode, 1
SetControlDelay -1

winTitle = Star Wars

; Welcome window
WinWait, %winTitle%,, 90
if (Errorlevel) 
{
    Exit 1
}

WinActivate
; Click the OK button
ControlClick, &Next >, %winTitle%

; Uninstall window
WinWait, %winTitle%, Uninstall Star Wars,, 90
if (Errorlevel) 
{
    Exit 1
}
WinActivate
ControlClick, &Uninstall, %winTitle%

; Delete extra files window
WinWait, %winTitle%, uninstaller found extra files/folders in the install folder,, 20
if (!Errorlevel) 
{
    WinActivate
    ControlClick, &No, %winTitle%
}

; Uninstall complete
WinWait, %winTitle%, Uninstallation Complete,, 90
if (Errorlevel) 
{
    Exit 1
}
WinActivate
ControlClick, &Next >, %winTitle%

; Finish
WinWait, %winTitle%, Completing the Star Wars,, 90
if (Errorlevel) 
{
    Exit 1
}
WinActivate
ControlClick, &Finish, %winTitle%