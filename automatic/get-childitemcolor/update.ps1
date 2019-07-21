#import-module au

. $PSScriptRoot\..\..\scripts\all.ps1

$moduleName  = 'Get-ChildItemColor'

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
    $modulePath = Join-Path -Path $tempPath -ChildPath "\$ModuleName\$($Latest.ModuleVersion)\"
    '.git', 'devel', 'example', 'screenshots' | ForEach { Remove-Item -Path (Join-Path -Path $modulePath -ChildPath $_) -Recurse -Force }
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