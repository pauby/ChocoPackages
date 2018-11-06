#import-module au

. $PSScriptRoot\..\..\scripts\all.ps1

$releases    = 'https://support.techsmith.com/hc/en-us/articles/115006435067-Snagit-Windows-Version-History'

# Taken from https://gist.github.com/jstangroome/913062
function Get-MsiProductVersion {

    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [ValidateScript( {$_ | Test-Path -PathType Leaf})]
        [string]
        $Path
    )

    function Get-Property ($Object, $PropertyName, [object[]]$ArgumentList) {
        return $Object.GetType().InvokeMember($PropertyName, 'Public, Instance, GetProperty', $null, $Object, $ArgumentList)
    }

    function Invoke-Method ($Object, $MethodName, $ArgumentList) {
        return $Object.GetType().InvokeMember($MethodName, 'Public, Instance, InvokeMethod', $null, $Object, $ArgumentList)
    }

    $ErrorActionPreference = 'Stop'
    Set-StrictMode -Version Latest

    #http://msdn.microsoft.com/en-us/library/aa369432(v=vs.85).aspx
    $msiOpenDatabaseModeReadOnly = 0
    $Installer = New-Object -ComObject WindowsInstaller.Installer

    $Database = Invoke-Method $Installer OpenDatabase  @($Path, $msiOpenDatabaseModeReadOnly)

    $View = Invoke-Method $Database OpenView  @("SELECT Value FROM Property WHERE Property='ProductVersion'")

    $null = Invoke-Method $View Execute

    $Record = Invoke-Method $View Fetch
    if ($Record) {
        Write-Output (Get-Property $Record StringData 1)
    }

    $null = Invoke-Method $View Close @()
    Remove-Variable -Name Record, View, Database, Installer

}

function global:au_SearchReplace {
    @{
        ".\tools\chocolateyInstall.ps1" = @{
            '(^\s*\$url64\s*=\s*)(''.*'')'            = "`$1'$($Latest.URL64)'"
            "(?i)(^\s*checksum64\s*=\s*)('.*')"       = "`$1'$($Latest.Checksum64)'"
            "(?i)(^\s*checksumType64\s*=\s*)('.*')"   = "`$1'$($Latest.ChecksumType64)'"
        }
    }
}

function global:au_BeforeUpdate() {
    $Latest.Checksum64 = Get-RemoteChecksum $Latest.Url64
    $Latest.ChecksumType64 = 'SHA256'
}

function global:au_AfterUpdate {
    Set-DescriptionFromReadme -SkipFirst 2
}

function global:au_GetLatest {
    $page = Invoke-WebRequest -Uri $releases -UseBasicParsing
    $regexUrl = ": Snagit (?<version>[\d\.]+)"

    $page.content -match $regexUrl

    # we need to do a couple of things here to get the url version needed to download:
    # if 4 have a patch in the semantic versioning we need to add two zeroes so we can produce fix versions if needed
    # if the version starts with '20' we need to remove that - Camtastaa advertises the version as '2018' but tags it's installers as '18'
    # remove all the dots from the string version number
    $urlVersion = $matches.version

    # remove the trailing '20' if it's there
    if ($urlVersion.StartsWith("20")) {
        $urlVersion = $urlVersion.SubString(2)
    }
    else {
        # something isn't right if it doesn't start with '20' so throw an exception and we can come here to fix it
        throw "Camtasia version '$urlVersion' does not start with '20' so they may have changed their version numbering."
    }

    # remove the dots from the version string
    $urlVersion = $urlVersion.Replace('.', '')

    # now we can construct what should be the url
    $url = "https://download.techsmith.com/snagit/enu/$urlVersion/snagit.msi"
    $tempFile = New-TemporaryFile
    Invoke-WebRequest -Uri $url -OutFile $tempFile -UseBasicParsing
    $version = Get-MsiProductVersion -Path $tempFile

    if ([version]$version.major -gt 100) {
        throw "We downloaded a version of Camtasia and it's version number is '$version' - anything with a major version > 100 throws this exception. Something is not right and needs fixing."
    }
    else {
        # the version needs to have a '20' added to the start of it.
        $version = "20" + $version
    }

    # check if we have a revision number nad if so append 00 to it for use as a fix version
    # see https://github.com/chocolatey/choco/wiki/CreatePackages#package-fix-version-notation
    if (([version]$version).revision -ne -1) {
        # we have a revision number - add the 00
        $version += "00"
    }

    return @{
        URL64        = $url
        Version      = $version
    }
}

update -ChecksumFor none