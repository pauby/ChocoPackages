$ErrorActionPreference = 'Stop'

$packageArgs = @{
    packageName    = $env:ChocolateyPackageName
    fileType       = 'EXE' 
    url            = 'https://www.onenote.com/download/win32/x86/en-US'
    checksum       = '641c19e3b78e73f5b9229ad416b8284d15ea26b15ccc0fd374e0b24c3412cfbb'
    checksumType   = 'sha256'

    url64          = 'https://www.onenote.com/download/win32/x64/en-US'
    checksum64     = 'a75e2d54a20f042c7d7a78593596cf9ad5001f1f4e94a71a946ae157ecedb947'
    checksumType64 = 'sha256'  
    
    silentArgs     = ''
    validExitCodes = $(0)
}

Install-ChocolateyPackage @packageArgs 

Get-Process "OfficeC2RClient" -ErrorAction SilentlyContinue | Stop-Process
