#Automatically close KeePass if KeePass is running.
if (Get-Process -Name "Keepass" -ErrorAction "SilentlyContinue" ) { 
    Stop-Process -Name "Keepass"
}