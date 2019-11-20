<#
.SYNOPSIS
    
    Function used add a account to a workgroup
 
.PARAMETER AccessKey
 
    API Access Key from ShiftBoard account
    To view key, login > Admin > Cog Icon > General Settings > API Configuration

.PARAMETER SignatureKey
 
    Signature Key from ShiftBoard account
    To view key, login > Admin > Cog Icon > General Settings > API Configuration

.PARAMETER WorkgroupId
 
    Id of ShiftBoard workgroup to add member to

.PARAMETER AccountId
 
    Id of ShiftBoard account to be added to workgroup

.PARAMETER Level
 
    Account's workgroup permission level

    
.EXAMPLE
    
    $key = 'ef1231ea-9a1a-59c2-110a-e123a1231333'
    $secret = 'TvL>UoWKb&HZbdZqDpKja+LdKvLf9TBDm4*Frfhu'

    $result = Add-ShiftBoardWorkgroupMember -AccessKey $key -SignatureKey $secret -WorkgroupId "123456" -AccountId "999" -Level Member

    # adds account with id "999" to workgroup with id "123456" with level "member"



 
#>
function Add-ShiftBoardWorkgroupMember
{
    [CmdletBinding(PositionalBinding=$false)]
    param
    (
        [Parameter(Mandatory=$true)][string]$AccessKey,
        [Parameter(Mandatory=$true)][string]$SignatureKey,
        [Parameter(Mandatory=$true)][string]$WorkgroupId,
        [Parameter(Mandatory=$true)][string]$AccountId,
        [Parameter(Mandatory=$true)][ValidateSet("Member", "Coordinator", "Manager")][string]$Level
    )

    $levelCodes = @{
        Member = "2"
        Coordinator = "3"
        Manager = "4"
    }

    $params =  @{
        workgroup = $WorkgroupId
        member = $AccountId
        level = $levelCodes[$Level]
    }
    
    $paramsJson = $params | ConvertTo-Json
    

    $method = 'membership.create'

    $response = Invoke-ShiftboardApi -AccessKey $AccessKey -SignatureKey $SignatureKey -ShiftBoardMethod $method -ParameterString $paramsJson

    return $response.result

    
}



