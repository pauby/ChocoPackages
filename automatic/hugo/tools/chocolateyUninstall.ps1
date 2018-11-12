$ErrorActionPreference = 'Stop';

$hugoExe = Get-ChildItem $(Split-Path -Parent $MyInvocation.MyCommand.Definition) | Where-Object -Property Name -Match "hugo.exe"

if (-Not($hugoExe)) 
{
    Write-Error -Message "hugo exe is not found, please contact the maintainer of the package" -Category ResourceUnavailable
}

Write-Host "found hugo exe in $($hugoExe.FullName)"
Write-Host "attempting to remove it" 
Remove-Item $hugoExe.FullName