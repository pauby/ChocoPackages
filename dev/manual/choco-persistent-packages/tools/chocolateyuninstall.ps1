$ErrorActionPreference = 'Stop'
#persistentpackages.config file purposely not deleted as not to lose configuration on a re-installation
$packageName = 'choco-persistent-packages'

SchTasks /Delete /TN “choco-persistent-packages” /F
SchTasks /Delete /TN choco-persistent-packages-abort /F

