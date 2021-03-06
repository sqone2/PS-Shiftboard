try
{
    $public  = Get-ChildItem -Path "$PSScriptRoot\Public\" -Filter "*.ps1" -Recurse -ErrorAction: SilentlyContinue
}
catch
{
}

try
{
    $private = Get-ChildItem -Path "$PSScriptRoot\Private\" -Filter "*.ps1" -Recurse -ErrorAction: SilentlyContinue
}
catch
{
}

$toImport = @()
$toImport += $public
$toImport += $private

#Dot source the files
foreach ($file in $toImport)
{
    try
    {
        . $file.FullName
    }
    catch
    {
        Write-Error -Message "Failed to import function ""$($file.Name)"" Message: $($_.Exception.Message)"
        continue
    }
}


Export-ModuleMember -Function $public.Basename

