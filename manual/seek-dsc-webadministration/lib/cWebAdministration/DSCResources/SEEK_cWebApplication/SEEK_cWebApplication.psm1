function Get-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [parameter(Mandatory = $true)]
        [System.String]$Website,

        [parameter(Mandatory = $true)]
        [System.String]$Name
    )

    Confirm-Dependencies

    $webApplication = Find-UniqueWebApplication -Site $Website -Name $Name
    if ($webApplication -ne $null)
    {
        return @{
            Website = $Website
            Name = $Name
            WebAppPool = $webApplication.ApplicationPool
            PhysicalPath = $webApplication.PhysicalPath
            Ensure = "Present"
            AuthenticationInfo = Get-AuthenticationInfo -Website $Website -ApplicationName $Name
            SslFlags = (Get-SslFlags -Location "${Website}/${Name}")
            EnabledProtocols = (Get-ItemProperty "IIS:\Sites\${Website}\${Name}" -Name "EnabledProtocols").Value
        }
    }

    return @{
        Website = $Website
        Name = $Name
        WebAppPool = $null
        PhysicalPath = $null
        Ensure = "Absent"
        AuthenticationInfo = $null
        SslFlags = $null
        EnabledProtocols = $null
    }
}


function Set-TargetResource
{
    [CmdletBinding()]
    param
    (
        [parameter(Mandatory = $true)]
        [System.String]$Website,

        [parameter(Mandatory = $true)]
        [System.String]$Name,

        [parameter(Mandatory = $true)]
        [System.String]$WebAppPool,

        [parameter(Mandatory = $true)]
        [System.String]$PhysicalPath,

        [ValidateNotNull()]
        [string]$SslFlags = "",

        [ValidateSet("Present","Absent")]
        [System.String]$Ensure = "Present",

        [System.String] $EnabledProtocols,

        [Parameter(Mandatory=$false, HelpMessage="Obsolete")]
        [System.String] $AutoStartMode,

        [Microsoft.Management.Infrastructure.CimInstance]$AuthenticationInfo
    )

    Confirm-Dependencies
    Stop-AppFabricApplicationServer -SiteName $Website

    try
    {
        if ($AuthenticationInfo -eq $null) { $AuthenticationInfo = Get-DefaultAuthenticationInfo }

        $webApplication = Find-UniqueWebApplication -Site $Website -Name $Name
        $webappPath = "IIS:\Sites\${Website}\${Name}"
        if ($Ensure -eq "Present")
        {

            if ($webApplication -eq $null)
            {
                Write-Verbose "Creating new Web application $Name."
                New-WebApplication -Site $Website -Name $Name -PhysicalPath $PhysicalPath -ApplicationPool $WebAppPool
            }
            else
            {
                if ($webApplication.physicalPath -ne $PhysicalPath)
                {
                    Write-Verbose "Updating physical path for Web application $Name."
                    Set-ItemProperty -Path $webappPath -Name physicalPath -Value $physicalPath
                }
                if ($webApplication.applicationPool -ne $ApplicationPool)
                {
                    Write-Verbose "Updating physical path for Web application $Name."
                    Set-ItemProperty -Path $webappPath -Name applicationPool -Value $WebAppPool
                }
            }

            Set-AuthenticationInfo -Website $Website -ApplicationName $Name -AuthenticationInfo $AuthenticationInfo -ErrorAction Stop
            Set-WebConfiguration -Location "${Website}/${Name}" -Filter 'system.webserver/security/access' -Value $SslFlags

            if ($EnabledProtocols) {
                Set-ItemProperty -Path $webappPath -Name enabledProtocols -Value $EnabledProtocols
            }
        }
        elseif (($Ensure -eq "Absent") -and ($webApplication -ne $null))
        {
            Write-Verbose "Removing existing Web Application $Name."
            Remove-WebApplication -Site $Website -Name $Name
        }
    }
    finally
    {
        Start-AppFabricApplicationServer -SiteName $Website
    }

}


