#import-module au

. $PSScriptRoot\..\..\scripts\all.ps1

$moduleName  = 'dbatools'

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
    # 'tests', 'functions', 'internal\functions', 'bin/projects', 'bin/build', '.git', '.github' | ForEach-Object {
    #     Remove-Item -Path (Join-Path -Path $modulePath -ChildPath $_) -Recurse -Force -ErrorAction SilentlyContinue
    # }
    # Remove the compressed module if it already exists in the tools folder
    #   only needed when working locally
    Remove-Item -Path "tools\$moduleName.zip" -Force -ErrorAction SilentlyContinue
    Compress-Archive -Path (Join-Path -Path $modulePath -ChildPath "*") -DestinationPath "tools\$moduleName.zip"
    # $params = @{
    #     Path        = $modulePath
    #     Destination = "tools\$moduleName\"
    #     Force       = $true
    # }
    # Move-Item @params
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