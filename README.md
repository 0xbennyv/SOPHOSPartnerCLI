# SOPHOSPartnerCLI
This is a SOPHOS Central PowerShell Module for Partners.

# Getting Started

<<Add Notes for importing the module>>

Once Imported, running Set-SOPHOSCredentials will prompt for ClientID and ClientSecret. This will store the credentials in "sophos_partner_config.json" and will automatically trigger Get-SOPHOSToken and Get-SOPHOSPartnerID.

### Set-SOPHOSPartnerTenant

### Export-SOPHOSPartnerTenant
Export-SOPHOSPartnerTenant is designed to do a verbose dump of the partners tenants they have, this includes API Gateways, Tenant ID's etc.

Usage: Export-SOPHOSPartnerTenant -Redacted[Optional] -FileName[Optional]

### Export-SOPHOSPartnerTenantsRedacted
Export-SOPHOSPartnerTenantsRedacted is designed to do a verbose dump of the partners tenants they have without API details, more for administration purposes.

This function is goig to be deleted and rolled into Export-SOPHOSPartnerTenant with a -Redacted param

Usage: Export-SOPHOSPartnerTenant -FileName[Optional]

### Create-SOPHOSPartnerTenant
Create-SOPHOSPartnerTenant is for programatically addressing the function for additional services. As an engineer if there was a workflow that needed to be created for a batch job or some sort of processing to automatically create a new tenant. Create-SOPHOSPartnerTenant can be used.

Usage: Create-SOPHOSPartnerTenant -CustomerName[Mandatory] -dataGeography[Mandatory] -FistName[Mandatory] -LastName[Mandatory] -Phone[Mandatory] -Mobile[Mandatory] -Address1[Mandatory] -Address2[Optional] -Address3[Optional] -City[Mandatory] -State[Mandatory] -CountryCode[Mandatory] -PostCode[Mandatory]


### Get-SOPHOSTenantTemplate
Get-SOPHOSTenantTemplate gives you a csv file ready to fill out and used with Import-SOPHOSTenantTemplate

Usage: Get-SOPHOSTenantTemplate -FileName[Optional]

### Import-SOPHOSPartnerTenant
Import-SOPHOSPartnerTenant is designed for Bulk Importation of customers to create tenants using the CSV Template from Get-SOPHOSTenantTemplate you can import bulk lots.

Usage: Import-SOPHOSPartnerTenant -FileName[Optional]


