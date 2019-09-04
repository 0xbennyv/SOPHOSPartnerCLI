<#
    Author: Ben Verschaeren
    Description: Manage Parnter Tenants
#>


function Set-SOPHOSPartnerTenant{

    # Before the function runs check the token expiry and regenerate if needed
    Get-SOPHOSTokenExpiry

	# SOPHOS Whoami URI
	$PartnerTenantURI = "https://api.central.sophos.com/partner/v1/tenants?pageTotal=true"
	
    # SOPHOS Whoami Headers
    $PartnerTenantHeaders = @{
        "Authorization" = "Bearer $global:Token";
        "X-Partner-ID" = "$global:ApiPartnerId";
    }
	
    # Set TLS Version
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

	# Post Request to SOPHOS for Whoami Details
	$PartnerTenantResult = (Invoke-RestMethod -Method Get -Uri $PartnerTenantURI -Headers $PartnerTenantHeaders -ErrorAction SilentlyContinue -ErrorVariable Error)
    
    # Display List of Partners, gridview with passthough makes it selectable.
    $SelectedPartner = $PartnerTenantResult.items | Out-GridView -PassThru

    # We need the Token, TennantID and APIHost
    $global:PartnerId = $SelectedPartner.id
    $global:PartnerApiHost = $SelectedPartner.apiHost
    $global:PartnerName = $SelectedPartner.name
    Write-Host("$global:PartnerName has been selected")

}


function Export-SOPHOSPartnerTenants{
        
    # Set SysArgs for PureCLI Expirience
    param (
        [string]$FileName = ""
    )
        
    # Before the function runs check the token expiry and regenerate if needed
    Get-SOPHOSTokenExpiry
	
    # SOPHOS Whoami URI:
	$PartnerTenantURI = "https://api.central.sophos.com/partner/v1/tenants?pageTotal=true"
	
    # SOPHOS Whoami Headers
    $PartnerTenantHeaders = @{
        "Authorization" = "Bearer $global:Token";
        "X-Partner-ID" = "$global:ApiPartnerId";
    }
	
    # Set TLS Version
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

	# Post Request to SOPHOS for Whoami Details
	$PartnerTenantResult = (Invoke-RestMethod -Method Get -Uri $PartnerTenantURI -Headers $PartnerTenantHeaders -ErrorAction SilentlyContinue -ErrorVariable Error)
    
    # If not invoked from the commandline to save prompt for a saveas dialog:
    if ($FileName -eq "") {

        # Create a dialogbox for saveas (Thanks StackOverflow):
        Add-Type -AssemblyName System.Windows.Forms
        $dlg=New-Object System.Windows.Forms.SaveFileDialog
        
        # If save is clicked then do it
        if($dlg.ShowDialog() -eq 'Ok'){

            # Export list as CSV using the file name chosen in dialog
            $PartnerTenantResult.items | Export-Csv -Path $dlg.filename -NoTypeInformation

            # Confirmation of saving:
            Write-host "Tenant list exported as CSV to: $($dlg.filename)"
        };

    # If Filename is Set then export as per the norm
    }else{

        $PartnerTenantResult.items | Export-Csv -Path $FileName -NoTypeInformation
        Write-host "Tenant list exported as CSV to: $FileName"
    }

}


