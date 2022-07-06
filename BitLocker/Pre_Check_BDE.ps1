<#
.SYNOPSIS
    This script is to check the BitLocker drive status
.DESCRIPTION
    This script will detect the BitLocker Drive and define the decision to run escrow BitLocker
.NOTES
    File name: Pre_Check_BDE.ps1
    VERSION: 1.1.0
    AUTHOR: Chang Chia Jian
    Created:  2022-06-15
    Licensed under the MIT license.
    Please credit me if you fint this script useful and do some cool things with it.
.VERSION HISTORY:
    1.0.0 - (2022-06-15) Script created
#>

#Check BitLocker Drive Encryption
$BitLockerVolume = Get-BitLockerVolume  -ErrorAction Stop | where {($_.ProtectionStatus -eq "on") -and ($_.AutoUnlockEnabled -ne "false") -or ($_.AutoUnlockEnabled -eq "true")}
if($BitLockerVolume){
        return 1
    }else{
        return 2
    }


