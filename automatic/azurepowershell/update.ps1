#import-module au

. $PSScriptRoot\..\..\scripts\all.ps1

$releases = 'https://github.com/Azure/azure-powershell/releases'

function global:au_SearchReplace {
    @{
        '.\azurepowershell.nuspec' = @{
            '(^[\d\.]+\d)(\:)'                   = "$($Latest.Version)`$2"
            '(software\s+version\s+)([\d\.]+\d)' = "`${1}$($Latest.SoftwareVersion)"
        }
        '.\tools\ChocolateyInstall.ps1' = @{
            '(^\s*\$moduleVersion\s*=\s*\[version\])(''.*'')' = "`$1'$($Latest.SoftwareVersion)'"
            '(^\s*\$url\s*=\s*)(''.*'')'                    = "`$1'$($Latest.Url32)'"
            '(^\s*\$checksum\s*=\s*)(''.*'')'               = "`$1'$($Latest.Checksum32)'"
            '(^\s*\$checksumType\s*=\s*)(''.*'')'           = "`$1'$($Latest.ChecksumType32)'"
        }
    }
}

function global:au_BeforeUpdate() {
    $Latest.Checksum32 = Get-RemoteChecksum $Latest.Url32
    $Latest.ChecksumType32 = 'SHA256'
}

function global:au_AfterUpdate { 
    Set-DescriptionFromReadme -SkipFirst 2 
}

function global:au_GetLatest {
    $downloadPage = Invoke-WebRequest -Uri $releases -UseBasicParsing

    # https://github.com/Azure/azure-powershell/releases/download/v5.3.0-February2018-rtm/azure-powershell.5.3.0.msi
    $rx = '^' + [regex]::Escape($releases) + '/download/[^/]+/azure-powershell\.(?<v>\d+\.\d+\.\d+)\.msi$'
    $info = $downloadPage.Links | Select-Object -ExpandProperty href | Select-String -Pattern $rx | Select-Object -Property 'Line', @{ Name = 'Version'; Expression = { [version]$_.Matches[0].Groups['v'].Value } } | Sort-Object -Property 'Version' -Descending | Select-Object -First 1

    return @{
        SoftwareVersion = $info.Version
        Version = $info.Version
        Url32   = $info.Line
    }
}

update -ChecksumFor none
