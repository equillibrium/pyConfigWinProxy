#Requires -RunAsAdministrator

Write-Host "Installing SwitchProxy..." -ForegroundColor Yellow

$python_version = python --version

if (-not $python_version) {
    choco install python -y
    Set-ExecutionPolicy Bypass -Scope Process -Force | Out-Null
    [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
    iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
}
else {
    Write-Host $python_version -ForegroundColor Cyan
}


python -m pip install --upgrade pip wheel setuptools --verbose

Set-Location $($MyInvocation.MyCommand.Definition | Split-Path -Parent)

# LXML download
Write-Host "Downloading and installing LXML..." -ForegroundColor Yellow

$ProgressPreference = "SilentlyContinue"
$pyV = $python_version.Substring(0, $python_version.Length-1) -replace '[^0-9]'

[string]$lxmlLibName = (((iwr "https://www.lfd.uci.edu/~gohlke/pythonlibs").links | where innertext -like "lxml*cp*win_amd64.whl") | where outertext -like "*$pyV*" | select -First 1).outertext -replace "‑","-"

$lxmlDLLink = "https://download.lfd.uci.edu/pythonlibs/archived/$lxmlLibName"
$OutputFile = "$($MyInvocation.MyCommand.Definition | Split-Path -Parent)\$lxmlLibName"

iwr $lxmlDLLink -OutFile $OutputFile -Verbose

Get-Item -Path "$($MyInvocation.MyCommand.Definition | Split-Path -Parent)\lxml-*" | % {python -m pip install $_}

Remove-Item $OutputFile -Force -Verbose

python -m pip install --upgrade -r (Get-Item -Path "$($MyInvocation.MyCommand.Definition | Split-Path -Parent)\requirements.txt")

$WshShell = New-Object -comObject WScript.Shell
$Shortcut = $WshShell.CreateShortcut("$Home\Desktop\SwitchProxy.lnk")
$Shortcut.TargetPath = "$($MyInvocation.MyCommand.Definition | Split-Path -Parent)\main.py"
$Shortcut.Save()

Write-Host "Install complete, use Desktop Link `"SwitchProxy`" to switch proxy on/off" -ForegroundColor Green