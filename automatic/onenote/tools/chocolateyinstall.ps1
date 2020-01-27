$ErrorActionPreference = 'Stop'

$packageArgs = @{
    packageName    = $env:ChocolateyPackageName
    fileType       = 'EXE' 
    url            = 'https://www.onenote.com/download/win32/x86/en-US'
    checksum       = 'd48b2d6bc0b7026f15477e5918926d1591fdd9f97f12db10986a751feb1513f2'
    checksumType   = 'sha256'

    url64          = 'https://www.onenote.com/download/win32/x64/en-US'
    checksum64     = 'b40f319ede4c5da0aaf5b288cbfce44b5a557fcadb9f21d4d6306cd1fa1890c2'
    checksumType64 = 'sha256'  
    
    silentArgs     = ''
    validExitCodes = $(0)
}

Install-ChocolateyPackage @packageArgs 

Get-Process "OfficeC2RClient" -ErrorAction SilentlyContinue | Stop-Process