function Test-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Boolean])]
    param
    (
        [parameter(Mandatory = $true)]
        [System.String]$Website,

        [parameter(Mandatory = $true)]
        [System.String]$Name,

        [parameter(Mandatory = $true)]
        [System.String]$WebAppPool,

        [parameter(Mandatory = $true)]
        [System.String]$PhysicalPath,

        [ValidateNotNull()]
        [string]$SslFlags = "",

        [ValidateSet("Present","Absent")]
        [System.String]$Ensure = "Present",

        [System.String] $EnabledProtocols,

        [Parameter(Mandatory=$false, HelpMessage="Obsolete")]
        [System.String] $AutoStartMode,

        [Microsoft.Management.Infrastructure.CimInstance]$AuthenticationInfo
    )

    Confirm-Dependencies

    if ($AuthenticationInfo -eq $null) { $AuthenticationInfo = Get-DefaultAuthenticationInfo }

    $webApplication = Get-TargetResource -Website $Website -Name $Name

    if($Ensure -eq "Present")
    {
        $enabledProtocolsMatch = if ($EnabledProtocols) { $webApplication.EnabledProtocols -eq $EnabledProtocols } else { $true }

        if(($webApplication.Ensure -eq $Ensure) `
            -and ($webApplication.PhysicalPath -eq $PhysicalPath) `
            -and ($webApplication.WebAppPool -eq $WebAppPool) `
            -and ((Get-SslFlags -Location "${Website}/${Name}") -eq $SslFlags) `
            -and (Test-AuthenticationInfo -Website $Website -ApplicationName $Name -AuthenticationInfo $AuthenticationInfo) `
            -and $enabledProtocolsMatch)
        {
            return $true
        }
    }
    elseif($webApplication.Ensure -eq $Ensure)
    {
        return $true
    }

    return $false
}

function Find-UniqueWebApplication
{
    Param
    (
        [parameter(Mandatory = $true)]
        [System.String]$Site,

        [parameter(Mandatory = $true)]
        [System.String]$Name
    )

    $webApplications = @(Get-WebApplication -Site $Site -Name $Name)

    if ($webApplications.Count -gt 1)
    {
        throw "Multiple web applications found for ""${Site}/${Name}"""
    }

    return $webApplications[0]
}

function Test-AuthenticationEnabled
{
    [OutputType([System.Boolean])]
    Param
    (
        [parameter(Mandatory = $true)]
        [System.String]$WebSite,

        [parameter(Mandatory = $true)]
        [System.String]$ApplicationName,

        [parameter(Mandatory = $true)]
        [ValidateSet("Anonymous","Basic","Digest","Windows")]
        [System.String]$Type
    )


    $prop = Get-WebConfigurationProperty `
        -Filter /system.WebServer/security/authentication/${Type}Authentication `
        -Name enabled `
        -Location "${WebSite}/${ApplicationName}"
    return $prop.Value
}

function Set-Authentication
{
    Param
    (
        [parameter(Mandatory = $true)]
        [System.String]$WebSite,

        [parameter(Mandatory = $true)]
        [System.String]$ApplicationName,

        [parameter(Mandatory = $true)]
        [ValidateSet("Anonymous","Basic","Digest","Windows")]
        [System.String]$Type,

        [System.Boolean]$Enabled
    )

    Set-WebConfigurationProperty -Filter /system.WebServer/security/authentication/${Type}Authentication `
        -Name enabled `
        -Value $Enabled `
        -Location "${WebSite}/${Name}"
}

function Get-AuthenticationInfo
{
    [OutputType([Microsoft.Management.Infrastructure.CimInstance])]
    Param
    (
        [parameter(Mandatory = $true)]
        [System.String]$WebSite,

        [parameter(Mandatory = $true)]
        [System.String]$ApplicationName
    )

    $authenticationProperties = @{}
    foreach ($type in @("Anonymous", "Basic", "Digest", "Windows"))
    {
        $authenticationProperties[$type] = [string](Test-AuthenticationEnabled -Website $Website -ApplicationName $Name -Type $type)
    }

    return New-CimInstance -ClassName SEEK_cWebApplicationAuthenticationInformation -ClientOnly -Property $authenticationProperties
}

function Test-AuthenticationInfo
{
    [OutputType([System.Boolean])]
    param
    (
        [parameter(Mandatory = $true)]
        [System.String]$Website,

        [parameter(Mandatory = $true)]
        [System.String]$ApplicationName,

        [parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [Microsoft.Management.Infrastructure.CimInstance]$AuthenticationInfo
    )

    $result = $true

    foreach ($type in @("Anonymous", "Basic", "Digest", "Windows"))
    {

        $expected = $AuthenticationInfo.CimInstanceProperties[$type].Value
        $actual = Test-AuthenticationEnabled -Website $Website -ApplicationName $ApplicationName -Type $type
        if ($expected -ne $actual)
        {
            $result = $false
            break
        }
    }

    return $result
}

function Set-AuthenticationInfo
{
    param
    (
        [parameter(Mandatory = $true)]
        [System.String]$WebSite,

        [parameter(Mandatory = $true)]
        [System.String]$ApplicationName,

        [parameter()]
        [ValidateNotNullOrEmpty()]
        [Microsoft.Management.Infrastructure.CimInstance]$AuthenticationInfo
    )

    foreach ($type in @("Anonymous", "Basic", "Digest", "Windows"))
    {
        $enabled = ($AuthenticationInfo.CimInstanceProperties[$type].Value -eq $true)
        Set-Authentication -Website $Website -ApplicationName $ApplicationName -Type $type -Enabled $enabled
    }
}

function Get-DefaultAuthenticationInfo
{
    New-CimInstance -ClassName SEEK_cWebApplicationAuthenticationInformation `
        -ClientOnly `
        -Property @{Anonymous="false";Basic="false";Digest="false";Windows="false"}
}

function Get-SslFlags
{
    [CmdletBinding()]
    param
    (
        [System.String]$Location
    )

    $sslFlags = Get-WebConfiguration -PSPath IIS:\Sites -Location $Location -Filter 'system.webserver/security/access' | % { $_.sslFlags }
    $sslFlags = if ($sslFlags -eq $null) { "" } else { $sslFlags }
    return $sslFlags
}

function Stop-AppFabricApplicationServer
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]$SiteName
    )

    Write-Debug "Checking whether App Fabric is installed."
    Get-Module -ListAvailable -Name ApplicationServer -OutVariable applicationServerModule 4>&1 | Out-Null
    if($applicationServerModule)
    {
        Import-Module ApplicationServer 4>&1 | Out-Null
        Stop-ASApplication -SiteName $SiteName
    }
}

function Start-AppFabricApplicationServer
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]$SiteName
    )

    Write-Debug "Checking whether App Fabric is installed."
    Get-Module -ListAvailable -Name ApplicationServer -OutVariable applicationServerModule 4>&1 | Out-Null
    if($applicationServerModule)
    {
        Import-Module ApplicationServer 4>&1 | Out-Null
        Start-ASApplication -SiteName $SiteName
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

