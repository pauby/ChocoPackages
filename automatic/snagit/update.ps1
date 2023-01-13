. $PSScriptRoot\..\..\scripts\all.ps1

# $releases = 'https://support.techsmith.com/hc/en-us/articles/115006435067-Snagit-Windows-Version-History'
$releases    = 'https://updater.techsmith.com/tscupdate_deploy/Updates.asmx'
$requestBody = '<?xml version="1.0" encoding="utf-8"?><soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema"><soap:Body><CheckForUpdates xmlns="http://localhost/TSCUpdater"><product>Snagit</product><currentVersion>1.0.0</currentVersion><language>ENU</language><keyType>Single User</keyType><key></key><os>6.2.9200.0</os><dotNet>4.8.4084</dotNet><processor>x86</processor><bitness>64</bitness><osBitness>64</osBitness><KeyVersion>0</KeyVersion></CheckForUpdates></soap:Body></soap:Envelope>'
#$requestBody = '<?xml version="1.0" encoding="utf-8"?><soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema"><soap:Body><CheckForUpdates xmlns="http://localhost/TSCUpdater"><product>Snagit</product><currentVersion>1.0.0</currentVersion><language>ENU</language><keyType>Single User</keyType><key></key><os>6.2.9200.0</os><dotNet>4.8.4084</dotNet><processor>x86</processor><bitness>64</bitness><osBitness>64</osBitness><KeyVersion>0</KeyVersion></CheckForUpdates></soap:Body></soap:Envelope>'
$requestHeaders = @{ 'SOAPAction' = 'http://localhost/TSCUpdater/CheckForUpdates' }

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

    $response = Invoke-RestMethod -Uri $releases -Method Post -Body $requestBody -Headers $requestHeaders -ContentType 'text/xml' -UseBasicParsing

    $version = $response.Envelope.Body.CheckForUpdatesResponse.CheckForUpdatesResult.NextVersion
    if (-not [string]::IsNullOrEmpty($version)) {
        $downloadUrl = ("https://download.techsmith.com/snagit/releases/{0}/snagit.msi" -f $version.Replace('.', ''))

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
