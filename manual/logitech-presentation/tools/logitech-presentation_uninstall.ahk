#NoTrayIcon
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode "Input"  ; Recommended for new scripts due to its superior speed and reliability.
SetTitleMatchMode 1
SetControlDelay -1
CoordMode "Mouse", "Window"

winTitle := "Logitech Presentation Uninstaller"

if not WinWait(winTitle, "Logitech Presentation will be removed from your system", 90)
{
    ExitApp
}

WinActivate winTitle
ControlClick "&Uninstall", winTitle

if not WinWait(winTitle, "Uninstall complete", 300)
{
    ExitApp
}

WinActivate winTitle
ControlClick "&Close", winTitle