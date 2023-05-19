Set WshShell = CreateObject("WScript.Shell") 
WshShell.Run chr(34) & "C:\Users\%USERNAME%\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\runme2.bat" & Chr(34), 0
Set WshShell = Nothing