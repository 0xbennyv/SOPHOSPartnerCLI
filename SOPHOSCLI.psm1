. .\SOPHOSAPI.ps1
. .\SOPHOSPartnerTenants.ps1
. .\SOPHOSPartnerEndpoints.ps1

# SOPHOSAPI.ps1
Export-ModuleMember Set-SOPHOSCredentials
Export-ModuleMember Get-SOPHOSPartnerID
Export-ModuleMember Get-SOPHOSToken
Export-ModuleMember Check-SOPHOSTokenExpiry

# SOPHOSPartnerTenants.ps1
Export-ModuleMember Export-SOPHOSPartnerTenantsRedacted
Export-ModuleMember Export-SOPHOSPartnerTenants
Export-ModuleMember Set-SOPHOSPartnerTenant
Export-ModuleMember Create-SOPHOSPartnerTenant
Export-ModuleMember Get-SOPHOSTenantTemplate
Export-ModuleMember Import-SOPHOSPartnerTenant

# SOPHOSPartnerEndpoints
Export-ModuleMember Get-SOPHOSPartnerEndpoint
Export-ModuleMember Export-SOPHOSPartnerEndpoints