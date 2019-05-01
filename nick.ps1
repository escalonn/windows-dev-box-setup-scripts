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

choco upgrade IIS-ManagementConsole IIS-WebServer -y --source="'windowsfeatures'"

Enable-WindowsOptionalFeature -Online -FeatureName containers -All
RefreshEnv

#--- Tools ---
# See this for VS install args: https://chocolatey.org/packages/VisualStudio2019Community
# https://docs.microsoft.com/en-us/visualstudio/install/workload-component-id-vs-community
# https://docs.microsoft.com/en-us/visualstudio/install/use-command-line-parameters-to-install-visual-studio#list-of-workload-ids-and-component-ids

choco upgrade visualstudio2019community -y --params="'--add Component.GitHub.VisualStudio'"

choco upgrade 7zip -y
choco upgrade adobereader -y
choco upgrade awscli -y
choco upgrade azure-cli -y
choco upgrade batterybar -y
choco upgrade beyondcompare -y
choco upgrade ccleaner -y
choco upgrade conemu -y
choco upgrade docfx -y
choco upgrade docker-for-windows -y
choco upgrade dotnetcore-sdk -y
choco upgrade dotnetcore-windowshosting -y
choco upgrade dropbox -y
choco upgrade f.lux -y
choco upgrade fiddler -y
choco upgrade firefox -y
choco upgrade git -y --params="'/GitAndUnixToolsOnPath /NoShellIntegration'"
choco upgrade googlechromebeta -y
choco upgrade gyazo -y
choco upgrade javaruntime -y
choco upgrade kdiff3 -y
choco upgrade kubernetes-cli -y
choco upgrade libreoffice-fresh -y
choco upgrade nodejs -y
choco upgrade postman -y
choco upgrade pwsh -y
choco upgrade python2 -y
choco upgrade slack -y
choco upgrade sql-server-management-studio -y
choco upgrade visualstudio2019-workload-azure -y
choco upgrade visualstudio2019-workload-data -y
choco upgrade visualstudio2019-workload-manageddesktop -y
choco upgrade visualstudio2019-workload-netcoretools -y
choco upgrade visualstudio2019-workload-netweb -y
choco upgrade visualstudio2019-workload-node -y
choco upgrade webdeploy -y
choco upgrade winmerge -y
choco upgrade wsl -y

#--- reenabling critical items ---
Enable-UAC
Enable-MicrosoftUpdate
Install-WindowsUpdate -acceptEula
