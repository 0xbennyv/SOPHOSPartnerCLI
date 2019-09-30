<#
    Author: Ben Verschaeren
    Description: Manage Parnter Endppints
#>


function Get-SOPHOSPartnerEndpoints{

    param (
        [ValidateSet(“good”,”suspicious”,”bad”)]
        [string]$OverallHealth = $null,
        [string]$HostName = $null,
        [ValidateSet(“JSON”,”CSV”)]
        [string]$Export = "JSON"
    )

    # Before the function runs check the token expiry and regenerate if needed
    Get-SOPHOSTokenExpiry
	
    # Get the latest list of partners with the ID, API Host and Name
    Get-SOPHOSPartnerTenants

    # Set TLS Version
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12


	
    foreach ($tenant in $global:PartnerTenants) {
        
        $apihost = $tenant.apiHost
        $tenantid = $tenant.id

        # SOPHOS Customer Tenant API Headers:
        $TentantAPIHeaders = @{
            "Authorization" = "Bearer $global:Token";
            "X-Tenant-ID" = "$tenantid";
        }

	    # Post Request to SOPHOS for Endpoint API:
	    $TenantEndpointResult = (Invoke-RestMethod -Method Get -Uri $apiHost"/endpoint/v1/endpoints" -Headers $TentantAPIHeaders -ErrorAction SilentlyContinue -ErrorVariable Error)
    
        # All results for debugging
        # Write-Host($TenantEndpointResult.items | Out-GridView)

        # Build the query, Output of Assigned Products needs cleaning
        $TenantEndpoints = $TenantEndpointResult.items | 
        ? { (!$HostName) -or ($_.hostname -match $HostName)} |
        ? { (!$OverallHealth) -or ($_.Health.overall -eq $OverallHealth)} |
        Select -Property type, hostname, {$_.health.overall}, {$_.health.threats.status}, {$_.health.services.status}, 
        {$_.os.platform}, {$_.os.name}, {$_.associatedPerson.viaLogin}, {$_.assignedProducts} |
        ConvertTo-Json

        Write-Host($TenantEndpoints)
    }
}


function Export-SOPHOSPartnerEndpoints{
    
    # Function Params
    param (
        [string]$ComputerType = $null,
        [string]$Health = $null,
        [string]$User = $null,
        [string]$HostName = $null,
        [string]$FileName = $null
    )

    # Before the function runs check the token expiry and regenerate if needed
    Get-SOPHOSTokenExpiry

	# SOPHOS Customer Tenant API URI:
	$TenantAPIURI = $global:PartnerApiHost
	
    # SOPHOS Customer Tenant API Headers:
    $TentantAPIHeaders = @{
        "Authorization" = "Bearer $global:Token";
        "X-Tenant-ID" = "$global:PartnerId";
    }
	
    # Set TLS Version
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

	# Post Request to SOPHOS for Endpoint API:
	$TenantEndpointResult = (Invoke-RestMethod -Method Get -Uri $TenantAPIURI"/endpoint/v1/endpoints" -Headers $TentantAPIHeaders -ErrorAction SilentlyContinue -ErrorVariable Error)
    
    # All results for debugging
    #Write-Host($TenantEndpointResult.items | Out-GridView)

    # Build the query, Output of Assigned Products needs cleaning, just getting some data out for V1
    $TenantEndpoints = $TenantEndpointResult.items | 
    ? { (!$ComputerType) -or ($_.type -eq $ComputerType)} |  
    ? { (!$HostName) -or ($_.hostname -match $HostName)} |
    ? { (!$Health) -or ($_.Health.overall -eq $Health)} |
    ? { (!$User) -or ($_.associatedPerson.viaLogin -match $user)} | 
    Select -Property type, hostname, {$_.health.overall}, {$_.health.threats.status}, {$_.health.services.status}, 
    {$_.os.platform}, {$_.os.name}, {$_.associatedPerson.viaLogin}, {$_.assignedProducts.code}, {$_.assignedProducts.version}
     
    # If not invoked from the commandline to save prompt for a saveas dialog
    if ($FileName -eq "") {

        # Create a dialogbox for saveas (Thanks StackOverflow)
        Add-Type -AssemblyName System.Windows.Forms
        $dlg=New-Object System.Windows.Forms.SaveFileDialog
        
        # If save is clicked then do it
        if($dlg.ShowDialog() -eq 'Ok'){

            # Export list as CSV using the file name chosen in dialog
            $TenantEndpoints | Export-Csv -Path $dlg.filename -NoTypeInformation

            # Confirmation of saving:
            Write-host "Tenant list exported as CSV to: $($dlg.filename)"
        };

    # If Filename is Set then export as per the norm
    }else{

        $TenantEndpoints | Export-Csv -Path $FileName -NoTypeInformation
        Write-host "Tenant list exported as CSV to: $FileName"
    }

}