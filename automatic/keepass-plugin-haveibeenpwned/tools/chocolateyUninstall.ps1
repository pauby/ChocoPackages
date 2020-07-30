$ErrorActionPreference = 'Stop'

$toolsDir = Split-Path -Parent $MyInvocation.MyCommand.Definition
$installLog = Join-Path -Path $toolsDir -ChildPath ("{0}-install.log" -f $env:ChocolateyPackageName)

if (Test-Path -Path $installLog) {
    $installPath = Get-Content -Path $installLog -TotalCount 1
    $null = Remove-Item -Path $installPath -Force
}
else {
    throw "During install we created a log file '$installLog' with the path RuleBuilder was installed to. Cannot find this file so don't know where it was installed to and cannot continue."
}