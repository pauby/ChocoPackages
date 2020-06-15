$ErrorActionPreference = 'Stop'

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
if (-not ($params.Username)) {
    Write-Error "Mandatory parameter 'Username' missing." -ErrorAction Continue
    $missingParams = $true
}

if (-not ($params.Password -or $params.EnterPassword)) {
    Write-Error "Mandatory parameter 'Password' OR 'EnterPassword' missing." -ErrorAction Continue
    $missingParams = $true
}

if ($missingParams) {
    Write-Error "Please re-run the package install providing the missing parameters."
}

# Prompt for the password if the /EnterPassword parameter has been added
if ($params.EnterPassword) {
    # Use -AsSecureString so the characters are not echoed to the screen. 
    # But it does mean we need to extrac tht plain test password later.
    $securePassword = Read-Host -Prompt "Enter the password for user '$($params.Username)'." -AsSecureString

    # Now unencrypt the password
    $bstr = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($securePassword)
    $params.Password = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($bstr) 

    # Remove the EnterPassword parameter as it shows up later when we list the parameter values we are going to use.
    # I feel like it will cause confusion.
    $params.Remove('EnterPassword')
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
    if ($_ -eq 'password' -or $_ -eq 'enterpassword') {
        $msg = '******'
    }
    else {
        $msg = $params.$_
    }

    Write-Host ("    {0,-20} : {1}" -f $_, $msg)
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