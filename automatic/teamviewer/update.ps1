#import-module au

. $PSScriptRoot\..\..\scripts\all.ps1

$releasesx86 = 'https://download.teamviewer.com/download/TeamViewer_Setup.exe'
$releasesx64 = 'https://download.teamviewer.com/download/TeamViewer_Setup_x64.exe'

function global:au_SearchReplace {
    @{
        ".\tools\chocolateyInstall.ps1" = @{
            '(^\s*url\s*=\s*)(''.*'')'          = "`$1'$($Latest.URL32)'"
            "(?i)(^\s*checksum\s*=\s*)('.*')"     = "`$1'$($Latest.Checksum32)'"
            "(?i)(^\s*checksumType\s*=\s*)('.*')" = "`$1'$($Latest.ChecksumType32)'"
            '(^\s*url64\s*=\s*)(''.*'')'            = "`$1'$($Latest.URL64)'"
            "(?i)(^\s*checksum64\s*=\s*)('.*')"     = "`$1'$($Latest.Checksum64)'"
            "(?i)(^\s*checksumType64\s*=\s*)('.*')" = "`$1'$($Latest.ChecksumType64)'"
        }
    }
}

function global:au_AfterUpdate { 
    Set-DescriptionFromReadme -SkipFirst 2 
}

function global:au_GetLatest {
    $tempFile = New-TemporaryFile
    Invoke-WebRequest -Uri $releasesx86 -OutFile $tempFile -UseBasicParsing
    $fileVer = (Get-Item $tempfile).VersionInfo
    $versionForURL = "$($fileVer.ProductMajorPart)"
    $version = "$($fileVer.ProductMajorPart).$($fileVer.ProductMinorPart).$($fileVer.ProductBuildPart)"

    return @{
        URL32   = "https://download.teamviewer.com/download/version_$($versionForURL)x/TeamViewer_Setup.exe"
        URL64   = "https://download.teamviewer.com/download/version_$($versionForURL)x/TeamViewer_Setup_x64.exe"
        Version = $version
    }
}

update -ChecksumFor all
