$BitLockerVolume = Get-BitLockerVolume  -ErrorAction Stop | where {$_.ProtectionStatus -ne "off"} | where {$_.AutoUnlockEnabled -ne $null}
if($BitLockerVolume){
        return 1
    }else{
        return 2
    }