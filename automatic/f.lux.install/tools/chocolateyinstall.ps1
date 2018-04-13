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

$packageArgs = @{
    packageName    = $env:ChocolateyPackageName
    url            = 'https://justgetflux.com/flux-setup.exe'
    checksum       = '79FC802D9225D98EE15A288393BB2D4708575315B9EDAD33DBFCF29D1AF578B1'
    checksumType   = 'SHA256'
    fileType       = 'EXE'
    silentArgs     = '/S'
    validExitCodes = @(0)
}

Install-ChocolateyPackage @packageArgs

# only create the shortcut in startup if the /noautostart parameter has not been passed
$arguments = ConvertFrom-ChocoParameters -Parameter $env:ChocolateyPackageParameters
if (-not $arguments.ContainsKey("noautostart")) {
    $params = @{
        ShortcutFilePath    = Join-Path -Path ([Environment]::GetFolderPath('Startup')) -ChildPath 'f.lux.lnk'
        TargetPath          = Join-Path -Path ([Environment]::GetFolderPath('LocalApplicationData')) -ChildPath 'FluxSoftware\Flux\flux.exe'
        WorkingDirectory    = Join-Path -Path ([Environment]::GetFolderPath('LocalApplicationData')) -ChildPath 'FluxSoftware\Flux\runtime'
        Arguments           = '/noshow'
    }
    
    Install-ChocolateyShortcut @params
}