function Export-SOPHOSPartnerTenantsRedacted{
   
    # Set SysArgs for PureCLI Expirience
    param (
        [string]$FileName = ""
    )
	
    # Before the function runs check the token expiry and regenerate if needed
    Get-SOPHOSTokenExpiry

    # SOPHOS Whoami URI
	$PartnerTenantURI = "https://api.central.sophos.com/partner/v1/tenants?pageTotal=true"
	
    # SOPHOS Whoami Headers
    $PartnerTenantHeaders = @{
        "Authorization" = "Bearer $global:Token";
        "X-Partner-ID" = "$global:ApiPartnerId";
    }
	
    # Set TLS Version
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

	# Post Request to SOPHOS for Whoami Details:
	$PartnerTenantResult = (Invoke-RestMethod -Method Get -Uri $PartnerTenantURI -Headers $PartnerTenantHeaders -ErrorAction SilentlyContinue -ErrorVariable Error)
    
    # Confirmation Message
    $confirmationMsg = 'Tenant list exported as CSV to:'

    # If not invoked from the commandline to save prompt for a saveas dialog
    if ($FileName -eq "") {

        # Create a dialogbox for saveas (Thanks StackOverflow)
        Add-Type -AssemblyName System.Windows.Forms
        $dlg=New-Object System.Windows.Forms.SaveFileDialog
        
        # If save is clicked then do it
        if($dlg.ShowDialog() -eq 'Ok'){

            # Export list as CSV using the file name chosen in dialog
            $PartnerTenantResult.items | Select -Property name, billingType, dataRegion, dataGeography  | 
            Export-Csv -Path $dlg.filename -NoTypeInformation

            # Confirmation of saving:
            Write-host "$($confirmationMsg) $($dlg.filename)"
        };

    # If Filename is Set then export as per the norm
    }else{

        $PartnerTenantResult.items | Select -Property name, billingType, dataRegion, dataGeography | 
        Export-Csv -Path $FileName -NoTypeInformation
        Write-host "$($confirmationMsg) $($FileName)"
    }

}


function New-SOPHOSPartnerTenant{
   
    # Set SysArgs for PureCLI Expirience
    param (
        [Parameter(Mandatory=$true)]
        [string]$CustomerName = $null,
        [string]$dataGeography = 'US',
        [Parameter(Mandatory=$true)]
        [string]$firstName = $null,
        [Parameter(Mandatory=$true)]
        [string]$lastName = $null,
        [Parameter(Mandatory=$true)]
        [string]$email = $null,
        [Parameter(Mandatory=$true)]
        [string]$phone = $null,
        [Parameter(Mandatory=$true)]
        [string]$mobile = $null,
        [Parameter(Mandatory=$true)]
        [string]$address1 = $null,
        [string]$address2 = $null,
        [string]$address3 = $null,
        [Parameter(Mandatory=$true)]
        [string]$city = $null,
        [Parameter(Mandatory=$true)]
        [string]$state = $null,
        [Parameter(Mandatory=$true)]
        [string]$countryCode = $null,
        [Parameter(Mandatory=$true)]
        [string]$postCode = $null

    )
	
    # Before the function runs check the token expiry and regenerate if needed
    Get-SOPHOSTokenExpiry

    # SOPHOS Tenant URI
	$PartnerTenantURI = "https://api.central.sophos.com/partner/v1/tenants"
	
    # RequestBody for Tenant Creation
    $TokenRequestBody = @{
        "name" = $customerName;
        "dataGeography" = $dataGeography;
        "contact" = @{
            "firstName" = $firstName;
            "lastName" = $lastName;
            "email" = $email;
            "phone" = $phone;
            "mobile" = $mobile;
            "address" = @{
                "address1" = $address1;
                "address2" = $address2;
                "address3" = $address3;
                "city" = $city;
                "state" = $state;
                "countryCode" = $countrycode;
                "postCode" = $postCode;
                }
            }
        "billingType" = "trial";
        }
    $TokenRequestHeaders = @{
        "content-type" = "application/x-www-form-urlencoded";
    }
    # Request Headers
    $PartnerTenantHeaders = @{
        "Authorization" = "Bearer $global:Token";
        "X-Partner-ID" = "$global:ApiPartnerId";
    }
	
    # Set TLS Version
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

	# Post Request to SOPHOS for Whoami Details:
	# $PartnerTenantResult = (Invoke-RestMethod -Method Post -Uri $PartnerTenantURI -Body $TenantRequestBody -Headers $TenantRequestHeaders -ErrorAction SilentlyContinue -ErrorVariable Error)

}


