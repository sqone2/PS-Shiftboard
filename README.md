# PS-Shiftboard
Functions for working ShiftBoard JSON-RPC 2.0 API

Shiftboard API documentation: https://www.shiftdata.com/

### Installation

Download source and copy to a valid module directory. i.e. C:\Program Files\WindowsPowerShell\Modules\
From Powershell, import module

    Import-Module PS-Shiftboard
    
    
    
    
### Prerequisites

To view your API credentials: Login > Admin > Cog Icon > General Settings > API Configuration

    $key = 'ef1231ea-9a1a-59c2-110a-e123a1231333' 
    $secret = 'TvL>UoWKb&HZbdZqDpKja+LdKvLf9TBDm4*Frfhu'




### Examples


#### Accounts (Users)

Returns Shiftboard user account with email "jdoe@domain.com"


    $result = Get-ShiftboardAccount -AccessKey $key -SignatureKey $secret -Email "jdoe@domain.com"


Create new Shiftboard account named "Test Account"

    New-ShiftboardAccount -AccessKey $key -SignatureKey $secret -FirstName "Test" -LastName "Account" -Email "test@domain.com" -ExternalId "999999" -TimeZone 'Central'


Adds account with id "999" to workgroup with id "123456" with level "member"

    Add-ShiftboardWorkgroupMember -AccessKey $key -SignatureKey $secret -WorkgroupId "123456" -AccountId "999" -Level Member
