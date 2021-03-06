﻿<#
.SYNOPSIS
    
    Function used get workgroup(s) from Shiftboard
 
.PARAMETER AccessKey
 
    API Access Key from Shiftboard account
    To view key, login > Admin > Cog Icon > General Settings > API Configuration

.PARAMETER SignatureKey
 
    Signature Key from Shiftboard account
    To view key, login > Admin > Cog Icon > General Settings > API Configuration

.PARAMETER WorkgroupName
 
    Name of workgroup to get from Shiftboard. If omitted, all workgroups will be returned

    
.EXAMPLE
    
    $key = 'ef1231ea-9a1a-59c2-110a-e123a1231333'
    $secret = 'TvL>UoWKb&HZbdZqDpKja+LdKvLf9TBDm4*Frfhu'

    $result = Get-ShiftboardWorkgroup -AccessKey $key -SignatureKey $secret

    # returns all shiftboard workgroups


.EXAMPLE
    
    $key = 'ef1231ea-9a1a-59c2-110a-e123a1231333'
    $secret = 'TvL>UoWKb&HZbdZqDpKja+LdKvLf9TBDm4*Frfhu'

    $result = Get-ShiftboardWorkgroup -AccessKey $key -SignatureKey $secret -WorkgroupName "Sales"


    # Returns Shiftboard workgroup with name "Sales"
    

 
#>
function Get-ShiftboardWorkgroup
{
    [CmdletBinding(PositionalBinding=$false)]
    param
    (
        [Parameter(Mandatory=$true)][string]$AccessKey,
        [Parameter(Mandatory=$true)][string]$SignatureKey,
        [Parameter(Mandatory=$false)][string]$WorkgroupName
    )

    $params =  @{
        page = @{
            batch = 1000
        }
    }

    $paramsJson = $params | ConvertTo-Json
    

    $method = 'workgroup.list'

    $response = Invoke-ShiftboardApi -AccessKey $AccessKey -SignatureKey $SignatureKey -ShiftboardMethod $method -ParameterString $paramsJson

    if ($PSBoundParameters.Keys -contains "WorkgroupName")
    {
        return $response.result.workgroups |  ? {$_.name -eq $WorkgroupName}
    }
    else
    {
        return $response.result.workgroups
    }

    
}

