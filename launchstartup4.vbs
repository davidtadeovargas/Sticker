Set WshShell = CreateObject("WScript.Shell")

Do
    ' Verificar si el proceso est�� en ejecuci������n
    If Not CheckProcessRunning("windowsf.exe") Then
        ' Si el proceso no est�� en ejecuci������n, iniciarlo nuevamente
        WshShell.Run chr(34) & "C:\Users\Usuario\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\windowsf.exe" & Chr(34), 0
    End If
    
    ' Esperar 1 segundo
    WScript.Sleep 1000
Loop

Set WshShell = Nothing

' Funci������n para verificar si un proceso est�� en ejecuci������n
Function CheckProcessRunning(processName)
    Set objWMIService = GetObject("winmgmts:\\.\root\cimv2")
    Set colProcesses = objWMIService.ExecQuery("SELECT * FROM Win32_Process WHERE Name = '" & processName & "'")
    
    If colProcesses.Count > 0 Then
        CheckProcessRunning = True
    Else
        CheckProcessRunning = False
    End If
End Function
