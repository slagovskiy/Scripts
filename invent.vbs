' setup

Const DATA_DIR = "\\zeus\invent$\"
Const DATA_EXT = ".xml"

On Error Resume Next

Dim fso
Dim wmio
Dim rf

Set fso = CreateObject("Scripting.FileSystemObject")

Dim nwo, comp
Set nwo = CreateObject("WScript.Network")
comp = LCase(nwo.ComputerName)

If Len(comp) > 0 Then InventComp(comp)


Sub InventComp(compname)
	Set wmio = GetObject("WinMgmts:{impersonationLevel=impersonate}!\\" & compname & "\Root\CIMV2")
	Set rf = fso.OpenTextFile(DATA_DIR & compname & DATA_EXT, 2, True, -1)

	Dim build
	build = BuildVersion()

	rf.WriteLine "<?xml version=""1.0"" ?>"
	rf.WriteLine "	<info date=""" & NowD & """ time=""" & NowT & """>"

	rf.WriteLine "		<computer>"

	Log "Win32_ComputerSystemProduct", _
		"UUID", "", _
		"Êîìïüþòåð", _
		"UUID", 3

	Log "Win32_ComputerSystem", _
		"Name,Domain,PrimaryOwnerName,UserName,TotalPhysicalMemory", "", _
		"Computer System", _
		"Name,Domain,PrimaryOwnerName,UserName,TotalPhysicalMemory (Mb)", 3

	rf.WriteLine "		</computer>"

	rf.WriteLine "		<os>"
	Log "Win32_OperatingSystem", _
		"Caption,Version,CSDVersion,Description,RegisteredUser,SerialNumber,Organization,InstallDate", "", _
		"Operating System", _
		"Caption,Version,CSDVersion,Description,RegisteredUser,SerialNumber,Organization,InstallDate", 3
	rf.WriteLine "		</os>"

	rf.WriteLine "		<hardware>"
	rf.WriteLine "			<BaseBoard>"
	Log "Win32_BaseBoard", _
		"Manufacturer,Product,Version,SerialNumber", "", _
		"Base Board", _
		"Manufacturer,Product,Version,SerialNumber", 4
	rf.WriteLine "			</BaseBoard>"

	rf.WriteLine "			<BIOS>"
	Log "Win32_BIOS", _
		"Manufacturer,Name,SMBIOSBIOSVersion,SerialNumber", "", _
		"BIOS", _
		"Manufacturer,Name,SMBIOSBIOSVersion,SerialNumber", 4
	rf.WriteLine "			</BIOS>"

	rf.WriteLine "			<Processor>"
	Log "Win32_Processor", _
		"Name,Caption,CurrentClockSpeed,ExtClock,L2CacheSize,SocketDesignation,UniqueId", "", _
		"Processor", _
		"Name,Caption,CurrentClockSpeed (MHz),ExtClock FSB (MHz),L2CacheSize (kb),SocketDesignation,UniqueId", 4
	rf.WriteLine "			</Processor>"

	rf.WriteLine "			<Memory>"
	Log "Win32_PhysicalMemory", _
		"Capacity,Speed,DeviceLocator", "", _
		"Physical Memory", _
		"Capacity (Mb),Speed,DeviceLocator", 4
	rf.WriteLine "			</Memory>"

	rf.WriteLine "			<DiskDrive>"
	Log "Win32_DiskDrive", _
		"Model,Size,InterfaceType", "InterfaceType <> 'USB'", _
		"Disk Drive", _
		"Model,Size (Gb),InterfaceType", 4
	rf.WriteLine "			</DiskDrive>"

	rf.WriteLine "			<LogicalDisk>"
	Log "Win32_LogicalDisk", _
		"Name,FileSystem,Size,FreeSpace,VolumeSerialNumber", "DriveType = 3 AND Size IS NOT NULL", _
		"Logical Disk", _
		"Name,FileSystem,Size (Gb),FreeSpace (Gb),VolumeSerialNumber", 4
	rf.WriteLine "			</LogicalDisk>"

	rf.WriteLine "			<CDRomDrive>"
	Log "Win32_CDROMDrive", _
		"Name", "", _
		"CDROM Drive", _
		"Name", 4
	rf.WriteLine "			</CDRomDrive>"

	rf.WriteLine "			<VideoController>"
	If build >= 2600 Then 'Windows xp/2003 and >
		Log "Win32_VideoController", _
			"Name,AdapterRAM,VideoProcessor,VideoModeDescription,DriverDate,DriverVersion", "NOT (Name LIKE '%Secondary')", _
			"Video Controller", _
			"Name,AdapterRAM (Mb),VideoProcessor,VideoModeDescription,DriverDate,DriverVersion", 4
	Else 'Windows 2000
		Log "Win32_VideoController", _
			"Name,AdapterRAM,VideoProcessor,VideoModeDescription,DriverDate,DriverVersion", "", _
			"Video Controller", _
			"Name,AdapterRAM (Mb),VideoProcessor,VideoModeDescription,DriverDate,DriverVersion", 4
	End If
	rf.WriteLine "			</VideoController>"

	rf.WriteLine "			<NetworkAdapter>"
	If build >= 2600 Then 'Windows XP/2003 and >
		Log "Win32_NetworkAdapter", _
		"Name,AdapterType,PermanentAddress,MACAddress", "NetConnectionStatus > 0 AND NOT (Name LIKE 'VMware%')", _
		"Network Adapter", _
		"Name,AdapterType,PermanentAddress,MACAddress", 4
	Else 'Windows 2000
		Log "Win32_NetworkAdapter", _
		"Name,PermanentAddress,MACAddress", "", _
		"Network Adapter", _
		"Name,PermanentAddress,MACAddress", 4
	End If
	rf.WriteLine "			</NetworkAdapter>"

	rf.WriteLine "			<SoundDevice>"
	Log "Win32_SoundDevice", _
		"Name", "", _
		"Sound Device", _
		"Name", 4
	rf.WriteLine "			</SoundDevice>"

	rf.WriteLine "			<SCSIController>"
	Log "Win32_SCSIController", _
		"Name", "", _
		"SCSI Controller", _
		"Name", 4
	rf.WriteLine "			</SCSIController>"

	'Windows XP/2003 and >
	rf.WriteLine "			<Printer>"
	If build >= 2600 Then
		Log "Win32_Printer", _
		"Name,PortName,ShareName", "(Local = True OR Network = False) AND (PortName LIKE '%USB%' OR PortName LIKE '%LPT%')", _
		"Printer", _
		"Name,PortName,ShareName", 4
	End If
	rf.WriteLine "			</Printer>"

	rf.WriteLine "			<PortConnector>"
	Log "Win32_PortConnector", _
		"ExternalReferenceDesignator,InternalReferenceDesignator", "", _
		"PortConnector", _
		"ExternalReferenceDesignator,InternalReferenceDesignator", 4
	rf.WriteLine "			</PortConnector>"

	rf.WriteLine "			<Keyboard>"
	Log "Win32_Keyboard", _
		"Name,Description", "", _
		"Keyboard", _
		"Name,Description", 4
	rf.WriteLine "			</Keyboard>"

	rf.WriteLine "			<PointingDevice>"	
	Log "Win32_PointingDevice", _
		"Name", "", _
		"PointingDevice", _
		"Name", 4
	rf.WriteLine "			</PointingDevice>"

	rf.WriteLine "		</hardware>"

	rf.WriteLine "		<software>"

	Set wmio = GetObject("WinMgmts:{impersonationLevel=impersonate}!\\" & comp & "\Root\default:StdRegProv")

	Dim s, item
	s = ExtractSoft("SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\")
	rf.WriteLine "			<x32>" & VbCrLf & s & "			</x32>"

	s = ExtractSoft("SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\")
	rf.WriteLine "			<x64>" & VbCrLf & s & "			</x64>"

	rf.WriteLine "		</software>"

	rf.WriteLine "	</info>"

	rf.Close
End Sub

'WQL-query
'from - WMI class
'sel - WMI property through a comma
'where - condition of selection or empty line
'sect - report section
'param - param on report section, through a comma
'deep
Sub Log(from, sel, where, sect, param, deep)

	Const RETURN_IMMEDIATELY = 16
	Const FORWARD_ONLY = 32

	Dim query, cls, item, prop
	query = "Select " & sel & " From " & from

	Dim tab
	For i = 0 To deep
		tab = tab & "	"
	Next

	If Len(where) > 0 Then query = query & " Where " & where
	Set cls = wmio.ExecQuery(query,, RETURN_IMMEDIATELY + FORWARD_ONLY)

	Dim props, names, num, value
	props = Split(sel, ",")
	names = Split(param, ",")

	num = 1 
	For Each item In cls
		For i = 0 To UBound(props)

			Set prop = item.Properties_(props(i))
			value = prop.Value

			If IsNull(value) Then
				value = ""

			ElseIf IsArray(value) Then
				value = Join(value,",")

			ElseIf Right(names(i), 4) = "(Ìá)" Then
				value = CStr(Round(value / 1024 ^ 2))
			ElseIf Right(names(i), 4) = "(Ãá)" Then
				value = CStr(Round(value / 1024 ^ 3))

			ElseIf prop.CIMType = 101 Then
				value = ReadableDate(value)
			End If

			value = Trim(Replace(value, ";", "_"))

			If Len(value) > 0 Then rf.WriteLine tab & "<item name=""" & Replace(names(i), "&", " ") & """ value=""" & Replace(value, "&", " ") & """ num=""" & num & """ />"

		Next

		num = num + 1
	Next

End Sub

Function ExtractSoft(key)
	Const HKLM = &H80000002 'HKEY_LOCAL_MACHINE
	Dim items
	wmio.EnumKey HKLM, key, items
	If IsNull(items) Then
		ExtractSoft = ""
		Exit Function
	End If

	Dim s, item, ok, name, publ, inst, x, prev, u
	s = ""
	For Each item In items

		ok = True
		u = False

		prev = name
		wmio.GetStringValue HKLM, key & item, "DisplayName", name
		If IsNull(name) Or Len(name) = 0 Or name = prev Then
			ok = False
		Else
			name = Replace(name, ";", "_")
			name = Replace(name, """", "'")
		End If

		If ok Then
			wmio.GetStringValue HKLM, key & item, "ParentKeyName", x
			If False Then
				If IsNull(x) Or x <> "OperatingSystem" Then ok = False
			Else
				If Not IsNull(x) And x = "OperatingSystem" Then ok = False
			End If
		End If

		If ok Then
			wmio.GetStringValue HKLM, key & item, "InstallDate", inst
			If IsNull(inst) Or Len(inst) < 8 Then
				inst = "-"
			Else
				inst = Mid(inst, 7, 2) & "." & Mid(inst, 5, 2) & "." & Left(inst, 4)
			End If
		End If

		If ok Then
			wmio.GetStringValue HKLM, key & item, "Publisher", publ
			If IsNull(publ) Or Len(publ) = 0 Then publ = "-"
			publ = Replace(publ, """", "'")
		End If

		If ok Then s = s & "					<item name=""" & Replace(name, "&", " ") & """ publusher=""" & Replace(publ, "&", " ") & """ installdate=""" & inst & """ />" & vbCrLf

	Next

	ExtractSoft = s

End Function


Function BuildVersion()
	Dim cls, item
	Set cls = wmio.ExecQuery("Select BuildVersion From Win32_WMISetting")
	For Each item In cls
		BuildVersion = CInt(Left(item.BuildVersion, 4))
	Next
End Function

Function doPing(addr)
	Dim wmio, ping, p
	Set wmio = GetObject("WinMgmts:{impersonationLevel=impersonate}")
	Set ping = wmio.ExecQuery("SELECT StatusCode FROM Win32_PingStatus WHERE Address = '" & addr & "'")
	For Each p In ping
		If IsNull(p.StatusCode) Then
			Unavailable = True
		Else
			Unavailable = (p.StatusCode <> 0)
		End If
	Next
End Function

Function ReadableDate(str)
	ReadableDate = Mid(str, 7, 2) & "." & Mid(str, 5, 2) & "." & Left(str, 4)
End Function

Function NowD()
    d = AddZero(Day(Now))
    m = AddZero(Month(Now))    
    y = AddZero(Year(Now))
    NowD = d & "/" & m & "/" & y
End Function

Function NowT()
    h = AddZero(Hour(Now))
    m = AddZero(Minute(Now))    
    s = AddZero(Second(Now))
    NowT = h & ":" & m & ":" & s
End Function

Function AddZero(num)
    If(Len(num)=1) Then
        AddZero="0"&num
    Else
        AddZero=num
    End If
End Function