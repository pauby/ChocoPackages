function Get-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [System.String] $Link
    )

    @{
        Ensure = if (Test-Path $Link) { "Present" } else { "Absent" }
        Link = $Link
    }
}

function Test-TargetResource
{
    [CmdletBinding()]
    param
    (
        [parameter(Mandatory)]
        [ValidateSet("/D", "/H", "/J")]
        [System.String] $Type,

        [parameter(Mandatory)]
        [System.String] $Link,

        [parameter(Mandatory)]
        [System.String] $Target,

        [ValidateSet("Present","Absent")]
        [System.String]
        $Ensure  = "Present"
    )

    (Get-TargetResource -Link $Link).Ensure -eq $Ensure
}

function Set-TargetResource
{
    [CmdletBinding()]
    param
    (
        [ValidateSet("/D", "/H", "/J")]
        [parameter(Mandatory)]
        [System.String] $Type,

        [parameter(Mandatory)]
        [System.String] $Link,

        [parameter(Mandatory)]
        [System.String] $Target,

        [ValidateSet("Present","Absent")]
        [System.String]
        $Ensure  = "Present"
    )

    switch ($Ensure) {
        "Absent" { cmd /c rmdir $Link }
        "Present" { cmd /c mklink $Type $Link $Target }
    }
}
Export-ModuleMember -Function *-TargetResource
