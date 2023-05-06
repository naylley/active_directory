#Installing the DC

1.Use `SConfig` to:
        -Change Hostname
        -Change DC IP address to a static IP
        -Change DNS to DC server IP
2. Install the active directory windows feature
```shell
Install-windowsfeature AD-Domain-Services -IncludemanagementTools
```
3. Change DNS
```
Get-NetIPAddress
```
Take note of Interface index
```
Set-DnsClientServerAddress -InterfaceIndex {} -ServerAddresses {DC IP}
```