$ErrorActionPreference = 'Stop'

Write-Verbose 'Removing registry keys.'
@(
    'HKLM:\SOFTWARE\Classes\Onetastic.Addin',
    'HKLM:\SOFTWARE\Classes\Onetastic.Addin.1'
    'HKLM:\SOFTWARE\Classes\Onetastic.Macroinstaller',
    'HKLM:\SOFTWARE\Classes\Onetastic.Macroinstaller.1',
    'HKLM:\SOFTWARE\Microsoft\Office\OneNote\AddIns\Onetastic.Addin',
    'HKLM:\SOFTWARE\WOW6432Node\Microsoft\Office\OneNote\AddIns\Onetastic.Addin'
) | Remove-Item -Recurse -Force -ErrorAction SilentlyContinue

Write-Verbose "Removing installation folder from '$($env:ProgramFiles)' and '$(${env:ProgramFiles(x86)})'."
@(
    (Join-Path -Path $env:ProgramFiles -ChildPath 'Onetastic'),
    (Join-Path -Path ${env:ProgramFiles(x86)} -ChildPath 'Onetastic')
) | Remove-Item -Recurse -Force -ErrorAction SilentlyContinue