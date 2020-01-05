<#
.SYNOPSIS
    
    Returns information about account profile data
 
.PARAMETER AccessKey
 
    API Access Key from Shiftboard account
    To view key, login > Admin > Cog Icon > General Settings > API Configuration

.PARAMETER SignatureKey
 
    Signature Key from Shiftboard account
    To view key, login > Admin > Cog Icon > General Settings > API Configuration

.PARAMETER AccountId
 
    Id of Account to get profile data for


    
.EXAMPLE
    
    $key = 'ef1231ea-9a1a-59c2-110a-e123a1231333'
    $secret = 'TvL>UoWKb&HZbdZqDpKja+LdKvLf9TBDm4*Frfhu'

    $result = Get-ShiftboardAccount -AccessKey $key -SignatureKey $secret -Id 1234

    # returns profile data for Account 1234
 
#>
function Set-ShiftboardProfileData
{
    [CmdletBinding(PositionalBinding=$false)]
    param
    (
        [Parameter(Mandatory=$true)][string]$AccessKey,
        [Parameter(Mandatory=$true)][string]$SignatureKey,
        [Parameter(Mandatory=$true)][string]$AccountId,
        [Parameter(Mandatory=$true)][string]$ProfileOptionId,
        [Parameter(Mandatory=$true)][string]$ProfileOptionValue
        
    )


    $params =  @{
        account = $AccountId
        profile_data = @(
            @{
                profile_option = $ProfileOptionId
                value = $ProfileOptionValue
            }
        )
    }
   

    $method = 'profileData.update'

    $paramsJson = $params | ConvertTo-Json

    $response = Invoke-ShiftboardApi -AccessKey $AccessKey -SignatureKey $SignatureKey -ShiftboardMethod $method -ParameterString $paramsJson

    return $respons
}

