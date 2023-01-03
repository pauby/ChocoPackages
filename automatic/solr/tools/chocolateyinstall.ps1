$ErrorActionPreference = 'Stop'

$toolsDir = Split-Path $MyInvocation.MyCommand.Definition

$pp = Get-PackageParameters
if (-not $pp['InstallDir']) {
   $unzipPath = Get-ToolsLocation
}
else {
   if (Test-Path -Path $pp['InstallDir']) {
      $unzipPath = $pp['InstallDir']
      Write-Warning 'On uninstall, files will not be removed from a custom install location. Please remove them manually.'
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
   url           = 'https://archive.apache.org/dist/solr/solr/9.0.0/solr-9.0.0.tgz'
   unzipLocation = $unzipPath
   checksum      = '383c6b6f352f2a385ece99b2b0a82e1552430aea65c6c33e5569da422138844192db4e06f58699325af55ee631694e16f836a5bbf8556f86fdeabc0cfa0533d5'
   checksumType  = 'sha512'
}

Write-Host "Solr will be unpacked to '$unzipPath'."

# The tgz file is a tar file inside a zip file. We need to extract the tar file and then extract the contents
$tempPath = Join-Path -Path $env:TEMP -ChildPath (([GUID]::NewGuid()).Guid)
$tgzPath = Join-Path -Path $tempPath -ChildPath 'solr.tgz'
Get-ChocolateyWebFile @packageArgs -FileFullPath $tgzPath            # get the file
Get-ChocolateyUnzip -PackageName $packageArgs.PackageName -FileFullPath $tgzPath -Destination $tempPath    # extract the tar file from the tgz file

$tarPath = Join-Path -Path $tempPath -ChildPath 'solr.tar'           # get the extracted tar file
Get-ChocolateyUnzip -PackageName $packageArgs.PackageName -FileFullPath $tarPath -Destination $unzipPath   # extract the tar file contents to the final location
