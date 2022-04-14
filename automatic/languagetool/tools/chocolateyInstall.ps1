
$ErrorActionPreference = 'Stop'

$toolsDir = Split-Path -Parent $MyInvocation.MyCommand.Definition

$packageArgs = @{
    packageName    = $env:ChocolateyPackageName
    url            = 'https://languagetool.org/download/LanguageTool-5.7.zip'
    checksum       = '0c7ca3f7fa94d298c4ffb9d342b33e31cf6e93015602227b94924e3237b5ce79'
    checksumType   = 'SHA256'
    unzipLocation  = $toolsDir
}

# warn if no java detected but don't stop the install as it's not needed for installation only for running the server
if (-not (Get-Command -Name 'java.exe' -ErrorAction SilentlyContinue)) {
    Write-Warning "LanguageTool requires a flavour of jre8 to be installed in order to run the server. As there are so many flavours, this package does not recommend a specific one. Please install a flavour of jre8 before trying to run the 'languagetool' server."
}

Install-ChocolateyZipPackage @packageArgs

# each version will put the LanguageTool binaries into a folder named 'LanguageTool-<VERSION>'
# for consistency, lets move it to the 'LanguageTool' folder in the tools location
$toolsLocation = Get-ToolsLocation
$destination = Join-Path -Path $toolsLocation -ChildPath 'languagetool'
if (-not (Test-Path -Path $toolsLocation)) {
    New-Item -Path $toolsLocation -ItemType Directory -ErrorAction SilentlyContinue | Out-Null
}
Get-ChildItem -Path (Join-Path -Path $toolsDir -ChildPath 'LanguageTool-*\*') -Recurse | Move-Item -Destination $destination -Force

# this folder should be empty so no need for -Recurse
Remove-Item -Path (Join-Path -Path $toolsDir -ChildPath 'LanguageTool-*') -Force
