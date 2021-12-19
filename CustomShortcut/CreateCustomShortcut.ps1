<#
.SYNOPSIS
    This function create shortcut with custom icon
.DESCRIPTION
    This script will create shortcut for URL
.NOTES
    File name: *******.ps1
    VERSION: 2021a
    AUTHOR: Chang Chia Jian
    Created:  2021-07-20
    Licensed under the MIT license.
    Please credit me if you fint this script useful and do some cool things with it.
.VERSION HISTORY:
    1.0.0 - (2021-12-19) Script created
#>

$TargetDirectory = "C:\Users\public\Desktop\"
$iconfile = "C:\Users\public\Pictures"

If ((Test-Path "$($TargetDirectory)\SharePoint.lnk") -and (Test-Path "$($iconfile)\SPOicon.ico")) {
  Write-Warning "The file already exists."
  exit 0
}
Else  {
  #Create shortcut link here
  Copy-Item -Path ".\SPOicon.ico" -Destination "C:\Users\public\Pictures" -Recurse -force
  $TargetFile = "https://sharepoint.microsoft.com/" #You can change this to URL, File (UNC) or Folder (UNC)
  $shortcutFile = "C:\Users\Public\Desktop\SharePoint.lnk"
  $WScriptShell = New-Object -ComObject WScript.Shell
  $shortcut = $WScriptShell.CreateShortcut($shortcutFile)
  $shortcut.TargetPath = $TargetFile
  $shortcut.IconLocation = "$($iconfile)\SPOicon.ico"
  $shortcut.Save() 
  Write-Output "file created"
  exit 0
}
