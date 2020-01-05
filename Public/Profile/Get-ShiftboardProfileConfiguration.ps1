<#
.SYNOPSIS
    
    Returns information about profile configuration
 
.PARAMETER AccessKey
 
    API Access Key from Shiftboard account
    To view key, login > Admin > Cog Icon > General Settings > API Configuration

.PARAMETER SignatureKey
 
    Signature Key from Shiftboard account
    To view key, login > Admin > Cog Icon > General Settings > API Configuration
    
.EXAMPLE
    
    $key = 'ef1231ea-9a1a-59c2-110a-e123a1231333'
    $secret = 'TvL>UoWKb&HZbdZqDpKja+LdKvLf9TBDm4*Frfhu'

    $result = Get-ShiftboardProfileConfiguration -AccessKey $key -SignatureKey $secret

    # returns all configuration objects

#>
function Get-ShiftboardProfileConfiguration
{
    [CmdletBinding(PositionalBinding=$false)]
    param
    (
        [Parameter(Mandatory=$true)][string]$AccessKey,
        [Parameter(Mandatory=$true)][string]$SignatureKey
    )


    $params =  @{
    }

    $method = 'profileConfiguration.list'

    $paramsJson = $params | ConvertTo-Json

    $response = Invoke-ShiftboardApi -AccessKey $AccessKey -SignatureKey $SignatureKey -ShiftboardMethod $method -ParameterString $paramsJson

    return $response.result.profile_configuration
}

