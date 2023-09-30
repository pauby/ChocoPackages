. $PSScriptRoot\..\..\scripts\all.ps1

$repoOwner = 'microsoft'
$repoName = 'winget-cli'

# filename of the WinGet .msixbundle file
$wingetAppFilename = 'Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle'
$wingetLicenseFilename = 'License.xml'

function global:au_SearchReplace {
    @{
        "$($Latest.PackageName).nuspec"  = @{
            "(\<releaseNotes\>).*?(\</releaseNotes\>)" = "`${1}$([System.Web.HttpUtility]::HtmlEncode($Latest.ReleaseNotes))`$2"
        }
        ".\tools\chocolateyInstall.ps1"  = @{
            '(^\s*\$appxURL\s*=\s*)(''.*'')'                 = "`$1'$($Latest.URL64)'"
            '(^\s*\$appxChecksum\s*=\s*)(''.*'')'            = "`$1'$($Latest.Checksum64)'"
            '(^\s*\$appxChecksumType\s*=\s*)(''.*'')'        = "`$1'$($Latest.ChecksumType64)'"
            '(^\s*\$appxLicenseURL\s*=\s*)(''.*'')'          = "`$1'$($Latest.URLLicense64)'"
            '(^\s*\$appxLicenseChecksum\s*=\s*)(''.*'')'     = "`$1'$($Latest.LicenseChecksum)'"
            '(^\s*\$appxLicenseChecksumType\s*=\s*)(''.*'')' = "`$1'$($Latest.LicenseChecksumType)'"
        }
        ".\tools\winget-cli-helpers.ps1" = @{
            '(^\s*\$packagedAppxVersion\s*=\s*)(''.*'')' = "`$1'$($Latest.FourPartVersion)'"
            '(^\s*Version\s*=\s*)(''.*'')'               = "`$1'$($Latest.AppVersion)'"
        }
    }
}

function global:au_BeforeUpdate {
    $Latest.ChecksumType64 = $Latest.LicenseChecksumType = 'SHA256'

    $appxFile = New-TemporaryFile
    $ProgressPreference = 'SilentlyContinue'
    Invoke-WebRequest -Uri $Latest.URL64 -OutFile $appxFile
    $Latest.Checksum64 = (Get-FileHash -Path $appxFile -Algorithm $Latest.ChecksumType64).Hash
    # we need to get the app package version, which is different to the software version.
    # Its stored in the AppxMetadata\AppxBundleManifest.xml
    7z e $appxFile AppxMetadata\AppxBundleManifest.xml -o"$env:TEMP" -y
    $Latest.AppVersion = ([xml](Get-Content -Path (Join-Path -Path $env:TEMP -ChildPath 'AppxBundleManifest.xml'))).Bundle.Identity.Version

    $Latest.LicenseChecksum = Get-RemoteChecksum $Latest.URLLicense64
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

    $asset64 = $release.assets | Where-Object name -EQ $wingetAppFilename
    $assetLicense64 = $release.assets | Where-Object name -Match "_License1.xml$"
    $releaseNotes = if ([string]::IsNullOrEmpty($release.body)) {
        $release.html_url
    }
    else {
        $release.body
    }

    return @{
        Asset64         = $asset64
        AssetLicense64  = $assetLicense64
        URL64           = $asset64.browser_download_url
        URLLicense64    = $assetLicense64.browser_download_url
        Version         = $version
        FourPartVersion = ConvertTo-VersionNumber -Version ([version]$version) -Part 4
        ReleaseNotes    = $releaseNotes
    }
}

Update-Package -ChecksumFor None