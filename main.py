from fp.fp import FreeProxy
from winreg import *


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
        print("Proxy is Enabled, switching off")
        val = 0
    else:
        print("Proxy is Disabled, finding proxy and switching on...")
        val = 1
        proxy = FreeProxy(elite=1).get().replace("http://", "")
        print("Found proxy:", proxy)
        try:
            SetValueEx(aKey, "ProxyServer", 0, REG_SZ, proxy)
        except ValueError:
            print("Error in getting and setting proxy server!")
    try:
        SetValueEx(aKey, "ProxyEnable", 0, REG_DWORD, val)
    except EnvironmentError:
        print("Encountered problems writing into the Registry!")
    CloseKey(aKey)


if __name__ == '__main__':
    changeProxyState()
    input("Press enter to exit")
    