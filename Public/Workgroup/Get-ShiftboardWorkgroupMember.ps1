<#
.SYNOPSIS
    
    Function used get workgroup(s) from ShiftBoard
 
.PARAMETER AccessKey
 
    API Access Key from ShiftBoard account
    To view key, login > Admin > Cog Icon > General Settings > API Configuration

.PARAMETER SignatureKey
 
    Signature Key from ShiftBoard account
    To view key, login > Admin > Cog Icon > General Settings > API Configuration

.PARAMETER WorkgroupId
 
    Id to ShiftBoard workgroup to get membership of

    
.EXAMPLE
    
    $key = 'ef1231ea-9a1a-59c2-110a-e123a1231333'
    $secret = 'TvL>UoWKb&HZbdZqDpKja+LdKvLf9TBDm4*Frfhu'

    $result = Get-ShiftBoardWorkgroupMember -AccessKey $key -SignatureKey $secret -WorkgroupId "123456"

    # returns all shiftboard workgroup membership for workgroup with id "123456"



 
#>
function Get-ShiftBoardWorkgroupMember
{
    [CmdletBinding(PositionalBinding=$false)]
    param
    (
        [Parameter(Mandatory=$true)][string]$AccessKey,
        [Parameter(Mandatory=$true)][string]$SignatureKey,
        [Parameter(Mandatory=$true)][string]$WorkgroupId
    )

    $params =  @{
        page = @{
            batch = 1000
        }
        
        select = @{
            workgroup = $WorkgroupId
        }
    }
    

    $paramsJson = $params | ConvertTo-Json
    

    $method = 'account.listByWorkgroup'

    $response = Invoke-ShiftboardApi -AccessKey $AccessKey -SignatureKey $SignatureKey -ShiftBoardMethod $method -ParameterString $paramsJson

    return $response.result.members

    
}

