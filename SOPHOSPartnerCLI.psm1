. .\SOPHOSAPI.ps1
. .\SOPHOSPartnerTenants.ps1
. .\SOPHOSPartnerEndpoints.ps1
. .\SOPHOSPartnerStatus.ps1
. .\SOPHOSPartnerTamper.ps1

# SOPHOSAPI.ps1
Export-ModuleMember Set-SOPHOSCredentials
Export-ModuleMember Get-SOPHOSPartnerID
Export-ModuleMember Get-SOPHOSToken
Export-ModuleMember Get-SOPHOSTokenExpiry

# SOPHOSPartnerTenants.ps1
Export-ModuleMember Export-SOPHOSPartnerTenants
Export-ModuleMember Set-SOPHOSPartnerTenant
Export-ModuleMember Get-SOPHOSPartnerTenants
Export-ModuleMember New-SOPHOSPartnerTenant
Export-ModuleMember Get-SOPHOSTenantTemplate
Export-ModuleMember Import-SOPHOSPartnerTenant

# SOPHOSPartnerEndpoints
Export-ModuleMember Get-SOPHOSPartnerEndpointsAllTenants
Export-ModuleMember Get-SOPHOSPartnerEndpoints
Export-ModuleMember Set-SOPHOSPartnerEndpoint
Export-ModuleMember Export-SOPHOSPartnerEndpoints
Export-ModuleMember Get-SOPHOSPartnerTamperEnabled
Export-ModuleMember Get-SOPHOSPartnerTamperDisabled

# SOPHOSPartnerStatus
Export-ModuleMember Get-SOPHOSPartnerAllEndpoints
Export-ModuleMember Get-SOPHOSPartnerRedStatus
Export-ModuleMember Get-SOPHOSPartnerWarnedStatus
Export-ModuleMember Get-SOPHOSPartnerHealthyStatus

# SOPHOSPartnerTamper
Export-ModuleMember Enable-SOPHOSPartnerTamperProtection