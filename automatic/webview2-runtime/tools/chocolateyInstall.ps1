$ErrorActionPreference = 'Stop'

$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$softwareVersion = '138.0.3351.65'
$installedVersionRegKeyx64 = 'HKLM:\SOFTWARE\WOW6432Node\Microsoft\EdgeUpdate\Clients\{F3017226-FE2A-4295-8BDF-00C3A9A7E4C5}\'
$installedVersionRegKeyx86 = 'HKLM:\SOFTWARE\Microsoft\EdgeUpdate\Clients\{F3017226-FE2A-4295-8BDF-00C3A9A7E4C5}\'

# If WebView2 runtime is already installed, with a later version, an error code -2147219187 is given.
# See https://github.com/pauby/ChocoPackages/issues/241
# WebView2 runtime is automatically updated, likely by Windows Update.
# (see https://github.com/MicrosoftEdge/WebView2Feedback/issues/925#issuecomment-777894384)
# Like the KB packages, we need to detect if this installation is needed
#
# This package will do three things:
#   1. If --force is given ($env:ChocolateyForce), install the software.
#   2. If the locally installed WebView2 runtime version is older than the package version, install it.
#   3. If the locally installed WebView2 runtime version is newer than the package version, don't install but return success.

if (-not $env:ChocolateyForce) {

    Write-Verbose 'The --force command line option was not used.'

    if (Get-OSArchitectureWidth 32) {
        $regKey = $installedVersionRegKeyx86
    }
    else {
        $regKey = $installedVersionRegKeyx64
    }

    $installedVersion = (Get-ItemProperty -Path $regKey -ErrorAction SilentlyContinue).pv
    Write-Verbose "Found installed version of WebView2 runtime: v$($installedVersion)"

    if ($installedVersion) {
        Write-Verbose "Found version v$($installedVersion) of WebView2 runtime installed, at registry key '$regKey'."

        if ([version]$installedVersion -ge [version]$softwareVersion) {
            Write-Warning "The installed version of WebView2 runtime (v$($installedVersion)) is the same as, or later, than the version to be installed by this package (v$($softwareVersion))."
            Write-Warning 'As a result, WebView2 runtime has not been installed.'
            Write-Warning 'If you want to force the installation, please manually remove WebView2 runtime and install the package again.'
            Write-Warning 'Alternatively, you can force a reinstall by using the --force option on the command line. Depending on the installed version of WebView2 runtime, you may get an error requiring you to follow the above step.'
            exit 0
        }
        else {
            Write-Verbose "Did not find a version number for WebView2 runtime, at registry key '$regKey'."
            Write-Verbsoe 'Assuming WebView2 runtime software is not installed.'
        }
    }
}
else {
    Write-Verbose 'The --force command line option was used.'
}

$packageArgs = @{
    packageName   = $env:ChocolateyPackageName
    unzipLocation = $toolsDir
    fileType      = 'EXE' #only one of these: exe, msi, msu
    url           = 'https://msedge.sf.dl.delivery.mp.microsoft.com/filestreamingservice/files/5c672feb-6b72-4a3f-9dbc-bc9cc4005a62/MicrosoftEdgeWebView2RuntimeInstallerX86.exe'
    url64         = 'https://msedge.sf.dl.delivery.mp.microsoft.com/filestreamingservice/files/469a78ad-4352-4c93-912f-c026cb93456c/MicrosoftEdgeWebView2RuntimeInstallerX64.exe'
    softwareName  = 'Microsoft Edge WebView2*' #part or all of the Display Name as you see it in Programs and Features. It should be enough to be unique

    checksum      = 'f843496f073774883b7ea7b6df4668c28f3b21261576936af2013cc8ce81d313'
    checksum64    = '2e4fe09766b9e0e227f92c81bfd6aa359062a3714cacfd5e5d2fba0d9f7008c8'
    checksumType  = 'sha256'

    silentArgs    = '/silent /install'
    validExitCodes= @(0)
}

Install-ChocolateyPackage @packageArgs
