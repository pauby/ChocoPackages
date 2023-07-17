# Packaging Notes

IPVanish is problematic software to auotmate using AutoHotkey. The software install and uninstall window is not a traditional Windows dialog. It doesn't have a normal title and had to be detected using it's `ahk_exe` value. The text in the window doesn't appear and can't be detected by AHK and none of the buttons are controls that can be addressed but have to be clicked using coordinates.

Furthermore we had to detect what page we were on by colours in the window.

Finally, we can't detect the colours on the very last window in the uninstall until it is clicked. So I had to add in a click in the top left hand corner.

The install seems to create registry entries for both an MSI and an EXE (see the chocolateyUninstall.ps1 script for more info on that). So we have to grab the EXE one as uninstalling the MSI doesn't remove it from Programs and Features.

It's all a bit of a mess, nothing is normal, I hate the AHK scripts but they do work. Why people write installers like this I have no idea. I'm sure it made sense to them.