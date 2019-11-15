<#
.SYNOPSIS
    
    Function used communicate with the ShiftBoard.com JSON-RPC 2.0 API
 
.PARAMETER AccessKey
 
    API Access Key from ShiftBoard account
    To view key, login > Admin > Cog Icon > General Settings > API Configuration

.PARAMETER SignatureKey
 
    Signature Key from ShiftBoard account
    To view key, login > Admin > Cog Icon > General Settings > API Configuration

.PARAMETER Email
 
    Email of user to get from ShiftBoard. If omitted, all users will be returned

    
.EXAMPLE
    
    $key = 'ef1231ea-9a1a-59c2-110a-e123a1231333'
    $secret = 'TvL>UoWKb&HZbdZqDpKja+LdKvLf9TBDm4*Frfhu'

    $result = Get-ShiftBoardUser -AccessKey $key -SignatureKey $secret

    # returns all shiftboard users


.EXAMPLE
    
    $key = 'ef1231ea-9a1a-59c2-110a-e123a1231333'
    $secret = 'TvL>UoWKb&HZbdZqDpKja+LdKvLf9TBDm4*Frfhu'

    $result = Get-ShiftBoardUser -AccessKey $key -SignatureKey $secret -Email "jdoe@domain.com"


    # Returns ShiftBoard user with email "jdoe@domain.com"
    

 
#>
function Get-ShiftboardUser
{
    [CmdletBinding(PositionalBinding=$false)]
    param
    (
        [Parameter(Mandatory=$true)][string]$AccessKey,
        [Parameter(Mandatory=$true)][string]$SignatureKey,
        [Parameter(Mandatory=$false)][string]$Email
    )


    if ($PSBoundParameters.Keys -contains "Email")
    {
            $params =  @{
                select = @{
                    email = $Email
                }
            }
                
    }
    else
    {
        $params =  @{
            page = @{
                batch = 1000
            }
        }
    }


    $method = 'account.list'

    $paramsJson = $params | ConvertTo-Json

    $response = Invoke-ShiftboardApi -AccessKey $AccessKey -SignatureKey $SignatureKey -ShiftBoardMethod $method -ParameterString $paramsJson

    return $response.result.accounts
}

