#import-module au

. $PSScriptRoot\..\..\scripts\all.ps1

$releases    = 'https://gc-updates.elgato.com/windows/sd-update/final/download-website.php'

function Get-MsiProductVersion {

    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [ValidateScript( { $_ | Test-Path -PathType Leaf })]
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
            '(^\s*url64\s*=\s*)(''.*'')'            = "`$1'$($Latest.URL64)'"
            "(?i)(^\s*checksum64\s*=\s*)('.*')"       = "`$1'$($Latest.Checksum64)'"
            "(?i)(^\s*checksumType64\s*=\s*)('.*')"   = "`$1'$($Latest.ChecksumType64)'"
        }
    }
}

function global:au_BeforeUpdate() {
    $Latest.Checksum64 = Get-RemoteChecksum $Latest.Url64
    $Latest.ChecksumType64 = 'SHA256'
}

function global:au_AfterUpdate {
    Set-DescriptionFromReadme -SkipFirst 2
}

function global:au_GetLatest {

    $tempFile = New-TemporaryFile
    Invoke-WebRequest -Uri $releases -OutFile $tempFile -UseBasicParsing
    $version = Get-MsiProductVersion -Path $tempFile

    return @{
        URL64   = "https://edge.elgato.com/egc/windows/sd/Stream_Deck_$version.msi"
        Version = $version
    }
}

Update-Package -ChecksumFor none