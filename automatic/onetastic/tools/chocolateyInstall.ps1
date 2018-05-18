$ErrorActionPreference = 'Stop'

$toolsDir       = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$configFilename = 'config.xml'

$url64          = 'https://getonetastic.com/downloadFile&fv=0&file=OnetasticInstaller.x64.exe&agree=1'
$checksum64     = 'bfaf0e08ad23b19e0bfa80f67e4c054d382b9cf29e3f8fc0566030694ae1ca60'

$packageArgs = @{
    packageName    = $env:ChocolateyPackageName
    fileType       = 'EXE'
    url            = 'https://getonetastic.com/downloadFile&fv=0&file=OnetasticInstaller.x86.exe&agree=1'
    checksum       = '3CDF7F9A0402B53CAB7C0CB88108745530BFED0DF046D3FBFFF766C13532DF1C'
    checksumType   = 'SHA256'
    silentArgs     = "/config $(Join-Path -Path $toolsDir -ChildPath $configFilename)"
    validExitCodes = @(0)
}

$arguments = Get-PackageParameters
if ($arguments.ContainsKey("OneNotex64")) {
    Write-Verbose 'Installing the x64 version of Onetastic.'
    Write-Verbose 'You only need to do this IF you are running the x64 version of Microsoft OneNote. This has nothing to with the Operating System!' 
    $packageArgs.url = $url64
    $packageArgs.checksum = $checksum64
}

#$ahkExe = 'AutoHotKey'
#$ahkFile = Join-Path -Path $env:TEMP -ChildPath "$(Get-Random).ahk" 
#$ahkSourceFile = Join-Path -Path $toolsDir -ChildPath "$($env:ChocolateyPackageName)_install.ahk"
#Copy-Item -Path $ahkSourceFile -Destination $ahkFile

#Write-Verbose "Running AutoHotkey install script $ahkFile"
#$ahkProc = Start-Process -FilePath $ahkExe -ArgumentList $ahkFile -PassThru
#$ahkId = $ahkProc.Id
#Write-Debug "$ahkExe start time:`t$($ahkProc.StartTime.ToShortTimeString())"
#Write-Debug "Process ID:`t$ahkId"

Install-ChocolateyPackage @packageArgs

#Remove-Item -Path $ahkFile -Force -ErrorAction SilentlyContinue
