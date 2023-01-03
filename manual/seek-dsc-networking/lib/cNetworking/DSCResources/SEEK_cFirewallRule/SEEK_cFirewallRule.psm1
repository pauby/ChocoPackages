function Get-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [System.String]$Name
    )


    try
    {
        $advFirewallOutput = (Invoke-NetshAdvFirewall -Name $Name -Operation "show")
        $firewallRuleExists = $advFirewallOutput -match "Rule Name:\s+$Name\s+"
    }
    catch
    {
        $firewallRuleExists = $false
    }

    if (-not $firewallRuleExists)
    {
        return @{
            Name = $Name
            Direction = $null
            LocalPort = $null
            Protocol = $null
            Action = $null
            Ensure = "Absent"
        }
    }

    if ($advFirewallOutput -match "Direction:\s+(.+?)\s+")
    {
        $direction = switch ($Matches[1])
        {
            "in" {"Inbound"}
            "out" {"Outbound"}
        }
    }
    if ($advFirewallOutput -match "LocalPort:\s+(.+?)\s+")
    {
        $localport = $Matches[1]
    }
    if ($advFirewallOutput -match "Protocol:\s+(.+?)\s+")
    {
        $protocol = $Matches[1]
    }
    if ($advFirewallOutput -match "Action:\s+(.+?)\s+")
    {
        $action = $Matches[1]
    }

    return @{
        Name = $Name
        Direction = $direction
        LocalPort = $localPort
        Protocol = $protocol
        Action = $action
        Ensure = "Present"
    }
}

function Set-TargetResource
{
    [CmdletBinding(DefaultParameterSetName = "Absent")]
    param
    (
        [parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [System.String]$Name,

        [parameter(Mandatory=$true,ParameterSetName = "Present")]
        [ValidateSet("Inbound","Outbound")]
        [System.String]$Direction,

        [parameter(Mandatory=$true,ParameterSetName = "Present")]
        [ValidateNotNullOrEmpty()]
        [System.String]$LocalPort,

        [parameter(Mandatory=$true,ParameterSetName = "Present")]
        [ValidateSet("TCP","UDP")]
        [System.String]$Protocol,

        [parameter(Mandatory=$true,ParameterSetName = "Present")]
        [ValidateSet("Allow","Block", "Bypass")]
        [System.String]$Action,

        [parameter(Mandatory=$false,ParameterSetName = "Present")]
        [parameter(Mandatory=$true,ParameterSetName = "Absent")]
        [ValidateSet("Present","Absent")]
        [System.String]
        $Ensure  = "Present"
    )

    if ($Ensure -eq "Present")
    {
        New-NetFirewallRule -Name $Name `
            -Direction $Direction `
            -LocalPort $LocalPort `
            -Protocol $Protocol `
            -Action $Action
    }
    else
    {
        Remove-NetFirewallRule -Name $Name
    }
}

function Test-TargetResource
{
    [CmdletBinding(DefaultParameterSetName = "Absent")]
    param
    (
        [parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [System.String]$Name,

        [parameter(Mandatory=$true,ParameterSetName = "Present")]
        [ValidateSet("Inbound","Outbound")]
        [System.String]$Direction,

        [parameter(Mandatory=$true,ParameterSetName = "Present")]
        [ValidateNotNullOrEmpty()]
        [System.String]$LocalPort,

        [parameter(Mandatory=$true,ParameterSetName = "Present")]
        [ValidateSet("TCP","UDP")]
        [System.String]$Protocol,

        [parameter(Mandatory=$true,ParameterSetName = "Present")]
        [ValidateSet("Allow","Block", "Bypass")]
        [System.String]$Action,

        [parameter(Mandatory=$false,ParameterSetName = "Present")]
        [parameter(Mandatory=$true,ParameterSetName = "Absent")]
        [ValidateSet("Present","Absent")]
        [System.String]
        $Ensure  = "Present"
    )

    $firewallRule = Get-TargetResource -Name $Name

    if ($Ensure -eq "Absent" -and $firewallRule.Ensure -eq "Absent")
    {
        return $true
    }

    if ($Ensure -eq "Present" `
        -and $firewallRule.Ensure -eq "Present" `
        -and $firewallRule.Direction -eq $Direction `
        -and $firewallRule.LocalPort -eq $LocalPort `
        -and $firewallRule.Protocol -eq $Protocol `
        -and $firewallRule.Action -eq $Action)
    {
        return $true
    }

    return $false
}

function New-NetFirewallRule
{
    param
    (
        [parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String]$Name,

        [String]$Protocol,

        [String]$LocalPort,

        [ValidateSet("Inbound", "Outbound")]
        [String]$Direction,

        [ValidateSet("Allow", "Block", "Bypass")]
        [String]$Action
    )

    Invoke-NetshAdvFirewall -Name $Name `
        -Operation "add" `
        -Protocol $Protocol `
        -LocalPort $LocalPort `
        -Direction $Direction `
        -Action $Action
}

function Remove-NetFirewallRule
{
    param
    (
        [parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String]$Name
    )

    Invoke-NetshAdvFirewall -Name $Name -Operation "del"
}

function Invoke-NetshAdvFirewall
{
    [CmdletBinding()]
    [OutputType([System.String])]
    param
    (
        [parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String]$Name,

        [parameter(Mandatory = $true)]
        [ValidateSet("add","del","show")]
        [String]$Operation,

        [String]$Protocol,

        [String]$LocalPort,

        [ValidateSet("Inbound", "Outbound")]
        [String]$Direction,

        [ValidateSet("Allow", "Block", "Bypass")]
        [String]$Action
    )

    $argumentList = @(
        'advfirewall', 'firewall', $Operation, 'rule',
        "name=""${Name}"""
    )

    if ($Direction)
    {
        $dir = switch ($Direction)
        {
            "Inbound" {"in"}
            "Outbound" {"out"}
        }
        $argumentList += "dir=$dir"
    }

    if ($Protocol)
    {
        $argumentList += "protocol=$Protocol"
    }

    if ($LocalPort)
    {
        $argumentList += "localport=$LocalPort"
    }

    if ($Action)
    {
        $argumentList += "action=$Action"
    }

    $outputPath = "${env:TEMP}\netsh.out"
    $process = Start-Process netsh -ArgumentList $argumentList -Wait -NoNewWindow -RedirectStandardOutput $outputPath -Passthru
    if ($process.ExitCode -ne 0) { throw "Error performing operation '$Operation' for firewall rule"}
    return ((Get-Content $outputPath) -join "`n")
}

Export-ModuleMember -function Get-TargetResource, Set-TargetResource, Test-TargetResource
