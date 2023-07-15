. $PSScriptRoot\..\..\scripts\all.ps1

$releases    = 'https://download.techsmith.com/update/camtasiastudio/enu/manifest.xml?utm_source=product&utm_medium=cs&utm_campaign=cw22&ipc_item_name=cs&ipc_platform=windows'

function global:au_SearchReplace {
    @{
        ".\tools\chocolateyInstall.ps1" = @{
            '(^\s*\$url64\s*=\s*)(''.*'')'            = "`$1'$($Latest.URL64)'"
            "(?i)(^\s*checksum64\s*=\s*)('.*')"       = "`$1'$($Latest.Checksum64)'"
            "(?i)(^\s*checksumType64\s*=\s*)('.*')"   = "`$1'$($Latest.ChecksumType64)'"
        }
    }
}

function global:au_BeforeUpdate() {
}

function global:au_GetLatest {

    # this doesn't return an XML formatted document so we need to regex it to get the version
    $response = Invoke-RestMethod -Uri $releases -Method 'Get' -ContentType 'text/xml' -UseBasicParsing
    $response -match '\<Application Name="Camtasia Studio" Version="(?<version>[\d\.]+)"' | Out-Null
    $version = $matches.version
    
    if (-not [string]::IsNullOrEmpty($version)) {
        $downloadUrl = ("https://download.techsmith.com/camtasiastudio/releases/{0}/camtasia.msi" -f $version.Replace('.', ''))

        # check the URL is valid - this will throw if it's not
        Invoke-WebRequest -Uri $downloadUrl -UseBasicParsing -Method HEAD
    }
    else {
        return
    }

    return @{
        URL64        = $downloadUrl
        Version      = '20' + $version
    }
}

Update-Package -ChecksumFor 64
