$ErrorActionPreference = 'Stop'

$softwareVersion = '29.4'
$exeFile = "emacs-$($softwareVersion)-installer_x64.exe"

$toolsDir = "$(Split-Path -Parent $MyInvocation.MyCommand.Definition)"
$filePath = Join-Path -Path $toolsDir -ChildPath $exeFile
$installPath = Join-Path -Path $env:ProgramFiles -ChildPath "emacs\emacs-$softwareVersion"

$packageArgs = @{
    packageName    = $env:ChocolateyPackageName
    fileType       = 'exe'
    silentArgs     = '/S'
    file64         = $filePath
}

Install-ChocolateyInstallPackage @packageArgs

# Shim executables
'runemacs', 'emacs' | Foreach-Object { Install-BinFile -Name $_ -Path (Join-Path -Path $installPath -ChildPath "bin\$($_).exe") -UseStart }
