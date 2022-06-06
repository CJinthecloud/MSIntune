######################################################################################################################################
###
### Name:           : UltimateEscrowBitLockerKey.ps1
### Created by      : Chang Chia Jian
### Created on      : 06/06/2022
### Latest Version  : 0.1
### Version History : 0.1 First version of the script                   
###
######################################################################################################################################

if (Test-Path 'HKLM:\HKEY_LOCAL_MACHINE\SOFTWARE\BackupBitLocker') {
        Write-Output 'Registry Path Exists'
    } else {
        Write-Output 'Registry Path does not exist, Creating...'
        New-Item 'HKLM:\SOFTWARE\BackupBitLocker' -Force | Out-Null
    }

$BitLockerVolume = Get-BitLockerVolume  -ErrorAction Stop | where {$_.ProtectionStatus -eq "On"} | where {$_.EncryptionPercentage -eq '100'}

if($BitLockerVolume){
    New-ItemProperty -Path 'HKLM:\SOFTWARE\BackupBitLocker' -Name "BitLockerDrive" -Value 1 -Force | Out-Null
    #Write-Host "true, backup key now..."
    $DriveLetter = $BitLockerVolume.MountPoint
    $a = $DriveLetter.Split(" ")
    $i = 0
    $a.ForEach({
    #Write-Host "this is" $a[$i] "Drive"
        $MP = $a[$i]
        $Protectors = (Get-BitlockerVolume -MountPoint  $MP).KeyProtector 
        $RecoveryPw = ($Protectors | where-object { $_.KeyProtectorType -eq "RecoveryPassword" })
        $Escrow2AAD = BackupToAAD-BitLockerKeyProtector -MountPoint $MP -KeyProtectorId $RecoveryPw.KeyProtectorID
        New-ItemProperty -Path 'HKLM:\SOFTWARE\BackupBitLocker' -Name $MP -Value 1 -Force | Out-Null
        $i++})
    }else{
    #Write-Host "No bitlockerdrive, exit 0"
    New-ItemProperty -Path 'HKLM:\SOFTWARE\BackupBitLocker' -Name "BitLockerDrive" -Value 0 -Force | Out-Null
    }
    
    
