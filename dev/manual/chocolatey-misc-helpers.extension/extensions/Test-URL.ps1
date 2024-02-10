$ErrorActionPreference = 'Stop'
# chocolatey-misc-helpers.extension v0.0.4 (08-24-2020) by Bill Curran - public domain
# Test a download URL and return true if it's valid or false if it's not.
# Use before Install-ChocolateyPackage so that you can switch to an alternative URL.
# Recommended implementation: define $urlalt and $url64alt in your nuspec similar to $url and $url64.
# Add the following 2 lines to your chocolateyInstall script to check and use the alternate URL when the primary is bad:
# if (Test-URL "$url") {} else {if (Test-URL "$urlalt"){$url=$urlalt}}
# if (Test-URL "$url64") {} else {if (Test-URL "$url64alt"){$url64=$url64alt}}
# Thanks to https://stackoverflow.com/questions/23760070/the-remote-server-returned-an-error-401-unauthorized

function Test-URL([string]$url){
if (($url -match "http://") -or ($url -match "https://")){
     $HTTP_Response = $null
     $HTTP_Request = [System.Net.WebRequest]::Create($url)
     try{
         $HTTP_Response = $HTTP_Request.GetResponse()
         $HTTP_Status = [int]$HTTP_Response.StatusCode
         if ($HTTP_Status -eq 200) { 
           return $true
         } else {
           return $true
         }
         $HTTP_Response.Close()
        } catch {
          $HTTP_Status = [regex]::matches($_.exception.message, "(?<=\()[\d]{3}").Value
          return $false
        }
   }
}
