# PS-Shiftboard
Powershell functions for working Shiftboard.com JSON-RPC 2.0 API

Shiftboard API documentation: https://www.shiftdata.com/

&nbsp;
&nbsp;
### Installation

Download source and copy to a valid module directory. i.e. `C:\Program Files\WindowsPowerShell\Modules\`

From Powershell, import module

    Import-Module PS-Shiftboard
    
&nbsp;
&nbsp;
### Prerequisites

To view your API credentials: Login > Admin > Cog Icon > General Settings > API Configuration
    
    # replace these variables with your API keys
    $key = 'ef1231ea-9a1a-59c2-110a-e123a1231333' 
    $secret = 'TvL>UoWKb&HZbdZqDpKja+LdKvLf9TBDm4*Frfhu'



&nbsp;
&nbsp;
### Invoke API directly

Returns first 10 user accounts from Shiftboard account

    $method = 'account.list'
    $params =  '{}'

    Invoke-ShiftboardApi -AccessKey $key -SignatureKey $secret -ShiftboardMethod $method -ParameterString $params


Creates new user named "Test User"

    $method = 'account.create'

    $newUser = @{
        "first_name" = "Test"
        "last_name" = "User"
        "screen_name" = "Test User"
        "email" = "test@domain.com"
        "external_id" = "123456"
    }
    $params = $newUser | ConvertTo-Json

    Invoke-ShiftboardApi -AccessKey $key -SignatureKey $secret -ShiftboardMethod $method -ParameterString $params
    
    
&nbsp;
&nbsp;
### Helper function examples


&nbsp;
#### Accounts (Users)

Get Shiftboard user account

    Get-ShiftboardAccount -AccessKey $key -SignatureKey $secret -Email "jdoe@domain.com"


Create new Shiftboard user account

    New-ShiftboardAccount -AccessKey $key -SignatureKey $secret -FirstName "Test" -LastName "Account" -Email "test@domain.com" -ExternalId "999999" -TimeZone 'Central'


&nbsp;
#### Workgroups (Teams)

Get a workgroup's members

    Get-ShiftboardWorkgroupMember -AccessKey $key -SignatureKey $secret -WorkgroupId "123456"


Adds account to a workgroup

    Add-ShiftboardWorkgroupMember -AccessKey $key -SignatureKey $secret -WorkgroupId "123456" -AccountId "999" -Level Member

&nbsp;
#### Time Off Requests

Create new time off request

    New-ShiftboardTimeOffRequest -AccessKey $key -SignatureKey $secret -AccountId '123456' -Type: 'All Day' -Status: Approved -StartDate '2019-12-25' -WorkgroupId "98765" -Paid: $true -Category 4
    
    
    
