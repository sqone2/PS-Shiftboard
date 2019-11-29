<#
.SYNOPSIS
    
    Function used get shifts object(s) from Shiftboard
 
.PARAMETER AccessKey
 
    API Access Key from Shiftboard account
    To view key, login > Admin > Cog Icon > General Settings > API Configuration

.PARAMETER SignatureKey
 
    Signature Key from Shiftboard account
    To view key, login > Admin > Cog Icon > General Settings > API Configuration


.PARAMETER Id

    Id of Shiftboard time off request

.PARAMETER Unconfirm

    In case of conflicts the conflicted shifts will be unconfirmed.

.PARAMETER Unpublish

    In case of conflicts the conflicted shifts will be unpublished.
    On success, empty results will be returned if neither unconfirmed/unpublished has been specified.
    If a conflict was found and if either unconfirmed/unpublished was specified, the result set will have one field "conflicts" containing an array of conflict descriptions. Each element describes one conflict in terms of start date for the shift, the team name and a text with details for the conflict.



.EXAMPLE
    
    $key = 'ef1231ea-9a1a-59c2-110a-e123a1231333'
    $secret = 'TvL>UoWKb&HZbdZqDpKja+LdKvLf9TBDm4*Frfhu'

    $request = Approve-ShiftboardTimeOffRequest -AccessKey $key -SignatureKey $secret -Id 123456 -Unconfirm $true -Unpublish $true

    # Approves timeOffRequest 123456 and unconfirms and unpublishes conflicting shifts

    
#>
function Approve-ShiftboardTimeOffRequest
{
    [CmdletBinding(PositionalBinding=$false)]
    param
    (
        [Parameter(Mandatory=$true)][string]$AccessKey,
        [Parameter(Mandatory=$true)][string]$SignatureKey,

        [Parameter(Mandatory=$true)][string]$Id,
        [Parameter(Mandatory=$false)][bool]$Unconfirm = $false,
        [Parameter(Mandatory=$false)][bool]$Unpublish = $false
    )


    $params =  @{
        id = $Id
        unconfirm = $Unconfirm
        unpublish = $Unpublish
    }



    $paramsJson = $params | ConvertTo-Json

    $method = 'timeOffRequest.approve'

    $response = Invoke-ShiftboardApi -AccessKey $AccessKey -SignatureKey $SignatureKey -ShiftboardMethod $method -ParameterString $paramsJson

    return $response.result
}


