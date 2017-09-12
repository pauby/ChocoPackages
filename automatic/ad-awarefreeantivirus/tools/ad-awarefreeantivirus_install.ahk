#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
#NoTrayIcon
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
SetTitleMatchMode, 1
SetControlDelay -1
CoordMode, Mouse, Window

winTitle = Adaware Antivirus Updater

WinWait, %winTitle%,, 180
if !(Errorlevel) {
	Loop 5 
	{
		WinActivate, %winTitle%
		PixelGetColor, colour, 390, 270, RGB
		if (colour = "0xFCB34F")
		{
			break
		}
		Sleep 1000
	}
	
	ifWinExist, %winTitle%
	{
		Click 390 270
	}
	
	Loop, 300 {
		WinActivate, %winTitle%
		PixelGetColor, colour, 380, 220, RGB
		if (colour = "0x36BE34") {
			break
		}
		Sleep, 1000
	}

	ifWinExist %winTitle%
	{
		WinActivate %winTitle%
		Click 300 540
		Sleep 2000
	}
	else
	{
		ExitApp
	}

	ifWinExist, %WinTitle% 
	{
		WinActivate %winTitle%
		Click 330 390
	}
	else
	{
		ExitApp
	}
}