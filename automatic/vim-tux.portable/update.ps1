$ErrorActionPreference = 'Stop'

#
# 6 September 2023
# Package was converted to using the 7z files for vim-tux due to very high AV counts for the EXE version.
# The EXE version was a self-extracting archive that may be at the root of this.
#

. $PSScriptRoot\..\..\scripts\all.ps1

$releases = "https://tuxproject.de/projects/vim/"
$checksumType = 'SHA256'

function global:au_SearchReplace {

    $embeddedFiles = (Get-ChildItem -Path 'tools\*.7z' | ForEach-Object {
            "    - {0}: {1} ({2})" -f $_.Name, (Get-FileHash -Path $_ -Algorithm $checksumType).Hash, $checksumType
        }) -join "`n"

    @{
        "$($Latest.PackageName).nuspec"   = @{
            "(\<releaseNotes\>).*?(\</releaseNotes\>)" = "`${1}$($Latest.ReleaseNotes)`$2"
        }
        ".\tools\chocolateyInstall.ps1"   = @{
#            '(?i)(^\s*\$versPath\s*=\s*)(''.*'')' = "`$1'$($Latest.versionPath)'"
            '(?i)(^\s*\$filename64\s*=\s*)(".*")' = "`$1""`$toolsDir\$($Latest.Url64Filename)"""
        }
#        ".\tools\chocolateyUninstall.ps1" = @{
#            '(?i)(^\s*\$versPath\s*=\s*)(''.*'')' = "`${1}'$($Latest.versionPath)'"
#        }
        ".\tools\VERIFICATION.txt"        = @{
            "(?i)(^\s*3.\s*The checksums should match the following\:).*" = "`${1}`n$embeddedFiles"
        }
    }
}

function global:au_BeforeUpdate() {
    Remove-Item -Path 'tools\*.7z' -Force -ErrorAction SilentlyContinue
#    $Latest.Url32Filename = Split-Path -Path $Latest.Url32 -Leaf
    $Latest.Url64Filename = Split-Path -Path $Latest.Url64 -Leaf

#    Invoke-WebRequest -Uri $Latest.Url32 -OutFile "tools\$($Latest.Url32Filename)" -UseBasicParsing
    Invoke-WebRequest -Uri $Latest.Url64 -OutFile "tools\$($Latest.Url64Filename)" -UseBasicParsing
}

function global:au_AfterUpdate {
    Set-DescriptionFromReadme -SkipFirst 2
}

function global:au_GetLatest {

    $matches = $null
    ((Invoke-WebRequest -Uri $releases -UseBasicParsing).RawContent.Split("`n") | Select-String '<title>') -match "(\d+)\.(\d+)\.\d+"
    $version = $matches[0]
    $versionPath = "vim" + $matches[1] + $matches[2]

    return @{
        Version      = ConvertTo-VersionNumber -Version ([version]$version) -Part 3
#        VersionPath  = $versionPath
#        Url32        = 'http://tuxproject.de/projects/vim/complete-x86.7z'
        Url64        = 'http://tuxproject.de/projects/vim/complete-x64.7z'
        ReleaseNotes = "https://www.vim.org/$versionPath.php"
    }
}

Update-Package -ChecksumFor none
