$ErrorActionPreference = 'Stop'

$toolsDir = "$(Split-Path -Parent $MyInvocation.MyCommand.Definition)"
$filePath = Get-Item -Path (Join-Path -Path $toolsDir -ChildPath 'emacs-*.exe')
$installPath = Join-Path -Path $env:ProgramFiles -ChildPath "emacs\emacs-$($env:ChocolateyPackageVersion)"

$packageArgs = @{
    packageName    = $env:ChocolateyPackageName
    fileType       = 'exe'
    silentArgs     = '/S'
    file64         = $filePath
}

Install-ChocolateyInstallPackage @packageArgs

# Shim executables
'runemacs', 'emacs' | Foreach-Object { Install-BinFile -Name $_ -Path (Join-Path -Path $installPath -ChildPath "bin\$($_).exe") -UseStart }