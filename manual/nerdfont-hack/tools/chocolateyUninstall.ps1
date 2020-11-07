$ErrorActionPreference = 'Stop'

# different fonts path in the registry depending on os architecture
$regPath = @( 'HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows NT\CurrentVersion\Fonts', 
    'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Fonts'
)

# remove the fonts data from the registry path
ForEach ($path in $regPath) {
    (Get-Item -Path $path).property | Where-Object { $_ -like 'hack nerd font*' } | ForEach-Object {
        Remove-ItemProperty -Name $_ -Path $path -ErrorAction SilentlyContinue
    }
}

Get-ChildItem -Path "$([Environment]::GetFolderPath('Fonts'))" -Filter 'Hack-*.ttf' | Remove-Item -Force

Write-Warning 'If you receive any errors uninstalling, please reboot'









$ErrorActionPreference = 'Stop'

# Find which fonts were installed
$toolsDir = Split-Path -parent $MyInvocation.MyCommand.Definition
$fontZipFilename = "{0}.zip" -f $env:ChocolateyPackageName
$unzipLogPath = Join-Path -Path $toolsDir -ChildPath $fontZipFilename

if (Test-Path -Path $unzipLogPath) {
    $fontFilename  = Get-Content -Path $unzipLogPath | `
        Where-Object { $_ -match '\.ttf$' } | `
        ForEach-Object { $_.split('\')[-1] }

    $fontRemoved = Uninstall-ChocolateyFont -FontFiles $fontFilename -Multiple

    if ($fontRemoved -ne $fontFilename.Count) {
        throw ("{0} out of {1} fonts were not removed." -f $fontFilename.count - $fontRemoved, $fontFilename.count)
    }
}
else {
    throw "Cannot find the font unzip log '$unzipLogPath'. Cannot continue as I don't know which fonts to uninstall!"
}