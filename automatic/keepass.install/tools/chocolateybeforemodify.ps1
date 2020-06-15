# Automatically close KeePass if KeePass is running. If the database has unsaved changes the user will be prompted to save the database.
# Works only with the default installation paths
$keepassProcess = Get-Process -Name "Keepass" -ErrorAction "SilentlyContinue"
if ($keepassProcess) {
    Write-Host "KeePass is running. Try to close KeePass automatically. If you have unsaved entries, you will be prompted to save them."
    & $keepassProcess.Path --exit-all
}
