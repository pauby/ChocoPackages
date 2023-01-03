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

    if(!(Test-QueueExists($Name)))
    {
        return @{Name = $Name; Ensure = "Absent"}
    }

    return Get-QueueDetails($Name)
}


function Set-TargetResource
{
    [CmdletBinding(SupportsShouldProcess=$true)]
    param
    (
        [parameter(Mandatory = $true)]
        [System.String]
        $Name,

        [ValidateSet("Present","Absent")]
        [System.String]
        $Ensure  = "Present",

        [ValidateSet("true", "false")]
        [System.String]
        $Transactional = "true",

        [ValidateSet("true","false")]
        [System.String]
        $UseJournalQueue = "false",

        [Parameter(HelpMessage="Maximum Journal Size in kilobytes")]
        [ValidateScript({[bool]($_ -as [int] -is [int])})]
        [System.String]
        $MaximumJournalSize = "1024",

        [System.String]
        $Label = "private$\${Name}"
    )

    if($Ensure -eq "Absent")
    {
        if ($PsCmdlet.ShouldProcess($Name, 'Removing') )
        {
          Remove-Queue($Name)
        }
    }
    else
    {
        if(Test-QueueExists($Name))
        {
            if ($PsCmdlet.ShouldProcess($Name, 'Removing existing') )
            {
                Remove-Queue($Name)
            }
        }

        if ($PsCmdlet.ShouldProcess($Name, 'Creating New Queue'))
        {
            New-Queue -Name $Name `
                -Transactional ([System.Boolean]::Parse($Transactional)) `
                -UseJournalQueue ([System.Boolean]::Parse($UseJournalQueue)) `
                -MaximumJournalSize ([int]::Parse($MaximumJournalSize)) `
                -Label $Label
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

        [ValidateSet("Present","Absent")]
        [System.String]
        $Ensure  = "Present",

        [ValidateSet("true","false")]
        [System.String]
        $Transactional = "true",

        [ValidateSet("true","false")]
        [System.String]
        $UseJournalQueue = $false,

        [Parameter(HelpMessage="Maximum Journal Size in kilobytes")]
        [ValidateScript({[bool]($_ -as [int] -is [int])})]
        [System.String]
        $MaximumJournalSize = "1024",

        [AllowNull()]
        [System.String]
        $Label
    )

    $Queue = Get-TargetResource -Name $Name

    if($Ensure -eq "Present")
    {
        if($Queue.Ensure -eq $Ensure`
            -and $Queue.State -eq $state`
            -and $Queue.Transactional -eq [System.Boolean]::Parse($Transactional) `
            -and $Queue.UseJournalQueue -eq [System.Boolean]::Parse($UseJournalQueue) `
            -and $Queue.MaximumJournalSize -eq [int]::Parse($MaximumJournalSize) `
            -and $Queue.Label -eq $Label)
        {
            return $true
        }
    }
    elseif($Queue.Ensure -eq $Ensure)
    {
        return $true
    }

    return $false
}


function Get-QueueDetails
{
    param
    (
        [parameter(Mandatory = $true)]
        [System.String]
        $Name
    )

    $Details = @{}
    foreach ($Queue in [System.Messaging.MessageQueue]::GetPrivateQueuesByMachine("."))
    {
        if (Test-NameMatchesPath -Name $Name -Path $Queue.QueueName)
        {
            $Details = @{
                Name   = $Name
                Ensure = "Present"
                Transactional = $Queue.Transactional
                UseJournalQueue = $Queue.UseJournalQueue
                MaximumJournalSize = $Queue.MaximumJournalSize
                Label = $Queue.Label
            }
        }
    }
    return $Details
}

function Test-QueueExists
{
    param
    (
        [parameter(Mandatory = $true)]
        [System.String]
        $Name
    )
    [System.Messaging.MessageQueue]::Exists((Get-QueuePath -Name $Name))
}

function Remove-Queue
{
    param
    (
        [parameter(Mandatory = $true)]
        [System.String]
        $Name
    )

    foreach ($Queue in [System.Messaging.MessageQueue]::GetPrivateQueuesByMachine("."))
    {
        if (Test-NameMatchesPath -Name $Name -Path $Queue.QueueName)
        {
            Write-Verbose("Removing the MSMQ Queue ${Name}")
            try
            {
                [System.Messaging.MessageQueue]::Delete($Queue.Path)
                Write-Verbose("Successfully removed the MSMQ queue ${Name}")
                break
            }
            catch
            {
                Write-Error("Failed to remove the MSMQ queue ${Name}")
                throw $_
            }
        }
    }
}


function New-Queue
{
    param
    (
        [parameter(Mandatory = $true)]
        [System.String]
        $Name,

        [parameter(Mandatory = $true)]
        [System.Boolean]
        $Transactional,

        [parameter(Mandatory = $true)]
        [System.Boolean]
        $UseJournalQueue,

        [parameter(Mandatory = $true, HelpMessage = "Maximum Journal Size in kilobytes")]
        [int]
        $MaximumJournalSize,

        [parameter(Mandatory = $true)]
        [System.String]
        $Label
    )

    Write-Verbose("Creating the MSMQ Queue ${Name}")
    $QueuePath = (Get-QueuePath -Name $Name)
    $Queue = $null
    try
    {
        $Queue = [System.Messaging.MessageQueue]::Create($QueuePath, $Transactional)
        $Queue.UseJournalQueue = $UseJournalQueue
        $Queue.MaximumJournalSize = $MaximumJournalSize
        $Queue.Label = $Label
    }
    catch
    {
        Write-Error("Failed to create the MSMQ queue ${Name}")
        throw $_
    }
}


function Get-QueuePath
{
    param
    (
        [parameter(Mandatory = $true)]
        [System.String]
        $Name
    )

    return ".\private$\${Name}"
}


function Test-NameMatchesPath
{
    param
    (
        [parameter(Mandatory = $true)]
        [System.String]
        $Path,

        [parameter(Mandatory = $true)]
        [System.String]
        $Name
    )

    $Path -match "\$\\${Name}$"
}


Export-ModuleMember -Function *-TargetResource
