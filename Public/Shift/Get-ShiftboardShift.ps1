﻿<#
.SYNOPSIS
    
    Function used get shifts object(s) from Shiftboard
 
.PARAMETER AccessKey
 
    API Access Key from Shiftboard account
    To view key, login > Admin > Cog Icon > General Settings > API Configuration

.PARAMETER SignatureKey
 
    Signature Key from Shiftboard account
    To view key, login > Admin > Cog Icon > General Settings > API Configuration


.PARAMETER AccountId

    Id of Shiftboard user


.PARAMETER StartDate

    Optional. Day that shift begins.
    If omitted, default value is today's date.

.PARAMETER EndDate

    Optional. Date that shift ends
    If omitted, default value is 7 days after StartDate.


.PARAMETER PuslishedOnly

    Optional. If set to True, only shifts which are published will be returned




.EXAMPLE
    
    $key = 'ef1231ea-9a1a-59c2-110a-e123a1231333'
    $secret = 'TvL>UoWKb&HZbdZqDpKja+LdKvLf9TBDm4*Frfhu'

    $request = $reqs = Get-ShiftboardShift -AccessKey $key -SignatureKey $secret -AccountId 27 -StartDate '2019-11-28'

    # Returns shifts that take place after '2019-11-28', and where the user account id is "27"

    
#>
function Get-ShiftboardShift
{
    [CmdletBinding(PositionalBinding=$false)]
    param
    (
        [Parameter(Mandatory=$true)][string]$AccessKey,
        [Parameter(Mandatory=$true)][string]$SignatureKey,

        [Parameter(Mandatory=$true)][string]$AccountId,

        [Parameter(Mandatory=$false)][datetime]$StartDate,
        [Parameter(Mandatory=$false)][datetime]$EndDate,
        [Parameter(Mandatory=$false)][bool]$PuslishedOnly

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
        $params.select += @{covering_member = $AccountId}
    }

    if ($PSBoundParameters.Keys -contains 'StartDate')
    {
        $params.select += @{start_date = $StartDate.ToString("yyyy-MM-dd")}
    }

    if ($PSBoundParameters.Keys -contains 'EndDate')
    {
        $params.select += @{end_date = $EndDate.ToString("yyyy-MM-dd")}
    }

    if ($PuslishedOnly -eq $true)
    {
        $params.select += @{published = $true}
    }


    $paramsJson = $params | ConvertTo-Json

    $method = 'shift.list'

    $response = Invoke-ShiftboardApi -AccessKey $AccessKey -SignatureKey $SignatureKey -ShiftboardMethod $method -ParameterString $paramsJson

    return $response.result.shifts
}


