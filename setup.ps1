#Requires -RunAsAdministrator
Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))

choco install python -y

python -m pip install --upgrade pip wheel setuptools

Set-Location $($MyInvocation.MyCommand.Definition | Split-Path -Parent)
Get-Item -Path "$($MyInvocation.MyCommand.Definition | Split-Path -Parent)\lxml-4.9.0*" | % {python -m pip install $_}
python -m pip install --upgrade -r (Get-Item -Path "$($MyInvocation.MyCommand.Definition | Split-Path -Parent)\requirements.txt")

$WshShell = New-Object -comObject WScript.Shell
$Shortcut = $WshShell.CreateShortcut("$Home\Desktop\SwitchProxy.lnk")
$Shortcut.TargetPath = "$($MyInvocation.MyCommand.Definition | Split-Path -Parent)\main.py"
$Shortcut.Save()