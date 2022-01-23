$ErrorActionPreference = 'Stop'

$installPath = Join-Path -Path $env:ProgramFiles -ChildPath "emacs"

$packageArgs = @{
    packageName = $env:ChocolateyPackageName
    fileType    = 'exe'
    silentArgs  = '/S'
    file        = Join-Path -Path $installPath -ChildPath "Uninstall.exe"
}

Uninstall-ChocolateyPackage @packageArgs

'runemacs', 'emacs' | ForEach-Object {
    Uninstall-BinFile -Name $_
}