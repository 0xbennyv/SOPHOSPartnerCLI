<#
    Author: Ben Verschaeren
    Description: Manage Parnter Tenants
#>

# Function is used to manually set a tenant for indevidual alert managment
function Set-SOPHOSPartnerTenant{

    # Before the function runs check the token expiry and regenerate if needed
    Get-SOPHOSTokenExpiry

	# SOPHOS Whoami URI
	$PartnerTenantURI = "https://api.central.sophos.com/partner/v1/tenants?pageTotal=True"
	
    # SOPHOS Whoami Headers
    $PartnerTenantHeaders = @{
        "Authorization" = "Bearer $global:Token";
        "X-Partner-ID" = "$global:ApiPartnerId";
    }

    # Set TLS Version
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

	# Post Request to SOPHOS Endpoint Gateway, This request is just used to get the pages (waste of a request I know)
	$PartnerTenantResult = (Invoke-RestMethod -Method Get -Uri $PartnerTenantURI -Headers $PartnerTenantHeaders -ErrorAction SilentlyContinue -ErrorVariable Error)
    
    # Check them all into this collection
    $AllPartnerTenantResults = @()
    
    For ($i=1; $i -le $PartnerTenantResult.pages.total; $i++) {
        $PartnerTenantURI = "https://api.central.sophos.com/partner/v1/tenants?pageTotal=True&page=$i"
        $AllPartnerTenantResults += (Invoke-RestMethod -Method Get -Uri $PartnerTenantURI -Headers $PartnerTenantHeaders -ErrorAction SilentlyContinue -ErrorVariable Error)
    }

    # Display List of Partners, gridview with passthough makes it selectable.
    $SelectedPartner = $AllPartnerTenantResults.items | Out-GridView -PassThru

    # We need the Token, TennantID and APIHost
    $global:PartnerId = $SelectedPartner.id
    $global:PartnerApiHost = $SelectedPartner.apiHost
    $global:PartnerName = $SelectedPartner.name
    Write-Host("$global:PartnerName has been selected")

}


# Designed to be invoked for other functions to get "All" tenant/endpoint data
function Get-SOPHOSPartnerTenants{

    # Before the function runs check the token expiry and regenerate if needed
    Get-SOPHOSTokenExpiry

	# SOPHOS Whoami URI
	$PartnerTenantURI = "https://api.central.sophos.com/partner/v1/tenants?pageTotal=True"
	
    # SOPHOS Whoami Headers
    $PartnerTenantHeaders = @{
        "Authorization" = "Bearer $global:Token";
        "X-Partner-ID" = "$global:ApiPartnerId";
    }

    # Set TLS Version
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

	# Post Request to SOPHOS Endpoint Gateway, This request is just used to get the pages (waste of a request I know)
	$PartnerTenantResult = (Invoke-RestMethod -Method Get -Uri $PartnerTenantURI -Headers $PartnerTenantHeaders -ErrorAction SilentlyContinue -ErrorVariable Error)
    
    # Check them all into this collection
    $AllPartnerTenantResults = @()
    
    For ($i=1; $i -le $PartnerTenantResult.pages.total; $i++) {
        $PartnerTenantURI = "https://api.central.sophos.com/partner/v1/tenants?pageTotal=True&page=$i"
        $AllPartnerTenantResults += (Invoke-RestMethod -Method Get -Uri $PartnerTenantURI -Headers $PartnerTenantHeaders -ErrorAction SilentlyContinue -ErrorVariable Error)
    }

    $global:PartnerTenants = $AllPartnerTenantResults | Select -Property id, apihost, name

}


# Export out each tenant, need to add page support
function Export-SOPHOSPartnerTenants{
        
    # Set SysArgs for PureCLI Expirience
    param (
        [string]$FileName = "",
        [switch]$Redacted = $false
    )
        
    # Before the function runs check the token expiry and regenerate if needed
    Get-SOPHOSTokenExpiry
	
    # SOPHOS Whoami URI:
	$Uri = "https://api.central.sophos.com/partner/v1/tenants?pageTotal=true"
	
    # SOPHOS Whoami Headers
    $Headers = @{
        "Authorization" = "Bearer $global:Token";
        "X-Partner-ID" = "$global:ApiPartnerId";
    }
	
    # Set TLS Version
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

	# Post Request to SOPHOS for Whoami Details
	$Result = (Invoke-RestMethod -Method Get -Uri $Uri -Headers $Headers -ErrorAction SilentlyContinue -ErrorVariable Error)
    
    # Redact Information if needed
    if ($Redacted -eq $true){
        $TenantDetails = $Result.items | Select -Property name, billingType, dataRegion, dataGeography
    }else{
        $TenantDetails = $Result.items
    }
   
    # If not invoked from the commandline to save prompt for a saveas dialog:
    if ($FileName -eq "") {

        # Create a dialogbox for saveas (Thanks StackOverflow):
        Add-Type -AssemblyName System.Windows.Forms
        $dlg=New-Object System.Windows.Forms.SaveFileDialog
        
        # If save is clicked then do it
        if($dlg.ShowDialog() -eq 'Ok'){

            # Export list as CSV using the file name chosen in dialog
            $TenantDetails | Export-Csv -Path $dlg.filename -NoTypeInformation

            # Confirmation of saving:
            Write-host "Tenant list exported as CSV to: $($dlg.filename)"
        };

    # If Filename is Set then export as per the norm
    }else{
            $TenantDetails | Export-Csv -Path $FileName -NoTypeInformation
            Write-host "Tenant list exported as CSV to: $FileName"
            
    }
}

