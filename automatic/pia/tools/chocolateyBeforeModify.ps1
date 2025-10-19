$ErrorActionPreference = 'Stop'

# Stop the pia services
'PrivateInternetAccessService', 'PrivateInternetAccessWireguard' | ForEach-Object {
    Stop-Service $_ -Force -ErrorAction SilentlyContinue
}
