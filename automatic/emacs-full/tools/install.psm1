$packageName = 'emacs'

$majorVersion = '27'
$minorVersion = '1'

$emacsNameVersion = "$($packageName)-$($majorVersion).$($minorVersion)"
$installDir = $(Split-Path -parent $MyInvocation.MyCommand.Definition) + '/' + $packageName

$FullPackageArgs = @{
    packageName    = $packageName
    unzipLocation  = $installDir
    url            = "https://ftpmirror.gnu.org/emacs/windows/emacs-$($majorVersion)/$($emacsNameVersion)-i686.zip"
    url64bit       = "https://ftpmirror.gnu.org/emacs/windows/emacs-$($majorVersion)/$($emacsNameVersion)-x86_64.zip"
    checksum       = 'A52A1126825F3BF02B727F727874BFCCB82FFAAB4E914DEFBEAEC28EB3ED6F1E'
    checksumType   = 'sha256'
    checksum64     = '65F1B01BCD14E59D7DA0EBAD3979C5DF9F9BD8D24B2FF2E32A5AF3AACB226229'
    checksumType64 = 'sha256'
}

$NoDepsPackageArgs = @{
    packageName    = $packageName
    unzipLocation  = $installDir
    url            = "https://alpha.gnu.org/gnu/emacs/pretest/windows/emacs-$($majorVersion)/$($emacsNameVersion)-i686-no-deps.zip"
    url64bit       = "https://alpha.gnu.org/gnu/emacs/pretest/windows/emacs-$($majorVersion)/$($emacsNameVersion)-x86_64-no-deps.zip"
    checksum       = 'd9a5d3513f8aad075068db2f41a08676f50db900b62ce32c6edd54cbc7c54392'
    checksumType   = 'sha256'
    checksum64     = 'dc00a3bd152d984f079472d2fb34af6ae4beb9bfef56162d6aa4a6685571900a'
    checksumType64 = 'sha256'
}

$emacsDepsVersion = "emacs-$($majorVersion)"

$DepsPackageArgs = @{
  packageName    = $packageName
  unzipLocation  = $installDir
  url            = "https://alpha.gnu.org/gnu/emacs/pretest/windows/emacs-$($majorVersion)/$($emacsDepsVersion)-i686-deps.zip"
  url64bit       = "https://alpha.gnu.org/gnu/emacs/pretest/windows/emacs-$($majorVersion)/$($emacsDepsVersion)-x86_64-deps.zip"
  checksum       = '1F28BEA4A14E86817B730C7ED71905407436B98B5ABCC1BDFE32513B74311C7C'
  checksumType   = 'sha256'
  checksum64     = '9597cccaf3eb8a26eb5504327a042354d11760b7aae5e83c75ce793491d2de1d'
  checksumType64 = 'sha256'
}

function New-ShimHintFiles() {
    # Exclude executables from getting shimmed
    $guiExes = @("runemacs.exe", "emacsclientw.exe")
    $shimExes = @("emacs.exe", "emacsclient.exe")

    $guiFilter = "^" + $($guiExes -join "$|^") + "$"
    $shimFilter = "^" + $($shimExes -join "$|^") + "$"

    $files = Get-Childitem $installDir -include *.exe -recurse

    foreach ($file in $files) {
        if ($file.Name -match $guiFilter) {
            #generate an gui file
            New-Item "$file.gui" -type file -force | Out-Null
        }
        elseif (-not ($file.Name -match $shimFilter)) {
            #generate an ignore file
            New-Item "$file.ignore" -type file -force | Out-Null
        }
    }
}

Export-ModuleMember -Variable 'FullPackageArgs'
Export-ModuleMember -Variable 'NoDepsPackageArgs'
Export-ModuleMember -Variable 'DepsPackageArgs'
Export-ModuleMember -Function 'New-ShimHintFiles'