# Used to create a new tenant
function New-SOPHOSPartnerTenant{

	param (
     [Parameter(Mandatory=$true)]
     [string]$customerName = $null,
     [ValidateSet(“US”,”IE”,”DE”)] 
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
     [Parameter(Mandatory=$true)]
     [string]$address2 = $null,
     [Parameter(Mandatory=$true)]
     [string]$address3 = $null,
     [Parameter(Mandatory=$true)]
     [string]$city = $null,
     [Parameter(Mandatory=$true)]
     [string]$state = $null,
     [Parameter(Mandatory=$true)]
     [string]$countryCode = $null,
     [Parameter(Mandatory=$true)]
     [string]$postCode = $null,
     [switch]$active = $false

)
    # Before the function runs check the token expiry and regenerate if needed
    Get-SOPHOSTokenExpiry

    # SOPHOS Tenant URI
	$Uri = "https://api.central.sophos.com/partner/v1/tenants"
	
    # RequestBody for Tenant Creation
    # You may ask, why not use ConvertTo-JSON, great question. Powershell adds whitespace that just gets nasty and errs out of life
    # Also, not prompting for Fax because it's 2019 and it shouldn't be a mandatory field.
    $Body = "{
    ""name"": ""$customerName"",
    ""dataGeography"": ""US"",
    ""contact"": {
        ""firstName"": ""$firstName"",
        ""lastName"": ""$lastName"",
        ""email"": ""$email"",
        ""phone"": ""$phone"",
        ""mobile"": ""$mobile"",
        ""fax"": ""00001111"",
        ""address"": {
            ""address1"": ""$address1"",
            ""address2"": ""$address2"",
            ""address3"": ""$address3"",
            ""city"": ""$city"",
            ""state"": ""$state"",
            ""countryCode"": ""$countryCode"",
            ""postalCode"": ""$postCode""
        }
    },
    ""billingType"": ""trial""
    }"


    # Request Headers
    $Headers = [ordered]@{
        "Authorization" = "Bearer $global:token";
        "X-Partner-ID" = "$global:ApiPartnerId";
        "Content-Type" = "application/json";
        "cache-control" = "no-cache";

    }

    # Set TLS Version
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

    # Post Request to SOPHOS Details:
	$Result = (Invoke-RestMethod -Uri $Uri -Method Post -ContentType "application/json" -Headers $Headers -Body $Body -ErrorAction SilentlyContinue -ErrorVariable Error)

    # Notify SysAdmin
    Write-Host "Sucessfully created tennant for: $($Result.name)"
    
    # If the active flag is set then set it
    if ($active -eq $true){
        $global:PartnerId = $Result.id
        $global:PartnerApiHost = $Result.apiHost
        $global:PartnerName = $Result.name
        Write-Host("$global:PartnerName is now active")
    }

}


# Get a template for importation
function Get-SOPHOSTenantTemplate{

    # Set SysArgs for PureCLI Expirience
    param (
        [string]$FileName = ""
    )

    #$template.items | Select -Property 'Customer Name'  | ConvertTo-Csv | Export-Csv -Path test.csv -notypeinformation
    $csvTemplate = [ordered]@{CustomerName = 'Aiblockchain Cloud';
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
    $template = New-Object PSObject -Property $csvTemplate

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


# Import the CSV File
function Import-SOPHOSPartnerTenant{
   
    # Set SysArgs for PureCLI Expirience
    param (
        [string]$FileName = $null

    )
	
    # Before the function runs check the token expiry and regenerate if needed
    Get-SOPHOSTokenExpiry

    # SOPHOS Tenant URI
	$Uri = "https://api.central.sophos.com/partner/v1/tenants"
	
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
        # Quick and Dirty to be tidied, escaping the $_. isn't working.
        $customerName = $_.CustomerName
        $dataGeography = $_.dataGeography
        $firstName = $_.FirstName
        $lastName = $_.LastName
        $email = $_.Email
        $phone = $_.Phone
        $mobile = $_.Mobile
        $fax = $_.Fax
        $address1 = $_.Address1
        $address2 = $_.Address2
        $address3 = $_.Address3
        $city = $_.City
        $state = $_.State
        $countryCode = $_.CountryCode
        $postCode = $_.PostCode

        $Body = "{
        ""name"": ""$customerName"",
        ""dataGeography"": ""$dataGeography"",
        ""contact"": {
            ""firstName"": ""$firstName"",
            ""lastName"": ""$lastName"",
            ""email"": ""$email"",
            ""phone"": ""$phone"",
            ""mobile"": ""$mobile"",
            ""fax"": ""$fax"",
            ""address"": {
                ""address1"": ""$address1"",
                ""address2"": ""$address2"",
                ""address3"": ""$address3"",
                ""city"": ""$city"",
                ""state"": ""$state"",
                ""countryCode"": ""$countryCode"",
                ""postalCode"": ""$postCode""
            }
        },
        ""billingType"": ""trial""
        }"

        # Request Headers
        $Headers = [ordered]@{
        "Authorization" = "Bearer $global:token";
        "X-Partner-ID" = "$global:ApiPartnerId";
        "Content-Type" = "application/json";
        "cache-control" = "no-cache";
        }

        Write-Host $Body
        # Set TLS Version
        [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
        
        # Post Request
        $Result = (Invoke-RestMethod -Uri $Uri -Method Post -ContentType "application/json" -Headers $Headers -Body $Body -ErrorAction SilentlyContinue -ErrorVariable Error)

        # Notify SysAdmin
        Write-Host "Sucessfully created tennant for: $($Result.name)"
    }

}