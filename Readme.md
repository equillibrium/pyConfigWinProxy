# Run as exe
Just use dist\main.exe to run a 'compiled' version that does not require python installation

# Build exe
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
- [ ] Error catching setup.ps1 and main.py
- [ ] Create basic UI: on, off, country select
- [ ] Create country checklist
- [x] Compile as 1 exe file
