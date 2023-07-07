$ErrorActionPreference = 'Stop'

$internalAppXPackage = @{
    SoftwareName = 'WinGet-CLI'
    PackageName  = 'Microsoft.DesktopAppInstaller'
    Version      = '2023.606.2047.0'
}

$packagedAppxVersion = '1.5.1572.0'

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