$ErrorActionPreference = 'Stop';

$toolsDir = $(Split-Path -parent $MyInvocation.MyCommand.Definition)
$ahkFile = 'adobe-de_Uninstall.ahk'
$ahkPath = $(Join-Path -Path $toolsDir -ChildPath $ahkFile)

$packageName = 'adobe-de'
$softwareName = 'adobe-de*'
$installerType = 'EXE' 

$silentArgs = '/s'
$validExitCodes = @(0)

$uninstalled = $false
[array]$key = Get-UninstallRegistryKey -SoftwareName $softwareName

$ahkRun = "$Env:Temp\$(Get-Random).ahk"
write-warning "ahk file at start: $ahkrun"
Copy-Item $ahkPath "$ahkRun" -Force
$ahkProc = Start-Process -FilePath 'AutoHotKey' `
   -ArgumentList $ahkRun `
   -PassThru

if ($key.Count -eq 1) {
  $key | % { 
    $file = "$($_.UninstallString)"
	
    Uninstall-ChocolateyPackage -PackageName $packageName `
                                -FileType $installerType `
                                -SilentArgs "$silentArgs" `
                                -ValidExitCodes $validExitCodes `
                                -File "$file"
  }
} elseif ($key.Count -eq 0) {
  Write-Warning "$packageName has already been uninstalled by other means."
} elseif ($key.Count -gt 1) {
  Write-Warning "$key.Count matches found!"
  Write-Warning "To prevent accidental data loss, no programs will be uninstalled."
  Write-Warning "Please alert package maintainer the following keys were matched:"
  $key | % {Write-Warning "- $_.DisplayName"}
}

Remove-Item "$ahkRun" -Force