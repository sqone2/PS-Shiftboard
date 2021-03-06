﻿<#
.SYNOPSIS
    
    Function used communicate with the Shiftboard.com JSON-RPC 2.0 API
 
.PARAMETER AccessKey
 
    API Access Key from Shiftboard account
    To view key, login > Admin > Cog Icon > General Settings > API Configuration

.PARAMETER SignatureKey
 
    Signature Key from Shiftboard account
    To view key, login > Admin > Cog Icon > General Settings > API Configuration


.PARAMETER ShiftboardMethod

    Method specified in Shiftboard documentation. Format is <object>.<action>  i.e. account.create


.PARAMETER ParameterString

    JSON string that specifies the parameters passed to Shiftboard API. Use '{}' if no parameters need to be passed


.PARAMETER  HttpMethod

    Specifies the http method used for the web request. Default is GET
    Shiftboard documentation: "At this time, only GET requests are supported (except for batch requests, which use POST)"
    

.EXAMPLE
    
    $key = 'ef1231ea-9a1a-59c2-110a-e123a1231333'
    $secret = 'TvL>UoWKb&HZbdZqDpKja+LdKvLf9TBDm4*Frfhu'
    $method = 'account.list'
    $params =  '{}'

    $result = Invoke-ShiftboardApi -AccessKey $key -SignatureKey $secret -ShiftboardMethod $method -ParameterString $params

    # Returns first 10 user accounts from Shiftboard account


.EXAMPLE
    
    $key = 'ef1231ea-9a1a-59c2-110a-e123a1231333'
    $secret = 'TvL>UoWKb&HZbdZqDpKja+LdKvLf9TBDm4*Frfhu'
    $method = 'account.list'
    $params =  @{
        page = @{
            "batch" = 1000
        }
    }

    $paramsJson = $params | ConvertTo-Json

    $result = Invoke-ShiftboardApi -AccessKey $key -SignatureKey $secret -ShiftboardMethod $method -ParameterString $paramsJson

    # Returns first 1000 user accounts from Shiftboard account
    

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

    $result = Invoke-ShiftboardApi -AccessKey $key -SignatureKey $secret -ShiftboardMethod $method -ParameterString $params

    # Creates new user named "Test User". Other relevant properties can be added to the $newUser HashTable as needed.
    
 
#>
function Invoke-ShiftboardApi
{
    [CmdletBinding(PositionalBinding=$false)]
    param
    (
        [Parameter(Mandatory=$true)][string]$AccessKey,
        [Parameter(Mandatory=$true)][string]$SignatureKey,
        [Parameter(Mandatory=$true)][string]$ShiftboardMethod,
        [Parameter(Mandatory=$true)][string]$ParameterString,
        [Parameter(Mandatory=$false)][ValidateSet("GET", "POST")][string]$HttpMethod = "GET"
    )


    # these values should not change
    $baseUrl = 'https://api.shiftdata.com/api/api.cgi'
    $jsonRPCString = "jsonrpc=2.0";


    #### Step 1. Create base64 hash of apiSecret, parameters, and method

    # combine method and parameters into "methodString". Turn methodString into bytes
    $shiftboardMethodString = "method" + $shiftboardMethod + "params" + $ParameterString
    $shiftboardMethodStringBytes = [System.Text.Encoding]::UTF8.GetBytes($shiftboardMethodString)

    # encode apiSecret
    $signatureKeyBytes = [System.Text.Encoding]::UTF8.GetBytes($signatureKey)
    $encodedSecret = [System.Security.Cryptography.HMACSHA1]::new($signatureKeyBytes)

    # combine method string and apiSecret into hash and convert to base64
    $combinedHash = $encodedSecret.ComputeHash($shiftboardMethodStringBytes)
    $combinedBase64 = [System.Convert]::ToBase64String($combinedHash)


    #### Step 2. Encode parameters

    # encode parameters
    $paramBytes = [System.Text.Encoding]::UTF8.GetBytes($ParameterString)
    $encodedParams = [System.Convert]::ToBase64String($paramBytes)



    #### Step 3. Create URL


    $uri = "$($baseUrl)?$($jsonRPCString)&method=$($ShiftboardMethod)&params=$($encodedParams)&access_key_id=$($AccessKey)&signature=$($combinedBase64)"


    #### Step 4. Call API

    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

    $response = Invoke-RestMethod  -Uri $uri -Method $HttpMethod -UseBasicParsing: $true


    if ($response.error -ne $null)
    {
        throw "Error $($response.error.code) / $($response.error.data.code) - $($response.error.data.message)"
    }

    return $response

}

