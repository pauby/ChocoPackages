data LocalizedData
{
    # culture="en-US"
    ConvertFrom-StringData @'
SetTargetResourceInstallwhatIfMessage=Trying to create website "{0}".
SetTargetResourceUnInstallwhatIfMessage=Trying to remove website "{0}".
WebsiteNotFoundError=The requested website "{0}" is not found on the target machine.
WebsiteDiscoveryFailureError=Failure to get the requested website "{0}" information from the target machine.
WebsiteCreationFailureError=Failure to successfully create the website "{0}".
WebsiteRemovalFailureError=Failure to successfully remove the website "{0}".
WebsiteUpdateFailureError=Failure to successfully update the properties for website "{0}".
WebsiteBindingUpdateFailureError=Failure to successfully update the binding "{0}" for website "{1}".
WebsiteBindingInputInvalidationError=Desired website bindings not valid for website "{0}".
WebsiteCompareFailureError=Failure to successfully compare properties for website "{0}".
WebBindingCertifcateError=Failure to add certificate to web binding. Please make sure that the certificate thumbprint "{0}" is valid.
WebsiteStateFailureError=Failure to successfully set the state of the website {0}.
WebsiteBindingConflictOnStartError = Website "{0}" could not be started due to binding conflict. Ensure that the binding information for this website does not conflict with any existing website's bindings before trying to start it.
'@
}

