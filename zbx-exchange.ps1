# Trying add EMS snapin
# Exchange 2010: Microsoft.Exchange.Management.PowerShell.E2010
# Exchange 2013/2016: Microsoft.Exchange.Management.PowerShell.SnapIn
try {
    Add-PSSnapin -Name Microsoft.Exchange.Management.PowerShell.SnapIn -ErrorAction Stop
} catch [Exception] {
    return -1
}

# Low-Level Discovery function
function Make-LLD() {
    $dbs = Get-MailboxDatabase | Select-Object @{Name = "{#DB.NAME}"; e={$_.Name}},
                                  @{Name = "{#DB.LCNAME}"; e={$_.Name.tolower()}},
                                  @{Name = "{#DB.EDBPATH}"; e={$_.EdbFilePath}}
    return ConvertTo-Json @{"data" = [array]$dbs} -Compress
}

Write-Host $(Make-LLD)