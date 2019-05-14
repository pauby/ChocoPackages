# Automatically close KeePass if KeePass is running. If the database has unsaved changes the user will be prompted to save the database.
# Works only with the default installation paths
if (Get-Process -Name "Keepass" -ErrorAction "SilentlyContinue" ) { 
    if (Test-Path "${env:ProgramFiles(x86)}\KeePass Password Safe 2\KeePass.exe") {
        & "${env:ProgramFiles(x86)}\KeePass Password Safe 2\KeePass.exe" "--exit-all"
    } else {
        if (Test-Path "$env:ProgramFiles\KeePass Password Safe 2\KeePass.exe") {
            & "$env:ProgramFiles\KeePass Password Safe 2\KeePass.exe" "--exit-all"
        }
    }
}
