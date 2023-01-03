function Get-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [parameter(Mandatory = $true)]
        [System.String]$Section
    )

    Confirm-Dependencies

    $configuration = Get-WebConfiguration -Filter $Section -PSPath "IIS:"

    if($configuration -ne $null -and $configuration.OverrideMode -eq "Allow") {
        return @{
            Ensure = "Present"
            Section = $Section
        }
    }

    return @{Ensure = "Absent"}
}

function Test-TargetResource
{
    [CmdletBinding()]
    param
    (
        [parameter(Mandatory = $true)]
        [System.String]
        $Section,

        [ValidateSet("Present","Absent")]
        [System.String]
        $Ensure  = "Present"
    )

    Confirm-Dependencies

    $actualState = Get-TargetResource -Section $Section

    if ($Ensure -eq $actualState.Ensure) { return $true }

    return $false
}

function Set-TargetResource
{
    [CmdletBinding()]
    param
    (
        [parameter(Mandatory = $true)]
        [System.String]
        $Section,

        [ValidateSet("Present","Absent")]
        [System.String]
        $Ensure  = "Present"
    )

    Confirm-Dependencies

    if($Ensure -eq "Absent") {
        $overrideMode = "Deny"
    }
    else {
        $overrideMode = "Allow"
    }

    Set-WebConfiguration -Filter $Section -PSPath "IIS:" -MetaData "overrideMode" -Value $overrideMode
}

function Confirm-Dependencies
{
    Write-Debug "Checking whether WebAdministration is there in the machine or not."
    Get-Module -ListAvailable -Name WebAdministration -OutVariable webAdministrationModule 4>&1 | Out-Null
    if(-not $webAdministrationModule)
    {
        Throw "Please ensure that the WebAdministration module is installed."
    }
    Import-Module WebAdministration 4>&1 | Out-Null
}


Export-ModuleMember -Function *-TargetResource
