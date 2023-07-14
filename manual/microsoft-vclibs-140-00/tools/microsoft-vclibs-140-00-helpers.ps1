$ErrorActionPreference = 'Stop'

$internalAppXPackage = @{
    SoftwareName = 'Microsoft.VCLibs'
    PackageName  = 'Microsoft.VCLibs.140.00.UWPDesktop'
    #! This package version must have the 4 version segments that MATCH EXACTLY with the installed AppX version. EXACTLY.
    Version      = '14.0.30704.0'
}

function Test-AppXDependency {
    [CmdletBinding()]

    Param (
        [Parameter(Mandatory = $true)]
        [String]
        $Name,

        # An array of packages that should be the output from Get-AppXPackages
        [Parameter(Mandatory = $true)]
        [Object[]]
        $PackageList
    )

    ForEach ($pkg in $PackageList) {
        if ($pkg.Dependencies.Name -contains $Name) {
            return $true
        }
    }

    return $false
}