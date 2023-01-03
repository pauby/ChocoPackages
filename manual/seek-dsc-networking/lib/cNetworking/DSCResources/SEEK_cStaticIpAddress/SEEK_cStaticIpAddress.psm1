# NOTE: Supports IPv4 addresses only

function Get-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [System.String]$IpAddress
    )


    $networkAdapterConfiguration = Get-NetworkAdapterConfigurationByIpAddress $IpAddress

    if ($networkAdapterConfiguration -eq $null)
    {
        return @{
            IpAddress = $IpAddress
            Interface = $null
            SubnetMask = $null
            DHCPEnabled = $null
            Ensure = "Absent"
        }
    }

    $networkAdapter = Get-NetworkAdapterByIndex $networkAdapterConfiguration.Index
    $ipAddressList = $networkAdapterConfiguration.IPAddress | Where-IPv4Address
    $ipSubnetList = $networkAdapterConfiguration.IPSubnet | Where-IPv4Subnet
    $ipAddressIndex = $ipAddressList.IndexOf($IpAddress)

    return @{
        IpAddress = $IpAddress
        Interface = $networkAdapter.NetConnectionID
        SubnetMask = @($ipSubnetList)[$ipAddressIndex]
        DHCPEnabled = $networkAdapterConfiguration.DHCPEnabled
        Ensure = "Present"
    }
}

