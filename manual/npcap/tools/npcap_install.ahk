#NoTrayIcon
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode "Input"  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir A_ScriptDir  ; Ensures a consistent starting directory.
SetTitleMatchMode 1
SetControlDelay -1

winTitle := "Npcap"

try {
    WinWait(winTitle, "License Agreement", 90)

    WinActivate
    ; Click the "I Agree" button
    ControlClick("I &Agree", winTitle)

    WinWait(winTitle, "Installation Options", 90)

    WinActivate
    ; Click the "Install" button
    ControlClick("&Install", winTitle)

    WinWait(winTitle, "Installation Complete", 90)

    WinActivate
    ; Click the "Next" button
    ControlClick("&Next >", winTitle)

    WinWait(winTitle, "Finished", 90)

    WinActivate
    ; Click the "Finish" button
    ControlClick("Finish", winTitle)
}