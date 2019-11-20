<#
.SYNOPSIS
    
    Function used create new timeOffRequest object in Shiftboard
 
.PARAMETER AccessKey
 
    API Access Key from Shiftboard account
    To view key, login > Admin > Cog Icon > General Settings > API Configuration

.PARAMETER SignatureKey
 
    Signature Key from Shiftboard account
    To view key, login > Admin > Cog Icon > General Settings > API Configuration


.PARAMETER AccountId

    Id of Shiftboard user. Can also use ExternalId instead of Id

.PARAMETER ExternalId

    External Id of Shiftboard user. Can also use Id instead of ExternalId

.PARAMETER Type

    Type of requets. i.e. "All Day"

.PARAMETER Status

    Request status. i.e. "Approved"

.PARAMETER StartDate

    Day that timeOffRequest begins

.PARAMETER EndDate

    Optional. Date that timeOffRequest ends

.PARAMETER WorkgroupId

    Optional. Workgroup to be associated with timeOffRequest


.PARAMETER Paid

    Whether timeOffRequest is paid time off

.PARAMETER Category

    Integer value of category mapping set in Shiftboard. To get these values, use "Get-ShiftboardTimeOffCategories"

.PARAMETER Summary

    Summary of timeOffRequest


.EXAMPLE
    
    $key = 'ef1231ea-9a1a-59c2-110a-e123a1231333'
    $secret = 'TvL>UoWKb&HZbdZqDpKja+LdKvLf9TBDm4*Frfhu'

    $request = New-ShiftboardTimeOffRequest -AccessKey $key -SignatureKey $secret -AccountId '123456' -Type: 'All Day' -Status: Approved -StartDate '2019-12-25' -WorkgroupId "98765" -Paid: $true -Category 4

    # Creates new timeOffRequest for user with Id "123456"

    
#>
function New-ShiftboardTimeOffRequest
{
    [CmdletBinding(DefaultParametersetName='AccountId',PositionalBinding=$false)]
    param
    (
        [Parameter(Mandatory=$true)][string]$AccessKey,
        [Parameter(Mandatory=$true)][string]$SignatureKey,

        [Parameter(ParameterSetName='AccountId',Mandatory=$true)][string]$AccountId,
        [Parameter(ParameterSetName='ExternalId',Mandatory=$true)][string]$ExternalId,

        [Parameter(Mandatory=$true)][ValidateSet("Start & End Date", "Open Ended", "All Day")][string]$Type,
        [Parameter(Mandatory=$true)][ValidateSet("New", "Approved", "Denied")][string]$Status,
        
        [Parameter(Mandatory=$true)][datetime]$StartDate,
        [Parameter(Mandatory=$false)][datetime]$EndDate,

        [Parameter(Mandatory=$false)][string]$WorkgroupId,
        [Parameter(Mandatory=$false)][bool]$Paid,
        [Parameter(Mandatory=$false)][int]$Category,
        [Parameter(Mandatory=$false)][string]$Summary
        
    )


    $typeCodes = @{
        "Start & End Date" = "3"
        "Open Ended" = "4"
        "All Day" = "5"
    }

    $statusCodes = @{
       New = "0"
       Approved = "2"
       Denied = "3"
    }


    $params = @{
        use_time = $typeCodes[$Type]
        status = $statusCodes[$Status]
        start_date = $StartDate.ToString("yyyy-MM-dd")
    }


    if ($PSBoundParameters.Keys -contains 'AccountId')
    {
        $params += @{member = $AccountId}
    }

    if ($PSBoundParameters.Keys -contains 'ExternalId')
    {
        $params += @{external_member = $ExternalId}
    }

    if ($PSBoundParameters.Keys -contains 'WorkgroupId')
    {
        $params += @{workgroup = $WorkgroupId}
    }

    if ($PSBoundParameters.Keys -contains 'EndDate')
    {
        $params += @{end_date = $EndDate.ToString("yyyy-MM-dd")}
    }

    if ($PSBoundParameters.Keys -contains 'Paid')
    {
        $params += @{paid = $Paid}
    }

    if ($PSBoundParameters.Keys -contains 'Category')
    {
        $params += @{category = [string]$Category}
    }

    if ($PSBoundParameters.Keys -contains 'Summary')
    {
        $params += @{summary = $Summary}
    }


    $paramsJson = $params | ConvertTo-Json

    $method = 'timeOffRequest.create'

    $response = Invoke-ShiftboardApi -AccessKey $AccessKey -SignatureKey $SignatureKey -ShiftboardMethod $method -ParameterString $paramsJson

    return $response.result
}