# The Get-TargetResource cmdlet is used to fetch the status of role or Website on the target machine.
# It gives the Website info of the requested role/feature on the target machine.
function Get-TargetResource
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]$Name
    )

        Confirm-Dependencies

        $getTargetResourceResult = $null;

        $Website = Get-Website | where {$_.Name -eq $Name}

        if ($Website.count -eq 0) # No Website exists with this name.
        {
            $ensureResult = "Absent";
        }
        elseif ($Website.count -eq 1) # A single Website exists with this name.
        {
            $ensureResult = "Present"

            $SslFlags = Get-SslFlags -Location $Name

            [PSObject[]] $Bindings
            $Bindings = (Get-ItemProperty -path IIS:\Sites\$Name -Name Bindings).collection

            $CimBindings = foreach ($binding in $bindings)
            {
                $BindingObject = Get-WebBindingObject -Binding $binding

                if($BindingObject.Protocol -eq "http") {
                    New-CimInstance -ClassName SEEK_cWebBindingInformation -Property @{Port=[System.UInt16]$BindingObject.Port;Protocol=$BindingObject.Protocol;HostName=$BindingObject.HostName;IPAddress=$BindingObject.IPAddress} -ClientOnly
                }
                elseif($BindingObject.Protocol -eq "https") {
                    if (($BindingObject.CertificateThumbprint -eq $null) -or ($BindingObject.CertificateStoreName -eq $null)) {
                        New-CimInstance -ClassName SEEK_cWebBindingInformation -Property @{Port=[System.UInt16]$BindingObject.Port;Protocol=$BindingObject.Protocol;HostName=$BindingObject.HostName;IPAddress=$BindingObject.IPAddress} -ClientOnly
                    }
                    else {
                        New-CimInstance -ClassName SEEK_cWebBindingInformation -Property @{Port=[System.UInt16]$BindingObject.Port;Protocol=$BindingObject.Protocol;HostName=$BindingObject.HostName;IPAddress=$BindingObject.IPAddress;CertificateThumbprint=$BindingObject.CertificateThumbprint;CertificateStoreName=$BindingObject.CertificateStoreName} -ClientOnly
                    }
                }
                elseif($BindingObject.Protocol -eq "net.pipe") {
                    New-CimInstance -ClassName SEEK_cWebBindingInformation -Property @{Protocol=$BindingObject.Protocol;HostName=$BindingObject.HostName} -ClientOnly
                }
                elseif($BindingObject.Protocol -eq "net.tcp") {
                    New-CimInstance -ClassName SEEK_cWebBindingInformation -Property @{Port=[System.UInt16]$BindingObject.Port;Protocol=$BindingObject.Protocol;HostName=$BindingObject.HostName} -ClientOnly
                }
            }

            $CimAuthentication = Get-AuthenticationInfo -Website $Name

        }
        else # Multiple websites with the same name exist. This is not supported and is an error
        {
            ThrowTerminatingError `
                -ErrorId "WebsiteDiscoveryFailure" `
                -ErrorMessage  ($($LocalizedData.WebsiteDiscoveryFailure) -f ${Name}) `
                -ErrorCategory ([System.Management.Automation.ErrorCategory]::InvalidResult)

        }

        # Add all Website properties to the hash table
        $getTargetResourceResult = @{
                                        Name = $Name
                                        Ensure = $ensureResult
                                        PhysicalPath = $Website.physicalPath
                                        State = $Website.state
                                        ID = $Website.id
                                        SslFlags = $SslFlags
                                        ApplicationPool = $Website.applicationPool
                                        BindingInfo = $CimBindings
                                        AuthenticationInfo = $CimAuthentication
                                        HostFileInfo = $null
                                    }

        return $getTargetResourceResult
}


# The Set-TargetResource cmdlet is used to create, delete or configuure a website on the target machine.
function Set-TargetResource
{
    [CmdletBinding()]
    param
    (
        [ValidateSet("Present", "Absent")]
        [string]$Ensure = "Present",

        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]$Name,

        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]$PhysicalPath,

        [ValidateSet("Started", "Stopped")]
        [string]$State = "Started",

        [string]$ApplicationPool,

        [ValidateNotNull()]
        [string]$SslFlags = "",

        [Microsoft.Management.Infrastructure.CimInstance[]]$BindingInfo,

        [Microsoft.Management.Infrastructure.CimInstance[]]$HostFileInfo,

        [Microsoft.Management.Infrastructure.CimInstance]$AuthenticationInfo
    )

    Confirm-Dependencies

    $getTargetResourceResult = $null;

    if($Ensure -eq "Present")
    {
        #Remove Ensure from parameters as it is not needed to create new website
        $Result = $psboundparameters.Remove("Ensure");
        #Remove State parameter form website. Will start the website after configuration is complete
        $Result = $psboundparameters.Remove("State");

        #Remove SslFlags parameter form website.
        #SslFlags will be added to site using separate cmdlet
        $Result = $psboundparameters.Remove("SslFlags");

        #Remove bindings from parameters if they exist
        #Bindings will be added to site using separate cmdlet
        $Result = $psboundparameters.Remove("BindingInfo");

        #Remove authentication settings from parameters if they exist
        #Authentication settings will be added to site using separate cmdlet
        $Result = $psboundparameters.Remove("AuthenticationInfo");

        #Remove host file settings from parameters if they exist
        #Host file settings will be added to site using separate cmdlet
        $Result = $psboundparameters.Remove("HostFileInfo");

        if(!(Test-BindingDoesNotConflictWithOtherSites -WebsiteName $Name -WebsiteBindingInfo $BindingInfo))
        {
            ThrowTerminatingError `
                -ErrorId "WebsiteBindingConflictOnStart" `
                -ErrorMessage  ($($LocalizedData.WebsiteBindingConflictOnStartError) -f ${Name}) `
                -ErrorCategory ([System.Management.Automation.ErrorCategory]::InvalidResult)
        }

        $website = Get-Website | where {$_.Name -eq $Name}

        if($website -ne $null)
        {
            Stop-AppFabricApplicationServer -SiteName $Name

            #update parameters as required

            $UpdateNotRequired = $true

            #Update Physical Path if required
            if(ValidateWebsitePath -Name $Name -PhysicalPath $PhysicalPath)
            {
                $UpdateNotRequired = $false
                Set-ItemProperty -Path "IIS:\Sites\${Name}" -Name physicalPath -Value $physicalPath
                Write-Verbose("Physical path for website $Name has been updated to $PhysicalPath");
            }

            #Update Bindings if required
            if ($BindingInfo -ne $null)
            {
                if(ValidateWebsiteBindings -Name $Name -BindingInfo $BindingInfo)
                {
                    $UpdateNotRequired = $false

                    #Update Bindings
                    UpdateBindings -Name $Name -BindingInfo $BindingInfo

                    Write-Verbose("Bindings for website $Name have been updated.");
                }
            }

            if (!(Test-AuthenticationInfo -Website $Name -AuthenticationInfo $AuthenticationInfo))
            {
                Set-AuthenticationInfo -Website $Name -AuthenticationInfo $AuthenticationInfo
                Write-Verbose ("Authentication information for website $Name has been updated.")
            }

            #Update host entry if required
            if ($HostFileInfo -ne $null)
            {
                if(ValidateHostFileEntry -HostFileInfo $HostFileInfo)
                {
                    UpdateHostFileEntry -HostFileInfo $HostFileInfo

                    Write-Verbose("Hostfile for website $Name has been updated.");
                }
            }

            #Update Application Pool if required
            if(($website.applicationPool -ne $ApplicationPool) -and ($ApplicationPool -ne ""))
            {
                $UpdateNotRequired = $false
                Set-ItemProperty -Path "IIS:\Sites\${Name}" -Name applicationPool -Value $applicationPool
                Write-Verbose("Application Pool for website $Name has been updated to $ApplicationPool")
            }

            Set-WebConfiguration -PSPath IIS:\Sites -Location $Name -Filter 'system.webserver/security/access' -Value $SslFlags

            #Update State if required
            if($website.state -ne $State -and $State -ne "")
            {
                $UpdateNotRequired = $false
                if($State -eq "Started")
                {

                    try
                    {

                    Start-Website -Name $Name

                    }
                    catch
                    {
                        ThrowTerminatingError `
                            -ErrorId "WebsiteStateFailure" `
                            -ErrorMessage  ($($LocalizedData.WebsiteStateFailureError) -f ${Name}) `
                            -ErrorCategory ([System.Management.Automation.ErrorCategory]::InvalidResult) `
                            -Exception ($_.exception)
                    }

                }
                else
                {
                    try
                    {

                    Stop-Website -Name $Name

                    }
                    catch
                    {
                        ThrowTerminatingError `
                            -ErrorId "WebsiteStateFailure" `
                            -ErrorMessage  ($($LocalizedData.WebsiteStateFailureError) -f ${Name}) `
                            -ErrorCategory ([System.Management.Automation.ErrorCategory]::InvalidResult) `
                            -Exception ($_.exception)
                    }
                }

                Write-Verbose("State for website $Name has been updated to $State");

            }

            if($UpdateNotRequired)
            {
                Write-Verbose("Website $Name already exists and properties do not need to be udpated.");
            }

            Start-AppFabricApplicationServer -SiteName $Name
        }
        else #Website doesn't exist so create new one
        {
            try
            {
                #Workaround for bug when there are no websites then New-Website fails
                if ((Get-Website).count -eq 0) {
                    $psboundparameters.Add("Id", 1)
                }
                $Website = New-Website @psboundparameters
                $Result = Stop-Website $Website.name -ErrorAction Stop

                Set-WebConfiguration -PSPath IIS:\Sites -Location $Name -Filter 'system.webserver/security/access' -Value $SslFlags

                #Clear default bindings if new bindings defined and are different
                if($BindingInfo -ne $null)
                {
                    if(ValidateWebsiteBindings -Name $Name -BindingInfo $BindingInfo)
                    {
                        UpdateBindings -Name $Name -BindingInfo $BindingInfo

                        Write-Verbose ("Binding information for website $Name added")
                    }
                }

                Write-Verbose ("Begin Authentication information update for website $Name, $AuthenticationInfo")

                Set-AuthenticationInfo -Website $Name -AuthenticationInfo $AuthenticationInfo

                #Update host entry if required
                if ($HostFileInfo -ne $null)
                {
                  UpdateHostFileEntry -HostFileInfo $HostFileInfo

                  Write-Verbose("Hostfile for website $Name has been updated.")
                }

                Write-Verbose("successfully created website $Name")

                #Start site if required
                if($State -eq "Started")
                {
                    #Wait 1 sec for bindings to take effect
                    #I have found that starting the website results in an error if it happens to quickly
                    Start-Sleep -s 1
                    Start-Website -Name $Name -ErrorAction Stop
                }

                Write-Verbose("successfully started website $Name")
            }
            catch
            {
                ThrowTerminatingError `
                    -ErrorId "WebsiteCreationFailure" `
                    -ErrorMessage  ($($LocalizedData.FeatureCreationFailureError) -f ${Name}) `
                    -ErrorCategory ([System.Management.Automation.ErrorCategory]::InvalidResult) `
                    -Exception ($_.exception)
            }
        }
    }
    else #Ensure is set to "Absent" so remove website
    {
        try
        {
            $website = Get-Website | where {$_.Name -eq $Name}
            if($website -ne $null)
            {
                Stop-AppFabricApplicationServer -SiteName $Name
                Remove-website -name $Name

                Write-Verbose("Successfully removed Website $Name.")
            }
            else
            {
                Write-Verbose("Website $Name does not exist.")
            }
        }
        catch
        {
            ThrowTerminatingError `
                -ErrorId "WebsiteRemovalFailure" `
                -ErrorMessage  ($($LocalizedData.WebsiteRemovalFailureError) -f ${Name}) `
                -ErrorCategory ([System.Management.Automation.ErrorCategory]::InvalidResult) `
                -Exception ($_.exception)
        }

    }
}

