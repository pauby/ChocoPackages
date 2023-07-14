function ConvertTo-VersionNumber {
    [CmdletBinding()]

    Param (
        [Parameter(Mandatory = $true)]
        [Version]
        $Version,

        [ValidateRange(1, 4)]
        [Int32]
        $Part = 4
    )

    $versionNumber = ''    # initialize this before using it so it knows it's a string!
    $partName = @('Major', 'Minor', 'Build', 'Revision')
    for ($i = 0; $i -lt $Part; $i++) {
        if ($partName[$i] -ne 'Major') {
            $versionNumber += '.'
        }
        
        if ($Version.$($partName[$i]) -eq -1) {
            $versionNumber += '0'
        }
        else {
            $versionNumber += $Version.$($partName[$i])
        }
    }

    [version]$versionNumber
}