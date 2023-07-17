#NoTrayIcon
SendMode "Event"  ; Recommended for new scripts due to its superior speed and reliability.
SetTitleMatchMode 1
SetControlDelay -1
CoordMode "Mouse", "Window"
#WinActivateForce

; NOTE
; The IPVanish installer isn't a proper 'Window' from the point of view of AHK.
; We therefore can't just detect buttons or text in the window as there is nothing there
; so we are relying on colours.
; One other thing to note is that while the window is activated or detected, we sometimes 
; have to wait before 'clicking' a button.

winTitle := "ahk_exe IPVanish.exe"
sleepWait := 250
totalWait := 300000

if not WinWait(winTitle, , 90)
{
    ExitApp
}

; We are checking for the green recycle bin that means we are on uninstall window
wait := 0
WinActivate winTitle
While PixelGetColor(400, 280) != "0x46D153" and wait < totalWait
{
    Sleep sleepWait
    wait += sleepWait
    WinActivate winTitle
}

WinActivate winTitle
Sleep 250
Click 650, 450

; Just loop here until the page with the computer screen appears. That's the final 'its uninstalled' page.
; the colour we are detecting is the dark gray half (top right half)
wait := 0
WinActivate winTitle
; This is here as that last window needs the mouse clicked on it _somewhere_ before
; it picks up the pixel colour and works
Click 10, 10
While PixelGetColor(430, 225, "Slow") != "0x4A4A4A" and wait < totalWait
{
    Sleep sleepWait
    wait += sleepWait
    WinActivate winTitle
}

WinActivate winTitle
; put in a delay here - while the window is active, clicking the button is hit and miss. The delay seems to fix that.
Sleep 250
Click 400, 450