<#
    Author: Ben Verschaeren
    Description: View Endpoint Status
#>


function Get-SOPHOSPartnerAllEndpoints{
    #Runs function in SOPOSPartnerEndpoints.ps1
    Get-SOPHOSPartnerEndpointsAllTenants
}


function Get-SOPHOSPartnerRedStatus{
    #Runs function in SOPOSPartnerEndpoints.ps1
    Get-SOPHOSPartnerEndpointsAllTenants -OverallHealth bad

}


function Get-SOPHOSPartnerWarnedStatus{
    #Runs function in SOPOSPartnerEndpoints.ps1
    Get-SOPHOSPartnerEndpointsAllTenants -OverallHealth suspicious

}

function Get-SOPHOSPartnerHealthyStatus{
    #Runs function in SOPOSPartnerEndpoints.ps1
    Get-SOPHOSPartnerEndpointsAllTenants -OverallHealth good

}

