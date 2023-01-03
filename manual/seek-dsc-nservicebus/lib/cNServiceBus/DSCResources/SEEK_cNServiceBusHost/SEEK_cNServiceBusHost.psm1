function Get-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [String]$ServiceName
    )

    $service = Get-HostService $ServiceName
    if($service) {
        return @{
            ServiceName = $ServiceName
            Ensure = "Present"
            Configuration = $null
            ApplicationRoot = $null
            DisplayName = $service.DisplayName
            Description = $null
            DependsOn = $null
        }
    }

    return @{
        ServiceName = $ServiceName
        Ensure = "Absent"
        Configuration = $null
        ApplicationRoot = $null
        DisplayName = $null
        Description = $null
        DependsOn = $null
    }
}

function Set-TargetResource
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [String]$ServiceName,

        [ValidateSet("Present", "Absent")]
        [String]$Ensure = "Present",

        [ValidateSet("true", "false")]
        [String]$StartManually = "false",

        [ValidateSet("Debug", "Release")]
        [String]$Configuration = "Release",

        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [String]$ApplicationRoot,

        [ValidateNotNullOrEmpty()]
        [String]$DisplayName = $ServiceName,

        [ValidateNotNullOrEmpty()]
        [String]$Description = $DisplayName,

        [String]$DependsOn
    )

    $servicePresent = Test-HostServicePresent $ServiceName

    if (($Ensure -eq "Present") -and (!$servicePresent))
    {
        Install-HostService -ServiceName $ServiceName `
            -Configuration $Configuration `
            -ApplicationRoot $ApplicationRoot `
            -StartManually $StartManually `
            -DisplayName $DisplayName `
            -Description $Description `
            -DependsOn $DependsOn
    }
    elseif (($Ensure -eq "Absent") -and ($servicePresent))
    {
        Remove-HostService -ServiceName $ServiceName `
            -Configuration $Configuration `
            -ApplicationRoot $ApplicationRoot
    }
}

function Test-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Boolean])]
    param
    (
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [String]$ServiceName,

        [ValidateSet("Present", "Absent")]
        [String]$Ensure = "Present",

        [ValidateSet("true", "false")]
        [String]$StartManually = "false",

        [ValidateSet("Debug", "Release")]
        [String]$Configuration = "Release",

        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [String]$ApplicationRoot,

        [ValidateNotNullOrEmpty()]
        [String]$DisplayName = $ServiceName,

        [ValidateNotNullOrEmpty()]
        [String]$Description = $DisplayName,

        [String]$DependsOn
    )

    $servicePresent = Test-HostServicePresent $ServiceName

    if ($servicePresent -and ($Ensure -eq "Present")) {
        return $true
    }
    elseif ((!$servicePresent) -and ($Ensure -eq "Absent"))
    {
        return $true
    }
    return $false
}

function Get-HostService
{
    param
    (
        [parameter(Mandatory = $true)]
        [System.String]$ServiceName
    )

    return @(Get-Service $ServiceName -ErrorAction Ignore)[0]
}

function Test-HostServicePresent
{
    param
    (
        [parameter(Mandatory = $true)]
        [System.String]$ServiceName
    )

    if (Get-HostService $ServiceName)
    {
        return $true
    }
    return $false
}

function Install-HostService
{
    param
    (
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [String]$ServiceName,

        [ValidateSet("Present", "Absent")]
        [String]$Ensure = "Present",

        [ValidateSet("true", "false")]
        [String]$StartManually = "false",

        [ValidateSet("Debug", "Release")]
        [String]$Configuration = "Release",

        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [String]$ApplicationRoot,

        [ValidateNotNullOrEmpty()]
        [String]$DisplayName = $ServiceName,

        [ValidateNotNullOrEmpty()]
        [String]$Description = $DisplayName,

        [String]$DependsOn
    )

    $installArgs = @("-install",
        "-serviceName=""${ServiceName}""",
        "-displayName=""${DisplayName}""",
        "-description=""${Description}""")

    if ([System.Convert]::ToBoolean($StartManually)) { $installArgs += "-startManually" }
    if ($DependsOn) { $installArgs += "-dependsOn=""${DependsOn}""" }

    Start-Process "${ApplicationRoot}\bin\${Configuration}\NServiceBus.Host.exe" `
        -ArgumentList $installArgs `
        -Wait
}

function Remove-HostService
{
    param
    (
        [parameter(Mandatory = $true)]
        [System.String]$ServiceName,

        [ValidateSet("Debug", "Release")]
        [String]$Configuration = "Release",

        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [String]$ApplicationRoot
    )

    Start-Process "${ApplicationRoot}\bin\${Configuration}\NServiceBus.Host.exe" `
        -ArgumentList @("-uninstall", "-serviceName=""${ServiceName}""") `
        -Wait
}

#  FUNCTIONS TO BE EXPORTED
Export-ModuleMember -function Get-TargetResource, Set-TargetResource, Test-TargetResource
