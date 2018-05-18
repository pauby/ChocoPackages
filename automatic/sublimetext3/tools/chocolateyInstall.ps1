$ErrorActionPreference = 'Stop'

$packageArgs = @{
    packageName    = $env:ChocolateyPackageName
    url            = 'https://download.sublimetext.com/Sublime%20Text%20Build%203176%20Setup.exe'
    checksum       = '7339ec15eda39c7b9328554a271cc4fc6029a3fbe9804c242be02b8c2d1854d1'
    checksumType   = 'SHA256'
    url64          = 'https://download.sublimetext.com/Sublime%20Text%20Build%203176%20x64%20Setup.exe'
    checksum64     = 'a6f2652584c98b39855252feb84a830b303fd7b09002c9956f71426543403257'
    checksumtype64 = 'SHA256'
    fileType       = 'EXE'
    silentArgs     = '/VERYSILENT /NORESTART /TASKS="contextentry"'
    validExitCodes = @(0)
}

Install-ChocolateyPackage @packageArgs
