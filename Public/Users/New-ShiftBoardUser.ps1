<#
.SYNOPSIS
    
    Function used create a new user in ShiftBoard
 
.PARAMETER AccessKey
 
    API Access Key from ShiftBoard account
    To view key, login > Admin > Cog Icon > General Settings > API Configuration

.PARAMETER SignatureKey
 
    Signature Key from ShiftBoard account
    To view key, login > Admin > Cog Icon > General Settings > API Configuration


.PARAMETER FirstName

    First name value of new user


.PARAMETER LastName

    Last name value of new user

.PARAMETER Email

    Email value of new user

.PARAMETER ExternalId

   External id of new user

.PARAMETER TimeZone

    New user's time zone
    
.EXAMPLE
    
    $key = 'ef1231ea-9a1a-59c2-110a-e123a1231333'
    $secret = 'TvL>UoWKb&HZbdZqDpKja+LdKvLf9TBDm4*Frfhu'

    $newUser = New-ShiftboardUser -AccessKey $key -SignatureKey $secret -FirstName "Test" -LastName "User" -Email "test@domain.com" -ExternalId "999999" -TimeZone 'Central'

    # Creates new ShiftBoard user named "Test User"

    

#>
function New-ShiftboardUser
{
    [CmdletBinding(PositionalBinding=$false)]
    param
    (
        [Parameter(Mandatory=$true)][string]$AccessKey,
        [Parameter(Mandatory=$true)][string]$SignatureKey,
        [Parameter(Mandatory=$true)][string]$FirstName,
        [Parameter(Mandatory=$true)][string]$LastName,
        [Parameter(Mandatory=$true)][string]$Email,
        [Parameter(Mandatory=$true)][string]$ExternalId,
        [Parameter(Mandatory=$true)][ValidateSet("Eastern", "Central", "Mountain", "Pacific")][string]$TimeZone 
    )



    if ($TimeZone -eq "Eastern")
    {
        $tzString = "Eastern Time (US/Can) (GMT-05:00)"
    }
    elseif ($TimeZone -eq "Central")
    {
        $tzString = "Central Time (US/Can) (GMT-06:00)"
    }
    elseif ($TimeZone -eq "Mountain")
    {
        $tzString = "Mountain Time (US/Can) (GMT-07:00)"
    }
    elseif ($TimeZone -eq "Pacific")
    {
        $tzString = "Pacific Time (US/Can) (GMT-08:00)"
    }
    else
    {
        # default
         $tzString = "Central Time (US/Can) (GMT-06:00)"
    }


    $params = @{
        first_name = $FirstName
        last_name = $LastName
        email = $Email
        external_id = $ExternalId
        timzone = $tzString
    }

    $paramsJson = $params | ConvertTo-Json

    $method = 'account.create'

    $response = Invoke-ShiftboardApi -AccessKey $AccessKey -SignatureKey $SignatureKey -ShiftBoardMethod $method -ParameterString $paramsJson

    return $response.result
}

