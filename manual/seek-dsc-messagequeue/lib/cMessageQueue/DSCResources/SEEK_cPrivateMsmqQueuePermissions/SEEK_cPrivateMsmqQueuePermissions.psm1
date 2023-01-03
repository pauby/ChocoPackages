Add-Type -AssemblyName "System.Messaging, Version=2.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a"

function Get-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [parameter(Mandatory = $true)]
        [System.String]
        $Name
    )

    return @{Name = $Name}
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
        [System.String[]]
        $QueueNames,

        [ValidateSet("Present","Absent")]
        [System.String]
        $Ensure  = "Present",

        [AllowEmptyCollection()]
        [System.String[]]
        $AdminUsers = @(),

        [AllowEmptyCollection()]
        [System.String[]]
        $ReadUsers = @(),

        [AllowEmptyCollection()]
        [System.String[]]
        $WriteUsers = @()
    )

    $Acl = (New-Object System.Messaging.AccessControlList | `
            Add-AccessRights -Users $AdminUsers -Rights ([System.Messaging.MessageQueueAccessRights]::FullControl) | `
            Add-AccessRights -Users $ReadUsers -Rights ([System.Messaging.MessageQueueAccessRights] "ReceiveMessage,PeekMessage,GetQueueProperties,GetQueuePermissions,WriteMessage") | `
            Add-AccessRights -Users $WriteUsers -Rights ([System.Messaging.MessageQueueAccessRights]::GenericWrite))

    Get-PrivateQueues | Where-NameIn -Names $QueueNames | Reset-Permissions | Where-Present -Ensure $Ensure | Set-Permissions -AccessControlList $Acl
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
        [System.String[]]
        $QueueNames,

        [ValidateSet("Present","Absent")]
        [System.String]
        $Ensure  = "Present",

        [AllowEmptyCollection()]
        [System.String[]]
        $AdminUsers = @(),

        [AllowEmptyCollection()]
        [System.String[]]
        $ReadUsers = @(),

        [AllowEmptyCollection()]
        [System.String[]]
        $WriteUsers = @()
    )

    Write-Verbose "Cannot query queue permissions, testing desired state will return False"
    return $false
}


function Where-Present
{
    [CmdletBinding()]
    param
    (
        [parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [PSObject]
        $InputObject,

        [parameter(Mandatory = $true)]
        [string]
        $Ensure
    )

    process
    {
        if ($Ensure -eq "Present")
        {
            Write-Output $InputObject
        }
    }
}


function Reset-Permissions
{
    [CmdletBinding()]
    param
    (
        [parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [PSObject]
        $InputObject
    )

    process
    {
        if ($InputObject -ne $null)
        {
            Write-Verbose ("Resetting current permissions of queue with path " + $InputObject.Queue.QueueName)
            $InputObject.Queue.ResetPermissions()
        }
        $InputObject | Write-Output
    }
}


function Set-Permissions
{
    [CmdletBinding()]
    param
    (
        [parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [AllowNull()]
        [PSObject]
        $InputObject,

        [parameter(Mandatory = $true)]
        [System.Messaging.AccessControlList]
        $AccessControlList
    )

    process
    {
        if ($InputObject -ne $null)
        {
            Write-Verbose ("Modifying permissions of queue with path " + $InputObject.Queue.QueueName)
            $InputObject.Queue.SetPermissions($AccessControlList)
        }
    }
}


function Add-AccessRights
{
    [CmdletBinding()]
    param
    (
        [parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [AllowEmptyCollection()]
        [System.Messaging.AccessControlList]
        $AccessControlList,

        [parameter(Mandatory = $true)]
        [AllowEmptyCollection()]
        [System.String[]]
        $Users,

        [parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [System.Messaging.MessageQueueAccessRights]
        $Rights
    )

    process
    {
        Write-Verbose "Adding access rights to access control list"
        foreach ($UserName in $Users)
        {
            $Trustee = New-Object System.Messaging.Trustee($UserName)
            [void]$AccessControlList.Add((New-Object System.Messaging.MessageQueueAccessControlEntry($Trustee, $Rights)))
        }
        Write-Output $AccessControlList -NoEnumerate
    }
}


function Get-PrivateQueues
{
    [CmdletBinding()]
    param ()

    process
    {
        Write-Verbose "Retrieving all private queues on the local machine"
        [System.Messaging.MessageQueue]::GetPrivateQueuesByMachine(".") | New-QueuePayload
    }
}

function New-QueuePayload
{
    [CmdletBinding()]
    param
    (
        [parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [System.Messaging.MessageQueue]
        $MessageQueue
    )

    process
    {
        New-Object -typename PSObject | Add-Member -membertype NoteProperty -name Queue -value $MessageQueue -passthru
    }
}


function Where-NameIn
{
    [CmdletBinding()]
    param
    (
        [parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [PSObject]
        $InputObject,

        [parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [System.String[]]
        $Names
    )

    process
    {
        foreach ($Name in $Names)
        {
            if ($InputObject.Queue.QueueName -match "\$\\$Name$")
            {
                Write-Verbose ("Processing queue with name " + $Name)
                Write-Output $InputObject
            }
        }

    }
}


Export-ModuleMember -Function *-TargetResource
