@ECHO OFF
setlocal enableDelayedExpansion
mode con: cols=120 lines=8
color 2f
echo choco-install-packages-from-web v0.0.2 (02/19/2019)
echo.
rem echo   ** Installing %chocoprotocolURL% via %1
sudo %ChocolateyInstall%\bin\cinst.exe %1 -y
timeout 10
exit