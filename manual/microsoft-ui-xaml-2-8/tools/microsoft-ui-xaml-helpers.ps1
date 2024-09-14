$ErrorActionPreference = 'Stop'

$internalAppXPackage = @{
    SoftwareName = 'Microsoft.UI.Xaml'
    PackageName  = 'Microsoft.Ui.Xaml.2.8'
    Version      = '8.2305.5001.0'
}

$appxFileName = 'Microsoft.UI.Xaml.2.8.appx'
$packagedAppxVersion = '2.8.4'

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