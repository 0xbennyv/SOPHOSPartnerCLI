# SOPHOSPartnerCLI
This is a SOPHOS Central PowerShell Module for SOPHOS Partners. It's still pretty beta and raw and looking for collaboration/contribution.

# Getting Started

In the current iteration of the scripts, the way to get started is:

```Import-Module .\SOPHOSPartnerCLI.psm1```

Once Imported, running Set-SOPHOSCredentials will prompt for ClientID and ClientSecret. This will store the credentials in C:\Users\%userprofile\sophos_partner_config.json and will automatically trigger Get-SOPHOSToken and Get-SOPHOSPartnerID.

## Partnet Tenant Commands

### Set-SOPHOSPartnerTenant
Set-SOPHOSPartnerTenant gives you a list of tenants you can then select to start working with the Endpoint Commands

### Export-SOPHOSPartnerTenant
Export-SOPHOSPartnerTenant is designed to do a verbose dump of the partners tenants they have, this includes API Gateways, Tenant ID's etc.

```Usage: Export-SOPHOSPartnerTenant -Redacted[Optional] -FileName[Optional]```

### New-SOPHOSPartnerTenant
New-SOPHOSPartnerTenant is for programatically addressing the function for additional services. As an engineer if there was a workflow that needed to be created for a batch job or some sort of processing to automatically create a new tenant. The Active Switch sets the tenant to the active tenant for the session

```Usage: Create-SOPHOSPartnerTenant -Active -CustomerName[Mandatory] -dataGeography[Mandatory] -FistName[Mandatory] -LastName[Mandatory] -Phone[Mandatory] -Mobile[Mandatory] -Address1[Mandatory] -Address2[Optional] -Address3[Optional] -City[Mandatory] -State[Mandatory] -CountryCode[Mandatory] -PostCode[Mandatory]```


### Get-SOPHOSTenantTemplate
Get-SOPHOSTenantTemplate gives you a csv file ready to fill out and used with Import-SOPHOSTenantTemplate

```Usage: Get-SOPHOSTenantTemplate -FileName[Optional]```

### Import-SOPHOSPartnerTenant
Import-SOPHOSPartnerTenant is designed for Bulk Importation of customers to create tenants using the CSV Template from Get-SOPHOSTenantTemplate you can import bulk lots.

```Usage: Import-SOPHOSPartnerTenant -FileName[Optional]```

## Endpoint Commands
### Get-SOPHOSPartnerAllEndpoints
Dumps a list of every tenants endpoints

### Get-SOPHOSPartnerRedStatus
Returns any endpoint with a health status of "bad"

### Get-SOPHOSPartnerWarnedStatus
Returns any endpoint with a health status of "suspicous"

### Get-SOPHOSPartnerHealthyStatus
Returns any endpoint with a health status of "good"


