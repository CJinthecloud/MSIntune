<#
.SYNOPSIS
    This function create shortcut with custom icon
.DESCRIPTION
    This script will create shortcut for URL
.NOTES
    File name: *******.ps1
    VERSION: 2022a
    AUTHOR: Chang Chia Jian
    Created:  2022-02-20
    Licensed under the MIT license.
    Please credit me if you fint this script useful and do some cool things with it.
.VERSION HISTORY:
    1.0.0 - (2021-12-19) Script created
#>

$BLinfo = Get-Bitlockervolume

if($BLinfo.MountPoint -eq  $env:SystemDrive -and $blinfo.ProtectionStatus -eq 'On'-and $blinfo.EncryptionPercentage -eq '100'){
 ##   write-output "'$env:computername - '$($blinfo.MountPoint)' is encrypted"
    $CProtectors = (Get-BitlockerVolume -MountPoint  $env:SystemDrive).KeyProtector 
    $CRecoveryProtector = ($CProtectors | where-object { $_.KeyProtectorType -eq "RecoveryPassword" })
    $CResult = BackupToAAD-BitLockerKeyProtector -MountPoint $env:SystemDrive -KeyProtectorId $CRecoveryProtector.KeyProtectorID
    Set-RegistryKey -Key 'Computer\HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\FVE' -Name 'OSAADBackup' -Type 'Dword' -Value '1'
   New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\FVE" -Name "OSAADBackup" -Value ”1”  -PropertyType "Dword"
    #Write-Log -Message "OS drive BitLocker key uploaded to Azure AD"
}else{
New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\FVE" -Name "OSAADBackup" -Value ”0”  -PropertyType "Dword"
    #Write-Log -Message "No encryption in C: drive"
}


