import-module au

. $PSScriptRoot\..\..\scripts\all.ps1

$moduleName  = 'Plaster'

function global:au_SearchReplace {
    @{
    }
}

function global:au_BeforeUpdate() {
    do {
        $tempPath = Join-Path -Path $env:TEMP -ChildPath ([GUID]::NewGuid()).ToString()
    }
    while (Test-Path $tempPath)

    New-Item -Path $tempPath -ItemType Directory | Out-Null
    Save-Module -Name $moduleName -RequiredVersion $Latest.ModuleVersion -Path $tempPath

    $params = @{ 
        Path        = Join-Path -Path $tempPath -ChildPath "\$ModuleName\$($Latest.ModuleVersion)\"
        Destination = "tools\$moduleName\"
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