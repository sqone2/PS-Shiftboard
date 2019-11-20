<#
.SYNOPSIS
    
    Function used to get Account(s) from Shiftboard
 
.PARAMETER AccessKey
 
    API Access Key from Shiftboard account
    To view key, login > Admin > Cog Icon > General Settings > API Configuration

.PARAMETER SignatureKey
 
    Signature Key from Shiftboard account
    To view key, login > Admin > Cog Icon > General Settings > API Configuration

.EXAMPLE
    
    $key = 'ef1231ea-9a1a-59c2-110a-e123a1231333'
    $secret = 'TvL>UoWKb&HZbdZqDpKja+LdKvLf9TBDm4*Frfhu'

    $result = Get-ShiftboardTimeOffCategories -AccessKey $key -SignatureKey $secret

    # returns all time off categories




 
#>
function Get-ShiftboardTimeOffCategories
{
    [CmdletBinding(PositionalBinding=$false)]
    param
    (
        [Parameter(Mandatory=$true)][string]$AccessKey,
        [Parameter(Mandatory=$true)][string]$SignatureKey
    )

    $params =  @{
        org_settings = $true
    }

    $method = 'account.self'

    $paramsJson = $params | ConvertTo-Json

    $response = Invoke-ShiftboardApi -AccessKey $AccessKey -SignatureKey $SignatureKey -ShiftboardMethod $method -ParameterString $paramsJson

    $categories = $response.result.org_settings.timeoff_categories
    $categoryCount = ($categories | Get-Member -MemberType NoteProperty).Count

    # format output into hashtable
    $returnHashTable = @{}
    for ($i = 1; $i -le $categoryCount; $i++)
    { 
        if ($categories.$i.Length -gt 0)
        {
            $returnHashTable += @{$categories.$i = $i}
        }
    }

    return $returnHashTable

}

