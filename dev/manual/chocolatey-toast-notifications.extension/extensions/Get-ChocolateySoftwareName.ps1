$ErrorActionPreference = 'Stop'
# chocolatey-toast-notifications.extension v0.0.4 by Bill Curran AKA BCURRAN3 - 2018-2020 Copyleft Bill Curran
# This function gets the name (title) of the software being installed from the package .nuspec file.
# Morphed and expanded into Get-NuspecInfo.ps1 found in chocolatey-fastanswers.extension v0.0.2+

function Get-ChocolateySoftwareName{
$nuspecXML = "$env:ChocolateyInstall\lib\$env:chocolateyPackageName\$env:chocolateyPackageName.nuspec"

# Import title/softwareName
[xml]$nuspecFile = Get-Content $nuspecXML
$chocolateySoftwareName = $nuspecFile.package.metadata.title
return $chocolateySoftwareName
}
