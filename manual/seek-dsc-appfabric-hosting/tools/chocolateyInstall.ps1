try
{
	$DSCResourcesRoot = Join-Path $env:ProgramFiles "WindowsPowerShell\Modules"
	$DSCResourceTarget = Join-Path $env:chocolateyPackageFolder "lib"

	# remove DSC resources that may have been manually installed
	if (Test-Path "$DSCResourcesRoot\SEEK - Modules") {
		cmd /c rmdir "$DSCResourcesRoot\SEEK - Modules"
	}

	
	Get-ChildItem $DSCResourceTarget | Foreach-Object {
		if (Test-Path "$DSCResourcesRoot\$_") {
			# remove previous installation of this package
			cmd /c rmdir "$DSCResourcesRoot\$_"
		}
		cmd /c mklink /j "$DSCResourcesRoot\$_" "$DSCResourceTarget\$_"
		Get-ChildItem -Path "$DSCResourcesRoot\$_" -File -Recurse | Unblock-File
	}

} catch {
	$host.SetShouldExit(1)
	throw $_.Exception
}
