# Description: Boxstarter Script
# Author: Microsoft
# Nick's settings for development

Disable-UAC

# Get the base URI path from the ScriptToCall value
$bstrappackage = "-bootstrapPackage"
$helperUri = $Boxstarter['ScriptToCall']
$strpos = $helperUri.IndexOf($bstrappackage)
$helperUri = $helperUri.Substring($strpos + $bstrappackage.Length)
$helperUri = $helperUri.TrimStart("'", " ")
$helperUri = $helperUri.TrimEnd("'", " ")
$helperUri = $helperUri.Substring(0, $helperUri.LastIndexOf("/"))
$helperUri += "/scripts"
write-host "helper script base URI is $helperUri"

function executeScript {
    Param ([string]$script)
    write-host "executing $helperUri/$script ..."
	iex ((new-object net.webclient).DownloadString("$helperUri/$script"))
}

# Workaround choco / boxstarter path too long error
# https://github.com/chocolatey/boxstarter/issues/241
$ChocoCachePath = "$env:USERPROFILE\AppData\Local\Temp\chocolatey"
New-Item -Path $ChocoCachePath -ItemType Directory -Force

#--- Setting up Windows ---
executeScript "SystemConfiguration.ps1";
executeScript "FileExplorerSettings.ps1";
executeScript "RemoveDefaultApps.ps1";
executeScript "HyperV.ps1";

Disable-GameBarTips
Disable-BingSearch
Enable-RemoteDesktop

choco install IIS-ManagementConsole IIS-WebServer -y --source="'windowsfeatures'"

Enable-WindowsOptionalFeature -Online -FeatureName containers -All
RefreshEnv

#--- Tools ---
# See this for VS install args: https://chocolatey.org/packages/VisualStudio2019Community
# https://docs.microsoft.com/en-us/visualstudio/install/workload-component-id-vs-community
# https://docs.microsoft.com/en-us/visualstudio/install/use-command-line-parameters-to-install-visual-studio#list-of-workload-ids-and-component-ids

choco upgrade --cacheLocation="$ChocoCachePath" visualstudio2019community -y --params="'--add Component.GitHub.VisualStudio'"

choco upgrade --cacheLocation="$ChocoCachePath" 7zip.install -y
choco upgrade --cacheLocation="$ChocoCachePath" adobereader -y
choco upgrade --cacheLocation="$ChocoCachePath" awscli -y
choco upgrade --cacheLocation="$ChocoCachePath" azure-cli -y
choco upgrade --cacheLocation="$ChocoCachePath" beyondcompare -y
choco upgrade --cacheLocation="$ChocoCachePath" ccleaner -y
choco upgrade --cacheLocation="$ChocoCachePath" discord.install -y
choco upgrade --cacheLocation="$ChocoCachePath" docfx -y
choco upgrade --cacheLocation="$ChocoCachePath" docker-desktop -y
choco upgrade --cacheLocation="$ChocoCachePath" dotnetcore-windowshosting -y
choco upgrade --cacheLocation="$ChocoCachePath" f.lux.install -y
choco upgrade --cacheLocation="$ChocoCachePath" fiddler -y
choco upgrade --cacheLocation="$ChocoCachePath" firacode -y
choco upgrade --cacheLocation="$ChocoCachePath" firefox -y
choco upgrade --cacheLocation="$ChocoCachePath" git.install -y --params="'/GitAndUnixToolsOnPath /NoShellIntegration'"
choco upgrade --cacheLocation="$ChocoCachePath" googlechrome -y
choco upgrade --cacheLocation="$ChocoCachePath" gyazo -y
choco upgrade --cacheLocation="$ChocoCachePath" javaruntime -y
choco upgrade --cacheLocation="$ChocoCachePath" kdiff3 -y
choco upgrade --cacheLocation="$ChocoCachePath" kubernetes-cli -y
choco upgrade --cacheLocation="$ChocoCachePath" libreoffice-fresh -y
choco upgrade --cacheLocation="$ChocoCachePath" nodejs.install -y
choco upgrade --cacheLocation="$ChocoCachePath" postman -y
choco upgrade --cacheLocation="$ChocoCachePath" powershell-core -y
choco upgrade --cacheLocation="$ChocoCachePath" python2 -y
choco upgrade --cacheLocation="$ChocoCachePath" python3 -y
choco upgrade --cacheLocation="$ChocoCachePath" slack -y
choco upgrade --cacheLocation="$ChocoCachePath" sql-server-management-studio -y
choco upgrade --cacheLocation="$ChocoCachePath" steam -y
choco upgrade --cacheLocation="$ChocoCachePath" visualstudio2019-workload-azure -y
choco upgrade --cacheLocation="$ChocoCachePath" visualstudio2019-workload-data -y
choco upgrade --cacheLocation="$ChocoCachePath" visualstudio2019-workload-manageddesktop -y
choco upgrade --cacheLocation="$ChocoCachePath" visualstudio2019-workload-netcoretools -y
choco upgrade --cacheLocation="$ChocoCachePath" visualstudio2019-workload-netweb -y
choco upgrade --cacheLocation="$ChocoCachePath" visualstudio2019-workload-node -y
choco upgrade --cacheLocation="$ChocoCachePath" webdeploy -y
choco upgrade --cacheLocation="$ChocoCachePath" windirstat -y
choco upgrade --cacheLocation="$ChocoCachePath" winmerge -y
choco upgrade --cacheLocation="$ChocoCachePath" wsl -y
choco upgrade --cacheLocation="$ChocoCachePath" yarn -y

#--- reenabling critical items ---
Enable-UAC
Enable-MicrosoftUpdate
Install-WindowsUpdate -acceptEula
