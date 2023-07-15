$ErrorActionPreference = 'Stop'

$moduleName = 'Microsoft.WinGet.Client' # this could be different from package name
$moduleVersion = ''
$savedParamsPath = Join-Path $toolsDir -ChildPath 'parameters.saved'
$minPSVersion = '5.1.0'
