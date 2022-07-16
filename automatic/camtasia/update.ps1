#import-module au

. $PSScriptRoot\..\..\scripts\all.ps1

# NOTE: Camtasia doesn't appear to use the same method of detecting package updates as
# Snagit (ie. using SOAP to get info from an update server).
$releases    = 'https://support.techsmith.com/hc/en-us/articles/115006443267%C2%A0'

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
    # $Latest.Checksum64 = Get-RemoteChecksum $Latest.Url64
    # $Latest.ChecksumType64 = 'SHA256'
}

function global:au_AfterUpdate {
    Set-DescriptionFromReadme -SkipFirst 2
}

function global:au_GetLatest {
    $page = Invoke-WebRequest -Uri $releases -UseBasicParsing -UserAgent [Microsoft.PowerShell.Commands.PSUserAgent]::FireFox
    $regexUrl = ": Camtasia \(Windows\) (?<version>[\d\.]+)"

    $page.content -match $regexUrl

    # we need to do a couple of things here to get the url version needed to download:
    # if 4 have a patch in the semantic versioning we need to add two zeroes so we can produce fix versions if needed
    # if the version starts with '20' we need to remove that - Camtastaa advertises the version as '2018' but tags it's installers as '18'
    # remove all the dots from the string version number
    $version = $matches.version

    # remove the trailing '20' if it's there as we need this to construct the download URL later
    if ($version.StartsWith("20")) {
        $urlVersion = $version.SubString(2)
    }
    else {
        # something isn't right if it doesn't start with '20' so throw an exception and we can come here to fix it
        throw "Camtasia version '$version' does not start with '20' so they may have changed their version numbering."
    }

    # # remove the dots from the version string
    # now we can construct what should be the url
    $url = ("https://download.techsmith.com/camtasiastudio/releases/{0}/camtasia.msi" -f $urlVersion.Replace('.', ''))

    # check if we have a revision number and if so append 00 to it for use as a fix version
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

Update-Package -ChecksumFor 64