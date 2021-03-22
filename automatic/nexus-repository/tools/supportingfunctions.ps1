
Function Test-IfVarOrObjPropIsSetAndNotFalse {
  <#
  .SYNOPSIS
    Tests if a Variable or Object Property BOTH exists and is not $null and is not $False.
  .DESCRIPTION
    Allows a test for variables that can be commented, removed or set to $null to disable their functionality.
    Returns: $False if a Variable or Object Property either does not exist or is $null.
    IMPORTANT: The "$" character should NOT be included when calling this function.
    IMPORTANT: The function assumes an object property instead of a variable if the name given to it contains a "." character.
    IMPORTANT: If a non-existence object checked, $False is returned - becareful that your code does 
               not assume only the absence of the property.
  .COMPONENT
     pshTemplate
  .ROLE
     Core
  .PARAMETER Name
    Variable name with no "$".
  .EXAMPLE
    Test-IfVarOrObjPropIsSetAndNotFalse MyVariable
    Checks if the variable "MyVariable" exists and is not $null or $false.
    IMPORTANT: The "$" character should NOT be included when calling this function.
  .EXAMPLE
    Test-IfVarOrObjPropIsSetAndNotFalse MyObject.MyProperty
    Checks if the object property "MyObject.MyProperty" exists and is not $null or $false.
    IMPORTANT: The "$" character should NOT be included when calling this function.
    IMPORTANT: The function assumes an object property instead of a variable if the name given to it contains a "." character.
  .NOTES
    Test Verification: 
    SHOULD RETURN FALSE FOR [a] Non-existence, [b] Set to 0 (zero), [c] Set to $null, [d] Set to $False, [e] Set to ""
    FOR THESE DATA TYPES:
     Variable, Array, HashTable, Object.Property
  #> 
  [CmdletBinding()]
  param (
    [parameter(Mandatory=$True,Position=0)][string]$Name
  )
  $VariableIsNotNullNotFalseNotZero = $False
  
  if ($name.Contains(".")) {
    If (test-path ('variable:'+$name.remove($name.indexof(".")))) {
      $VariableIsNotNullNotFalseNotZero = [bool](Invoke-Expression "`$$name") 
    }
  } Else {
    If (test-path ('variable:'+$name)) {
      $VariableIsNotNullNotFalseNotZero = [bool](Get-Variable -Name $name -value) 
    }
  }
  
  return $VariableIsNotNullNotFalseNotZero
  }
Function Test-IfProcRunning ($ProcNames) {
  <#
  .SYNOPSIS
    Determines if one or more instances of any process on the list is running.
  .DESCRIPTION
    Determines if one or more instances of any process on the list is running.
    Returns $True if processes are running, $False if not.
  .PARAMETER ProcName
   Can be a string array or comma delimited string.  Can contain .exe extensions or follow PowerShell
   syntax and exclude extensions.
  .EXAMPLE
    Test-IfProcRunning @("notepad.exe","calc.exe")
  .EXAMPLE
    Test-IfProcRunning @("notepad","calc")
  .EXAMPLE
    Test-IfProcRunning "notepad.exe,calc.exe"
  .NOTES
    Author: Darwin Sanoy
    Modified: 4/4/2013
    Depends On: Write-Host()
  #> 
  # Convert string to array
  if ($ProcNames -is [System.String]) { 
  #Convert String to Array
  $ProcessNames = ($ProcNames.Split(','))
  } elseif ($ProcNames -is [System.Array]) {
  $ProcessNames = $ProcNames
  }
  
  #strip spaces and .exe if present
  for($i = 0; $i -lt $ProcessNames.count) {
  
  $ProcessNames[$i] = $ProcessNames[$i].replace(".exe","").trim()
  $i++
  }
  
  #ignore errors in case there are no instances of any given name
  $ErrorActionPreference = "SilentlyContinue"
  
  $ProcessInstances = @(get-process -ProcessName $ProcessNames).count
  
  Write-Host "Processes Running: $ProcessInstances total instances of processes with any of these names: $ProcessNames"
  
  if ($ProcessInstances -gt 0) {
  return $True
  } else {
  return $False
  }
  
} # End Function Test-IfProcRunning

