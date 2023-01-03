function Get-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [System.String] $User,

        [parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [System.String] $Password,

        [System.String] $Server = "(local)"
    )

    $login = Get-SQLLogin -Username $user

    if ($login) {
        @{
            Ensure = "Present";
            User = $login.Name;
            Server = $login.Parent.Name;
            Password = $null
        }
    } else {
        @{
            Ensure = "Absent";
            User = $null;
            Server = $null;
            Password = $null
        }
    }
}

function Test-TargetResource
{
    [CmdletBinding()]
    param
    (
        [parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [System.String] $User,

        [parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [System.String] $Password,

        [System.String] $Server = "(local)",

        [ValidateSet("Present","Absent")]
        [System.String]
        $Ensure  = "Present"
    )

    (Get-TargetResource -User $User -Password $Password -Server $Server).Ensure -eq $Ensure
}

function Set-TargetResource
{
    [CmdletBinding()]
    param
    (
        [parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [System.String] $User,

        [parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [System.String] $Password,

        [System.String] $Server = "(local)",

        [ValidateSet("Present","Absent")]
        [System.String]
        $Ensure  = "Present"
    )

    [System.Reflection.Assembly]::LoadWithPartialName("Microsoft.SqlServer.Smo") | Out-Null

    switch ($Ensure) {
        "Absent" {
            $login = Get-SQLLogin -Username $User
            $login.Drop()
         }
        "Present" {
            $login = new-object Microsoft.SqlServer.Management.Smo.Login("${Server}", "${User}")
            $login.LoginType = 'SqlLogin'
            $login.PasswordPolicyEnforced = $false
            $login.PasswordExpirationEnabled = $false
            $login.Create("${Password}")
         }
    }
}

function Get-SQLLogin {
    param (
        [string]$Username
    )
    [System.Reflection.Assembly]::LoadWithPartialName("Microsoft.SqlServer.Smo") | Out-Null
    $smo = New-Object Microsoft.SqlServer.Management.Smo.Server $Server
    $smo.logins.Item($Username)
}

Export-ModuleMember -Function *-TargetResource