# Ensure that there are no other websites with binding information that will conflict with this site
function Test-BindingDoesNotConflictWithOtherSites {
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]$WebsiteName,

        [Microsoft.Management.Infrastructure.CimInstance[]]
        $WebsiteBindingInfo
    )
    [array]$existingSites = Get-Website | Where Name -ne $WebsiteName | Select -ExpandProperty Name
    [array]$existingBindingInfo = $existingSites | Where-Object { $_ -ne $null } | ForEach-Object { (Get-TargetResource -Name $_).BindingInfo }
    [array]$proposedBindingInfo = $existingBindingInfo + (NormalizeIpAddressBinding -BindingInfo $WebsiteBindingInfo)
    [array]$uniqueBindingInfo = $proposedBindingInfo | Where-Object { $_ -ne $null } | Select -Property Port, IpAddress, HostName -Unique
    return ($proposedBindingInfo.Count -eq $uniqueBindingInfo.Count)
}


# The Test-TargetResource cmdlet is used to validate if the role or feature is in a state as expected in the instance document.
function Test-TargetResource
{
    [CmdletBinding()]
    param
    (
        [ValidateSet("Present", "Absent")]
        [string]$Ensure = "Present",

        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]$Name,

        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]$PhysicalPath,

        [ValidateSet("Started", "Stopped")]
        [string]$State = "Started",

        [string]$ApplicationPool,

        [ValidateNotNull()]
        [string]$SslFlags = "",

        [Microsoft.Management.Infrastructure.CimInstance[]]$BindingInfo,

        [Microsoft.Management.Infrastructure.CimInstance[]]$HostFileInfo,

        [Microsoft.Management.Infrastructure.CimInstance]$AuthenticationInfo
    )

    Confirm-Dependencies

    $DesiredConfigurationMatch = $true;

    $website = Get-Website | where {$_.Name -eq $Name}
    $Stop = $true

    Do
    {
        #Check Ensure
        if(($Ensure -eq "Present" -and $website -eq $null) -or ($Ensure -eq "Absent" -and $website -ne $null))
        {
            $DesiredConfigurationMatch = $false
            Write-Verbose("The Ensure state for website $Name does not match the desired state.");
            break
        }

        # Only check properties if $website exists
        if ($website -ne $null)
        {
            #Check Physical Path property
            if(ValidateWebsitePath -Name $Name -PhysicalPath $PhysicalPath)
            {
                $DesiredConfigurationMatch = $false
                Write-Verbose("Physical Path of Website $Name does not match the desired state.");
                break
            }

            #Check State
            if($website.state -ne $State -and $State -ne $null)
            {
                $DesiredConfigurationMatch = $false
                Write-Verbose("The state of Website $Name does not match the desired state.");
                break
            }

            #Check Application Pool property
            if(($ApplicationPool -ne "") -and ($website.applicationPool -ne $ApplicationPool))
            {
                $DesiredConfigurationMatch = $false
                Write-Verbose("Application Pool for Website $Name does not match the desired state.");
                break
            }

            if((Get-SslFlags -Location $Name) -ne $SslFlags)
            {
                $DesiredConfigurationMatch = $false
                Write-Verbose("SSL Flags for Website $Name does not match the desired state.");
                break
            }

            #Check Binding properties
            if($BindingInfo -ne $null)
            {
                if(ValidateWebsiteBindings -Name $Name -BindingInfo $BindingInfo)
                {
                    $DesiredConfigurationMatch = $false
                    Write-Verbose("Bindings for website $Name do not mach the desired state.");
                    break
                }
            }

            if (!(Test-AuthenticationInfo -Website $Name -AuthenticationInfo $AuthenticationInfo))
            {
                $DesiredConfigurationMatch = $false
                Write-Verbose("Authentication for website $Name do not mach the desired state.");
                break
            }

            #Check Host file entry properties
            if($HostFileInfo -ne $null)
            {
                if(ValidateHostFileEntry -HostFileInfo $HostFileInfo)
                {
                    $DesiredConfigurationMatch = $false
                    Write-Verbose("Host file entries for website $Name do not mach the desired state.");
                    break
                }
            }
        }

        $Stop = $false
    }
    While($Stop)

    $DesiredConfigurationMatch;
}

