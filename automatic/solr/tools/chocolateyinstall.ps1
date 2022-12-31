$ErrorActionPreference = 'Stop'

$toolsDir = Split-Path $MyInvocation.MyCommand.Definition
$savedParamsPath = Join-Path $toolsDir -ChildPath 'parameters.saved'

$pp = Get-PackageParameters
if (-not $pp['InstallDir']) {
   $unzipPath = Get-ToolsLocation
}
else {
   if (Test-Path -Path $pp['InstallDir']) {
      $unzipPath = $pp['InstallDir']
   }
   else {
      throw "Custom install location, '$($pp['InstallDir'])', is invalid or does not exist. Cannot install to this location."
   }
}

# warn if no java detected but don't stop the install as it's not needed for installation only
if (-not (Get-Command -Name 'java.exe' -ErrorAction SilentlyContinue)) {
   Write-Warning "Java 11 is not required to install the package, but is required to run Solr. As there are so many flavours, this package does not recommend a specific one."
   Write-Warning "Please see https://solr.apache.org/guide/solr/latest/deployment-guide/system-requirements.html#java-requirements and install a suitable version and flavour of Java."
}

$packageArgs = @{
   PackageName   = 'solr'
   url           = 'https://www.apache.org/dyn/closer.lua/solr/solr/9.1.0/solr-9.1.0.tgz?action=download'
   unzipLocation = $unzipPath
   checksum      = '16715fe50a74bc4906f655531523875e9e5d4a013aea22afff10a52dc6f05a8b62e079aee75cd9f2e250300e40071140c0a966cbd51af811a622f2f1f0b0c926'
   checksumType  = 'sha512'
}

# we need to know the software version (not the package version) as it's part of the install folder path
if ($packageArgs.url -match 'solr-(?<version>[\d\.]+)\.tgz') {
   $softwareVersion = $matches.version
   # save the custom install location so we can uninstall it later
   # the path will be, for example with Solr 9.0.0, 'c:\tools\solr-9.0.0' (last part is the basename of the tar file)
   $solrFullPath = Join-Path -Path $unzipPath -ChildPath "solr-$($softwareVersion)"
   Add-Content -Path $savedParamsPath -Value $solrFullPath
   Write-Host "Solr will be unpacked to '$solrFullPath'."
}
else {
   Write-Warning 'Could not determine software version. Will be unable to automatically uninstall so you will need to remove files manually.'
}

# The tgz file is a tar file inside a zip file. We need to extract the tar file and then extract the contents
$tempPath = Join-Path -Path $env:TEMP -ChildPath (([GUID]::NewGuid()).Guid)
$tgzPath = Join-Path -Path $tempPath -ChildPath 'solr.tgz'
Get-ChocolateyWebFile @packageArgs -FileFullPath $tgzPath            # get the file
Get-ChocolateyUnzip -FileFullPath $tgzPath -Destination $tempPath    # extract the tar file from the tgz file

$tarPath = Join-Path -Path $tempPath -ChildPath 'solr.tar'           # get the extracted tar file
Get-ChocolateyUnzip -FileFullPath $tarPath -Destination $unzipPath   # extract the tar file contents to the final location

# remove any zip.txt files as we don't need them and they'll just cause confusion
Remove-Item -Path (Join-Path -Path $toolsDir -ChildPath '*.zip.txt') -ErrorAction SilentlyContinue | Out-Null