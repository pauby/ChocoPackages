function Get-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [parameter(Mandatory = $true)]
        [System.String]
        $Name,

        [parameter(Mandatory = $true)]
        [System.String]
        $ApplicationName
    )

    Confirm-Dependencies

    $AppPool = Get-AppPool($Name)
    if($AppPool -eq $null)
    {
        return @{Name = $Name; ApplicationName = $ApplicationName; Ensure = "Absent"; State = "Stopped"}
    }

    $returnValue = @{
        Name   = $Name
        ApplicationName = $ApplicationName
        Ensure = "Present"
        State  = $AppPool.State
        managedRuntimeVersion = $AppPool.managedRuntimeVersion
        managedPipelineMode = $AppPool.managedPipelineMode
        enable32BitAppOnWin64 = $AppPool.enable32BitAppOnWin64
        processModel = @{
            identityType = $AppPool.processModel.identityType
            userName = $AppPool.processModel.userName
            password = $AppPool.processModel.password
        }
    }

    return $returnValue
}


function Set-TargetResource
{
    [CmdletBinding()]
    param
    (
        [parameter(Mandatory = $true)]
        [System.String]
        $Name,

        [parameter(Mandatory = $true)]
        [System.String]
        $ApplicationName,

        [ValidateSet("Present","Absent")]
        [System.String]
        $Ensure  = "Present",

        [ValidateSet("Started","Stopped")]
        [System.String]
        $State = "Started",

        [ValidateSet("v2.0","v4.0", "")]
        [System.String]
        $ManagedRuntimeVersion = "v4.0",

        [ValidateSet("Integrated","Classic")]
        [System.String]
        $ManagedPipelineMode = "Integrated",

        [ValidateSet("true","false")]
        [System.String]
        $Enable32BitAppOnWin64 = "false",

        [ValidateSet("ApplicationPoolIdentity","LocalSystem","LocalService","NetworkService","SpecificUser")]
        [System.String]
        $IdentityType = "SpecificUser",

        [parameter(Mandatory = $true)]
        [System.String]
        $UserName,

        [parameter(Mandatory = $true)]
        [System.String]
        $Password
    )

    Confirm-Dependencies

    if($Ensure -eq "Absent")
    {
        Write-Verbose("Removing the Web App Pool")
        Remove-WebAppPool $Name
    }
    else
    {
        $AppPool = Get-AppPool($Name)
        if($AppPool -eq $null)
        {
            Write-Verbose("Creating the Web App Pool")
            $AppPool = New-WebAppPool $Name
        }

        $AppPool.managedRuntimeVersion = $ManagedRuntimeVersion
        $AppPool.managedPipelineMode = $ManagedPipelineMode
        $AppPool.enable32BitAppOnWin64 = $Enable32BitAppOnWin64
        $AppPool.processModel.identityType = $IdentityType
        $AppPool.processModel.userName = $UserName
        $AppPool.processModel.password = $Password
        $AppPool | Set-Item

        if($AppPool.State -ne $State)
        {
            Execute-RequiredState -Name $Name -State $State
        }
    }
}


function Test-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Boolean])]
    param
    (
        [parameter(Mandatory = $true)]
        [System.String]
        $Name,

        [parameter(Mandatory = $true)]
        [System.String]
        $ApplicationName,

        [ValidateSet("Present","Absent")]
        [System.String]
        $Ensure  = "Present",

        [ValidateSet("Started","Stopped")]
        [System.String]
        $State = "Started",

        [ValidateSet("v2.0","v4.0", "")]
        [System.String]
        $ManagedRuntimeVersion = "v4.0",

        [ValidateSet("Integrated","Classic")]
        [System.String]
        $ManagedPipelineMode = "Integrated",

        [ValidateSet("true","false")]
        [System.String]
        $Enable32BitAppOnWin64 = "false",

        [ValidateSet("ApplicationPoolIdentity","LocalSystem","LocalService","NetworkService","SpecificUser")]
        [System.String]
        $IdentityType = "SpecificUser",

        [parameter(Mandatory = $true)]
        [System.String]
        $UserName,

        [parameter(Mandatory = $true)]
        [System.String]
        $Password
    )

    Confirm-Dependencies

    $WebAppPool = Get-TargetResource -Name $Name -ApplicationName $ApplicationName

    if($Ensure -eq "Present")
    {
        if($WebAppPool.Ensure -eq $Ensure`
         -and $WebAppPool.State -eq $state`
         -and $WebAppPool.ManagedRuntimeVersion -eq $ManagedRuntimeVersion`
         -and $WebAppPool.ManagedPipelineMode -eq $ManagedPipelineMode`
         -and $WebAppPool.Enable32BitAppOnWin64.toString() -eq $Enable32BitAppOnWin64`
         -and $WebAppPool.ProcessModel.IdentityType -eq $IdentityType`
         -and $WebAppPool.ProcessModel.UserName -eq $UserName`
         -and $WebAppPool.ProcessModel.Password -eq $Password)
        {
            return $true
        }
    }
    elseif($WebAppPool.Ensure -eq $Ensure)
    {
        return $true
    }

    return $false
}


function Get-AppPool([string] $Name)
{
    return $AppPool = Get-Item -Path "IIS:\AppPools\*" | ? {$_.name -eq $Name}
}


function Execute-RequiredState([string] $Name, [string] $State)
{
    if($State -eq "Started")
    {
        Write-Verbose("Starting the Web App Pool")
        Start-WebAppPool -Name $Name
    }
    else
    {
        Write-Verbose("Stopping the Web App Pool")
        Stop-WebAppPool -Name $Name
    }
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
