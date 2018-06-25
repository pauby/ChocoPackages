$ErrorActionPreference = 'Stop'

$packageArgs = @{
    packageName    = $env:ChocolateyPackageName
    fileType       = 'EXE'
    url            = 'https://www.ntwind.com/download/AltTabTer_3.3-setup.exe'
    checksum       = '48E4A8E4B945742251142722BA017CA158C18A8558575716F9185FE23FD38EF4'
    checksumType   = 'sha256'

    silentArgs     = "/S"
    validExitCodes = @(0)
}

Install-ChocolateyPackage @packageArgs