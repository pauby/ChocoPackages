#
# Converts parameters into a hashtable where the parameter name is the key and the parameter value is the value
#

function global:ConvertFrom-ChocoParameters ([string]$parameter) {
    $arguments = @{};

    if ($parameter) {
        $match_pattern = "\/(?<option>([a-zA-Z]+)):(?<value>([`"'])?([a-zA-Z0-9- _\\:\.]+)([`"'])?)|\/(?<option>([a-zA-Z]+))"
        $option_name = 'option'
        $value_name = 'value'

        if ($parameter -match $match_pattern) {
            $results = $parameter | Select-String $match_pattern -AllMatches
            $results.matches | % {
                $arguments.Add(
                    $_.Groups[$option_name].Value.Trim(),
                    $_.Groups[$value_name].Value.Trim())
            }
        }
        else {
          throw "Package Parameters were found but were invalid (REGEX Failure). See package description for correct format."
        }
    }

    return $arguments;
}

#
# Returns a unique temporary filename
#
function global:Get-ChocoUniqueTempName
{
    do {
        $tempDir = Join-Path -Path $env:TEMP -ChildPath ([System.Guid]::NewGuid().ToString())
    } while (Test-Path $tempDir)

    return $tempDir
}

#
# Tewts if the OS is a Server
#
function global:Test-ChocoServerOS
{
    return ($env:OS_NAME -like "*Server*")
}

#
# Added by d.hilgarth
# Query Installed Applications information
#
# Returns information about one or all installed packages that match
# naming pattern. Do it by analyzing registry, so it's not only showing
# Windows Instaler MSI packages.
#
# Usage:
#
#   Show-AppUninstallInfo -match "micro" -first $false
#
# Author:
#   Colovic Vladan, cvladan@gmail.com
#

function global:Show-AppUninstallInfo {
param(
    [string] $matchPattern = '',
    [string] $ignorePattern = '',
    [bool] $firstOnly = $false
)

    Write-Debug "Querying registry keys for uninstall pattern: $matchPattern"

    if ($env:PROCESSOR_ARCHITEW6432 -eq "AMD64") {

        # In reality, it's possible, but not worth it...
        # How to query 64 bit Registry with 32 bit PowerShell...
        #
        # http://www.zerosignal.co.uk/2011/12/64-bit-registry-32-bit-powershell/
        # http://stackoverflow.com/questions/10533421/accessing-64-bit-registry-from-32-bit-application
        # http://poshcode.org/2470
        # http://stackoverflow.com/a/8588982/1579985
        #
        Write-Host ""
        Write-Host "CAUTION:" -foregroundcolor red
        Write-Host "  You are running 32-bit process on a 64-bit operating system," -foregroundcolor red
        Write-Host "  and in this environment it's not possible to reliably detect" -foregroundcolor red
        Write-Host "  all installed applications." -foregroundcolor red
        Write-Host ""
    }

    # Any error at this point should be terminating
    #
    $ErrorActionPreference = "Stop"

    # Array of hashes/ Using hash similar to an object to hold our
    # application information
    #
    $appArray = @()

    # This is the real magic of the script. We use Get-ChildItem to
    # get all of the sub-keys that contain application info.
    # Here, we MUST silently ignore errors
    #
    $ErrorActionPreference = "SilentlyContinue"

    $keys  = Get-ChildItem "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall" -Recurse
    $keys += Get-ChildItem "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall" -Recurse
    $keys += Get-ChildItem "HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall" -Recurse
    $keys += Get-ChildItem "HKCU:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall" -Recurse

    # On 64-bit systems, we get very important extra list from the
    # Wow6432Node nodes. But now I'm skipping OS detection that we
    # used before, as it turned out that it's really not very reliable.

    # Build out hash for every matched application
    #
    foreach ($key in $keys)
    {
        # Adding a try-catch around the statement will hide the error and
        # prevent it being caught in the main try / catch. And we are
        # already silnetly continuing on errors
        #
        try { $pkgName = $key.GetValue("DisplayName") } catch {}

        # Only query data for apps with a name
        #
        if ($pkgName)
        {
            $pkgName = $pkgName.Trim()

            if (($pkgName.Length -eq 0) -or `
                ($matchPattern -and ($pkgName -notmatch $matchPattern)) -or `
                ($ignorePattern -and ($pkgName -match $ignorePattern)))
            {
                # Move on if not match regular expression.
                # It's case-insensitive comparison.
                #
                continue
            }

            Write-Debug "* $pkgName"

            # Ignore every error
            #
            try {

                # Convert estimated size to megabytes
                #
                $tmpSize = '{0:N2}' -f ($key.GetValue("EstimatedSize") / 1MB)

                # Populate our object
                # We must initialize object here, not outside loop
                #
                $app = @{}
                $app["DisplayName"]            = $pkgName                                  # Name / InnoSetup: yes, MSI: yes
                $app["DisplayVersion"]         = $key.GetValue("DisplayVersion")
                $app["Publisher"]              = $key.GetValue("Publisher")                # Company / InnoSetup: yes, MSI: yes
                $app["InstallLocation"]        = $key.GetValue("InstallLocation")          # / InnoSetup: yes, MSI: sometimes empty
                $app["InstallDate"]            = $key.GetValue("InstallDate")              # yyyymmdd / InnoSetup: yes, MSI: yes
                $app["UninstallString"]        = $key.GetValue("UninstallString")          # / InnoSetup: yes, MSI: yes
                $app["QuietUninstallString"]   = $key.GetValue("QuietUninstallString")     # / InnoSetup: yes, MSI: no
                $app["EstimatedSizeMB"]        = $tmpSize                                  # / InnoSetup: yes, MSI: yes

            } catch {}

            $app["RegistryPath"]           = $key.name
            $app["RegistryKeyName"]        = $key.pschildname

            # If it has keys that start with `Inno Setup:`, like `Inno
            # Setup: App Path` or `Inno Setup: Selected Tasks`, then we have
            # a lot of extra information and know the installer
            #
            # Inno Setup almost always has `QuietUninstallString` set, which
            # is usually normal one appended with ` /SILENT`. And
            # you can discover silent installation arguments by analyzing
            # keys with `Tasks` and `Components`
            #
            # Uninstall Registry Key for MSI installer:
            # http://msdn.microsoft.com/en-us/library/windows/desktop/aa372105(v=vs.85).aspx

            $appArray += $app

            if ($matchPattern -and $firstOnly)
            {
                # If pattern was defined and we want only the first
                # result, it means we found our first app. I think we
                # can exit now - I don't need multiple list for that.

                break
            }
        }
    }

    # Reset error action preference
    $ErrorActionPreference = "Continue"

    return $appArray
}

