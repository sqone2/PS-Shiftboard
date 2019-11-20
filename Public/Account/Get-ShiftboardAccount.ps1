<#
.SYNOPSIS
    
    Function used to get Account(s) from Shiftboard
 
.PARAMETER AccessKey
 
    API Access Key from Shiftboard account
    To view key, login > Admin > Cog Icon > General Settings > API Configuration

.PARAMETER SignatureKey
 
    Signature Key from Shiftboard account
    To view key, login > Admin > Cog Icon > General Settings > API Configuration

.PARAMETER Email
 
    Email of Account to get from Shiftboard. If omitted, all Accounts will be returned


    
.EXAMPLE
    
    $key = 'ef1231ea-9a1a-59c2-110a-e123a1231333'
    $secret = 'TvL>UoWKb&HZbdZqDpKja+LdKvLf9TBDm4*Frfhu'

    $result = Get-ShiftboardAccount -AccessKey $key -SignatureKey $secret

    # returns all Shiftboard Accounts


.EXAMPLE
    
    $key = 'ef1231ea-9a1a-59c2-110a-e123a1231333'
    $secret = 'TvL>UoWKb&HZbdZqDpKja+LdKvLf9TBDm4*Frfhu'

    $result = Get-ShiftboardAccount -AccessKey $key -SignatureKey $secret -Email "jdoe@domain.com"


    # Returns Shiftboard Account with email "jdoe@domain.com"
    

 
#>
function Get-ShiftboardAccount
{
    [CmdletBinding(PositionalBinding=$false)]
    param
    (
        [Parameter(Mandatory=$true)][string]$AccessKey,
        [Parameter(Mandatory=$true)][string]$SignatureKey,
        [Parameter(Mandatory=$false)][string]$Email
        
    )

    # return by email
    if ($PSBoundParameters.Keys -contains "Email")
    {
        $params =  @{
            extended = $true
            select = @{
                email = $Email
            }
        }
                
    }
    # return all accounts
    else
    {
        $params =  @{
        extended = $true
            page = @{
                batch = 1000
            }
        }
    }


    $method = 'account.list'

    $paramsJson = $params | ConvertTo-Json

    $response = Invoke-ShiftboardApi -AccessKey $AccessKey -SignatureKey $SignatureKey -ShiftboardMethod $method -ParameterString $paramsJson

    return $response.result.accounts
}

