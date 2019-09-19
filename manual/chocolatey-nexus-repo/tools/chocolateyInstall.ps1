$ErrorActionPreference = 'Stop'

# mandatory parameters that must be supplied
$requiredParams = @( 'Username', 'Password' )

# default parameters
$defaultParams = @{
    ServerUri      = 'http://localhost:8081'
    RepositoryName = 'choco-base'
    BlobStoreName  = 'default'
}

function Invoke-NexusScript {
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory)]
        [String]
        $ServerUri,

        [Parameter(Mandatory)]
        [Hashtable]
        $ApiHeader,

        [Parameter(Mandatory)]
        [String]
        $Script
    )

    $scriptName = [GUID]::NewGuid().ToString()
    $body = @{
        name    = $scriptName
        type    = 'groovy'
        content = $Script
    }

    # Call the API
    $baseUri = "$ServerUri/service/rest/v1/script"

    #Store the Script
    $uri = $baseUri
    Invoke-RestMethod -Uri $uri -ContentType 'application/json' -Body $($body | ConvertTo-Json) -Header $ApiHeader -Method Post
    #Run the script
    $uri = "{0}/{1}/run" -f $baseUri, $scriptName
    $result = Invoke-RestMethod -Uri $uri -ContentType 'text/plain' -Header $ApiHeader -Method Post
    #Delete the Script
    $uri = "{0}/{1}" -f $baseUri, $scriptName
    Invoke-RestMethod -Uri $uri -Header $ApiHeader -Method Delete

    $result
}

# defaults
$params = Get-PackageParameters

# Check for mandatory parameters
$missingParams = $false
$requiredParams | ForEach-Object {
    if (-not $params.$_) {
        Write-Error "Mandatory parameter missing - '$_'." -ErrorAction Continue
        $missingParams = $true
    }
}

if ($missingParams) {
    throw "One or more mandatory parameters have not been provided."
}

# loop through the defaults
# if a parameter does not exist that matches the $defaultParams.Keys then use the value from $defaultParams
$defaultParams.Keys | ForEach-Object {
    if (-not $params.$_) {
        $params.$_ = $defaultParams.$_
    }
}

# trim any trailing '/' from the URI
$params.ServerUri = $params.ServerUri.trim('/')

# Tell the user the details we are going to use
Write-Host "Will create a repository using these details:"
$params.Keys | ForEach-Object {
    Write-Host ("    {0,-20} : {1}" -f $_, $params.$_)
}

# Create the Api header
$credPair = ("{0}:{1}" -f $params.Username, $params.Password)
$encodedCreds = [System.Convert]::ToBase64String([System.Text.Encoding]::ASCII.GetBytes($credPair))
$header = @{
    Authorization = "Basic $encodedCreds"
}

# Check the repo does not already exist
$repositories = Invoke-RestMethod -Uri 'http://localhost:8081/service/rest/v1/repositories' -Method Get -Headers $header
if ($params.RepositoryName -in @($repositories.Name)) {
    throw "Cannot create repository '$($params.RepositoryName)' as it already exists!"
}

# Create the NuGet Repo
$createRepoParams = @{
    ServerUri = $params.ServerUri
    ApiHeader = $header
    Script    = @"
import org.sonatype.nexus.repository.Repository;
repository.createNugetHosted("$($params.RepositoryName)","$($params.BlobStoreName)");
"@
}

Invoke-NexusScript @createRepoParams | Out-Null

# Enable the NuGet Relam
$enableNugetRealmParams = @{
    ServerUri = $params.ServerUri
    ApiHeader = $header
    Script    = @"
import org.sonatype.nexus.security.realm.RealmManager

realmManager = container.lookup(RealmManager.class.getName())

// enable/disable the NuGet API-Key Realm
realmManager.enableRealm("NuGetApiKey")
"@
}

Invoke-NexusScript @enableNugetRealmParams | Out-Null