. $PSScriptRoot\..\..\scripts\all.ps1

$releases = 'https://helpx.adobe.com/acrobat/release-note/release-notes-acrobat-reader.html'

function global:au_SearchReplace {
    @{
        'tools\chocolateyInstall.ps1' = @{
            "(^[$]allChecksumType\s*=\s*)('.*')"    = "`$1'$($Latest.ChecksumType)'"
            "(^[$]MUIurl\s*=\s*)('.*')"             = "`$1'$($Latest.FullURL32)'"
            "(^[$]MUIchecksum\s*=\s*)('.*')"        = "`$1'$($Latest.FullChecksum32)'"
            "(^[$]MUIurl64\s*=\s*)('.*')"           = "`$1'$($Latest.FullURL64)'"
            "(^[$]MUIchecksum64\s*=\s*)('.*')"      = "`$1'$($Latest.FullChecksum64)'"
            "(^[$]MUImspURL\s*=\s*)('.*')"          = "`$1'$($Latest.PatchURL32)'"
            "(^[$]MUImspChecksum\s*=\s*)('.*')"     = "`$1'$($Latest.PatchChecksum32)'"
            "(^[$]MUImspURL64\s*=\s*)('.*')"        = "`$1'$($Latest.PatchURL64)'"
            "(^[$]MUImspChecksum64\s*=\s*)('.*')"   = "`$1'$($Latest.PatchChecksum64)'"
        } 
    }
}

function global:au_BeforeUpdate() {
    $tempFolder = Join-Path -Path $env:TEMP -ChildPath ([Guid]::NewGuid()).Guid
    New-Item -Path $tempFolder -ItemType Directory -Force

    $savedProgressPreference = $ProgressPreference
    $ProgressPreference = 'SilentlyContinue'

    Invoke-WebRequest -Uri $Latest.FullUrl32 -OutFile (Join-Path -Path $tempFolder -ChildPath 'full32.exe')
    $Latest.FullChecksum32 = (Get-FileHash -Path (Join-Path -Path $tempFolder -ChildPath 'full32.exe')).Hash

    Invoke-WebRequest -Uri $Latest.FullUrl64 -OutFile (Join-Path -Path $tempFolder -ChildPath 'full64.exe')
    $Latest.FullChecksum64 = (Get-FileHash -Path (Join-Path -Path $tempFolder -ChildPath 'full64.exe')).Hash

    Invoke-WebRequest -Uri $Latest.PatchUrl32 -OutFile (Join-Path -Path $tempFolder -ChildPath 'patch32.msp')
    $Latest.PatchChecksum32 = (Get-FileHash -Path (Join-Path -Path $tempFolder -ChildPath 'patch32.msp')).Hash

    Invoke-WebRequest -Uri $Latest.PatchUrl64 -OutFile (Join-Path -Path $tempFolder -ChildPath 'patch64.msp')
    $Latest.PatchChecksum64 = (Get-FileHash -Path (Join-Path -Path $tempFolder -ChildPath 'patch64.msp')).Hash

    $ProgressPreference = $savedProgressPreference
}

function global:au_AfterUpdate { 
    Set-DescriptionFromReadme -SkipFirst 2
}

function global:au_GetLatest {
    # # We do tests on the $matches variable, so lets just make sure it's clear before we start
    # Clear-Variable -Name 'matches' -ErrorAction SilentlyContinue

    # # Discover the latest release version
    # $page = Invoke-WebRequest -Uri $releases -UseBasicParsing
    # $page.links | Where-Object outerHTML -match 'DC .* \((?<version>[\d\.]+)\)' | Select-Object -First 1 | Out-Null

    # # check we got $matches
    # if ($null -eq $matches.version) {
    #     throw "Version wasn't detected!"
    # } else {
    #     $urlVersion = $matches.version.Replace('.', '')     # used in the URL
    #     $packageVersion = ([version]"20$($matches.version)").ToString()
    # }


    # # note the base URL's for the x64 and x86 installers are different:
    # #   x86: https://ardownload2.adobe.com/pub/adobe/READER/win
    # #   x64: https://ardownload2.adobe.com/pub/adobe/ACROBAT/win/

    $fullEdition = Get-EvergreenApp -Name 'AdobeAcrobatReaderDC' | Where-Object { $_.language -eq 'MUI' }
    $patchEdition = Get-EvergreenApp -Name 'AdobeAcrobatDC' | Where-Object { $_.type -eq 'ReaderMUI' }

    return  @{ 
        Version      = "20{0}" -f ($fullEdition | Where-Object { $_.architecture -eq 'x86' }).Version
        FullURL32    = ($fullEdition | Where-Object { $_.architecture -eq 'x86' }).URI
        FullURL64    = ($fullEdition | Where-Object { $_.architecture -eq 'x64' }).URI
        PatchURL32   = ($patchEdition | Where-Object { $_.architecture -eq 'x86' }).URI
        PatchURL64   = ($patchEdition | Where-Object { $_.architecture -eq 'x64' }).URI
#        URL32        = ("https://ardownload2.adobe.com/pub/adobe/reader/win/AcrobatDC/{0}/AcroRdrDCUpd{0}_MUI.msp" -f $urlVersion)
#        URL64        = ("https://ardownload2.adobe.com/pub/adobe/acrobat/win/AcrobatDC/{0}/AcroRdrDCx64Upd{0}_MUI.msp" -f $urlVersion)
        ChecksumType = 'SHA256'
    }
}

Update-Package -CheckSumFor 'none'
