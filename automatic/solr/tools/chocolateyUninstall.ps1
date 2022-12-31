$ErrorActionPreference = 'Stop'

$toolsDir = Split-Path $MyInvocation.MyCommand.Definition
$savedParamsPath = Join-Path -Path $toolsDir -ChildPath 'parameters.saved'

# This is new functionality added for v9.0.0 onwards. Version < 9.0.0 did not remove the software
if (Test-Path -Path $savedParamsPath) {
    $removePath = Get-Content -Path $savedParamsPath

    ForEach ($path in $removePath) {
        Write-Verbose "Removing Solr from '$path'."
        Remove-Item -Path $path -Recurse -Force -ErrorAction SilentlyContinue
    }
}
else {
    Write-Warning "No files were removed as unable to determine where Solr was installed. Please remove Solr files and folders manually."
}