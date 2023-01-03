function Get-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [parameter(Mandatory = $true)]
        [System.String] $Site
    )

    Confirm-Dependencies

    get-BindingsResource (get-BindingConfigElements $Site) $Site
}

function Test-TargetResource
{
    [CmdletBinding()]
    param
    (
        [parameter(Mandatory = $true)]
        [System.String] $Site,

        [ValidateSet("Present","Absent")]
        [System.String]
        $Ensure  = "Present",

        [Microsoft.Management.Infrastructure.CimInstance[]]
        $Bindings = @(),

        [System.Boolean]
        $Clear = $false
    )

    Confirm-Dependencies

    $currentCimBindings = get-CurrentCimBindings $Site
    $commonCimBindings = select-CommonCimBindings (new-CimBindingsWithBindingInformation $Bindings) $currentCimBindings

    if (($Ensure -eq "Absent") -and $Clear) { return (@($currentCimBindings).count -eq 0) -and (@($commonCimBindings).count -eq 0) }
    if ($Ensure -eq "Absent") { return @($commonCimBindings).count -eq 0 }

    if ($Clear) { return $currentCimBindings.count -eq $commonCimBindings.count }
    return (@($commonCimBindings).count -eq $Bindings.count)
}

function Set-TargetResource
{
    [CmdletBinding()]
    param
    (
        [parameter(Mandatory = $true)]
        [System.String] $Site,

        [ValidateSet("Present","Absent")]
        [System.String]
        $Ensure  = "Present",

        [Microsoft.Management.Infrastructure.CimInstance[]]
        $Bindings = @(),

        [System.Boolean]
        $Clear = $false
    )

    Confirm-Dependencies
    Stop-AppFabricApplicationServer -SiteName $Site

    try
    {
        $newCimBindings = new-CimBindingsForSite $Ensure $Bindings $Site $Clear
        $sitePath = $("IIS:\Sites\${Site}")
        Set-ItemProperty -Path $sitePath -Name bindings -Value (new-BindingsValue $newCimBindings)
        $newCimBindings | Where-Object Protocol -eq "https" | ForEach-Object { add-SslCertificateForHttpsCimBinding $_ }

        $protocols = $newCimBindings | Select-Object -ExpandProperty Protocol -Unique
        Set-ItemProperty $sitePath -Name EnabledProtocols -Value ($protocols -join ',')
    }
    finally
    {
        Start-AppFabricApplicationServer -SiteName $Site
    }

}

function New-CimBinding
{
    [CmdletBinding()]
    param
    (
        [System.String] $BindingInformation,
        [System.String] $Protocol
    )

    New-CimInstance -ClassName SEEK_cBinding -ClientOnly -Property @{
        BindingInformation = $BindingInformation
        Protocol = $Protocol
    }
}

function New-HttpCimBinding {
    [CmdletBinding()]
    param
    (
        [System.String] $HostName,
        [System.String] $IPAddress,
        [System.UInt16] $Port
    )

    New-CimInstance -ClassName SEEK_cBinding -ClientOnly -Property @{
        HostName = $HostName
        IPAddress = $IPAddress
        Port = $Port
        Protocol = "http"
    }
}

function New-HttpsCimBinding {
    [CmdletBinding()]
    param
    (
        [System.String] $CertificatePath,
        [System.String] $CertificateSubject,
        [System.String] $IPAddress,
        [System.UInt16] $Port
    )

    New-CimInstance -ClassName SEEK_cBinding -ClientOnly -Property @{
        CertificatePath = $CertificatePath
        CertificateSubject = $CertificateSubject
        IPAddress = $IPAddress
        Port = $Port
        Protocol = "https"
    }
}

function add-SslCertificateForHttpsCimBinding
{
    [CmdletBinding()]
    param($httpsCimBinding)

    $ip = get-HttpSysIp $httpsCimBinding.IPAddress
    $path = $httpsCimBinding.CertificatePath
    $port = $httpsCimBinding.Port
    $thumbprint = get-CertificateThumbprint $httpsCimBinding

    $sslBindingPath = "IIS:\SslBindings\${ip}!${port}"

    if (Test-Path $sslBindingPath) {
        Write-Verbose "SSL binding for endpoint ${ip}:${port} alerady exists."
        Write-Verbose "Clobbering with new SSL binding."
        Remove-Item $sslBindingPath
    }

    Get-Item "${path}\${thumbprint}" | New-Item $sslBindingPath
}

function compare-CimBindings {
    [CmdletBinding()]
    param
    (
        $cimBinding,
        $otherCimBinding
    )

    $matchingBindingInformation = $cimBinding.BindingInformation -eq $otherCimBinding.BindingInformation
    $matchingProtocol = $cimBinding.Protocol -eq $otherCimBinding.Protocol

    if (-not ($matchingBindingInformation -and $matchingProtocol)) { return $false }

    $true
}

function containsCimBinding {
    [CmdletBinding()]
    param($bindings, $binding)

    $result = $false
    $bindings | ForEach-Object { if(compare-CimBindings $_ $binding) { $result = $true } }
    $result
}

