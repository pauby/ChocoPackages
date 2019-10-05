$ErrorActionPreference = 'Stop'

$moduleName = 'appveyorbyoc'    # this could be different from package name
$toolsDir = Split-Path -parent $MyInvocation.MyCommand.Definition
$loadedModulesPath = Join-Path $toolsdir -ChildPath 'loaded.modules'

$modules = Get-Content -Path $loadedModulesPath
ForEach ($m in $modules) {
    Remove-Module -Name $m -Force -ErrorAction SilentlyContinue
}