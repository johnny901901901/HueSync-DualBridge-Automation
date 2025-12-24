Set WshShell = CreateObject("WScript.Shell")

' Path must match your .bat location exactly
WshShell.Run chr(34) & "C:\Scripts\HueDualLaunch.bat" & chr(34), 0, False

Set WshShell = Nothing
