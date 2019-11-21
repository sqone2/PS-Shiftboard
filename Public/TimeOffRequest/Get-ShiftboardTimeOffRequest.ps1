<#
.SYNOPSIS
    
    Function used create new timeOffRequest object in Shiftboard
 
.PARAMETER AccessKey
 
    API Access Key from Shiftboard account
    To view key, login > Admin > Cog Icon > General Settings > API Configuration

.PARAMETER SignatureKey
 
    Signature Key from Shiftboard account
    To view key, login > Admin > Cog Icon > General Settings > API Configuration


.PARAMETER AccountId

    Id of Shiftboard user. Can also use ExternalId instead of Id

.PARAMETER ExternalId

    External Id of Shiftboard user. Can also use Id instead of ExternalId

.PARAMETER Type

    Type of requets. i.e. "All Day"

.PARAMETER Status

    Request status. i.e. "Approved"

.PARAMETER StartDate

    Day that timeOffRequest begins

.PARAMETER EndDate

    Optional. Date that timeOffRequest ends

.PARAMETER WorkgroupId

    Optional. Workgroup to be associated with timeOffRequest


.PARAMETER Paid

    Whether timeOffRequest is paid time off

.PARAMETER Category

    Integer value of category mapping set in Shiftboard. To get these values, use "Get-ShiftboardTimeOffCategories"

.PARAMETER Summary

    Summary of timeOffRequest


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


