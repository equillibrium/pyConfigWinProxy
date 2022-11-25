# Description
A small program that enables and disables system wide Windows 10 proxy settings.  
Gets a list of proxies using [Free-proxy](https://pypi.org/project/free-proxy/) python module and then modifies the Windows registry:

    HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings
    ProxyEnable=1
    ProxyServer=*server:port* that it got from Free-proxy module
Currently, set to US Elite proxy  
Press Enter to switch proxy states when the program is running, typr q, press ctrl+c or close the program to stop it.


# Run as exe
Just use .\dist\main.exe to run a 'compiled' version that does not require python installation.  
Or download .exe from the latest release section: https://github.com/equillibrium/pyConfigWinProxy/releases/latest

# Build exe
Use pyinstaller python module to build the .exe:

    pyinstaller --onefile .\main.py -n SwitchProxy

# Setup
If you want to run main.py: run powershell as admin and execute setup.ps1
It installs chocolatey repository, the latest python, lxml for Windows, Free-proxy pip module

Libxml for Win:
https://www.lfd.uci.edu/~gohlke/pythonlibs/#lxml


# To Do 
- [x] Automate lxml lib download based on python version
- [ ] Create Timer for Proxy
- [ ] Change Desktop Icon based on Proxy Status
- [x] (Needs more testing) Error catching setup.ps1 and main.py
- [ ] Create basic UI: on, off, country select
- [ ] Create country checklist
- [x] Compile as 1 exe file
