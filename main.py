from winreg import *
import os

import requests
from fp.fp import FreeProxy


def isProxyEnabled():
    aReg = ConnectRegistry(None, HKEY_CURRENT_USER)

    aKey = OpenKey(aReg, r"Software\Microsoft\Windows\CurrentVersion\Internet Settings")
    subCount, valueCount, lastModified = QueryInfoKey(aKey)

    for i in range(valueCount):
        try:
            n, v, t = EnumValue(aKey, i)
            if n == 'ProxyEnable':
                return v and True or False
        except EnvironmentError:
            break
    CloseKey(aKey)


def changeProxyState():
    aReg = ConnectRegistry(None, HKEY_CURRENT_USER)
    aKey = OpenKey(aReg, r"Software\Microsoft\Windows\CurrentVersion\Internet Settings", 0, KEY_WRITE)
    proxy = ''

    if isProxyEnabled():
        print("Proxy is ENABLED, switching off...")
        val = 0
    else:
        print("Proxy is DISABLED, finding proxy and switching on...")
        val = 1
        while proxy == '':
            try:
                #proxy = FreeProxy(elite=1, rand=1, country_id='US').get().replace("http://", "")
                proxy = requests.get('https://gimmeproxy.com/api/getProxy?supportsHttps=true&country=US,CA,GB&protocol=http&ipPort=true&maxCheckPeriod=360').text
            except BaseException as e:
                print(str(e), "Failed to fetch a proxy. Retying...")

        os.system('cls||clear')

        print("Found proxy:", proxy)

        try:
            SetValueEx(aKey, "ProxyServer", 0, REG_SZ, proxy)
        except ValueError:
            print("Error in setting proxy server in registry!")

    # Set Exclusions
    try:
        SetValueEx(aKey, "ProxyOverride", 0, REG_SZ, '*.local;*.tass.ru;*.corp.tass.ru;<local>')
    except ValueError:
        print("Error in setting proxy exclusions in registry!")

    # Enable/disable proxy
    try:
        SetValueEx(aKey, "ProxyEnable", 0, REG_DWORD, val)
    except EnvironmentError:
        print("Encountered problems writing into the Registry!")

    flushNetworkSettings()

    print(f">>Proxy{' ' + proxy + ' ' if proxy else ' '}is now {'ENABLED!' if val == 1 else 'DISABLED!'}<<")

    CloseKey(aKey)

    # Pause or Quit
    inputVal = input(
        f"\r\nPress ENTER to {'ENABLE' if val == 0 else 'DISABLE'} proxy"
        "\r\nClose the program, press ctrl+c or type q to exit\r\n")
    if inputVal.lower() == 'q':
        exit()


def flushNetworkSettings():
    os.system('cmd /c "ipconfig /flushdns"')
    os.system('cmd /c "nbtstat -r"')
    os.system('cmd /c "netsh int ip reset"')
    os.system('cmd /c "netsh winsock reset"')
    os.system('cls||clear')


if __name__ == '__main__':
    while True:
        os.system('cls||clear')
        changeProxyState()
