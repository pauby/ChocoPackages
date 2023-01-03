try
{
	$DSCResourcesRoot = Join-Path $env:ProgramFiles "WindowsPowerShell\Modules"
	$DSCResourceTarget = Join-Path $env:chocolateyPackageFolder "lib"
	Get-ChildItem $DSCResourceTarget | Foreach-Object { cmd /c rmdir "$DSCResourcesRoot\$_" }
} catch {
    throw $_.Exception
}