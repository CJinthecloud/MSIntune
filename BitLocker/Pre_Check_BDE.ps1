######################################################################################################################################
###
### Name:           : UltimateEscrowBitLockerKey.ps1
### Created by      : Chang Chia Jian
### Created on      : 06/06/2022
### Latest Version  : 0.1
### Version History : 0.1 First version of the script                   
###
######################################################################################################################################
 
 
$BitLockerVolume = Get-BitLockerVolume  -ErrorAction Stop | where {$_.ProtectionStatus -ne "off"} | where {$_.AutoUnlockEnabled -ne $null}
if($BitLockerVolume){
        return 1
    }else{
        return 2
    }
