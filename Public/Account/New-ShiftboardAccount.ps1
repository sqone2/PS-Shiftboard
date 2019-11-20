<#
.SYNOPSIS
    
    Function used to create a new Account in Shiftboard
 
.PARAMETER AccessKey
 
    API Access Key from Shiftboard account
    To view key, login > Admin > Cog Icon > General Settings > API Configuration

.PARAMETER SignatureKey
 
    Signature Key from Shiftboard account
    To view key, login > Admin > Cog Icon > General Settings > API Configuration


.PARAMETER FirstName

    First name value of new Account


.PARAMETER LastName

    Last name value of new Account

.PARAMETER Email

    Email value of new Account

.PARAMETER ExternalId

   External id of new Account

.PARAMETER TimeZone

    New Account's time zone
    
.EXAMPLE
    
    $key = 'ef1231ea-9a1a-59c2-110a-e123a1231333'
    $secret = 'TvL>UoWKb&HZbdZqDpKja+LdKvLf9TBDm4*Frfhu'

    $newAccount = New-ShiftboardAccount -AccessKey $key -SignatureKey $secret -FirstName "Test" -LastName "Account" -Email "test@domain.com" -ExternalId "999999" -TimeZone 'Central'

    # Creates new Shiftboard Account named "Test Account"

    

#>
function New-ShiftboardAccount
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
        [Parameter(Mandatory=$true)][ValidateSet("Eastern", "Central", "Mountain", "Pacific")][string]$TimeZone,
        [Parameter(Mandatory=$false)][datetime]$StartDate
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
        timezone = $tzString
    }

    if ($PSBoundParameters.Keys -contains "StartDate")
    {
        $params += @{start_date = $StartDate.ToString("yyyy-MM-dd")}
    }

    $paramsJson = $params | ConvertTo-Json

    $method = 'account.create'

    $response = Invoke-ShiftboardApi -AccessKey $AccessKey -SignatureKey $SignatureKey -ShiftboardMethod $method -ParameterString $paramsJson

    return $response.result
}

