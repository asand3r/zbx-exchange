<#
    .SYNOPSIS
    Script implemets Low Level Discovery for Zabbix server in pre 4.2 format.

    .DESCRIPTION
    Provides LLD for Exchange Server database.
    
    .PARAMETER ExchVersion
    Exchange Server version. Using to determine Exchange SnapIn name.
    Default: 2016

    .PARAMETER Pretty
    Print output in human-readable format with line breaks and spaces.

    .PARAMETER Version
    Print verion number and exit.

    .EXAMPLE
    zbx-exchange.ps1
    {"data":["{#DB.NAME}":"DB 1","{#DB.LCNAME}":"db 1", "{#DB.EDBPATH}":"D:\\DB1\\DB1.edb", ...]}
    
    .NOTES
    Author: Khatsayuk Alexander
    Github: https://github.com/asand3r/
#>

Param (
    [switch]$Version = $False,
    [ValidateSet(2010,2013,2016,2019)][Parameter(Position=0,Mandatory=$False)][int]$ExchVersion = 2016,
    [Parameter(Mandatory=$False)][switch]$Pretty
)

# Script version
$VERSION_NUM="0.1"

if ($Version) {
    Write-Host $VERSION_NUM
    break
}

# Determine Exchange snapin name
switch ($ExchVersion) {
    2010 { $SnapinName = "Microsoft.Exchange.Management.PowerShell.E2010" }
    Default { $SnapinName = "Microsoft.Exchange.Management.PowerShell.SnapIn" }
}

# Trying to add Exchange Snapin
try {
    Add-PSSnapin -Name $SnapinName -ErrorAction Stop
} catch [Exception] {
    return -1
}

# Low-Level Discovery function
function Make-LLD() {
    $dbs = Get-MailboxDatabase | Select-Object @{Name = "{#DB.NAME}"; e={$_.Name}},
                                  @{Name = "{#DB.LCNAME}"; e={$_.Name.tolower()}},
                                  @{Name = "{#DB.EDBPATH}"; e={$_.EdbFilePath}}
    
    # Is we need to print output with linebreaks?
    if ($pretty) {
        return ConvertTo-Json @{"data" = [array]$dbs}
    } else {
        return ConvertTo-Json @{"data" = [array]$dbs} -Compress 
    }
}

Write-Host $(Make-LLD)