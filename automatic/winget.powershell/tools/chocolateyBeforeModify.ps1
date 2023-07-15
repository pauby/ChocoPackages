$ErrorActionPreference = 'Stop'

$toolsDir = Split-Path -parent $MyInvocation.MyCommand.Definition

. $(Join-Path -Path $toolsDir -ChildPath "$($env:ChocolateyPackageName)-helpers.ps1")

Remove-Module -Name $moduleName -Force -ErrorAction SilentlyContinue