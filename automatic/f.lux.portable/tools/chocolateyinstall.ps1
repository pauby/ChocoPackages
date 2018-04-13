$ErrorActionPreference = 'Stop'

function ConvertFrom-ChocoParameters ([string]$parameter) {
    $arguments = @{};

    if ($parameter) {
        $match_pattern = "\/(?<option>([a-zA-Z]+)):(?<value>([`"'])?([a-zA-Z0-9- _\\:\.]+)([`"'])?)|\/(?<option>([a-zA-Z]+))"
        $option_name = 'option'
        $value_name = 'value'

        if ($parameter -match $match_pattern) {
            $results = $parameter | Select-String $match_pattern -AllMatches
            $results.matches | ForEach-Object {
                $arguments.Add(
                    $_.Groups[$option_name].Value.Trim(),
                    $_.Groups[$value_name].Value.Trim())
            }
        }
        else {
            throw "Package Parameters were found but were invalid (REGEX Failure). See package description for correct format."
        }
    }

    return $arguments
}

$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$packageArgs = @{
    packageName    = $env:ChocolateyPackageName
    url            = 'https://justgetflux.com/flux-setup.exe'
    checksum       = '79FC802D9225D98EE15A288393BB2D4708575315B9EDAD33DBFCF29D1AF578B1'
    checksumType   = 'SHA256'
    unzipLocation  = $toolsdir
}

# Taken from https://github.com/brianmego/Chocolatey/pull/6/files
Install-ChocolateyZipPackage @packageArgs

# Start menu shortcuts
$progsFolder = [Environment]::GetFolderPath('Programs')
If ( Test-ProcessAdminRights ) {
    $progsFolder = [Environment]::GetFolderPath('CommonPrograms') 
}

Install-ChocolateyShortcut -shortcutFilePath (Join-Path -Path $progsFolder -ChildPath 'f.lux.lnk') `
    -targetPath "$($env:ChocolateyInstall)\lib\$packageName\tools\flux.exe" `
    -WorkingDirectory "$($env:ChocolateyInstall)\lib\$packageName\tools\runtime"

# only create the shortcut in startup if the /noautostart parameter has not been passed
$arguments = ConvertFrom-ChocoParameters -Parameter $env:ChocolateyPackageParameters
if (-not $arguments.ContainsKey("noautostart")) {
    Install-ChocolateyShortcut -shortcutFilePath (Join-Path -Path $progsFolder -ChildPath 'Startup\f.lux.lnk') `
        -targetPath "$($env:ChocolateyInstall)\lib\$packageName\tools\flux.exe" `
        -WorkingDirectory "$($env:ChocolateyInstall)\lib\$packageName\tools\runtime" `
        -Arguments "/noshow"
}