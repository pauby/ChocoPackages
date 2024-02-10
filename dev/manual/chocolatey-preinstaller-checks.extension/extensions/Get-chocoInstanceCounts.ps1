$ErrorActionPreference = 'Stop'
# chocolatey-preinstaller-checks.extension v0.0.2 by Bill Curran AKA BCURRAN3 - 2018 Copyleft Bill Curran
# modification created by Michel Buczynski AKA MikeBoutch 
# \ProgramData\chocolatey\bin\choco.exe (in path) is a shim and \ProgramData\chocolatey\choco.exe actual (not in path)
# SelfServe mode imply a background choco.exe with chocolatey-agent as parent and
#    a forground choco.exe with a shim as parent
# Get the current instance choco.exe (so we a count of 1 already)
# get all instances of choco.exe 
#    Dont count who has chocholatey-agent.exe has parent since they a foreground pair of shim and choco.exe running
#    Count only those that have a shim or chocolatey-management-service as parent

function Get-chocoInstanceCounts{
    
    $chocoCommands='chocolatey', 'choco', 'cinst', 'clist',  'cpack', 'cpush', 'cup', 'cuninst', 'cver', 'chocolatey-management-service' 
  
    Write-verbose "Current Process: $($PID)"
    if ($(Get-Process -Id (Get-CimInstance -Class Win32_Process -Verbose:$false -Filter "ProcessID=$($PID)").ParentProcessId).ProcessName -eq 'chocolatey-agent'){
        Write-verbose "   Running in SelfServe (background mode)"
    }
  
    Write-verbose "Searching for choco.exe process"
    $counts=0
    Get-Process -ea silentlycontinue -Name choco| % {
      $_Cim=Get-CimInstance -Class Win32_Process -Verbose:$false -Filter "ProcessID=$($_.Id)"
      $_Parent=Get-Process -Id $_Cim.ParentProcessId
      $_ParentCim=Get-CimInstance -Class Win32_Process -Verbose:$false -Filter "ProcessID=$($_Parent.Id)"
      Write-Verbose "$($_.Id): ``$($_Cim.CommandLine)`` --> $($_Parent.Id): ``$($_ParentCim.CommandLine)``"
      if ($chocoCommands.contains($_Parent.ProcessName)) {
        Write-Verbose "$($_.Id) is actual choco process"
        $counts+=1 
      } elseif ($_Parent.ProcessName -eq 'chocolatey-agent'){
        Write-Verbose "$($_.Id) is Chocolatey in background mode"
        #count only choco.exe running in foreground   
      } else {
        Write-Verbose "$($_.Id) is probably a shim of choco.exe"
      }
    }
    Write-Verbose "choco.exe instance count is $($counts)"
  
    return $counts
  }
