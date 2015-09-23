' setup

Const DATA_DIR = "data\"
Const DATA_EXT = ".xml"

On Error Resume Next

Dim fso
Dim wmio
Dim rf

Set fso = CreateObject("Scripting.FileSystemObject")

Dim nwo, comp
Set nwo = CreateObject("WScript.Network")
comp = LCase(nwo.ComputerName)

msgbox comp

If Len(comp) > 0 Then InventComp(comp)


Sub InventComp(compname)
	Set wmio = GetObject("WinMgmts:{impersonationLevel=impersonate}!\\" & compname & "\Root\CIMV2")
	Set rf = fso.CreateTextFile(DATA_DIR & compname & DATA_EXT, True)

	Dim build
	build = BuildVersion()

	msgbox build
End Sub

Function BuildVersion()
	Dim cls, item
	Set cls = wmio.ExecQuery("Select BuildVersion From Win32_WMISetting")
	For Each item In cls
		BuildVersion = CInt(Left(item.BuildVersion, 4))
	Next
End Function

