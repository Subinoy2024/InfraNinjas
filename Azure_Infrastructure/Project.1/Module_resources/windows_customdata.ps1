Install-WindowsFeature -name Web-Server -IncludeManagementTools
$disk = Get-Disk | Where-Object PartitionStyle -Eq 'RAW'
Initialize-Disk $disk.Number -PartitionStyle MBR -PassThru |
New-Partition -AssignDriveLetter -UseMaximumSize |
Format-Volume -FileSystem NTFS -Confirm:$false
New-Item -Path "D:\IISLogs" -ItemType Directory
Set-ItemProperty "HKLM:\SYSTEM\CurrentControlSet\Services\W3SVC\Parameters" `
-Name "LogFileDirectory" -Value "D:\IISLogs"