. .\SOPHOSAPI.ps1
. .\SOPHOSPartnerTenants.ps1
. .\SOPHOSPartnerEndpoints.ps1
. .\SOPHOSPartnerStatus.ps1

# SOPHOSAPI.ps1
Export-ModuleMember Set-SOPHOSCredentials
Export-ModuleMember Get-SOPHOSPartnerID
Export-ModuleMember Get-SOPHOSToken
Export-ModuleMember Get-SOPHOSTokenExpiry

# SOPHOSPartnerTenants.ps1
Export-ModuleMember Export-SOPHOSPartnerTenantsRedacted
Export-ModuleMember Export-SOPHOSPartnerTenants
Export-ModuleMember Set-SOPHOSPartnerTenant
Export-ModuleMember New-SOPHOSPartnerTenant
Export-ModuleMember Get-SOPHOSTenantTemplate
Export-ModuleMember Import-SOPHOSPartnerTenant

# SOPHOSPartnerEndpoints
Export-ModuleMember Get-SOPHOSPartnerEndpoint
Export-ModuleMember Export-SOPHOSPartnerEndpoints

# SOPHOSPartnerStatus
Export-ModuleMember Get-SOPHOSPartnerAllEndpoints
Export-ModuleMember Get-SOPHOSPartnerRedStatus
Export-ModuleMember Get-SOPHOSPartnerWarnedStatus
Export-ModuleMember Get-SOPHOSPartnerHealthyStatus