function Get-SOPHOSTenantTemplate{

    # Set SysArgs for PureCLI Expirience
    param (
        [string]$FileName = ""
    )

    #$template.items | Select -Property 'Customer Name'  | ConvertTo-Csv | Export-Csv -Path test.csv -notypeinformation
    $csvTemplate = @{CustomerName = 'Aiblockchain Cloud';
                     DataGeography = 'US/IE/DE';
                     FirstName = 'Kate';
                     LastName = 'Libby';
                     Email = 'kate@hacktheplanet.com';
                     Phone = '61 74732 5464';
                     Mobile = '61 74732 5464';
                     Fax = '61 74732 5464';
                     Address1 = '666 Haxor Court';
                     Address2 = 'Address2';
                     Address3 = 'Address3';
                     City = 'City';
                     State = 'State';
                     CountryCode = 'CountryCode';
                     PostCode = '1337';}

    # Export list as CSV using the file name chosen in dialog
    $template = New-Object PSObject -Property $csvTemplate | 
                Select CustomerName, DataRegion, FirstName, LastName, Email, Phone, Mobile, Fax, Address1, Address2, Address3, City, State, CountryCode, PostCode
    
    $confirmationMsg = 'CSV Template has been exported too:'

    # If not invoked from the commandline to save prompt for a saveas dialog
    if ($FileName -eq "") {

        # Create a dialogbox for saveas (Thanks StackOverflow)
        Add-Type -AssemblyName System.Windows.Forms
        $dlg=New-Object System.Windows.Forms.SaveFileDialog
        
        # If save is clicked then do it
        if($dlg.ShowDialog() -eq 'Ok'){
            
            # Put it all together
            $template | Export-CSV -Path $dlg.filename -NoTypeInformation

            # Confirmation of saving:
            Write-host "$($confirmationMsg) $($dlg.filename)"
        };

    # If Filename is Set then export as per the norm
    }else{

        $template | Export-CSV -Path $FileName -NoTypeInformation
        Write-host "$($confirmationMsg) $($dlg.filename)"
    }
}

function Import-SOPHOSPartnerTenant{
   
    # Set SysArgs for PureCLI Expirience
    param (
        [string]$FileName = $null

    )
	
    # Before the function runs check the token expiry and regenerate if needed
    Get-SOPHOSTokenExpiry

    # SOPHOS Tenant URI
	$PartnerTenantURI = "https://api.central.sophos.com/partner/v1/tenants"
	
    # If not invoked from the commandline to save prompt for a saveas dialog
    if ($FileName -eq "") {

        # Create a dialogbox for OpenFOrmDialog
        Add-Type -AssemblyName System.Windows.Forms
        $dlg=New-Object System.Windows.Forms.OpenFileDialog
        
        # If Open is clicked then do it
        if($dlg.ShowDialog() -eq 'Ok'){
            
            # Confirmation of saving:
            $FileName = $dlg.filename
        };

    # If Filename is Set then export as per the norm
    }

    Import-CSV -Path $FileName | 
    ForEach-Object {
        # RequestBody for Tenant Creation
        $TenantRequestBody = @{
            "name" = $_.CustomerName;
            "dataGeography" = $_.dataGeography;
            "contact" = @{
                "firstName" = $_.FirstName;
                "lastName" = $_.FastName;
                "email" = $_.Email;
                "phone" = $_.Phone;
                "mobile" = $_.Mobile;
                "address" = @{
                    "address1" = $_.Address1;
                    "address2" = $_.Address2;
                    "address3" = $_.Address3;
                    "city" = $_.City;
                    "state" = $_.State;
                    "countryCode" = $_.CountryCode;
                    "postCode" = $_.PostCode;
                    }
                }
            "billingType" = "trial";
            }


        # Request Headers
        $PartnerTenantHeaders = @{
            "Authorization" = "Bearer $global:Token";
            "X-Partner-ID" = "$global:ApiPartnerId";
        }


        # Set TLS Version
        [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
        
        # Post Request
        # $PartnerTenantResult = (Invoke-RestMethod -Method Post -Uri $PartnerTenantURI -Body $TenantRequestBody -Headers $TenantRequestHeaders -ErrorAction SilentlyContinue -ErrorVariable Error)

        # Notify SysAdmin
        Write-Host "Sucessfully created tennant for: $($TenantRequestBody.name)"
    }

}