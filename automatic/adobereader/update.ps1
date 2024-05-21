. $PSScriptRoot\..\..\scripts\all.ps1

$releases = 'https://helpx.adobe.com/acrobat/release-note/release-notes-acrobat-reader.html'

function global:au_SearchReplace {
    @{
        'tools\chocolateyInstall.ps1' = @{
            "(^[$]allChecksumType\s*=\s*)('.*')"    = "`$1'$($Latest.ChecksumType)'"
            "(^[$]MUImspURL\s*=\s*)('.*')"          = "`$1'$($Latest.URL32)'"
            "(^[$]MUImspChecksum\s*=\s*)('.*')"     = "`$1'$($Latest.Checksum32)'"
            "(^[$]MUImspURL64\s*=\s*)('.*')"        = "`$1'$($Latest.URL64)'"
            "(^[$]MUImspChecksum64\s*=\s*)('.*')"   = "`$1'$($Latest.Checksum64)'"
        } 
    }
}

function global:au_BeforeUpdate() {
}

function global:au_AfterUpdate { 
    Set-DescriptionFromReadme -SkipFirst 2
}

function global:au_GetLatest {
    # We do tests on the $matches variable, so lets just make sure it's clear before we start
    Clear-Variable -Name 'matches' -ErrorAction SilentlyContinue

    # Discover the latest release version
    $page = Invoke-WebRequest -Uri $releases -UseBasicParsing
    $page.links | Where-Object outerHTML -match 'DC .* \((?<version>[\d\.]+)\)' | Select-Object -First 1 | Out-Null

    # check we got $matches
    if ($null -eq $matches.version) {
        throw "Version wasn't detected!"
    } else {
        $urlVersion = $matches.version.Replace('.', '')     # used in the URL
        $packageVersion = ([version]"20$($matches.version)").ToString()
    }


    # note the base URL's for the x64 and x86 installers are different:
    #   x86: https://ardownload2.adobe.com/pub/adobe/READER/win
    #   x64: https://ardownload2.adobe.com/pub/adobe/ACROBAT/win/
    return  @{ 
        Version      = $packageVersion
        URL32        = ("https://ardownload2.adobe.com/pub/adobe/reader/win/AcrobatDC/{0}/AcroRdrDCUpd{0}_MUI.msp" -f $urlVersion)
        URL64        = ("https://ardownload2.adobe.com/pub/adobe/acrobat/win/AcrobatDC/{0}/AcroRdrDCx64Upd{0}_MUI.msp" -f $urlVersion)
        ChecksumType = 'SHA256'
    }
}

Update-Package -CheckSumFor 'all'
