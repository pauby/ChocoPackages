Import-Module ApplicationServer

function Get-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [parameter(Mandatory = $true)]
        [String]$Website,

        [parameter(Mandatory = $true)]
        [String]$Name
    )

    $application = (Get-ASApplication -SiteName $Website -VirtualPath $Name -OutVariable $null)
    if ($application -ne $null)
    {
        $autoStartMode = $application.AutoStartMode
        $ensure = "Present"
        if ($autoStartMode -eq $null -or $autoStartMode -eq "Disable") {
            $autoStartMode = "Disable"
            $ensure = "Absent"
        }
        return @{
            Website = $Website
            Name = $Name
            Ensure = $ensure
            AutoStartMode = $autoStartMode
        }
    }

    return @{
        Website = $Website
        Name = $Name
        Ensure = "Absent"
        AutoStartMode = "Disable"
    }
}


function Set-TargetResource
{
    [CmdletBinding()]
    param
    (
        [parameter(Mandatory = $true)]
        [String]$Website,

        [parameter(Mandatory = $true)]
        [String]$Name,

        [ValidateSet("Present","Absent")]
        [String]$Ensure = "Present",

        [ValidateSet("All","Custom","Disable")]
        [String] $AutoStartMode
    )

    $application = Get-TargetResource -Website $Website -Name $Name

    if ($Ensure -eq "Present")
    {
        Set-ASApplication -SiteName $Website `
            -VirtualPath $Name `
            -AutoStartMode $AutoStartMode `
            -EnableApplicationPool
    }
    elseif (($Ensure -eq "Absent") -and ($application -ne $null))
    {
        Set-ASApplication -SiteName $Website -VirtualPath $Name -AutoStartMode "Disable"
    }
}


function Test-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Boolean])]
    param
    (
        [parameter(Mandatory = $true)]
        [String]$Website,

        [parameter(Mandatory = $true)]
        [String]$Name,

        [ValidateSet("Present","Absent")]
        [String]$Ensure = "Present",

        [ValidateSet("All","Custom","Disable")]
        [String] $AutoStartMode
    )

    $application = Get-TargetResource -Website $Website -Name $Name

    if($Ensure -eq "Present")
    {
        if(($application.Ensure -eq $Ensure) `
            -and ($application.AutoStartMode -eq $AutoStartMode))
        {
            return $true
        }
    }
    elseif($application.Ensure -eq $Ensure)
    {
        return $true
    }

    return $false
}

Export-ModuleMember -Function *-TargetResource
