#import-module au

. $PSScriptRoot\..\..\scripts\all.ps1

# info here https://community.box.com/t5/How-to-Guides-for-Admins/Large-Scale-Deployments-Box-Sync/ta-p/6455
$releasesx86 = 'https://e3.boxcdn.net/box-installers/sync/Sync+4+External/SyncMSI32.msi'
$releasesx64 = 'https://e3.boxcdn.net/box-installers/sync/Sync+4+External/SyncMSI64.msi'

function Get-MsiProductVersion {

    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [ValidateScript( {$_ | Test-Path -PathType Leaf})]
        [string]
        $Path
    )

    # We need absolute paths for this to work
    $Path = (Resolve-Path -Path $Path).Path

    function Get-Property ($Object, $PropertyName, [object[]]$ArgumentList) {
        return $Object.GetType().InvokeMember($PropertyName, 'Public, Instance, GetProperty', $null, $Object, $ArgumentList)
    }

    function Invoke-Method ($Object, $MethodName, $ArgumentList) {
        return $Object.GetType().InvokeMember($MethodName, 'Public, Instance, InvokeMethod', $null, $Object, $ArgumentList)
    }

    $ErrorActionPreference = 'Stop'
    Set-StrictMode -Version Latest

    #http://msdn.microsoft.com/en-us/library/aa369432(v=vs.85).aspx
    $msiOpenDatabaseModeReadOnly = 0
    $Installer = New-Object -ComObject WindowsInstaller.Installer

    $Database = Invoke-Method $Installer OpenDatabase  @($Path, $msiOpenDatabaseModeReadOnly)

    $View = Invoke-Method $Database OpenView  @("SELECT Value FROM Property WHERE Property='ProductVersion'")

    $null = Invoke-Method $View Execute

    $Record = Invoke-Method $View Fetch
    if ($Record) {
        Write-Output (Get-Property $Record StringData 1)
    }

    $null = Invoke-Method $View Close @()
    Remove-Variable -Name Record, View, Database, Installer
}

function global:au_SearchReplace {
    @{
        ".\tools\chocolateyInstall.ps1" = @{
            '(^\s*\$url32\s*=\s*)(''.*'')'          = "`$1'$($Latest.Url32)'"
            "(?i)(^\s*checksum\s*=\s*)('.*')"       = "`$1'$($Latest.Checksum32)'"
            "(?i)(^\s*checksumType\s*=\s*)('.*')"   = "`$1'$($Latest.ChecksumType32)'"
            '(^\s*\$url64\s*=\s*)(''.*'')'          = "`$1'$($Latest.Url64)'"
            "(?i)(^\s*checksum64\s*=\s*)('.*')"     = "`$1'$($Latest.Checksum64)'"
            "(?i)(^\s*checksumType64\s*=\s*)('.*')" = "`$1'$($Latest.ChecksumType64)'"
        }
    }
}

function global:au_BeforeUpdate() {
    $Latest.Checksum32 = Get-RemoteChecksum $Latest.Url32
    $Latest.Checksum64 = Get-RemoteChecksum $Latest.Url64

    $Latest.ChecksumType32 = 'SHA256'
    $Latest.ChecksumType64 = 'SHA256'
}

function global:au_AfterUpdate {
    Set-DescriptionFromReadme -SkipFirst 2
}

function global:au_GetLatest {
    $tempFile = New-TemporaryFile
    Invoke-WebRequest -Uri $releasesx64 -OutFile $tempFile -UseBasicParsing
    $version = Get-MsiProductVersion -Path $tempFile

    return @{
        URL32   = $releasesx86
        URL64   = $releasesx64
        Version = ConvertTo-VersionNumber -Version ([version]$version) -Part 3
    }
}

update -ChecksumFor none