$ErrorActionPreference = 'Stop'

$moduleName = 'Microsoft.WinGet.Client'    # this could be different from package name
$toolsDir = Split-Path -parent $MyInvocation.MyCommand.Definition

Remove-Module -Name $moduleName -Force -ErrorAction SilentlyContinue