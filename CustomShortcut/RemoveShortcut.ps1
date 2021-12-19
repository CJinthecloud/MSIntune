<#
.SYNOPSIS
    This script will remove the shortcut
.DESCRIPTION
    This script use to delete the shortcut which created from CreateCustomShortcut.ps1 
.NOTES
    File name: RemoveShortcut.ps1
    VERSION: 2021a
    AUTHOR: Chang Chia Jian
    Created:  2021-12-19
    Licensed under the MIT license.
    Please credit me if you fint this script useful and do some cool things with it.
.VERSION HISTORY:
    1.0.0 - (2021-12-19) Script created
#>

Remove-Item C:\Users\Public\Desktop\SharePoint.lnk
Remove-Item C:\Users\Public\Pictures\SPOicon.ico
