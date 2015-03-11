$s = Get-StorageSubSystem -FriendlyName *Spaces*
$d = Get-PhysicalDisk -CanPool $true
New-StoragePool -FriendlyName Pool1 -StorageSubSystemFriendlyName $s.FriendlyName -PhysicalDisks $d
$p = Get-StoragePool Pool1
Set-ResiliencySetting -StoragePool $p -Name Mirror -NumberofColumnsDefault 2 -NumberOfDataCopiesDefault 2
$p | New-VirtualDisk -FriendlyName Space1 -ResiliencySettingName Mirror –UseMaximumSize
 
$L ="X”
$N = (Get-VirtualDisk -FriendlyName Space1 | Get-Disk).Number 
Set-Disk -Number $N -IsReadOnly 0 
Set-Disk -Number $N -IsOffline 0 
Initialize-Disk -Number $N -PartitionStyle MBR 
New-Partition -DiskNumber $N -DriveLetter $L -UseMaximumSize  
Start-Sleep –Seconds 10
Initialize-Volume -DriveLetter $L -FileSystem NTFS -Confirm:$false

