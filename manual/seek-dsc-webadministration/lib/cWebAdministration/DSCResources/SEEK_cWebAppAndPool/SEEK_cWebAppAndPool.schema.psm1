Configuration cWebAppAndPool
{
    param
    (
        [String]$Name,
        [String[]]$WebSiteName,
        [String]$AppPoolName,
        [HashTable]$AppPoolCredentials,
        [String]$AppPoolManagedRuntimeVersion = "v4.0",
        [String]$AppPoolIdentityType = "SpecificUser",
        [String]$AppPoolManagedPipelineMode = "Integrated",
        [String]$AppPoolEnable32BitAppOnWin64 = "false",
        [HashTable]$AuthenticationInfo = @{Anonymous = "true"; Basic = "false"; Digest = "false"; Windows = "false"},
        [String]$PhysicalPath
    )

    Import-DscResource -Module cWebAdministration -Name SEEK_cWebAppPool, SEEK_cWebApplication

    cWebAppPool AppPool
    {
        Name = $AppPoolName
        ApplicationName = $Name
        UserName = $AppPoolCredentials.Username
        Password = $AppPoolCredentials.Password
        ManagedRuntimeVersion = $AppPoolManagedRuntimeVersion
        IdentityType = $AppPoolIdentityType
        ManagedPipelineMode = $AppPoolManagedPipelineMode
        Enable32BitAppOnWin64 = $AppPoolEnable32BitAppOnWin64
    }

    Foreach ($website in @($WebSiteName))
    {
        cWebApplication "${website}WebApplication"
        {
            Name = $Name
            Website = $website
            WebAppPool =  $AppPoolName
            PhysicalPath = $PhysicalPath
            AuthenticationInfo = SEEK_cWebApplicationAuthenticationInformation
                                {
                                    Anonymous = $AuthenticationInfo.Anonymous
                                    Basic = $AuthenticationInfo.Basic
                                    Digest = $AuthenticationInfo.Digest
                                    Windows = $AuthenticationInfo.Windows
                                }
            DependsOn = @("[cWebAppPool]AppPool")
        }
    }
}
