#import-module au

. $PSScriptRoot\..\..\scripts\all.ps1

$moduleName  = 'Microsoft.WinGet.Client'

function global:au_SearchReplace {
    @{
        ".\tools\winget.powershell-helpers.ps1" = @{
            '(^\s*\$moduleVersion\s*=\s*)(''.*'')' = "`$1'$($Latest.ModuleVersion)'"
        }
    }
}

function global:au_BeforeUpdate() {
    #$depModulesPath = 'tools\dependent.modules'
    do {
        $tempPath = Join-Path -Path $env:TEMP -ChildPath ([GUID]::NewGuid()).ToString()
    }
    while (Test-Path $tempPath)

    New-Item -Path $tempPath -ItemType Directory | Out-Null
    Save-Module -Name $moduleName -RequiredVersion $Latest.ModuleVersion -Path $tempPath
    # create a list of depdendent modules that will need to be uninstalled
    #Remove-Item $depModulesPath -Force -ErrorAction SilentlyContinue
    #Get-ChildItem -Path $tempPath | Where-Object { $_.PSIsContainer -eq $true } | ForEach-Object { $_.basename.ToString() } | Add-Content -Path $depModulesPath -Force
    $modulePath = Join-Path -Path $tempPath -ChildPath "\$ModuleName\$($Latest.ModuleVersion)\"
    $zipPath = Join-Path -Path $tempPath -ChildPath "$moduleName.zip"
    Compress-Archive -Path (Join-Path -Path $modulePath -ChildPath "*") -DestinationPath $zipPath -CompressionLevel Optimal

    $params = @{
        Path        = $zipPath
        Destination = 'tools\'
        Force       = $true
    }
    Move-Item @params
}

function global:au_AfterUpdate { 
    Set-DescriptionFromReadme -SkipFirst 2 
}

function global:au_GetLatest {
    $version = (Find-Module -Name $moduleName).Version.ToString()

    return @{
        Version       = $version
        ModuleVersion = $version
    }
}

update -ChecksumFor none