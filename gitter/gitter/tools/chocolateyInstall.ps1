$packageName = 'gitter'
$installerType = 'exe'
$url = 'https://update.gitter.im/win/GitterSetup-3.1.0.exe'
$silentArgs = "/VERYSILENT /SUPPRESSMSGBOXES /NORESTART /SP- /DIR=$env:chocolateyPackageFolder"
$validExitCodes = @(0)

Install-ChocolateyPackage "$packageName" "$installerType" "$silentArgs" "$url" -validExitCodes $validExitCodes

# Start Menu shortcuts are created under the admin account - move them to All Users start menu
Move-Item -Path (Join-Path -Path $env:USERPROFILE -ChildPath "AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Gitter") `
	-Destination (Join-Path -Path $env:ALLUSERSPROFILE -ChildPath "Microsoft\Windows\Start Menu\Programs")
