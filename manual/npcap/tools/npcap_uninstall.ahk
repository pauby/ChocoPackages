#NoTrayIcon
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode "Input"  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir A_ScriptDir  ; Ensures a consistent starting directory.
SetTitleMatchMode 1
SetControlDelay -1

winTitle := "Npcap"

try {
    WinWait(winTitle, "Uninstall", 90)

    WinActivate
    ; Click the "Uninstall" button
    ControlClick("&Uninstall", winTitle)

    WinWait(winTitle, "Uninstallation Complete", 90)

    WinActivate
    ; Click the "Close" button
    ControlClick("&Close", winTitle)
}
