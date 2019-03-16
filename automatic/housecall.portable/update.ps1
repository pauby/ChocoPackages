#import-module au

. $PSScriptRoot\..\..\scripts\all.ps1

# info here https://community.box.com/t5/How-to-Guides-for-Admins/Large-Scale-Deployments-Box-Sync/ta-p/6455
$releases = 'https://go.trendmicro.com/housecall8/r2/HousecallLauncher64.exe'


function global:au_SearchReplace {
    @{
        ".\tools\chocolateyInstall.ps1" = @{
            "(?i)(^\s*url64\s*=\s*)('.*')"          = "`$1'$($Latest.Url64)'"
            "(?i)(^\s*checksum64\s*=\s*)('.*')"     = "`$1'$($Latest.Checksum64)'"
            "(?i)(^\s*checksumType64\s*=\s*)('.*')" = "`$1'$($Latest.ChecksumType64)'"
        }
    }
}

function global:au_BeforeUpdate() {
}

function global:au_AfterUpdate {
    Set-DescriptionFromReadme -SkipFirst 2
}

function global:au_GetLatest {
    $tempFile = New-TemporaryFile
    Invoke-WebRequest -Uri $releases -OutFile $tempFile -UseBasicParsing
    $version = (Get-Item -Path $tempFile).VersionInfo.FileVersion

    return @{
        URL64   = $releases
        Checksum64 = (Get-FileHash -Path $tempFile).Hash
        ChecksumType64 = 'SHA256'
        Version = $version
    }
}

update -ChecksumFor none