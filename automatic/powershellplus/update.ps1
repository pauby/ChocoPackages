#import-module au

. $PSScriptRoot\..\..\scripts\all.ps1

$releases32 = 'http://downloadfiles.idera.com/products/IderaPowerShellPlusSetup-x86.zip'
$releases64 = 'http://downloadfiles.idera.com/products/IderaPowerShellPlusSetup-x64.zip'

function global:au_SearchReplace {
    @{
        ".\tools\chocolateyInstall.ps1" = @{
            '(^\s*url\s*=\s*)(''.*'')'              = "`$1'$($Latest.URL32)'"
            "(?i)(^\s*checksum\s*=\s*)('.*')"       = "`$1'$($Latest.Checksum32)'"
            "(?i)(^\s*checksumType\s*=\s*)('.*')"   = "`$1'$($Latest.ChecksumType32)'"
            '(^\s*url64\s*=\s*)(''.*'')'            = "`$1'$($Latest.URL64)'"
            "(?i)(^\s*checksum64\s*=\s*)('.*')"     = "`$1'$($Latest.Checksum64)'"
            "(?i)(^\s*checksumType64\s*=\s*)('.*')" = "`$1'$($Latest.ChecksumType64)'"
        }
    }
}

function global:au_BeforeUpdate {
    $Latest.Checksum32 = Get-RemoteChecksum $Latest.Url32
    $Latest.ChecksumType32 = 'SHA256'
    $Latest.Checksum64 = Get-RemoteChecksum $Latest.Url64
    $Latest.ChecksumType64 = 'SHA256'
}

function global:au_AfterUpdate { 
    Set-DescriptionFromReadme -SkipFirst 2 
}

function global:au_GetLatest {
    $exeFilename = 'iderapowershellplussetup-x86.exe'
    $tempFile = New-TemporaryFile
    Invoke-WebRequest -Uri $releases32 -OutFile $tempFile -UseBasicParsing
    & 7z.exe e -aoa $tempFile $exeFilename

    $version = (Get-Item $exeFilename).VersionInfo.FileVersionRaw

    return @{
        URL32   = $releases32
        URL64   = $releases64
        Version = $version
    }
}

update -ChecksumFor none