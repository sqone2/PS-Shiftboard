<#
.SYNOPSIS
    
    Function used remove an account from a workgroup
 
.PARAMETER AccessKey
 
    API Access Key from Shiftboard account
    To view key, login > Admin > Cog Icon > General Settings > API Configuration

.PARAMETER SignatureKey
 
    Signature Key from Shiftboard account
    To view key, login > Admin > Cog Icon > General Settings > API Configuration

.PARAMETER WorkgroupId
 
    Id of Shiftboard workgroup to remove member from

.PARAMETER AccountId
 
    Id of Shiftboard account to be removed from workgroup

    
.EXAMPLE
    
    $key = 'ef1231ea-9a1a-59c2-110a-e123a1231333'
    $secret = 'TvL>UoWKb&HZbdZqDpKja+LdKvLf9TBDm4*Frfhu'

    $result = Remove-ShiftboardWorkgroupMember -AccessKey $key -SignatureKey $secret -WorkgroupId "123456" -AccountId "999"

    # removes account with id "999" from workgroup with id "123456"



 
#>
function Remove-ShiftboardWorkgroupMember
{
    [CmdletBinding(PositionalBinding=$false)]
    param
    (
        [Parameter(Mandatory=$true)][string]$AccessKey,
        [Parameter(Mandatory=$true)][string]$SignatureKey,
        [Parameter(Mandatory=$true)][string]$WorkgroupId,
        [Parameter(Mandatory=$true)][string]$AccountId
    )



    $params =  @{
        workgroup = $WorkgroupId
        member = $AccountId

    }
    
    $paramsJson = $params | ConvertTo-Json
    

    $method = 'membership.delete'

    $response = Invoke-ShiftboardApi -AccessKey $AccessKey -SignatureKey $SignatureKey -ShiftboardMethod $method -ParameterString $paramsJson

    return $response.result

    
}
