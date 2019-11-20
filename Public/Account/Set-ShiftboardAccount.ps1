<#
.SYNOPSIS
    
    Function used to update an Account in Shiftboard
 
.PARAMETER AccessKey
 
    API Access Key from Shiftboard account
    To view key, login > Admin > Cog Icon > General Settings > API Configuration

.PARAMETER SignatureKey
 
    Signature Key from Shiftboard account
    To view key, login > Admin > Cog Icon > General Settings > API Configuration

.PARAMETER Id 

    Id of user to be modified

.PARAMETER Enabled 

    True = User is changed to "Good standing" in Shiftboard (Enabled)
    False = User is changed to "Admin Hold" in Shiftboard (Disabled)

.EXAMPLE
    
    $key = 'ef1231ea-9a1a-59c2-110a-e123a1231333'
    $secret = 'TvL>UoWKb&HZbdZqDpKja+LdKvLf9TBDm4*Frfhu'

    $result = Set-ShiftboardAccount -AccessKey $key -Id '123456' -Enabled $false

    # Disables Shiftboard user with Id "123456"


.EXAMPLE
    
    $key = 'ef1231ea-9a1a-59c2-110a-e123a1231333'
    $secret = 'TvL>UoWKb&HZbdZqDpKja+LdKvLf9TBDm4*Frfhu'

    $result = Set-ShiftboardAccount -AccessKey $key -Id '123456' -FirstName "Rick" -ExternalId "9595" -StartDate "2019-05-20"

    # Modifies values on user with Id "123456"
    

#>
function Set-ShiftboardAccount
{
    [CmdletBinding(PositionalBinding=$false)]
    param
    (
        [Parameter(Mandatory=$true)][string]$AccessKey,
        [Parameter(Mandatory=$true)][string]$SignatureKey,
        [Parameter(Mandatory=$true)][string]$Id,
        [Parameter(Mandatory=$false)][bool]$Enabled,
        [Parameter(Mandatory=$false)][string]$FirstName,
        [Parameter(Mandatory=$false)][string]$LastName,
        [Parameter(Mandatory=$false)][string]$Email,
        [Parameter(Mandatory=$false)][string]$ExternalId,
        [Parameter(Mandatory=$false)][ValidateSet("Eastern", "Central", "Mountain", "Pacific")][string]$TimeZone,
        [Parameter(Mandatory=$false)][datetime]$StartDate
    )

    $params = @{id = $Id}

    if ($PSBoundParameters.Keys -contains "TimeZone")
    {
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

        $params += @{timezone = $tzString}
    }

    if ($PSBoundParameters.Keys -contains "Enabled")
    {
        
        if ($Enabled -eq $false)
        {
            # disable user
            $params += @{org_hold = $true}
        }
        elseif ($Enabled -eq $true)
        {
            # enable user
            $params += @{org_hold = $false}
        }
        
    }

    if ($PSBoundParameters.Keys -contains "FirstName")
    {
        $params += @{first_name = $FirstName}
    }

    if ($PSBoundParameters.Keys -contains "LastName")
    {
        $params += @{last_name = $LastName}
    }

    if ($PSBoundParameters.Keys -contains "Email")
    {
        $params += @{email = $Email}
    }

    if ($PSBoundParameters.Keys -contains "ExternalId")
    {
        $params += @{external_id = $ExternalId}
    }

    if ($PSBoundParameters.Keys -contains "StartDate")
    {
        $params += @{start_date = $StartDate.ToString("yyyy-MM-dd")}
    }


    $paramsJson = $params | ConvertTo-Json

    $method = 'account.update'

    $response = Invoke-ShiftboardApi -AccessKey $AccessKey -SignatureKey $SignatureKey -ShiftboardMethod $method -ParameterString $paramsJson

    return $response.result
}

