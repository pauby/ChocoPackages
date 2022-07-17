#import-module au

. $PSScriptRoot\..\..\scripts\all.ps1

$releases = 'https://ftp.gnu.org/gnu/emacs/windows' # no trailing slash

function global:au_SearchReplace {
    @{
        ".\emacs.nuspec" = @{
            "(^\s*\<dependency\s*id=""emacs.portable""\s*version=""\[)(.*)" = "`${1}$($Latest.Version)]"" />"
        }
    }
}

function global:au_BeforeUpdate() {
}

function global:au_AfterUpdate { 
    Set-DescriptionFromReadme -SkipFirst 2 
}

function global:au_GetLatest {
    $page = Invoke-WebRequest -Uri $releases -UseBasicParsing

    # get all major versions that are available (28, 29, 30 etc.), choose the latest and open that page
    $majorVer = @()
    ForEach ($p in $page.links.href) {
        if ($p -match 'emacs-(?<version>[\d]+)') {
            $majorVer += $matches.version
        }
    }

    # we assume at this stage that they are sorted in the correct order so we just grab the last one
    $majorVer = $majorVer | Select-Object -Unique -Last 1

    # get all of the files within the page
    $downloadPage = Invoke-WebRequest "$releases/emacs-$majorVer" -UseBasicParsing

    $versions = @()
    ForEach ($v in $downloadPage.links.href) {
        if ($v -match 'emacs-(?<version>[\d\.]+)-') {
            $versions += $matches.version
        }
    }
    # we assume at this stage that they are sorted in the correct order so we just grab the last one 
    $version = $versions | Select-Object -Unique -Last 1
    $softwareVersion = $version     # this stores the emacs version

    # we should use a 3 part version number
    if (([version]$version).minor -eq -1) {
        $version += '.0.0'
    }
    elseif (([version]$version).build -eq -1) {
        $version += '.0'
    }
    return @{
        URL64           = "$releases/emacs-$majorVer/emacs-$softwareVersion.zip"
        SoftwareVersion = $softwareVersion
        Version         = $version
    }
}

Update-Package -ChecksumFor none
