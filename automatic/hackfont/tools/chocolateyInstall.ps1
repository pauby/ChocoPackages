# The code structure for this from the Inconsolata's source: https://chocolatey.org/packages/Inconsolata
# updated thanks to suggestions from Ramiro Morales (https://github.com/ramiro)

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

# Obtain system font folder for extraction
$shell = New-Object -ComObject Shell.Application
$fontsFolder = $shell.Namespace(0x14)

# Loop the extracted files and install them
Get-ChildItem -Path $tempPath -Recurse -Filter '*.ttf' | ForEach-Object { 
    Write-Verbose "Registering font '$($_.Name)'."
    $fontsFolder.CopyHere($_.FullName)  # copying to fonts folder ignores a second param on CopyHere
}

# Remove our temporary files
Remove-Item $tempPath -Recurse -ErrorAction SilentlyContinue

Write-Warning 'If the fonts are not available in your applications or receive any errors installing or upgrading, please reboot to release the font files.'