from winreg import *
import os

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

    if isProxyEnabled():
        print("Proxy is ENABLED, switching off")
        val = 0
    else:
        print("Proxy is DISABLED, finding proxy and switching on...")
        val = 1
        proxy = ''
        while proxy == '':
            try:
                proxy = FreeProxy(elite=1, https=0, country_id='US').get().replace("http://", "")
            except BaseException as e:
                print(str(e), "Failed to fetch a proxy. Retying...")
        print("\r\nFound proxy:", proxy)

        try:
            SetValueEx(aKey, "ProxyServer", 0, REG_SZ, proxy)
        except ValueError:
            print("Error in setting proxy server in registry!")
    try:
        SetValueEx(aKey, "ProxyEnable", 0, REG_DWORD, val)
    except EnvironmentError:
        print("Encountered problems writing into the Registry!")
    print(f"\r\n>>Proxy is now {'ENABLED!' if val == 1 else 'DISABLED!'}<<")
    CloseKey(aKey)
    inputVal = input(
        f"\r\nPress ENTER to {'ENABLE' if val == 0 else 'DISABLE'} proxy"
        "\r\nClose the program, press ctrl+c or type q to exit\r\n")
    if inputVal.lower() == 'q':
        exit()


if __name__ == '__main__':
    while True:
        os.system('cls||clear')
        changeProxyState()
