<#
.SYNOPSIS
    
    Function used get team(s) from ShiftBoard
 
.PARAMETER AccessKey
 
    API Access Key from ShiftBoard account
    To view key, login > Admin > Cog Icon > General Settings > API Configuration

.PARAMETER SignatureKey
 
    Signature Key from ShiftBoard account
    To view key, login > Admin > Cog Icon > General Settings > API Configuration

.PARAMETER TeamName
 
    Name of team to get from ShiftBoard. If omitted, all teams will be returned

    
.EXAMPLE
    
    $key = 'ef1231ea-9a1a-59c2-110a-e123a1231333'
    $secret = 'TvL>UoWKb&HZbdZqDpKja+LdKvLf9TBDm4*Frfhu'

    $result = Get-ShiftboardTeam -AccessKey $key -SignatureKey $secret

    # returns all shiftboard teams


.EXAMPLE
    
    $key = 'ef1231ea-9a1a-59c2-110a-e123a1231333'
    $secret = 'TvL>UoWKb&HZbdZqDpKja+LdKvLf9TBDm4*Frfhu'

    $result = Get-ShiftboardTeam -AccessKey $key -SignatureKey $secret -TeamName "Sales"


    # Returns ShiftBoard team with name "Sales"
    

 
#>
function Get-ShiftboardTeam
{
    [CmdletBinding(PositionalBinding=$false)]
    param
    (
        [Parameter(Mandatory=$true)][string]$AccessKey,
        [Parameter(Mandatory=$true)][string]$SignatureKey,
        [Parameter(Mandatory=$false)][string]$TeamName
    )

    $params =  @{
        page = @{
            batch = 1000
        }
    }

    $paramsJson = $params | ConvertTo-Json
    

    $method = 'teamCategoryItem.list'

    $allTeams = Invoke-ShiftboardApi -AccessKey $AccessKey -SignatureKey $SignatureKey -ShiftBoardMethod $method -ParameterString $paramsJson

    if ($PSBoundParameters.Keys -contains "TeamName")
    {
        return $allTeams.result.items |  ? {$_.name -eq $TeamName}
    }
    else
    {
        return $allTeams.result.items
    }

    
}

