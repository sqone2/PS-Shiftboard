<#
.SYNOPSIS
    
    Function used communicate with the ShiftBoard.com JSON-RPC 2.0 API
 
.PARAMETER AccessKey
 
    API Access Key from ShiftBoard account
    To view key, login > Admin > Cog Icon > General Settings > API Configuration

.PARAMETER SignatureKey
 
    Signature Key from ShiftBoard account
    To view key, login > Admin > Cog Icon > General Settings > API Configuration


.PARAMETER Id

    Id of ShiftBoard user. Can use ExternalId instead


.PARAMETER Externalid

    ExternalId of ShiftBoard user. Can use Id instead


    
.EXAMPLE
    
    $key = 'ef1231ea-9a1a-59c2-110a-e123a1231333'
    $secret = 'TvL>UoWKb&HZbdZqDpKja+LdKvLf9TBDm4*Frfhu'

    Remove-ShiftboardUser -AccessKey $key -SignatureKey $secret -ExternalId '123456'

    # Removes ShiftBoard user with ExternalId "123456"

    

#>
function Remove-ShiftboardUser
{
    [CmdletBinding(DefaultParametersetName='Id',PositionalBinding=$false)]
    param
    (
        [Parameter(Mandatory=$true)][string]$AccessKey,
        [Parameter(Mandatory=$true)][string]$SignatureKey,

        [Parameter(ParameterSetName='Id',Mandatory=$true)][string]$Id,

        [Parameter(ParameterSetName='ExternalId',Mandatory=$true)][string]$ExternalId,

        [Parameter(Mandatory=$false)][bool]$UnconfirmFutureShifts,
        [Parameter(Mandatory=$false)][bool]$UnpublishFutureShifts,
        [Parameter(Mandatory=$false)][bool]$Notify

    )


    $params = @{}

    if ($PsCmdLet.ParameterSetName -eq "Id")
    {
        $params += @{id = $Id}
    }
    
    if ($PsCmdLet.ParameterSetName -eq "ExternalId")
    {
        $params += @{external_id = $ExternalId}
    }



    if ($PSBoundParameters.Keys -contains "UnconfirmFutureShifts")
    {
        $params += @{unconfirm_future_shifts = $UnconfirmFutureShifts}
    }

    if ($PSBoundParameters.Keys -contains "UnpublishFutureShifts")
    {
        $params += @{unpublish_future_shifts = $UnpublishFutureShifts}
    }

    if ($PSBoundParameters.Keys -contains "Notify")
    {
        $params += @{notify = $Notify}
    }



    $paramsJson = $params | ConvertTo-Json

    $method = 'account.delete'

    $response = Invoke-ShiftboardApi -AccessKey $AccessKey -SignatureKey $SignatureKey -ShiftBoardMethod $method -ParameterString $paramsJson

    return $response.result
}

