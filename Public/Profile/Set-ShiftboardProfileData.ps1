<#
.SYNOPSIS
    
    Updates multiple profileData objects for a given account
 
.PARAMETER AccessKey
 
    API Access Key from Shiftboard account
    To view key, login > Admin > Cog Icon > General Settings > API Configuration

.PARAMETER SignatureKey
 
    Signature Key from Shiftboard account
    To view key, login > Admin > Cog Icon > General Settings > API Configuration

.PARAMETER AccountId
 
    Id of Account to update profile data for

.PARAMETER ProfileOptionId
 
    Id of profile configuration object to be updated

.PARAMETER ProfileOptionValue
 
    New value to be assigned to profile configuration object specified by -ProfileOptionId


    
.EXAMPLE
    
    $key = 'ef1231ea-9a1a-59c2-110a-e123a1231333'
    $secret = 'TvL>UoWKb&HZbdZqDpKja+LdKvLf9TBDm4*Frfhu'

    $result = Set-ShiftboardAccount -AccessKey $key -SignatureKey $secret -Id 1234 -ProfileOptionId '1031' -ProfileOptionValue 'Blue'

    # assigns new profile data value to account id 1234
 
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

