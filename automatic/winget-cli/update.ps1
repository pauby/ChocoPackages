. $PSScriptRoot\..\..\scripts\all.ps1

$repoOwner = 'microsoft'
$repoName = 'winget-cli'

# filename of the WinGet .msixbundle file
$wingetAppFilename = 'Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle'
$wingetLicenseFilename = 'License.xml'

function global:au_SearchReplace {
    @{
        "$($Latest.PackageName).nuspec" = @{
            "(\<releaseNotes\>).*?(\</releaseNotes\>)"      = "`${1}$([System.Web.HttpUtility]::HtmlEncode($Latest.ReleaseNotes))`$2"
        }
        ".\tools\chocolateyInstall.ps1" = @{
            '(^\s*\$appxFilename\s*=\s*)(''.*'')'           = "`$1'$($wingetAppFilename)'"
            '(^\s*\$appxLicenseFilename\s*=\s*)(''.*'')'    = "`$1'$($wingetLicenseFilename)'"
        }
        ".\tools\winget-cli-helpers.ps1" = @{
            '(^\s*\$packagedAppxVersion\s*=\s*)(''.*'')'    = "`$1'$($Latest.version)'"
            '(^\s*Version\s*=\s*)(''.*'')'                  = "`$1'$($Latest.AppVersion)'"
        }
        ".\tools\VERIFICATION.txt"      = @{
            "(^\s*Installer URL:\s*)(.*)"                   = "`$1$($Latest.URL64)"
            "(^\s*Installer Checksum:\s*)(.*)"              = "`${1}$($Latest.Checksum64)"
            "(^\s*Installer Checksum Type:\s*)(.*)"         = "`$1$($Latest.ChecksumType64)"
            "(^\s*License URL:\s*)(.*)"                     = "`$1$($Latest.URLLicense64)"
            "(^\s*License Checksum:\s*)(.*)"                = "`${1}$($Latest.ChecksumLicense64)"
            "(^\s*License Checksum Type:\s*)(.*)"           = "`$1$($Latest.ChecksumType64)"
        }
    }
}

function global:au_BeforeUpdate {
    Remove-Item -Path 'tools\$wingetAppFilename', 'tools\$wingetLicenseFilename' -Force -ErrorAction SilentlyContinue
    Invoke-WebRequest -Uri $Latest.URL64 -OutFile "tools\$wingetAppFilename"
    Invoke-WebRequest -Uri $Latest.URLLicense64 -OutFile "tools\$wingetLicenseFilename"

    $Latest.ChecksumType64 = 'SHA256'
    $Latest.Checksum64 = (Get-FileHash -Path "tools\$wingetAppFilename" -Algorithm $Latest.ChecksumType64).Hash
    $Latest.ChecksumLicense64 = (Get-FileHash -Path "tools\$wingetLicenseFilename" -Algorithm $Latest.ChecksumType64).Hash

    # we need to get the app package version, which is different to the software version.
    # Its stored in the AppxMetadata\AppxBundleManifest.xml

    7z e tools\$wingetAppFilename AppxMetadata\AppxBundleManifest.xml -o"$env:TEMP" -y
    $Latest.AppVersion = ([xml](Get-Content -Path (Join-Path -Path $env:TEMP -ChildPath 'AppxBundleManifest.xml'))).Bundle.Identity.Version
}

function global:au_AfterUpdate {
    Set-DescriptionFromReadme -SkipFirst 2
}

function global:au_GetLatest {

    $release = Get-GitHubRelease -OwnerName $repoOwner -RepositoryName $repoName -Latest
    $version = $release.tag_name
    if ($version.StartsWith('v')) {
        $version = $version.Substring(1)    # skip over 'v' in tag
    }

    $asset64 = $release.assets | Where-Object name -eq $wingetAppFilename
    $assetLicense64 = $release.assets | Where-Object name -match "_License1.xml$"
    $releaseNotes = if ([string]::IsNullOrEmpty($release.body)) {
        $release.html_url
    }
    else {
        $release.body
    }

    return @{
        Asset64        = $asset64
        AssetLicense64 = $assetLicense64
        URL64          = $asset64.browser_download_url
        URLLicense64   = $assetLicense64.browser_download_url
        Version        = ConvertTo-VersionNumber -Version ([version]$version) -Part 4
        ReleaseNotes   = $releaseNotes
    }
}

Update-Package -ChecksumFor None