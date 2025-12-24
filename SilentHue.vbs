Set WshShell = CreateObject("WScript.Shell")
' Ensure the path below matches your .bat location
WshShell.Run chr(34) & "C:\Scripts\HueDualLaunch.bat" & chr(34), 0, False
Set WshShell = Nothing
