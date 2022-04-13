
$ErrorActionPreference = 'Stop'

$toolsDir = Split-Path -Parent $MyInvocation.MyCommand.Definition

$packageArgs = @{
    packageName   = $env:ChocolateyPackageName
    url           = 'https://languagetool.org/download/LanguageTool-5.7.zip'
    checksum      = '0c7ca3f7fa94d298c4ffb9d342b33e31cf6e93015602227b94924e3237b5ce79'
    checksumType  = 'SHA256'
    unzipLocation = $toolsDir
}

if (-not (Get-Command -Name 'java.exe' -ErrorAction SilentlyContinue)) {
    Write-Error "LanguageTool requires a flavour of jre8 to be installed. As there are so many flavours, this package does not take a dependency on a specific one. Please install a flavour of jre8 before trying to install again."
}

Install-ChocolateyZipPackage @packageArgs
