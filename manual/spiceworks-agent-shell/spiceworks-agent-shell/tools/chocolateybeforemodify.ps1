Write-Verbose "Stopping the Spiceworks Agent Shell Service service"
Stop-Service -Name 'AgentShellService' -ErrorAction SilentlyContinue | Out-Null