function Get-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String]$Protocol = "http",

        [parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String]$Hostname = "*",

        [parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String]$Port
    )

    $url = Get-Url $Protocol $Hostname $Port
    $urlAclOutput = (Invoke-NetshUrlAcl -Protocol $Protocol -Operation "show" -Url $url)
    $urlReservationExists = $urlAclOutput -match "User:\s(.+?)\s"

    if (!$urlReservationExists)
    {
        return @{
            Protocol = $Protocol
            Hostname = $Hostname
            Port = $Port
            User = $null
            Ensure = "Absent"
        }
    }

    $user = $Matches[1]
    return @{
        Protocol = $Protocol
        Hostname = $Hostname
        Port = $Port
        User = $user
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
        [String]$Protocol = "http",

        [parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String]$Hostname = "*",

        [parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String]$Port,

        [parameter(Mandatory=$true,ParameterSetName = "Present")]
        [ValidateNotNullOrEmpty()]
        [String]$User,

        [parameter(Mandatory=$false,ParameterSetName = "Present")]
        [parameter(Mandatory=$true,ParameterSetName = "Absent")]
        [ValidateSet("Present","Absent")]
        [System.String]
        $Ensure  = "Present"
    )

    if ($Ensure -eq "Present")
    {
        New-UrlReservation -Protocol $Protocol -Hostname $Hostname -Port $Port -User $User
    }
    else
    {
        Remove-UrlReservation -Protocol $Protocol -Hostname $Hostname -Port $Port
    }
}

function Test-TargetResource
{
    [CmdletBinding(DefaultParameterSetName = "Absent")]
    param
    (
        [parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String]$Protocol = "http",

        [parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String]$Hostname = "*",

        [parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String]$Port,

        [parameter(Mandatory=$true,ParameterSetName = "Present")]
        [ValidateNotNullOrEmpty()]
        [String]$User,

        [parameter(Mandatory=$false,ParameterSetName = "Present")]
        [parameter(Mandatory=$true,ParameterSetName = "Absent")]
        [ValidateSet("Present","Absent")]
        [System.String]
        $Ensure  = "Present"
    )

    $urlReservation = Get-TargetResource -Protocol $Protocol -Hostname $Hostname -Port $Port

    if ($Ensure -eq "Absent" -and $urlReservation.Ensure -eq "Absent")
    {
        return $true
    }

    if ($Ensure -eq "Present" `
        -and $urlReservation.Ensure -eq "Present" `
        -and $urlReservation.Protocol -eq $Protocol `
        -and $urlReservation.Hostname -eq $Hostname `
        -and $urlReservation.Port -eq $Port `
        -and $urlReservation.User -eq $User)
    {
        return $true
    }

    return $false
}

function New-UrlReservation
{
    [CmdletBinding()]
    param
    (
        [parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String]$Protocol = "http",

        [parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String]$Hostname = "*",

        [parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String]$Port,

        [ValidateNotNullOrEmpty()]
        [String]$User
    )

    $url = Get-Url $Protocol $Hostname $Port
    Invoke-NetshUrlAcl -Protocol $Protocol -Operation "add" -Url $url -User $User
}

function Remove-UrlReservation
{
    [CmdletBinding()]
    param
    (
        [parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String]$Protocol = "http",

        [parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String]$Hostname = "*",

        [parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String]$Port
    )

    $url = Get-Url $Protocol $Hostname $Port
    Invoke-NetshUrlAcl -Protocol $Protocol -Operation "del" -Url $url
}

function Get-Url
{
    [CmdletBinding()]
    param
    (
        [parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String]$Protocol = "http",

        [parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String]$Hostname = "*",

        [parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String]$Port
    )

    return "${Protocol}://${Hostname}:${Port}/"
}

function Invoke-NetshUrlAcl
{
    [CmdletBinding()]
    [OutputType([System.String])]
    param
    (
        [parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String]$Protocol = "http",

        [parameter(Mandatory = $true)]
        [ValidateSet("add","del","show")]
        [String]$Operation,

        [parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String]$Url,

        [String]$User
    )
    $argumentList = @(
        $Protocol, $Operation, 'urlacl',
        "url=""${Url}"""
    )
    if ($user)
    {
        $argumentList += "user=""${User}"""
    }
    $outputPath = "${env:TEMP}\netsh.out"
    $process = Start-Process netsh -ArgumentList $argumentList -Wait -NoNewWindow -RedirectStandardOutput $outputPath -Passthru
    if ($process.ExitCode -ne 0) { throw "Error performing operation '${Operation}' for reserved url"}
    return ((Get-Content $outputPath) -join "`n")
}


Export-ModuleMember -function Get-TargetResource, Set-TargetResource, Test-TargetResource
