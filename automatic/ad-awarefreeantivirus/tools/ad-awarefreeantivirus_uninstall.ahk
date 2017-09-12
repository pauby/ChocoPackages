#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
#NoTrayIcon
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
SetTitleMatchMode, 1
SetControlDelay -1

winTitle = Adaware Antivirus Updater
WinWait, %winTitle%,, 60
if !(Errorlevel) 
{
	Loop, 5
	{	
		WinActivate, %winTitle%
		PixelGetColor, colour, 475, 540, RGB
		if (colour = "0xFCB34F")
		{
			break
		}
		Sleep 1000
	}

	ifWinExist, %winTitle%
	{
		WinActivate, %winTitle%
		Click 475 540
	}
	else
	{
		ExitApp
	}

	; Window 'Keep some level of protection'
	Loop, 5
	{
		WinActivate, %winTitle%
		PixelGetColor, colour, 570, 550, RGB	; this is the NEXT button
		if (colour = "0xFCB34F")
		{
			break
		}
		Sleep 1000
	}

	ifWinExist, %winTitle%
	{
		WinActivate, %winTitle%
		Click 570 550	; the NEXT button
	}
	else
	{
		ExitApp
	}

	; Window 'Uninstall Adaware Antivirus'
	Loop, 5
	{
		WinActivate, %winTitle%
		PixelGetColor, colour, 450, 390, RGB	; this is the NO button which is orange (and selected) by default
		if (colour = "0xFCB34F")
		{
			break
		}
		Sleep 1000
	}

	ifWinExist, %winTitle%
	{
		WinActivate, %winTitle%
		Click 330 390	; this is the YES button
	}
	else
	{
		ExitApp
	}

	; Window 'Uninstallation Complete'
	Loop, 300
	{
		WinActivate, %winTitle%
		PixelGetColor, colour, 385, 220, RGB	; this is the green tick to show uninstallation complete
		if (colour = "0x36BE34")
		{
			break
		}
		Sleep 1000
	}

	ifWinExist, %winTitle%
	{
		WinActivate, %winTitle%
		Click 300 540	; this is the CLOSE button (ie. not to reboot)
	}
	else
	{
		ExitApp
	}

	; Window 'Warning!'
	Loop, 5
	{
		WinActivate, %winTitle%
		PixelGetColor, colour, 460, 400, RGB	; this is the REBOOT NOW button which is orange and selected by default
		if (colour = "0xFCB34F")
		{
			break
		}
		Sleep 1000
	}

	ifWinExist, %winTitle%
	{
		WinActivate, %winTitle%
		Click 330 390	; this is the CLOSE button (ie. not to reboot)
	}
	else
	{
		ExitApp
	}
}