#Requires -RunAsAdministrator
Clear-Host

Write-Host "Installing SwitchProxy..." -ForegroundColor Yellow

if ($python_version = python --version) {
    Write-Host "$python_version found!" -ForegroundColor Cyan
}
else {
    try{Set-ExecutionPolicy Bypass -Scope Process -Force}catch{}
    [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
    iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
    refreshenv
    choco uninstall python python3 --force
    choco install python -y --force --force-dependancies
    refreshenv
    Write-Host -ForegroundColor Cyan "If python installer or a dependancy require a reboot, please reaboot the PC and re-run setup.ps1"
    pause
}


Write-Host "Updating python modules..." -ForegroundColor Yellow
python -m pip install --upgrade pip wheel setuptools --verbose

Set-Location $($MyInvocation.MyCommand.Definition | Split-Path -Parent)

# LXML download
Write-Host "Downloading and installing LXML..." -ForegroundColor Yellow

$ProgressPreference = "SilentlyContinue"

$python_version = python --version
$pyV = $python_version.Substring(0, $python_version.Length-1) -replace '[^0-9]'

[string]$lxmlLibName = (((iwr "https://www.lfd.uci.edu/~gohlke/pythonlibs").links | where innertext -like "lxml*cp*win_amd64.whl") | where outertext -like "*$pyV*" | select -First 1).outertext -replace "‑","-"
Write-Host $lxmlLibName -ForegroundColor Cyan

$lxmlDLLink = "https://download.lfd.uci.edu/pythonlibs/archived/$lxmlLibName"
$OutputFile = "$($MyInvocation.MyCommand.Definition | Split-Path -Parent)\$lxmlLibName"

iwr $lxmlDLLink -OutFile $OutputFile -Verbose

Get-Item -Path "$($MyInvocation.MyCommand.Definition | Split-Path -Parent)\lxml-*" | % {python -m pip install $_}

Remove-Item $OutputFile -Force -Verbose

Write-Host "Installing required modules..." -ForegroundColor Yellow
python -m pip install --upgrade -r (Get-Item -Path "$($MyInvocation.MyCommand.Definition | Split-Path -Parent)\requirements.txt")

Write-Host "Creating Desktop icon..." -ForegroundColor Yellow
$WshShell = New-Object -comObject WScript.Shell
$Shortcut = $WshShell.CreateShortcut("$Home\Desktop\SwitchProxy.lnk")
$Shortcut.TargetPath = "$($MyInvocation.MyCommand.Definition | Split-Path -Parent)\main.py"
$Shortcut.Save()

Write-Host "Install complete, use Desktop Link `"SwitchProxy`" to switch proxy on/off" -ForegroundColor Green

pause