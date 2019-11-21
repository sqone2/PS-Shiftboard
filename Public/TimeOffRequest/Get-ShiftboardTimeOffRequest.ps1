<#
.SYNOPSIS
    
    Function used get timeOffRequest object(s) from Shiftboard
 
.PARAMETER AccessKey
 
    API Access Key from Shiftboard account
    To view key, login > Admin > Cog Icon > General Settings > API Configuration

.PARAMETER SignatureKey
 
    Signature Key from Shiftboard account
    To view key, login > Admin > Cog Icon > General Settings > API Configuration


.PARAMETER AccountId

    Optional. Id of Shiftboard user


.PARAMETER StartDate

    Optional. Day that timeOffRequest begins.
    If omitted, default value is today's date.

.PARAMETER EndDate

    Optional. Date that timeOffRequest ends
    If omitted, default value is 7 days after StartDate.



.EXAMPLE
    
    $key = 'ef1231ea-9a1a-59c2-110a-e123a1231333'
    $secret = 'TvL>UoWKb&HZbdZqDpKja+LdKvLf9TBDm4*Frfhu'

    $request = Get-ShiftboardTimeOffRequest -AccessKey $key -SignatureKey $secret

    # Returns all time off requests


.EXAMPLE
    
    $key = 'ef1231ea-9a1a-59c2-110a-e123a1231333'
    $secret = 'TvL>UoWKb&HZbdZqDpKja+LdKvLf9TBDm4*Frfhu'

    $request = $reqs = Get-ShiftboardTimeOffRequest -AccessKey $key -SignatureKey $secret -AccountId 27 -StartDate '2019-11-28'

    # Returns timeOffRequests that take place after '2019-11-28', and where the user account id is "27"

    
#>
function Get-ShiftboardTimeOffRequest
{
    [CmdletBinding(PositionalBinding=$false)]
    param
    (
        [Parameter(Mandatory=$true)][string]$AccessKey,
        [Parameter(Mandatory=$true)][string]$SignatureKey,

        [Parameter(Mandatory=$false)][string]$AccountId,

        [Parameter(Mandatory=$false)][datetime]$StartDate,
        [Parameter(Mandatory=$false)][datetime]$EndDate


    )


    $params =  @{
        extended = $true
        page = @{
            batch = 1000
        }
        select = @{

        }
    }
    


    if ($PSBoundParameters.Keys -contains 'AccountId')
    {
        $params.select += @{member = $AccountId}
    }

    if ($PSBoundParameters.Keys -contains 'StartDate')
    {
        $params.select += @{start_date = $StartDate.ToString("yyyy-MM-dd")}
    }

    if ($PSBoundParameters.Keys -contains 'EndDate')
    {
        $params.select += @{end_date = $EndDate.ToString("yyyy-MM-dd")}
    }


    $paramsJson = $params | ConvertTo-Json

    $method = 'timeOffRequest.list'

    $response = Invoke-ShiftboardApi -AccessKey $AccessKey -SignatureKey $SignatureKey -ShiftboardMethod $method -ParameterString $paramsJson

    return $response.result.timeOffRequests
}


