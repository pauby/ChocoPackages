$ErrorActionPreference = 'Stop'

$moduleName = 'configuration'    # this could be different from package name
$toolsDir = Split-Path -parent $MyInvocation.MyCommand.Definition
$depModulesPath = Join-Path $toolsdir -ChildPath 'loaded.modules'

$modules = Get-Content -Path $depModulesPath
ForEach ($m in $modules) {
    Remove-Module -Name $m -Force -ErrorAction SilentlyContinue
}