<#
.SYNOPSIS
Gets the product version from the MSI.

.DESCRIPTION
Queries the MSI "database" to retrieve the product version.

.PARAMETER Path
Path to the MSI file to query.

.EXAMPLE
Get-MsiProductVersion -Path C:\Temp\MyProgram.msi

.NOTES
I have had this code for a long time and while but I have no idea where I found it. If I discover that, I'll update this note
to give credit to the author.
#>
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