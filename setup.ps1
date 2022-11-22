Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
choco install python -y
python pip install --upgrade pip wheel setuptools
python pip install .\lxml-4.9.0-cp311-cp311-win_amd64.whl
python pip install --upgrade -r .\requirements.txt