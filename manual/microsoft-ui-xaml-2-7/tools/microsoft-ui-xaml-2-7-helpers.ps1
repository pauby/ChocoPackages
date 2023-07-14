$ErrorActionPreference = 'Stop'

$internalAppXPackage = @{
    SoftwareName = 'Microsoft.UI.Xaml'
    PackageName  = 'Microsoft.Ui.Xaml.2.7'
    Version      = '7.2208.15002.0'
}

$appxFileName = 'Microsoft.UI.Xaml.2.7.appx'
$packagedAppxVersion = '2.7.3'

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