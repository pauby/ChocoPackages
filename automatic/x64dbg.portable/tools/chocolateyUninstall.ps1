$ErrorActionPreference = 'Stop'

$toolsDir = Split-Path $MyInvocation.MyCommand.Definition

. $(Join-Path -Path $toolsDir -ChildPath "StopProcess.ps1")

Remove-Item $toolsDir -Recurse -Force -ErrorAction Ignore