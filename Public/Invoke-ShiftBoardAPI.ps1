<#
.SYNOPSIS
    
    Function used communicate with the ShiftBoard.com JSON-RPC 2.0 API
 
.PARAMETER AccessKey
 
    API Access Key from ShiftBoard account
    To view key, login > Admin > Cog Icon > General Settings > API Configuration

.PARAMETER SecretKey
 
    Signature Key from ShiftBoard account
    To view key, login > Admin > Cog Icon > General Settings > API Configuration


.PARAMETER  HttpMethod

    Specifies the http method used for the web request. i.e. GET, POST


.PARAMETER ShiftBoardMethod

    Method specified in ShiftBoard documentation. Format is <object>.<action>  i.e. account.create


.PARAMETER ParameterString

    JSON string that specifies the parameters passed to ShiftBoard API. Use '{}' if no parameters need to be passed
    

.EXAMPLE
    
    $key = 'ef1231ea-9a1a-59c2-110a-e123a1231333'
    $secret = 'TvL>UoWKb&HZbdZqDpKja+LdKvLf9TBDm4*Frfhu'
    $method = 'account.list'
    $params =  '{}'

    $result = Invoke-ShiftboardApi -AccessKey $key -SecretKey $secret -HttpMethod: GET -ShiftBoardMethod $method -ParameterString $params

    # Returns all user accounts from ShiftBoard account
    

.EXAMPLE

    $key = 'ef1231ea-9a1a-59c2-110a-e123a1231333'
    $secret = 'TvL>UoWKb&HZbdZqDpKja+LdKvLf9TBDm4*Frfhu'
    $method = 'account.create'

    $newUser = @{
        "first_name" = "Test"
        "last_name" = "User"
        "screen_name" = "Test User"
        "email" = "test@domain.com"
        "external_id" = "123456"
    }
    $params = $newUser | ConvertTo-Json

    $result = Invoke-ShiftboardApi -AccessKey $key -SecretKey $secret -HttpMethod: GET -ShiftBoardMethod $method -ParameterString $params

    # Creates new user named "Test User". Other relevant properties can be added to the $newUser HashTable as needed.
    
 
#>
function Invoke-ShiftboardApi
{
    [CmdletBinding(PositionalBinding=$false)]
    param
    (
        [Parameter(Mandatory=$true)][string]$AccessKey,
        [Parameter(Mandatory=$true)][string]$SecretKey,
        [Parameter(Mandatory=$true)][ValidateSet("GET", "POST", "PUT", "PATCH", "DELETE")][string]$HttpMethod,
        [Parameter(Mandatory=$true)][string]$ShiftBoardMethod,
        [Parameter(Mandatory=$true)][string]$ParameterString
    )


    # these values should not change
    $baseUrl = 'https://api.shiftdata.com/api/api.cgi'
    $jsonRPCString = "jsonrpc=2.0";


    #### Step 1. Create base64 hash of apiSecret, parameters, and method

    # combine method and parameters into "methodString". Turn methodString into bytes
    $ShiftBoardMethodString = "method" + $ShiftBoardMethod + "params" + $ParameterString
    $ShiftBoardMethodStringBytes = [System.Text.Encoding]::UTF8.GetBytes($ShiftBoardMethodString)

    # encode apiSecret
    $SecretKeyBytes = [System.Text.Encoding]::UTF8.GetBytes($SecretKey)
    $encodedSecret = [System.Security.Cryptography.HMACSHA1]::new($SecretKeyBytes);

    # combine method string and apiSecret into hash and convert to base64
    $combinedHash = $encodedSecret.ComputeHash($ShiftBoardMethodStringBytes)
    $combinedBase64 = [System.Convert]::ToBase64String($combinedHash)


    #### Step 2. Encode parameters

    # encode parameters
    $paramBytes = [System.Text.Encoding]::UTF8.GetBytes($ParameterString)
    $encodedParams = [System.Convert]::ToBase64String($paramBytes)



    #### Step 3. Create URL


    $uri = "$($baseUrl)?$($jsonRPCString)&method=$($ShiftBoardMethod)&params=$($encodedParams)&access_key_id=$($AccessKey)&signature=$($combinedBase64)"


    #### Step 4. Call API

    $response = Invoke-RestMethod  -Uri $uri -Method $HttpMethod -UseBasicParsing: $true

    return $response

}

