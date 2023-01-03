<#######################################################################################
 #  MSDSCPack_IPAddress : DSC Resource that will set/test/get the current IP
 #  Address, by accepting values among those given in MSDSCPack_IPAddress.schema.mof
 #######################################################################################>



######################################################################################
# The Get-TargetResource cmdlet.
# This function will get the present list of IP Address DSC Resource schema variables on the system
######################################################################################
function Get-TargetResource
{
    param
    (
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [String]$IPAddress,

        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [String]$NodeName
    )

    Write-Warning "SEEK_cIPAddress resource is obsolete, please use SEEK_cStaticIpAddress"

    $returnValue = @{
    }

    $returnValue
}

######################################################################################
# The Set-TargetResource cmdlet.
# This function will set a new IP Address in the current node
######################################################################################
function Set-TargetResource
{
    param
    (
        #IP Address that has to be set
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [String]$IPAddress,

        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [String]$NodeName
    )

    Write-Warning "SEEK_cIPAddress resource is obsolete, please use SEEK_cStaticIpAddress"

    ValidateProperties @PSBoundParameters
}

######################################################################################
# The Test-TargetResource cmdlet.
# This will test if the given IP Address is among the current node's IP Address collection
######################################################################################
function Test-TargetResource
{
    param
    (
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [String]$IPAddress,

        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [String]$NodeName
    )

    Write-Warning "SEEK_cIPAddress resource is obsolete, please use SEEK_cStaticIpAddress"

    $result = ValidateProperties @PSBoundParameters

    if ($result -eq $false)
    {
        $errorId = "WebsiteBindingConflictOnStart";
        $errorCategory = [System.Management.Automation.ErrorCategory]::InvalidResult
        $errorMessage = "IPAddress $IPAddress not found..."
        $exception = New-Object System.InvalidOperationException $errorMessage
        $errorRecord = New-Object System.Management.Automation.ErrorRecord $exception, $errorId, $errorCategory, $null

        $PSCmdlet.ThrowTerminatingError($errorRecord);
    }

    $result
}


#######################################################################################
#  Helper function that validates the IP Address properties. If the switch parameter
# "Apply" is set, then it will set the properties after a test
#######################################################################################
function ValidateProperties
{
    param
    (
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [String]$IPAddress,

        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [String]$NodeName,

        [Switch]$Apply
    )

    $ip = $IPAddress

    if(!([System.Net.Ipaddress]::TryParse($ip, [ref]0)))
    {
       throw "IP Address *$IPAddress* is not in the correct format. Please correct the ipaddress in the configuration and try again"
    }
    try
    {
        #Write-Verbose -Message "Checking the IPAddress ..."
        $Networks = Get-WmiObject Win32_NetworkAdapterConfiguration -ComputerName $NodeName | ? {$_.IPEnabled}

        foreach($Network in $Networks)
        {
            if ($Network.IPAddress.Contains($IPAddress))
            {
                return $true
                break;
            }
        }
        Write-Verbose -Message "IPAddressFound $IPAddressFound"
        return $false
    }
    catch
    {
       Write-Verbose -Message $_
       throw "Can not set or find valid IPAddress using InterfaceAlias $InterfaceAlias and AddressFamily $AddressFamily"
    }
}



#  FUNCTIONS TO BE EXPORTED
Export-ModuleMember -function Get-TargetResource, Set-TargetResource, Test-TargetResource
