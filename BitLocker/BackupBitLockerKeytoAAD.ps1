$BLinfo = Get-Bitlockervolume

if($BLinfo.MountPoint -eq  $env:SystemDrive -and $blinfo.ProtectionStatus -eq 'On'-and $blinfo.EncryptionPercentage -eq '100'){
 ##   write-output "'$env:computername - '$($blinfo.MountPoint)' is encrypted"
    $CProtectors = (Get-BitlockerVolume -MountPoint  $env:SystemDrive).KeyProtector 
    $CRecoveryProtector = ($CProtectors | where-object { $_.KeyProtectorType -eq "RecoveryPassword" })
    $CResult = BackupToAAD-BitLockerKeyProtector -MountPoint $env:SystemDrive -KeyProtectorId $CRecoveryProtector.KeyProtectorID
    Set-RegistryKey -Key 'Computer\HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\FVE' -Name 'OSAADBackup' -Type 'Dword' -Value '1'
    Write-Log -Message "OS drive BitLocker key uploaded to Azure AD"
}else{
    Write-Log -Message "No encryption in C: drive"
}

if($BLinfo.MountPoint -eq 'D:' -and $blinfo.ProtectionStatus -eq 'On'-and $blinfo.EncryptionPercentage -eq '100'){
    $DProtectors = (Get-BitlockerVolume -MountPoint D:).KeyProtector 
    $DRecoveryProtector = ($DProtectors | where-object { $_.KeyProtectorType -eq "RecoveryPassword" })
    $DResult = BackupToAAD-BitLockerKeyProtector -MountPoint "D:" -KeyProtectorId $DRecoveryProtector.KeyProtectorID
    Set-RegistryKey -Key 'Computer\HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\FVE' -Name 'FDVAADBackup' -Type 'Dword' -Value '1'
    Write-Log -Message "D: drive Bitlocker key uploaded to Azure AD"
    return $true
}else{
   Write-Log -Message "No encryption in D: drive"
}