<#
.SYNOPSIS
    This script is to escrow the BitLocker recovery key to AAD
.DESCRIPTION
    This script will detect and identify the BitLocker Drive and auto escrow to Azure AD
.NOTES
    File name: UltimateEscrowBitLockerKey.ps1
    VERSION: 1.1.0
    AUTHOR: Chang Chia Jian
    Created:  2022-06-10
    Licensed under the MIT license.
    Please credit me if you fint this script useful and do some cool things with it.
.VERSION HISTORY:
    1.0.0 - (2022-06-10) Script created
    1.1.0 - (2022-06-23) Debug the registry key set
#>

$path = "HKLM:\SOFTWARE\Microsoft\BackupBitLocker\"
if (Test-Path -Path $path) {
        write-host "path exists"
    } else {
        New-Item -Path $path -Force
    }

#Check BDE Status
$BitLockerVolume = Get-BitLockerVolume  -ErrorAction Stop | where {$_.ProtectionStatus -eq "on"} | where {$_.AutoUnlockEnabled -ne "false"}

#Split the output into array and loop based on the drive letter
if($BitLockerVolume){
    Set-ItemProperty -Path $path -Name "EncryptedDrive" -Value 1 -Force | Out-Null
    $DriveLetter = $BitLockerVolume.MountPoint
    $a = $DriveLetter.Split(" ")
    $i = 0
    $a.ForEach({
        $MP = $a[$i]
        $Protectors = (Get-BitlockerVolume -MountPoint  $MP).KeyProtector 
        $RecoveryPw = ($Protectors | where-object { $_.KeyProtectorType -eq "RecoveryPassword" })
        $Escrow2AAD = BackupToAAD-BitLockerKeyProtector -MountPoint $MP -KeyProtectorId $RecoveryPw.KeyProtectorID
        Set-ItemProperty -Path $path -Name $MP -Value 1 -Force | Out-Null
        $i++})
    }else{
    Set-ItemProperty -Path $path -Name "EncryptedDrive" -Value 0 -Force | Out-Null
    }   


