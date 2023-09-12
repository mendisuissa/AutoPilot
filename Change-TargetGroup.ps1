Connect-MSGraph
Update-MSGraphEnvironment -SchemaVersion "Beta" -Quiet
Connect-MSGraph -Quiet

$Serialnumbers = Get-Content C:\temp\SerialNumbers.txt
$autopilotDevices = Invoke-MSGraphRequest -HttpMethod GET -Url "deviceManagement/windowsAutopilotDeviceIdentities" | Get-MSGraphAllPages
foreach($autopilotDevice in $autopilotDevices)
{
foreach($Serialnumber in $serialnumbers)
{
if($autopilotDevice.serialNumber -eq $Serialnumber)
{
Write-Host "Matched, adding group tag to serial number" + $Serialnumber
$autopilotDevice.groupTag = "TEMP"
$requestBody=
@"
    {
        groupTag: `"$($autopilotDevice.groupTag)`",
    }
"@
Invoke-MSGraphRequest -HttpMethod POST -Content $requestBody -Url "deviceManagement/windowsAutopilotDeviceIdentities/$($autopilotDevice.id)/UpdateDeviceProperties" 
}
else
{
write-host "Skipping Serial Number " + $Serialnumber
}
}
}