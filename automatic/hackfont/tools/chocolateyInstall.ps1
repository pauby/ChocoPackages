$ErrorActionPreference = 'Stop'

# create temp directory
do {
    $tempPath = Join-Path -Path $env:TEMP -ChildPath ([System.Guid]::NewGuid().ToString())
} while (Test-Path $tempPath)
New-Item -ItemType Directory -Path $tempPath | Out-Null

$packageArgs = @{
    packageName    = $env:ChocolateyPackageName
    unzipLocation  = $tempPath
    specificFolder = 'ttf'
    url            = 'https://github.com//source-foundry/Hack/releases/download/v3.003/Hack-v3.003-ttf.zip'
    checksum       = '0c2604631b1f055041c68a0e09ae4801acab6c5072ba2db6a822f53c3f8290ac'
    checksumType   = 'sha256'
}
Install-ChocolateyZipPackage @packageArgs

$Installed = Add-Font $tempPath -Multiple

If ($Installed -eq 0) {
   Throw 'All font installation attempts failed!'
} elseif ($Installed -lt $FontFiles.count) {
   Write-Host "$Installed fonts were installed." -ForegroundColor Cyan
   Write-Warning "$($FontFiles.count - $Installed) submitted font paths failed to install."
} else {
   Write-Host "$Installed fonts were installed."
}

# Remove our temporary files
Remove-Item $tempPath -Recurse -ErrorAction SilentlyContinue

Write-Warning 'If the fonts are not available in your applications or receive any errors installing or upgrading, please reboot to release the font files.'