function Set-TargetResource
{
    [CmdletBinding()]
    param
    (
        [parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [System.String]$IpAddress,

        [parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [System.String]$Interface,

        [parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [System.String]$SubnetMask,

        [ValidateSet("Present","Absent")]
        [System.String]
        $Ensure  = "Present"
    )

    if(!([System.Net.Ipaddress]::TryParse($IpAddress, [ref]0))) { throw "IP Address ""$IpAddress"" is invalid"}
    if(!([System.Net.Ipaddress]::TryParse($SubnetMask, [ref]0))) { throw "SubnetMask ""$SubnetMask"" is invalid"}

    if ($Ensure -eq "Absent")
    {
        Remove-IpAddress -IpAddress $IpAddress -Interface $Interface
    }
    else
    {
        Add-IpAddress -IpAddress $IpAddress -Interface $Interface -SubnetMask $SubnetMask
    }
}

function Test-TargetResource
{
    [CmdletBinding()]
    param
    (
        [parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [System.String]$IpAddress,

        [parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [System.String]$Interface,

        [parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [System.String]$SubnetMask,

        [ValidateSet("Present","Absent")]
        [System.String]
        $Ensure  = "Present"
    )

    $existingIpAddress = Get-TargetResource $IpAddress

    if ($Ensure -eq "Present" -and `
        $existingIpAddress -ne $null -and `
        $existingIpAddress.Interface -eq $Interface -and `
        $existingIpAddress.SubnetMask -eq $SubnetMask -and `
        $existingIpAddress.Ensure -eq $Ensure -and `
        $existingIpAddress.DHCPEnabled -eq $false)
    {
        return $true
    }
    elseif ($Ensure -eq "Absent" -and `
        $existingIpAddress.Ensure -eq $Ensure)
    {
        return $true
    }

    return $false
}

function Add-IpAddress
{
    param
    (
        [parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [System.String]$IpAddress,

        [parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [System.String]$Interface,

        [parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [System.String]$SubnetMask
    )

    $networkAdapterConfiguration = Get-NetworkAdapterConfigurationByInterface $Interface

    if (Test-IpAddressBound -IpAddress $IpAddress -Index $networkAdapterConfiguration.Index -SubnetMask $SubnetMask) { return }

    if (Test-IpAddressBound $IpAddress)
    {
        Remove-IpAddress -IpAddress $IpAddress
    }

    $ipAddressList = $networkAdapterConfiguration.IPAddress + @($IpAddress) | Where-IPv4Address
    $ipSubnetList = $networkAdapterConfiguration.IPSubnet + @($SubnetMask) | Where-IPv4Subnet

    Enable-Static -NetworkAdapterConfiguration $networkAdapterConfiguration `
        -IpAddresses $ipAddressList `
        -IpSubnets $ipSubnetList
}

function Remove-IpAddress
{
    param
    (
        [parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [System.String]$IpAddress,

        [parameter(Mandatory = $false)]
        [System.String]$Interface = $null
    )

    $networkAdapterConfiguration = $null
    if ($Interface)
    {
        $networkAdapterConfiguration = Get-NetworkAdapterConfigurationByInterface $Interface
    }
    else
    {
        $networkAdapterConfiguration = Get-NetworkAdapterConfigurationByIpAddress $IpAddress
    }

    $ipAddressList = [System.Collections.ArrayList]@($networkAdapterConfiguration.IPAddress | Where-IPv4Address)
    $ipSubnetList = [System.Collections.ArrayList]@($networkAdapterConfiguration.IPSubnet | Where-IPv4Subnet)

    $ipAddressIndex = $ipAddressList.IndexOf($IpAddress)
    if ($ipAddressIndex -lt 0) {return}
    $ipAddressList.RemoveAt($ipAddressIndex)
    $ipSubnetList.RemoveAt($ipAddressIndex)

    if ($ipAddressList.Length -gt 0)
    {
        Enable-Static -NetworkAdapterConfiguration $networkAdapterConfiguration `
            -IpAddresses ([Object[]]$ipAddressList) `
            -IpSubnets ([Object[]]$ipSubnetList)
    }
    else
    {
        # Adapter is no longer bound to any IP addresses
        # Reverting adapter to DHCP
        Enable-DHCP -NetworkAdapterConfiguration $networkAdapterConfiguration
    }
}

function Where-IPv4Address
{
    [CmdletBinding()]
    param
    (
        [parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [String]
        $InputObject
    )

    process
    {
        if ($InputObject -notmatch ":")
        {
            Write-Output $InputObject
        }
    }
}

function Where-IPv4Subnet
{
    [CmdletBinding()]
    param
    (
        [parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [String]
        $InputObject
    )

    process
    {
        if ($InputObject -match "\d+\.\d+\.\d+\.\d+")
        {
            Write-Output $InputObject
        }
    }
}

function Get-NetworkAdapterByIndex
{
    param
    (
        [parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [Int32]$Index
    )

    $networkAdapter = Get-WmiObject Win32_NetworkAdapter | ? {$_.Index -eq $Index}
    $results = $networkAdapter | measure
    if ($results.count -le 0)
    {
        throw "Could not find a network adapter with index ""$Index"""
    }
    elseif ($results.count -gt 1)
    {
        $matchingAdapters = ($networkAdapter | % Path) -join ", "
        throw "Multiple network adapters match the index ""$Index"" {$matchingAdapters}"
    }

    return ($networkAdapter | Select-Object -First 1)
}

function Get-NetworkAdapterByInterface
{
    param
    (
        [parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [System.String]$Interface
    )



    $networkAdapter = Get-WmiObject Win32_NetworkAdapter | ? {$_.NetConnectionID -eq $Interface}
    $results = $networkAdapter | measure
    if ($results.count -le 0)
    {
        throw "Could not find a network adapter matching ""$Interface"""
    }
    elseif ($results.count -gt 1)
    {
        $matchingAdapters = ($networkAdapter | % Path) -join ", "
        throw "Multiple network adapters match the interface ""$Interface"" {$matchingAdapters}"
    }


    return ($networkAdapter | Select-Object -First 1)
}

function Get-NetworkAdapterConfigurationByInterface
{
    param
    (
        [parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [System.String]$Interface
    )

    $networkAdapter = Get-NetworkAdapterByInterface $Interface
    return (Get-WmiObject Win32_NetworkAdapterConfiguration | ? {$_.Index -eq $networkAdapter.Index} | Select-Object -First 1)
}

function Get-NetworkAdapterConfigurationByIpAddress
{
    param
    (
        [parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [System.String]$IpAddress
    )

    $networkAdapterConfiguration = Get-WmiObject Win32_NetworkAdapterConfiguration | ? {$_.IPAddress -contains $IpAddress}

    $results = $networkAdapterConfiguration | measure
    if ($results.count -gt 1)
    {
        $matchingAdapters = ($networkAdapterConfiguration | % Path) -join ", "
        throw "IP Address ""$IpAddress"" is bound to multiple network adapters {$matchingAdapters}"
    }

    return ($networkAdapterConfiguration | Select-Object -First 1)
}

function Test-IpAddressBound
{
    [OutputType([Boolean])]
    param
    (
        [parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [System.String]$IpAddress,

        [parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [Int32]$Index,

        [parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [System.String]$SubnetMask
    )

    $networkAdapterConfiguration = Get-WmiObject Win32_NetworkAdapterConfiguration | ? {$_.IPAddress -contains $IpAddress}

    if ($Index)
    {
        $networkAdapterConfiguration = $networkAdapterConfiguration | ? {$_.Index -eq $Index}
    }

    if ($SubnetMask)
    {
        $networkAdapterConfiguration = $networkAdapterConfiguration | ? {$_.IPSubnet[$_.IPAddress.IndexOf($IpAddress)] -eq $SubnetMask}
    }

    $results = $networkAdapterConfiguration | measure

    if ($results.count -le 0) { return $false } else { return $true }
}

function Enable-Static
{
    [CmdletBinding()]
    param
    (
        [parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [System.String[]]$IpAddresses,

        [parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [System.String[]]$IpSubnets,

        [parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [Object]$NetworkAdapterConfiguration
    )

    $result = $NetworkAdapterConfiguration.EnableStatic($IpAddresses, $IpSubnets)
    if ($result.ReturnValue -ne 0) { throw "Failed to enable static IP addresses on network adapter with index ""$($NetworkAdapterConfiguration.Index)"" {$($IpAddresses -join ", ")}"}
}

function Enable-DHCP
{
    [CmdletBinding()]
    param
    (
        [parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [Object]$NetworkAdapterConfiguration
    )

    $result = $NetworkAdapterConfiguration.EnableDHCP()
    if ($result.ReturnValue -ne 0) { throw "Failed to enable DHCP on network adapter with index ""$($NetworkAdapterConfiguration.Index)"""}
}

Export-ModuleMember -function Get-TargetResource, Set-TargetResource, Test-TargetResource
