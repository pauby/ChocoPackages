#import-module au

. $PSScriptRoot\..\..\scripts\all.ps1

$releases = 'https://msedge.api.cdp.microsoft.com/api/v2/contents/Browser/namespaces/Default/names?action=batchupdates'

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
    $jsonString = '[ { "Product":"msedgewebview-stable-win-x64", "targetingAttributes": { "AppAp":"", "AppBrandCode":"", "AppCohort":"", "AppCohortHint":"", "AppCohortName":"", "AppLang":"", "AppMajorVersion":"", "AppRollout":0.29, "AppTargetVersionPrefix":"", "AppVersion":"", "ExpETag":"", "HW_AVX":true, "HW_DiskType":2, "HW_LogicalCpus":2, "HW_PhysicalRamGB":4, "HW_SSE":true, "HW_SSE2":true, "HW_SSE3":true, "HW_SSE41":true, "HW_SSE42":true, "HW_SSSE3":true, "InstallSource":"taggedmi", "IsInternalUser":false, "IsMachine":true, "IsWIP":false, "OemProductManufacturer":"System Manufacturer", "OemProductName":"System Product Name", "OsArch":"x64", "OsPlatform":"win", "OsVersion":"10.0.17763.3887", "Priority":10, "Updater":"MicrosoftEdgeUpdate", "UpdaterVersion":"1.3.175.27","WIPBranch":""}}]'
    
    $response = Invoke-RestMethod -Uri $releases -Method Post -Body $jsonString -UseBasicParsing -ContentType 'application/json' -UserAgent 'Microsoft Edge Update/1.3.175.27;winhttp'

    $version = $response.ContentId.Version
    $url32 = 'https://go.microsoft.com/fwlink/p/?LinkId=2124703'

    return @{
        URL32   = $url32
        Version = $version
    }
}

Update-Package -ChecksumFor all