# Added by d.hilgarth
function global:Get-AppInstallLocation() {
    param ([string]$appNameRegex)

    $apps = @(Show-AppUninstallInfo -match $appNameRegex)

    if ($apps.Length -eq 0)
    {
        throw "Could not detect a valid installation for $appNameRegex"
    }

    $app = $apps[0]
    $installLocation = $app["InstallLocation"]

    if ($installLocation -eq $null) {
        throw "Application found, but no install location has been recorded for it."
    }
    if(-not (Test-Path "$installLocation")) {
        throw "Local installation is detected at '$apps', but directories are not accessible or have been removed"
    }

    return $installLocation
}

# Added by d.hilgarth
function global:Get-FullAppPath ([string]$uninstallName, [string]$relativePath, [string]$executable, [string]$installFolderName) {

    function GetInstalledApp ([string]$uninstallName, [string]$relativePath, [string]$executable) {
        $apps = @(Show-AppUninstallInfo -match $uninstallName)

        $exe = $null

        if ($apps.Length -ne 0)
        {
            $app = $apps[0]
            $dir = $app["InstallLocation"]
            if ((![string]::IsNullOrEmpty($dir)) -and (Test-Path "$dir")) {
                $exe = (Join-Path "$dir" (Join-Path $relativePath $executable))
            }
        }

        return $exe;
    }

    function FindInAppPaths([string]$executable) {
        $path = Get-ChildItem "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths" | Where-Object PSChildName -eq $executable | Select-Object -First 1
        if($path -ne $null) {
            $fullPath = $path.GetValue("")
            if($fullPath -ne $null) {
                return (Get-Item ([System.Environment]::ExpandEnvironmentVariables($fullPath))).FullName
            }
            $directory = $path.GetValue("Path")
            if($directory -ne $null) {
                return (Join-Path ([System.Environment]::ExpandEnvironmentVariables($directory)) $executable)
            }
        }
    }

    function FindInProgramsFolder([string]$programsFolder, [string]$installFolderName, [string]$relativePath, [string]$executable) {
        $installDir = Join-Path $programsFolder $installFolderName
        if(Test-Path $installDir) {
            $fullPath = Join-Path $installDir (Join-Path $relativePath $executable)
            if(Test-Path $fullPath) {
                return $fullPath
            }
        }
    }

    function FindInProgramFiles([string]$installFolderName, [string]$relativePath, [string]$executable) {
        $fullPath = FindInProgramsFolder $env:ProgramFiles $installFolderName $relativePath $executable
        if(($fullPath -ne $null) -and (Test-Path $fullPath)) {
            return $fullPath
        }
        $fullPath = FindInProgramsFolder ${env:ProgramFiles(x86)} $installFolderName $relativePath $executable
        if(($fullPath -ne $null) -and (Test-Path $fullPath)) {
            return $fullPath
        }
    }

    $exe = $null

    if($exe -eq $null) {
        if($PSBoundParameters.ContainsKey('uninstallName') -and $PSBoundParameters.ContainsKey('relativePath') -and $PSBoundParameters.ContainsKey('executable')) {
            $exe = GetInstalledApp $uninstallName $relativePath $executable
        }
    }

    if($exe -eq $null) {
        if($PSBoundParameters.ContainsKey('installFolderName') -and $PSBoundParameters.ContainsKey('relativePath') -and $PSBoundParameters.ContainsKey('executable')) {
            $exe = FindInProgramFiles $installFolderName $relativePath $executable
        }
    }

    if($exe -eq $null) {
        try {
            $exe = (Get-Command $executable -ErrorAction SilentlyContinue).Definition;
        }
        catch {
        }
    }

    if($exe -eq $null) {
        $exe = FindInAppPaths $executable
    }


    if($exe -eq $null) {
        throw "Unable to find $executable"
    }

    return $exe
}