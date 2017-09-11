$ErrorActionPreference = 'Stop'; # stop on all errors

Remove-Item -Path (Join-Path -Path $env:ALLUSERSPROFILE -ChildPath "Microsoft\Windows\Start Menu\Programs\AC Reloaded.lnk")