#import-module au

. $PSScriptRoot\..\..\scripts\all.ps1

$releases = 'https://msedge.api.cdp.microsoft.com/api/v1.1/contents/Browser/namespaces/Default/names/msedgewebview-stable-win-x64/versions/latest?action=select'

function global:au_SearchReplace {
    @{
        ".\tools\chocolateyInstall.ps1" = @{
            "(?i)(^\s*checksum\s*=\s*)('.*')"       = "`$1'$($Latest.Checksum32)'"
            "(?i)(^\s*checksumType\s*=\s*)('.*')"   = "`$1'$($Latest.ChecksumType32)'"
        }
    }
}

function global:au_BeforeUpdate() {
}

function global:au_AfterUpdate {
    Set-DescriptionFromReadme -SkipFirst 2
}

function global:au_GetLatest {
    $body = @{
        targetingAttributes = @{
            AppAp = ""
            AppBrandCode = ""
            AppCohort = ""
            AppCohortHint = ""
            AppCohortName = ""
            AppLang = ""
            AppMajorVersion = ""
            AppRollout = 0.06
            AppTargetVersionPrefix = ""
            AppVersion = ""
            ExpETag = ""
            HW_AVX = $true
            HW_DiskType = 2
            HW_LogicalCpus = 12
            HW_PhysicalRamGB = 64
            HW_SSE = $true
            HW_SSE2 = $true
            HW_SSE3 = $true
            HW_SSE41 = $true
            HW_SSE42 = $true
            HW_SSSE3 = $true
            InstallSource = "taggedmi"
            IsInternalUser = $false
            IsMachine = $false
            OemProductManufacturer = "System manufacturer"
            OemProductName = "System Product Name"
            OsArch = "x64"
            OsPlatform = "win"
            OsVersion = "10.0.19041.1415"
            Priority = 10
            Updater = "MicrosoftEdgeUpdate"
            UpdaterVersion = "1.3.155.85"
        }
    }

    $response = Invoke-RestMethod -Uri $releases -Method Post -Body $body -UseBasicParsing

    $version = $response.ContentId.Version
    $url32 = 'https://go.microsoft.com/fwlink/p/?LinkId=2124703'

    return @{
        URL32   = $url32
        Version = $version
    }
}

Update-Package -ChecksumFor all