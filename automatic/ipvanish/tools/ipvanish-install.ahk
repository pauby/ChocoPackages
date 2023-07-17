#NoTrayIcon
SendMode "Input"  ; Recommended for new scripts due to its superior speed and reliability.
SetTitleMatchMode 1
SetControlDelay -1
CoordMode "Mouse", "Window"

; NOTE
; The IPVanish installer isn't a proper 'Window' from the point of view of AHK.
; We therefore can't just detect buttons or text in the window as there is nothing there
; so we are relying on colours.
; One other thing to note is that while the window is activated or detected, we sometimes 
; have to wait before 'clicking' a button.

winTitle := "ahk_exe ipvanish-setup.exe"
sleepWait := 250
totalWait := 300000

if not WinWait(winTitle, , 90)
{
    ExitApp
}

; We are checking for the grey bar that the installation path is shown in
wait := 0
While PixelGetColor(85, 265) != "0x2F2F30" and wait < totalWait
{
    Sleep sleepWait
    wait += sleepWait
    WinActivate winTitle
}

WinActivate winTitle
Sleep 250
Click 400, 450

; Just loop here until the page with the world appears. That's the final 'its installed' page.
wait := 0
While PixelGetColor(365, 215) != "0x6FBC44" and wait < totalWait
{
    Sleep sleepWait
    wait += sleepWait
    WinActivate winTitle    
}

WinActivate winTitle
; put in a delay here - while the window is active, clicking the button is hit and miss. The delay seems to fix that.
Sleep 250
Click 100, 450