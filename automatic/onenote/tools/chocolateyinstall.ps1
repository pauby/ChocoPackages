$ErrorActionPreference = 'Stop'

$packageArgs = @{
    packageName    = $env:ChocolateyPackageName
    fileType       = 'EXE' 
    url            = 'https://www.onenote.com/download/win32/x86/en-US'
    checksum       = '4bc9206dff19fe14cabeee866b9e18f43a22c2fe2ee7bf6ea12e8a147195bc81'
    checksumType   = 'sha256'

    url64          = 'https://www.onenote.com/download/win32/x64/en-US'
    checksum64     = '9049bd23137e0ce1e8f7f8defbfc7e430e4080a297b9f0f6e69be52e715b222c'
    checksumType64 = 'sha256'  
    
    silentArgs     = ''
    validExitCodes = $(0)
}

Install-ChocolateyPackage @packageArgs 

Get-Process "OfficeC2RClient" -ErrorAction SilentlyContinue | Stop-Process
