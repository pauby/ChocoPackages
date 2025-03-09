$ErrorActionPreference = 'Stop'

$toolsDir    = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$packageArgs = @{
    packageName     = $env:ChocolateyPackageName
    fileType        = 'EXE'
    url             = 'https://npcap.com/dist/npcap-1.81.exe'
    softwareName    = 'Npcap*'

    checksum        = '69a7f8467d2d207fc9f188dda5fea42e13de71f126ebf42bcf4b4682d5b68bd0'
    checksumType    = 'SHA256'

    validExitCodes  = @(0)
}

$ahkExe = 'AutoHotKey'
$ahkFile = Join-Path -Path $env:TEMP -ChildPath "$(Get-Random).ahk" 
$ahkSourceFile = Join-Path -Path $toolsDir -ChildPath "$($env:ChocolateyPackageName)_install.ahk"
Copy-Item -Path $ahkSourceFile -Destination $ahkFile -Force | Out-Null

Write-Verbose "Running AutoHotkey install script $ahkFile"
$ahkProc = Start-Process -FilePath $ahkExe -ArgumentList $ahkFile -PassThru
$ahkId = $ahkProc.Id
Write-Debug "$ahkExe start time:`t$($ahkProc.StartTime.ToShortTimeString())"
Write-Debug "Process ID:`t$ahkId"

Install-ChocolateyPackage @packageArgs

Remove-Item $ahkFile -Force -ErrorAction SilentlyContinue