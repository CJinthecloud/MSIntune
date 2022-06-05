  if (Test-Path 'HKLM:\HKEY_LOCAL_MACHINE\SOFTWARE\BackupBitLocker') {
        Write-Output 'Registry Path Exists'
    } else {
        Write-Output 'Registry Path does not exist, Creating...'
        New-Item 'HKLM:\SOFTWARE\BackupBitLocker' -Force | Out-Null
    }

$BLinfo = Get-Bitlockervolume

if($BLinfo.MountPoint -eq  $env:SystemDrive -and $blinfo.ProtectionStatus -eq 'On'-and $blinfo.EncryptionPercentage -eq '100'){
 ##   write-output "'$env:computername - '$($blinfo.MountPoint)' is encrypted"
    $CProtectors = (Get-BitlockerVolume -MountPoint  $env:SystemDrive).KeyProtector 
    $CRecoveryProtector = ($CProtectors | where-object { $_.KeyProtectorType -eq "RecoveryPassword" })
    $CResult = BackupToAAD-BitLockerKeyProtector -MountPoint $env:SystemDrive -KeyProtectorId $CRecoveryProtector.KeyProtectorID
    #Set-RegistryKey -Key 'Computer\HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\FVE' -Name 'OSAADBackup' -Type 'Dword' -Value '1'
    New-ItemProperty -Path 'HKLM:\SOFTWARE\BackupBitLocker' -Name "C:2AAD" -Value 1 -Force | Out-Null
    #Write-Log -Message "OS drive BitLocker key uploaded to Azure AD"
}else{
    #Write-Log -Message "No encryption in C: drive"
    New-ItemProperty -Path 'HKLM:\SOFTWARE\BackupBitLocker' -Name "C:2AAD" -Value 0 -Force | Out-Null
}

if($BLinfo.MountPoint -eq 'D:' -and $blinfo.ProtectionStatus -eq 'On'-and $blinfo.EncryptionPercentage -eq '100'){
    $DProtectors = (Get-BitlockerVolume -MountPoint D:).KeyProtector 
    $DRecoveryProtector = ($DProtectors | where-object { $_.KeyProtectorType -eq "RecoveryPassword" })
    $DResult = BackupToAAD-BitLockerKeyProtector -MountPoint "D:" -KeyProtectorId $DRecoveryProtector.KeyProtectorID
    #Set-RegistryKey -Key 'Computer\HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\FVE' -Name 'FDVAADBackup' -Type 'Dword' -Value '1'
    New-ItemProperty -Path 'HKLM:\SOFTWARE\BackupBitLocker' -Name "D:2AAD" -Value 1 -Force | Out-Null
    #Write-Log -Message "D: drive Bitlocker key uploaded to Azure AD"
    return $true
}else{
   #Write-Log -Message "No encryption in D: drive"
   New-ItemProperty -Path 'HKLM:\SOFTWARE\BackupBitLocker' -Name "D:2AAD" -Value 0 -Force | Out-Null
}
