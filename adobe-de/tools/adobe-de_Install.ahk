#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
#NoTrayIcon
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
SetTitleMatchMode, 1
SetControlDelay -1

winTitle = Installing Adobe Digital Editions

WinWait, %winTitle%, Norton, 90
WinActivate
if !(Errorlevel) {
	ifWinExist, %winTitle%, Determine if your system is infected
		classNext = Static21
	else
		classNext = Static17
	
	Control, Uncheck,, Button1, %winTitle%
	ControlClick, %classNext%, %winTitle%
}