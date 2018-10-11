$ErrorActionPreference = 'Stop'

# create temp directory
do {
    $tempPath = Join-Path -Path $env:TEMP -ChildPath ([System.Guid]::NewGuid().ToString())
} while (Test-Path $tempPath)
New-Item -ItemType Directory -Path $tempPath | Out-Null

$zipArgs = @{
    packageName    = $env:ChocolateyPackageName
    fileFullPath   = Join-Path -Path $tempPath -ChildPath 'jenkins.zip';
    destination    = $tempPath
    url            = 'http://mirrors.jenkins-ci.org/windows-stable/jenkins-2.138.2.zip'
    checksum       = ''
    checksumType   = ''
}

Get-ChocolateyWebFile @zipArgs
Get-ChocolateyUnzip @zipArgs

$packageArgs = @{
    packageName   = $env:ChocolateyPackageName
    fileType      = 'msi'
    file = Join-Path -Path $tempPath -ChildPath 'jenkins.msi'
    silentArgs    = "/qn /norestart /l*v `"$($env:TEMP)\$($packageName).$($env:chocolateyPackageVersion).MsiInstall.log`"" # ALLUSERS=1 DISABLEDESKTOPSHORTCUT=1 ADDDESKTOPICON=0 ADDSTARTMENU=0
    validExitCodes= @(0, 3010, 1641)
}

Install-ChocolateyInstallPackage @packageArgs
