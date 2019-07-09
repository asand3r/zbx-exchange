# zbx-exchange
Zabbix server template for Exchange Server

Zabbix Share page: https://share.zabbix.com/cat-app/mail-servers/exchange-server  
Have fun and rate it on Zabbix Share page, if it helps you. =)

zbx-exchange provides possibility to make Low Level Discovery of Microsoft Exchange Server databases and retrieve their parameters with perfomance counters. Attached template Template Exchange Server 2016.xml works only with Zabbix 4.2 and above. For zabbix 4.0 please use the file Template Exchange Server zbx40.xml.
![alt text](https://pp.userapi.com/c850236/v850236406/167612/iavSvt1GcLA.jpg)  

**Latest stable version:** 0.1  

## Dependencies
 - PowerShell v3.0+
 - Exchange instrumentation installed (Microsoft.Exchange.Management.PowerShell.SnapIn)

## Feautres  
**Low Level Discovery:**
 - [x] Databases

## Supported arguments  
**-ExchVersion** (positional: 0)  
Takes one of next values: 2010, 2013, 2016, 2019. Determines name of PSSnapin to import (Default: 2016).  
**-Pretty**  
Print output in human-readable format.  
**-version**  
Print script version and exit.  

## Script Usage 
- Database discovery for Exchange Server 2016:
```powershell
PS C:\> .\zbx-exchange.ps1
{"data":[{"{#DB.NAME}":"DB1","{#DB.LCNAME}":"db1","{#DB.EDBPATH}":"D:\\Databases\\DB 1.edb"}, ... ]}
PS C:\> .\zbx-exchange.ps1 -ExchVersion 2016
{"data":[{"{#DB.NAME}":"DB1","{#DB.LCNAME}":"db1","{#DB.EDBPATH}":"D:\\Databases\\DB 1.edb"}, ... ]}
```
- Database discovery for Exchange Server 2010:
```powershell
PS C:\> .\zbx-exchange.ps1 -ExchVersion 2010
{"data":[{"{#DB.NAME}":"DB1","{#DB.LCNAME}":"db1","{#DB.EDBPATH}":"D:\\Databases\\DB 1.edb"}, ... ]}
```

## Installation
I'm using next foldes structure for my userparameters and scripts:
- "C:\Program Files\Zabbix Agent\scripts" for scripts
- "C:\Program Files\Zabbix Agent\userparameters" for additional config files included to main Zabbix Agent config with "Include" option.  
So, based on it, installation will be contents next steps:  
- Copy _zbx-exchange.conf_ to the _userparameters_ dir;
- Copy _zbx-exchange.ps1_ to the _scripts_ dir;
- Increase Timeout in Zabbix Agent config file at least to 10 seconds;
- Restart Zabbix Agent Service;

## Zabbix template
In addition I've attached preconfigured Zabbix Template for version 4.2, so you can use it in your environment.  
The template contains two LLD rules:
  - Exchange Database Discovery
  - Exchange Services Discovery
The first one uses _zbx-exchange.ps1_ script and the second one - built-in 'service.discovery', so, if you already has LLD for services, you must remove one of them.  
All perfomance counters thresholds has been taken from this page:  
https://docs.microsoft.com/ru-ru/exchange/exchange-2013-performance-counters-exchange-2013-help
![alt text](https://pp.userapi.com/c850236/v850236406/167648/tcaEMpfZjmk.jpg)

**Tested with**:  
Exchange Server 2016 on Windows Server 2016.
