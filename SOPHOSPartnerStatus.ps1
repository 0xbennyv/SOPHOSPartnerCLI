<#
    Author: Ben Verschaeren
    Description: Manage Parnter Alerts
#>


function Get-SOPHOSPartnerAllEndpoints{
    #Runs function in SOPOSPartnerEndpoints.ps1
    Get-SOPHOSPartnerEndpoints
}


function Get-SOPHOSPartnerRedStatus{
    #Runs function in SOPOSPartnerEndpoints.ps1
    Get-SOPHOSPartnerEndpoints -OverallHealth bad

}


function Get-SOPHOSPartnerWarnedStatus{
    #Runs function in SOPOSPartnerEndpoints.ps1
    Get-SOPHOSPartnerEndpoints -OverallHealth suspicious

}

function Get-SOPHOSPartnerHealthyStatus{
    #Runs function in SOPOSPartnerEndpoints.ps1
    Get-SOPHOSPartnerEndpoints -OverallHealth good

}