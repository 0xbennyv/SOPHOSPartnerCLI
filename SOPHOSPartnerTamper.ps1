<#
    Author: Ben Verschaeren
    Description: View Tamper Protection
#>

function Enable-SOPHOSPartnerTamperProtection{
    param (
        [ValidateSet(“All”,”Active”)]
        [string]$Tenant = "Active"
        )
    sleep(10)
    Write-Host("Tamper Protection has been enbled for $Global:PartnerName")
}