Function Ensure-StopProcess ($ProcessNameList) {
<#
.SYNOPSIS
  Checks if one or more instance of named tasks are executing on this PC and terminates them.  Use Ensure-ProcessesAndServicesAreStopped instead.
.DESCRIPTION
  Closes all instances of all tasks in the list.
.COMPONENT
    pshTemplate
.ROLE
    Core-INTERNAL
.PARAMETER ProcName
  Can be a string array or comma delimited string.  Can contain .exe extensions or follow PowerShell
  syntax and exclude extensions.
.EXAMPLE
  Ensure-StopProcess @("notepad.exe","calc.exe")
.EXAMPLE
  Ensure-StopProcess @("notepad","calc")
.EXAMPLE
  Ensure-StopProcess "notepad.exe,calc.exe"
#> 

# Convert string to array
if ($ProcessNameList -is [System.String]) { 
#Convert String to Array
$ProcessNames = ($ProcessNameList.Split(','))
} elseif ($ProcessNameList -is [System.Array]) {
$ProcessNames = $ProcessNameList
}

#strip spaces and .exe if present
for($i = 0; $i -lt $ProcessNames.count; $i++) {
  $ProcessNames[$i] = $ProcessNames[$i].replace(".exe","").trim()
}

#ignore errors in case there are no instances of any given name
$ErrorActionPreference = "SilentlyContinue"

$ProcessItems = get-process -Name $ProcessNames -ea SilentlyContinue
$ProcessInstances = @($ProcessItems).Count

Write-Host "Attempting to close: $ProcessInstances total instances of processes with any of these names: $ProcessNames"

DebugMessage "Number of processes to terminate: $ProcessInstances"
if ($ProcessInstances) {
  DebugMessage "Attempting kill processes..."
  $ProcessItems | Stop-Process -Force
  start-sleep -seconds 2
}

if (@((get-process -Name $ProcessNames -ea SilentlyContinue)).count -gt 0) { 
  $EnsureStopProcess = -1
} else {
  $EnsureStopProcess = $ProcessInstances 
}
$ErrorActionPreference = "Stop"
Write-Host "Returning: $EnsureStopProcess (<#> = instances closed, 0 = no instances to close, -1 = did not close all instances)" 
return $EnsureStopProcess
} # End Function Ensure-StopProcess

