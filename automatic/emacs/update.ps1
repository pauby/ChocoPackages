#import-module au

. $PSScriptRoot\..\..\scripts\all.ps1

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

    $version = (choco search emacs.portable --exact --by-id-only --limit-output | ConvertFrom-Csv -Delimiter '|' -Header 'name', 'version').version

    return @{
        Version = ConvertTo-VersionNumber -Version ([version]$version) -Part 3
    }
}

Update-Package -ChecksumFor none
