function Get-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [parameter(Mandatory = $true)]
        [Int]$Index = 0,
        [String[]]$Services = @("AppFabricWorkflowManagementService", "AppFabricEventCollectionService")
    )

    $serviceStatuses = $Services | ForEach-Object {
        Get-Service $_ | Select-Object -ExpandProperty Status
    }
    if ($serviceStatuses.Contains("Stopped")) {
        return @{
            Index = $Index
            Services = $Services
            Ensure = "Absent"
        }
    }

    return @{
        Index = $Index
        Services = $Services
        Ensure = "Present"
    }
}

function Set-TargetResource {
    [CmdletBinding()]
    param (
        [parameter(Mandatory = $true)]
        [Int]$Index = 0,
        [String[]]$Services = @("AppFabricWorkflowManagementService", "AppFabricEventCollectionService"),
        [ValidateSet("Present","Absent")]
        [String]$Ensure = "Present"
    )

    if ($Ensure -eq "Present") {
        $Services | ForEach-Object { Start-Service $_ }
    }
    else {
        $Services | ForEach-Object { Stop-Service $_ }
    }
}

function Test-TargetResource {
    [CmdletBinding()]
    [OutputType([System.Boolean])]
    param (
        [parameter(Mandatory = $true)]
        [Int]$Index = 0,
        [String[]]$Services = @("AppFabricWorkflowManagementService", "AppFabricEventCollectionService"),
        [ValidateSet("Present","Absent")]
        [String]$Ensure = "Present"
    )

    $resource = Get-TargetResource -Index $Index -Services $Services

    if($resource.Ensure -eq $Ensure)
    {
        return $true
    }

    return $false
}

Export-ModuleMember -Function *-TargetResource
