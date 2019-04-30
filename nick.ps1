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

#--- Setting up Windows ---
executeScript "SystemConfiguration.ps1";
executeScript "FileExplorerSettings.ps1";
executeScript "RemoveDefaultApps.ps1";
executeScript "HyperV.ps1";

Disable-GameBarTips
Disable-BingSearch
Enable-RemoteDesktop

choco upgrade IIS-ManagementConsole IIS-WebServer -y  --source="'windowsfeatures'"

Enable-WindowsOptionalFeature -Online -FeatureName containers -All
RefreshEnv
choco upgrade docker-for-windows -y

#--- Tools ---
# See this for VS install args: https://chocolatey.org/packages/VisualStudio2019Community
# https://docs.microsoft.com/en-us/visualstudio/install/workload-component-id-vs-community
# https://docs.microsoft.com/en-us/visualstudio/install/use-command-line-parameters-to-install-visual-studio#list-of-workload-ids-and-component-ids

#todo add remainder of choco packages

choco upgrade visualstudio2019community -y --params="'--add Component.GitHub.VisualStudio'"
Update-SessionEnvironment #refreshing env due to Git install

#--- reenabling critical items ---
Enable-UAC
Enable-MicrosoftUpdate
Install-WindowsUpdate -acceptEula