function get-BindingConfigElements
{
    [CmdletBinding()]
    param
    (
        [parameter(Mandatory = $true)]
        [System.String] $Site
    )

    (Get-ItemProperty "IIS:\Sites\${Site}" -Name bindings)
}

function get-BindingInformation
{
    [CmdletBinding()]
    param($binding)

    if($binding.BindingInformation -ne $null) { return $binding.BindingInformation }

    switch ($binding.Protocol)
    {
        "http"
        { get-HttpBindingInformation $binding }
        "https"
        { get-HttpsBindingInformation $binding }
    }
}

function get-BindingsResource
{
    [CmdletBinding()]
    param($bindingConfigElements, $site)

    $result = @{
        Bindings = @()
        Ensure = "Absent"
        Site = $site
    }

    if($bindingConfigElements.count -ne 0) {
        $result.Bindings = new-CimBindingsFromConfigElements $bindingConfigElements
        $result.Ensure = "Present"
    }

    $result
}

function get-CertificateThumbprint
{
    [CmdletBinding()]
    param($httpsCimBinding)

    (Get-ChildItem -Path $httpsCimBinding.CertificatePath | Where Subject -eq $httpsCimBinding.CertificateSubject).Thumbprint
}

function get-CurrentCimBindings
{
    [CmdletBinding()]
    param($site)

    (Get-TargetResource -Site $site).Bindings
}

function get-HttpBindingInformation
{
    [CmdletBinding()]
    param($httpBinding)

    $hostName = $httpBinding.HostName
    $ipAddress = $httpBinding.IPAddress
    $port = $httpBinding.Port

    "${ipAddress}:${port}:${hostName}"
}

function get-HttpsBindingInformation
{
    [CmdletBinding()]
    param($httpsBinding)

    $ipAddress = $httpsBinding.IPAddress
    $port = $httpsBinding.Port

    "${ipAddress}:${port}:"
}

function get-HttpSysIp
{
    [CmdletBinding()]
    param($ip)

    if ($ip -eq "*") { return "0.0.0.0" }
    $ip
}

function new-CimBindingsForSite {
    [CmdletBinding()]
    param($ensure, $cimBindings, $site, $clear = $false)

    $currentCimBindings = @()

    if (!$clear) { $currentCimBindings = @(get-CurrentCimBindings $site) }

    if ($Ensure -eq "Absent") {
        return select-FromCimBindingsWithoutCimBindings -From $currentCimBindings -Without $cimBindings
    }

    $newBindings = $currentCimBindings
    $newBindings += $cimBindings
    return $newBindings
}

function new-BindingsValue
{
    [CmdletBinding()]
    param($bindings)

    (new-CimBindingsWithBindingInformation $bindings) | ForEach-Object {
        @{
            bindingInformation = $_.BindingInformation
            protocol = $_.Protocol
        }
    }
}

function new-CimBindingsWithBindingInformation
{
    [CmdletBinding()]
    param($cimBindings)

    $cimBindings | ForEach-Object {
        new-CimBindingFromHash @{
            BindingInformation = get-BindingInformation $_
            CertificatePath = $_.CertificatePath
            CertificateSubject = $_.CertificateSubject
            HostName = $_.HostName
            IPAddress = $_.IPAddress
            Port = $_.Port
            Protocol = $_.Protocol
        }
    }
}

function new-CimBindingFromConfigElement
{
    [CmdletBinding()]
    param($bindingConfigElement)

    $bindingHash = @{
        BindingInformation = $bindingConfigElement.bindingInformation
        Protocol = $bindingConfigElement.protocol
    }

    if ($bindingHash.Protocol -eq "https") {
        $bindingHash.CertificatePath = $bindingConfigElement.certificatePath
        $bindingHash.CertificateSubject = $bindingConfigElement.certificateSubject
    }

    new-CimBindingFromHash $bindingHash
}

function new-CimBindingsFromConfigElements
{
    [CmdletBinding()]
    param($bindingConfigElements)

    $bindingConfigElements.collection | ForEach-Object { new-CimBindingFromConfigElement $_ }
}

function new-CimBindingFromHash
{
    [CmdletBinding()]
    param($bindingHash)

    New-CimInstance -ClassName SEEK_cBinding -ClientOnly -Property (new-HashWithoutNullValues $bindingHash)
}

function new-HashWithoutNullValues
{
    [CmdletBinding()]
    param($hashtable)

    $result = @{}
    $hashtable.Keys | Where { $hashtable.$_ -ne $null } | ForEach { $result.$_ = ($hashtable.$_) }
    $result
}

function select-CommonCimBindings
{
    [CmdletBinding()]
    param($cimBindings, $otherCimBindings)

    $cimBindings | Where-Object { containsCimBinding $otherCimBindings $_ }
}

function select-FromCimBindingsWithoutCimBindings
{
    [CmdletBinding()]
    param($from, $without)

    $from | Where-Object { -not (containsCimBinding $without $_) }
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

