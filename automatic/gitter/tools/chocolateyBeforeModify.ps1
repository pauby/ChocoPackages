$ErrorActionPreference = 'Stop'

$toolsDir = "$(Split-Path -Parent $MyInvocation.MyCommand.Definition)"
$installDir = Join-Path -Path $toolsDir -ChildPath 'data'

Write-Verbose "Stopping the 'gitter' process(es) if it is running."
Get-Process -Name 'gitter' -ErrorAction SilentlyContinue | Stop-Process

Start-Sleep -Milliseconds 500

# Older versions installed to the package folder - remove these as new version install elsewhere
if (Test-Path -Path (Join-Path -Path $env:ChocolateyPackageFolder -ChildPath 'gitter.exe')) {
    $ignoreFiles = 'tools', '*.nupkg','*.nuspec'
    $filesToRemove = Get-ChildItem -Path $env:ChocolateyPackageFolder
    ForEach ($f in $filesToRemove) {
        ForEach ($ignore in $ignoreFiles) {
            if ($f -notlike $ignore) {
                Remove-Item $f -Force -Recurse
            }
        }
    }
}
elseif (Test-Path -Path $installDir) {
    Remove-Item -Path $installDir -Force -Recurse
}