#region HelperFunctions

#Normalize empty IPAddress to "*"
function NormalizeIpAddressBinding
{
    [CmdletBinding()]
    param
    (
        [parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $BindingInfo
    )

    return $BindingInfo | Where-Object { $_ -ne $null } | ForEach-Object {
        if($_.IPAddress -eq "" -or $_.IPAddress -eq $null)
        {
            return New-CimInstance -ClassName SEEK_cWebBindingInformation -Property @{Port=[System.UInt16]$_.Port;Protocol=$_.Protocol;HostName=$_.HostName;IPAddress="*"} -ClientOnly
        }
        return $_
    }
}

function ValidateHostFileEntry
{
    [CmdletBinding()]
    param
    (
        [parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $HostFileInfo
    )

    $result = $true

    $hostFile = [Environment]::SystemDirectory + "\drivers\etc\hosts"

    foreach($aHostFileInfo in $HostFileInfo)
    {
        $HostEntryIPAddress = $aHostFileInfo.CimInstanceProperties["HostIpAddress"].Value
        $HostEntryName = $aHostFileInfo.CimInstanceProperties["HostEntryName"].Value
        $RequireHostFileEntry = [bool]::Parse([string]$aHostFileInfo.CimInstanceProperties["RequireHostFileEntry"].Value)

        if ($RequireHostFileEntry)
        {
            if (-not (Select-String $hostFile -pattern "^${HostEntryIPAddress}\s+${HostEntryName}\s*$"))
            {
                $result = $true
            }
            else
            {
                $result = $false
            }
        }
        else
        {
            $result = $false
        }
    }

    return $result
}

function UpdateHostFileEntry
{
    [CmdletBinding()]
    param
    (
        [parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $HostFileInfo
    )

    $hostFile = Get-HostsFilePath

    foreach($aHostFileInfo in $HostFileInfo)
    {
        $HostEntryIPAddress = $aHostFileInfo.CimInstanceProperties["HostIpAddress"].Value
        $HostEntryName = $aHostFileInfo.CimInstanceProperties["HostEntryName"].Value
        $RequireHostFileEntry = [bool]::Parse([string]$aHostFileInfo.CimInstanceProperties["RequireHostFileEntry"].Value)

        try
        {
            if ($RequireHostFileEntry)
            {
                if ($HostEntryIPAddress -ne $null -and $HostEntryName -ne $null)
                {
                    if (-not (Select-String $hostFile -pattern "\s+${hostEntryName}\s*$"))
                    {
                        Add-Content $hostFile "`n$HostEntryIPAddress    $hostEntryName"
                    }
                    else {
                        (Get-Content($hostFile)) | ForEach-Object {$_ -replace "^\d+.\d+.\d+.\d+\s+${HostEntryName}\s*$", "$HostEntryIPAddress    $hostEntryName" } | Set-Content($hostFile)
                    }
                }
            }
        }
        Catch
        {
            ThrowTerminatingError `
                -ErrorId "HostEntryUpdateFailure" `
                -ErrorMessage  ($($LocalizedData.HostEntryUpdateFailure) -f ${HostEntryName, HostEntryIPAddress}) `
                -ErrorCategory ([System.Management.Automation.ErrorCategory]::InvalidResult) `
                -Exception ($_.exception)
        }
    }
}

# ValidateWebsite is a helper function used to validate the results
function ValidateWebsite
{
    [CmdletBinding()]
    param
    (
        [object] $Website,

        [string] $Name
    )

    # If a wildCard pattern is not supported by the website provider.
    # Hence we restrict user to request only one website information in a single request.
    if($Website.Count-gt 1)
    {
        ThrowTerminatingError `
                -ErrorId "WebsiteDiscoveryFailure" `
                -ErrorMessage  ($($LocalizedData.WebsiteDiscoveryFailureError) -f ${Name}) `
                -ErrorCategory ([System.Management.Automation.ErrorCategory]::InvalidResult)
    }
}

# Helper function used to validate website path
function ValidateWebsitePath
{
    [CmdletBinding()]
    param
    (
        [string] $Name,

        [string] $PhysicalPath
    )

    $PathNeedsUpdating = $false

    if((Get-ItemProperty "IIS:\Sites\$Name" -Name physicalPath) -ne $PhysicalPath)
    {
        $PathNeedsUpdating = $true
    }

    $PathNeedsUpdating

}

# Helper function used to validate website bindings
# Returns true if bindings are valid (ie. port, IPAddress & Hostname combinations are unique).

function ValidateWebsiteBindings
{
    [CmdletBinding()]
    Param
    (
        [parameter()]
        [string]
        $Name,

        [parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $BindingInfo
    )

    if (!(Test-UniqueBindings -BindingInfo $BindingInfo))
    {
        ThrowTerminatingError `
            -ErrorId "WebsiteBindingInputInvalidation" `
            -ErrorMessage  ($($LocalizedData.WebsiteBindingInputInvalidationError) -f ${Name}) `
            -ErrorCategory ([System.Management.Automation.ErrorCategory]::InvalidResult)
    }

    return compareWebsiteBindings -Name $Name -BindingInfo $BindingInfo
}

# return true if all bindings are unique, false otherwise
function Test-UniqueBindings
{
    [CmdletBinding()]
    Param
    (
        [parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $BindingInfo
    )

    [array]$uniqueBindingInfo = $BindingInfo | Select -Property IpAddress, Port, HostName -Unique
    return ($BindingInfo.Count -eq $uniqueBindingInfo.Count)
}

function Test-AuthenticationEnabled
{
    [CmdletBinding()]
    [OutputType([System.Boolean])]
    Param
    (
        [parameter(Mandatory = $true)]
        [System.String]$WebSite,

        [parameter(Mandatory = $true)]
        [ValidateSet("Anonymous","Basic","Digest","Windows")]
        [System.String]$Type
    )


    $prop = Get-WebConfigurationProperty `
        -Filter /system.WebServer/security/authentication/${Type}Authentication `
        -Name enabled `
        -Location $WebSite
    return $prop.Value
}

function Set-Authentication
{
    [CmdletBinding()]
    Param
    (
        [parameter(Mandatory = $true)]
        [System.String]$WebSite,

        [parameter(Mandatory = $true)]
        [ValidateSet("Anonymous","Basic","Digest","Windows")]
        [System.String]$Type,

        [System.Boolean]$Enabled
    )

    Set-WebConfigurationProperty -Filter /system.WebServer/security/authentication/${Type}Authentication `
        -Name enabled `
        -Value $Enabled `
        -Location $WebSite
}

function Get-AuthenticationInfo
{
    [CmdletBinding()]
    [OutputType([Microsoft.Management.Infrastructure.CimInstance])]
    Param
    (
        [parameter(Mandatory = $true)]
        [System.String]$WebSite
    )

    $authenticationProperties = @{}
    foreach ($type in @("Anonymous", "Basic", "Digest", "Windows"))
    {
        $authenticationProperties[$type] = [string](Test-AuthenticationEnabled -Website $Website -Type $type)
    }

    return New-CimInstance -ClassName SEEK_cWebAuthenticationInformation -ClientOnly -Property $authenticationProperties
}

function Test-AuthenticationInfo
{
    [CmdletBinding()]
    [OutputType([System.Boolean])]
    param
    (
        [parameter(Mandatory = $true)]
        [System.String]$Website,

        [parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [Microsoft.Management.Infrastructure.CimInstance]$AuthenticationInfo
    )

    $result = $true

    foreach ($type in @("Anonymous", "Basic", "Digest", "Windows"))
    {
        $expected = $AuthenticationInfo.CimInstanceProperties[$type].Value
        $actual = Test-AuthenticationEnabled -Website $Website -Type $type
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
    [CmdletBinding()]
    param
    (
        [parameter(Mandatory = $true)]
        [System.String]$WebSite,

        [parameter()]
        [ValidateNotNullOrEmpty()]
        [Microsoft.Management.Infrastructure.CimInstance]$AuthenticationInfo
    )

    foreach ($type in @("Anonymous", "Basic", "Digest", "Windows"))
    {
        $enabled = ($AuthenticationInfo.CimInstanceProperties[$type].Value -eq $true)
        Set-Authentication -Website $Website -Type $type -Enabled $enabled
    }
}

function Get-DefaultAuthenticationInfo
{
    New-CimInstance -ClassName SEEK_cWebAuthenticationInformation `
        -ClientOnly `
        -Property @{Anonymous="false";Basic="false";Digest="false";Windows="false"}
}

# Helper function used to compare website bindings of actual to desired
# Returns true if bindings need to be updated and false if not.
function compareWebsiteBindings
{
    [CmdletBinding()]
    param
    (
        [parameter()]
        [string]
        $Name,

        [parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $BindingInfo
    )
    #Assume bindingsNeedUpdating
    $BindingNeedsUpdating = $false

    #check to see if actual settings have been passed in. If not get them from website
    if($ActualBindings -eq $null)
    {
        $ActualBindings = (Get-ItemProperty -path "IIS:\Sites\$Name" -Name Bindings).collection

        #Format Binding information: Split BindingInfo into individual Properties (IPAddress:Port:HostName)
        $ActualBindingObjects = @()
        foreach ($ActualBinding in $ActualBindings)
        {
            $ActualBindingObjects += Get-WebBindingObject -Binding $ActualBinding
        }
    }

    #Compare Actual Binding info ($FormatActualBindingInfo) to Desired($BindingInfo)
    try
    {
        if($BindingInfo.Count -le $ActualBindingObjects.Count)
        {
            foreach($Binding in $BindingInfo)
            {
                $ActualBinding = $ActualBindingObjects | ?{$_.Port -eq $Binding.CimInstanceProperties["Port"].Value}
                if ($ActualBinding -ne $null)
                {
                    if([string]$ActualBinding.Protocol -ne [string]$Binding.CimInstanceProperties["Protocol"].Value)
                    {
                        $BindingNeedsUpdating = $true
                        break
                    }

                    if([string]$ActualBinding.IPAddress -ne [string]$Binding.CimInstanceProperties["IPAddress"].Value)
                    {
                        # Special case where blank IPAddress is saved as "*" in the binding information.
                        if([string]$ActualBinding.IPAddress -eq "*" -AND [string]$Binding.CimInstanceProperties["IPAddress"].Value -eq "")
                        {
                            #Do nothing
                        }
                        else
                        {
                            $BindingNeedsUpdating = $true
                            break
                        }
                    }

                    if([string]$ActualBinding.HostName -ne [string]$Binding.CimInstanceProperties["HostName"].Value)
                    {
                        $BindingNeedsUpdating = $true
                        break
                    }

                    if([string]$ActualBinding.CertificateThumbprint -ne [string]$Binding.CimInstanceProperties["CertificateThumbprint"].Value)
                    {
                        $BindingNeedsUpdating = $true
                        break
                    }

                    if([string]$ActualBinding.CertificateStoreName -ne [string]$Binding.CimInstanceProperties["CertificateStoreName"].Value)
                    {
                        $BindingNeedsUpdating = $true
                        break
                    }
                }
                else
                {
                    {
                        $BindingNeedsUpdating = $true
                        break
                    }
                }
            }
        }
        else
        {
            $BindingNeedsUpdating = $true
        }

        $BindingNeedsUpdating

    }
    catch
    {
        ThrowTerminatingError `
                -ErrorId "WebsiteCompareFailure" `
                -ErrorMessage  ($($LocalizedData.WebsiteCompareFailureError) -f ${Name}) `
                -ErrorCategory ([System.Management.Automation.ErrorCategory]::InvalidResult) `
                -Exception ($_.exception)
    }
}

function UpdateBindings
{
    [CmdletBinding()]
    param
    (
        [parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [string]
        $Name,

        [parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $BindingInfo
    )

    #Enable all protocols specified in bindings
    $SiteEnabledProtocols = $BindingInfo  | Select-Object -ExpandProperty Protocol -Unique
    Set-ItemProperty -Path "IIS:\Sites\${Name}" -Name EnabledProtocols -Value ($SiteEnabledProtocols -join ',')

    $bindingParams = @()
    foreach($binding in $BindingInfo)
    {
        $Protocol = $Binding.CimInstanceProperties["Protocol"].Value
        if($Protocol -eq $null){$Protocol = 'http'} #Default to Http
        $IPAddress = $Binding.CimInstanceProperties["IPAddress"].Value
        if($IPAddress -eq $null){$IPAddress = '*'} # Default to any/all IP Addresses
        $Port = $Binding.CimInstanceProperties["Port"].Value
        $HostName = $Binding.CimInstanceProperties["HostName"].Value


        if ($Protocol -eq 'net.pipe')
        {
            $bindingInformation = "$HostName"
        }
        elseif ($Protocol -eq 'net.tcp')
        {
            $bindingInformation = "$($Port):$HostName"
        }
        else
        {
            $bindingInformation = "$($IPAddress):$($Port):$HostName"
        }

        $bindingParams += @{Protocol = $Protocol; BindingInformation = $bindingInformation}
    }

    try
    {
        Set-ItemProperty -Path "IIS:\Sites\${Name}" -Name bindings -value $bindingParams
    }
    Catch
    {
        ThrowTerminatingError `
            -ErrorId "WebsiteBindingUpdateFailure" `
            -ErrorMessage  ($($LocalizedData.WebsiteBindingUpdateFailureError) -f ${HostName}, ${Name}) `
            -ErrorCategory ([System.Management.Automation.ErrorCategory]::InvalidResult) `
            -Exception ($_.exception)
    }

    $HttpsBindingInfo = $BindingInfo | ? { $_.CimInstanceProperties["Protocol"].Value -eq "https" }
    foreach($binding in $HttpsBindingInfo)
    {
        $Port = $Binding.CimInstanceProperties["Port"].Value
        $IpAddress = $Binding.CimInstanceProperties["IPAddress"].Value
        $SslSubject = $Binding.CimInstanceProperties["SslSubject"].Value
        $SslCertPath = $Binding.CimInstanceProperties["SslCertPath"].Value

        try
        {
            if ($SslSubject -ne $null -and $SslCertPath -ne $null)
            {
                $theCert = Get-ChildItem -path $SslCertPath | Where-Object {$_.Subject -eq $SslSubject }

                Set-BindingCertificate `
                    -IpAddress $IpAddress `
                    -Port $Port `
                    -Certificate $theCert
            }
        }
        catch
        {
            throw $_
            ThrowTerminatingError `
                -ErrorId "WebBindingCertifcateError" `
                -ErrorMessage  ($($LocalizedData.WebBindingCertifcateError) -f ${CertificateThumbprint}) `
                -ErrorCategory ([System.Management.Automation.ErrorCategory]::InvalidResult) `
                -Exception ($_.exception)
        }
    }

}

function Set-BindingCertificate
{
    [CmdletBinding()]
    Param
    (
        [parameter(Mandatory=$true)]
        [System.Object]$Certificate,

        [System.String]$IpAddress = "0.0.0.0",

        [System.String]$Port = 443
    )
    $path = "IIS:\SslBindings\${IpAddress}!${Port}"

    if (Test-Path $path)
    {
        $thumbprint = (Get-Item $path).Thumbprint
        if ($Certificate.Thumbprint -eq $thumbprint)
        {
            return
        }
        else
        {
            Remove-Item $path
        }
    }

    New-Item -Path $path -Value $Certificate
}

function Get-WebBindingObject
{
    [CmdletBinding()]
    Param
    (
        [parameter(Mandatory=$true)]
        [System.Object]$Binding
    )

    $bindingProperties = @{Protocol = $Binding.protocol}

    switch -wildcard ($Binding.protocol)
    {
        "http*"
        {
            $Matches = $null
            if ($Binding.BindingInformation -match "^\[?(?<IPAddress>[\*\w\d\.:]*)\]?:(?<Port>[\*\d]+):(?<HostName>.*)$")
            {
                $bindingProperties["IPAddress"] = $Matches["IPAddress"]
                $bindingProperties["Port"] = $Matches["Port"]
                $bindingProperties["HostName"] = $Matches["HostName"]
            }
            else { throw "BindingInformation format is invalid for protocol ""$($Binding.protocol)"" {$($Binding.BindingInformation)}" }
        }
        "https"
        {
            $bindingProperties["CertificateThumbprint"] = $Binding.CertificateHash
            $bindingProperties["CertificateStoreName"] = $Binding.CertificateStoreName
        }
        "net.tcp"
        {
            $Matches = $null
            if ($Binding.BindingInformation -match "^(?<Port>[\*\d]+):(?<HostName>.*)$")
            {
                $bindingProperties["Port"] = $Matches["Port"]
                $bindingProperties["HostName"] = $Matches["HostName"]
            }
            else { throw "BindingInformation format is invalid for protocol ""$($Binding.protocol)"" {$($Binding.BindingInformation)}" }
        }
        "net.pipe"
        {
            $bindingProperties["HostName"] = $Binding.BindingInformation
        }
        "net.msmq"
        {
            $bindingProperties["HostName"] = $Binding.BindingInformation.Split("/")[0]
        }
        default { throw "Invalid protocol ""$($Binding.protocol)""" }
    }

    return (New-Object PSObject -Property $bindingProperties)
}

function Get-HostsFilePath
{
    return [Environment]::SystemDirectory + "\drivers\etc\hosts"
}

function ThrowTerminatingError
{
    [CmdletBinding()]
    param
    (
        [System.String]$ErrorId,
        [System.String]$ErrorMessage,
        [System.Management.Automation.ErrorCategory]$ErrorCategory,
        [System.Exception]$Exception = $null
    )

    $exception = New-Object System.InvalidOperationException $ErrorMessage, $Exception
    $errorRecord = New-Object System.Management.Automation.ErrorRecord $exception, $ErrorId, $ErrorCategory, $null
    throw $errorRecord
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

#endregion