Function Ensure-ProcessesAndServicesAreStopped {
<#
.SYNOPSIS
  Checks if a list of apps are running and presents user with message if they are.
  Safe to call even if none of the processes you give it are running.
.DESCRIPTION
  Returns true if the processes and services in the list are no longer running (no matter why they are not running)
  Services can be display name or registry name.
  Prompting does not apply to services, but the -Force parameter does.
  This function does comprehensive logging of the possible reasons for returning true.
  (e.g "No processes running", "User Successfully ended processes", "Processes were terminated forcefully"
  Important: If -Silent switch was used on script execution, msgboxtimed is silenced and therefore
  there is no delay at all on the FinalAction you requested.
  If you have a very stubborn service *that is a standalone EXE*, you can include it as both a service name and a process.
  It will [a] attempt to be stopped as a service, [b] Attempted to be forced down as a service, [c] have it's process terminated.
.PARAMETER ProcessAndServiceList
  List of processes and services to check.
  Processes with or without ".exe" extensions.
  Services can be display name or registry name.
  Generally services should *NOT* be killed via their EXE name, but use their service name for a proper shutdown.
  Can be set to a one of these global variables: $APS_OfficeAppsListCore or $APS_OfficeAppsListExhaustive
.PARAMETER ForceDown
  Will force processes down if the user is not able to end them.
  Will force services down if they do not come down on their own.
  Default: $False
.PARAMETER WarningCycles
  How many warning cycles to the user?
  Warning cycles are not displayed for services as users do not know how to end them.
  Default = 5.  
  Set to 0 for no warnings (silent operation).
.PARAMETER WarningSeconds
  How many seconds does each warning display?
  Default = 120.
.PARAMETER OverrideFriendlyAppNameList
  Normally the friendly name list of applications to ask the user to shutdown is taken from msgdisplay.xml.
  If this optional parameter is used to specify an array of strings, these will be displayed instead of the msgdisplay.xml list.
  This also ends up overrriding the language localization in msgdisplay.xml, as you must use the "CUSTOM" type rather than the "CLOSEAPP" message ID.
.EXAMPLE
  Ensure-ProcessesAndServicesAreStopped @("notepad.exe","calc.exe","Microsoft Office Service") -ForceDown
  Checks for Office core apps and notepad and calculator.
  Stops Microsoft Office Service (Office 365) by its display name "Microsoft Office Service"
  Warns 5 times and kills processes if user does not.
.EXAMPLE
  Ensure-ProcessesAndServicesAreStopped @("notepad.exe","calc.exe","OfficeSvc") -ForceDown -WarningCycles 8 
  TOffice core apps and notepad and calculator.
  Stops Microsoft Office Service (Office 365) by its registry name "OfficeSvc"
  Warns 8 times and kills processes if user does not.
.EXAMPLE
  Ensure-ProcessesAndServicesAreStopped "SuperCriticalProcessThatMustShutdowNormally.exe" -WarningCycles 10 -WarningSeconds 600
  Checks for "SuperCriticalProcessThatMustShutdowNormally.exe"
  Warns 5 times with a dialog that displays for 10 minutes each time) and returns false if process is not ended by user.
  IMPORTANT: Does NOT force processes down.
.EXAMPLE
  Ensure-ProcessesAndServicesAreStopped "ProcessUserCannotEnd.exe" -ForceDown -WarningCycles 0
  Terminates "ProcessUserCannotEnd.exe" without any warnings since user cannot end the process anyway.
.EXAMPLE
  Ensure-ProcessesAndServicesAreStopped @("IntegratedOffice.exe","Microsoft Office Service") -ForceDown
  The example shows the same service listed as a service name and an EXE name.
  The function will [a] attempt to be stopped it as a service, [b] atempt to force it down as a service, [c] terminate it's process.
.EXAMPLE
  Ensure-ProcessesAndServicesAreStopped @("abc.exe","xyz.exe") -ForceDown -OverrideFriendlyAppNameList @("Alphabet Software", "All Done Software")
  The example shows a custom msgdisplay.exe dialog with that asks that the software be shutdown - but lists the software in the -OverrideFriendlyAppNameList 
  rather than the list in msgdisplay.xml.
#> 
[CmdletBinding()]
param (
  [parameter(Mandatory=$True,Position=0)][string[]]$ProcessAndServiceList,
  [parameter(Mandatory=$False,Position=1)][switch]$ForceDown,
  [parameter(Mandatory=$False,Position=2)][int]$WarningCycles = 5,
  [parameter(Mandatory=$False,Position=3)][int]$WarningSeconds = 120,
  [parameter(Mandatory=$False,Position=4)][int]$SecondsToWaitForAllServices = 20,
  [parameter(Mandatory=$False,Position=5)][string[]]$OverrideFriendlyAppNameList
) 
#Request shutdown of Apps list
$ServicesReturnValue = $ProcsReturnValue = $False
$MyFunctionName = $myinvocation.MyCommand

  #Process any services in the list
  $ServicesInList = Get-Service $ProcessAndServiceList -ErrorAction SilentlyContinue
  If ($ServicesInList.Count) {
    #If there are any services in the list, stop them
    $InitialRunningServices = @($Servicesinlist | % {get-service $_.Displayname | where-object {$_.Status -eq "Running"}})
    If ($InitialRunningServices.Count -gt 0){
      Write-Host "$MyFunctionName : Found $($ServicesInList.count) services in list, of which $($InitialRunningServices.Count) are running.  Attempting to stop the following services:"
      $InitialRunningServices | Select -ExpandProperty DisplayName | Write-Host
      Stop-Service $InitialRunningServices -ErrorAction SilentlyContinue
      Start-Sleep -seconds $SecondsToWaitForAllServices
      $NonStoppingServices = @($InitialRunningServices | % {get-service $_.Displayname | where-object {$_.Status -eq "Running"}})
      If (($NonStoppingServices.count -gt 0) -and $ForceDown) {
        #If they didn't come down nicely, force them.
        Write-Host "$MyFunctionName : Some Services did not end voluntarily, forcing down the following services:"
        $NonStoppingServices | Select -ExpandProperty DisplayName | Write-Host
        $NonStoppingServices | Stop-Service -Force -ErrorAction SilentlyContinue
        Start-Sleep -seconds $SecondsToWaitForAllServices
        $NonStoppingServices = @($InitialRunningServices | % {get-service $_.Displayname | where-object {$_.Status -eq "Running"}})
      }
      If ($NonStoppingServices.count -gt 0) {
        Write-Host "$MyFunctionName : The following services did not stop after forcing:"
        $NonStoppingServices | Select -ExpandProperty DisplayName | Write-Host
        $ServicesReturnValue = $False
      } Else {
        Write-Host "$MyFunctionName : Stopped all $($ServicesInList.Count) services in list.  List: $ProcessAndServiceList"
        $ServicesReturnValue = $True
      }
    } else {
      Write-Host "$MyFunctionName : None of the $($ServicesInList.Count) in the list are running.  List: $ProcessAndServiceList"
      $ServicesReturnValue = $True
    }
  } else {
    Write-Host "$MyFunctionName : There are no services in this list: $ProcessAndServiceList"
    $ServicesReturnValue = $True
}

  if ($ProcessAndServiceList) {
  Write-Host "$MyFunctionName : Checking if any of these are running: $ProcessAndServiceList"
  
  if (Test-IfProcRunning $ProcessAndServiceList) {

    $j = 1
    while ((Test-IfProcRunning $ProcessAndServiceList) -and ($j -le $WarningCycles)) 
      {
      If (Test-IfVarOrObjPropIsSetAndNotFalse OverrideFriendlyAppNameList)  
        {
        #Use override friendly name list
        $TempMsgText = "[nl] Please close any applications in the below list:[nl]"
        ForEach ($FriendlyName in $OverrideFriendlyAppNameList)
          {
          $TempMsgText += "[nl]$FriendlyName"
          }
        Write-Host "Waiting $WarningSeconds seconds for the following to exit: $TempMsgText"
        Start-Sleep -Seconds $WarningSeconds
        }
      Else
        {
        Write-Host "Waiting for $WarningSeconds seconds"
        Start-Sleep -Seconds $WarningSeconds
        }
        if (-not (Test-IfProcRunning $ProcessAndServiceList)) {
          Write-Host "$MyFunctionName : User SUCCESSFULLY ended all processes in list: $ProcessAndServiceList"
          #Go back with true right now.
          $ProcsReturnValue = $True
        }
        $j++
      }
  } else {
    Write-Host "$MyFunctionName : No instances running of any processes in list: $ProcessAndServiceList"
    #Go back with true right now.
    $ProcsReturnValue = $True
  }
  if ((Test-IfProcRunning $ProcessAndServiceList) -and $ForceDown) 
    {
    Write-Host "$MyFunctionName : User did not end one or more process and -ForceDown was used, terminating processlist: $ProcessAndServiceList"
    $NumberClosed = Ensure-StopProcess($ProcessAndServiceList)
    if ($NumberClosed -eq -1) {
      $ProcsReturnValue = $False
    } else {
      Write-Host "$MyFunctionName : $NumberClosed Processes were forcefully terminated."
      #Go back with true right now.
      $ProcsReturnValue = $True
    }
    }
  }

  If ($ServicesReturnValue -and $ProcsReturnValue) {
    return $True
  } Else {
    return $False
  }
}
      