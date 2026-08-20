. $PSScriptRoot\..\..\scripts\all.ps1

$repoOwner = 'plantuml'
$repoName = 'plantuml'
$plantumlManual = "http://pdf.plantuml.net/PlantUML_Language_Reference_Guide_en.pdf"

function global:au_SearchReplace {
   @{

        ".\tools\VERIFICATION.txt" = @{
          "(?i)(\s+x32:).*"            = "`${1} $($Latest.URL32)"
          "(?i)(checksum32:).*"        = "`${1} $($Latest.Checksum32)"
          "(?i)(Get-RemoteChecksum).*" = "`${1} $($Latest.URL32)"
        }

        "$($Latest.PackageName).nuspec" = @{
            "(\<releaseNotes\>).*?(\</releaseNotes\>)" = "`${1}$([System.Web.HttpUtility]::HtmlEncode($Latest.ReleaseNotes))`$2"
        }
   }
}

function global:au_BeforeUpdate {
    Remove-Item -Path 'tools\*.jar', 'tools\*.pdf' -Force
    Invoke-WebRequest -Uri $Latest.URL32 -OutFile 'tools\plantuml.jar'

    Write-Host 'Downloading manual'$a
    $pdfFile = Join-Path -Path 'tools' -ChildPath (Split-Path -Leaf $plantumlManual)
    Invoke-WebRequest -Uri $plantumlManual -OutFile $pdfFile
    if ((Get-Item -Path $pdfFile).Length / 1MB -lt 1) {
        throw "Size of PDF manual too low"
    }
}

function global:au_AfterUpdate {
    Set-DescriptionFromReadme -SkipFirst 2
}

function global:au_GetLatest {
    $release = Get-GitHubRelease -OwnerName $repoOwner -RepositoryName $repoName -Latest
    $version = $release.tag_name
    if ($version.StartsWith('v')) {
        $version = $version.Substring(1)    # skip over 'v' in tag
    }

    $asset32 = $release.assets | Where-Object name -Match "plantuml-$($version).jar$"
    # digest is in the form 'sha256:89948f14c93756c7a3fb7b69078ff37e8489fd79dd430c582b931e2f65358690'
    # so we split it to get the hash
    $digest = $asset32.digest -split ':'

    #'plantuml-[0-9.]+\.jar$'
    # the release notes for Pandoc have been very long. Just use the URL
    #$releaseNotes = $release.html_url

    return @{
        Asset32      = $asset32
        Version      = $version
        URL32        = $asset32.browser_download_url
        Checksum32   = $digest[1]
        ReleaseNotes = $release.body
    }
}

update -NoCheckUrl -ChecksumFor none
