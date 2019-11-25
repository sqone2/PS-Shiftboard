<#
.SYNOPSIS
    
    Function used remove a timeOffRequest object
 
.PARAMETER AccessKey
 
    API Access Key from Shiftboard account
    To view key, login > Admin > Cog Icon > General Settings > API Configuration

.PARAMETER SignatureKey
 
    Signature Key from Shiftboard account
    To view key, login > Admin > Cog Icon > General Settings > API Configuration


.PARAMETER Id

    Id of Shiftboard timeOffRequest



.EXAMPLE
    
    $key = 'ef1231ea-9a1a-59c2-110a-e123a1231333'
    $secret = 'TvL>UoWKb&HZbdZqDpKja+LdKvLf9TBDm4*Frfhu'

    $request = Remove-ShiftboardTimeOffRequest -AccessKey $key -SignatureKey $secret -Id '123456'

    # Removes time off request with Id 123456



    
#>
function Remove-ShiftboardTimeOffRequest
{
    [CmdletBinding(PositionalBinding=$false)]
    param
    (
        [Parameter(Mandatory=$true)][string]$AccessKey,
        [Parameter(Mandatory=$true)][string]$SignatureKey,
        [Parameter(Mandatory=$true)][string]$Id
    )

        $params =  @{
            id = $Id
        }
    
    $paramsJson = $params | ConvertTo-Json

    $method = 'timeOffRequest.delete'

    $response = Invoke-ShiftboardApi -AccessKey $AccessKey -SignatureKey $SignatureKey -ShiftboardMethod $method -ParameterString $paramsJson

    return $response.result.timeOffRequests
}


