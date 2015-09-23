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

If Len(comp) > 0 Then InventComp(comp)


Sub InventComp(compname)
	Set wmio = GetObject("WinMgmts:{impersonationLevel=impersonate}!\\" & compname & "\Root\CIMV2")
	Set rf = fso.CreateTextFile(DATA_DIR & compname & DATA_EXT, True)

	Dim build
	build = BuildVersion()

	rf.WriteLine "<?xml version=""1.0"" ?>"
	rf.WriteLine "	<info>"

	rf.WriteLine "		<computer>"

	Log "Win32_ComputerSystemProduct", _
		"UUID", "", _
		"���������", _
		"UUID", 3

	Log "Win32_ComputerSystem", _
		"Name,Domain,PrimaryOwnerName,UserName,TotalPhysicalMemory", "", _
		"���������", _
		"������� ���,�����,��������,������� ������������,����� ������ (��)", 3

	rf.WriteLine "		</computer>"

	rf.WriteLine "		<os>"
	Log "Win32_OperatingSystem", _
		"Caption,Version,CSDVersion,Description,RegisteredUser,SerialNumber,Organization,InstallDate", "", _
		"������������ �������", _
		"������������,������,����������,��������,������������������ ������������,�������� �����,�����������,���� ���������", 3
	rf.WriteLine "		</os>"

	rf.WriteLine "		<hardware>"
	rf.WriteLine "			<BaseBoard>"
	Log "Win32_BaseBoard", _
		"Manufacturer,Product,Version,SerialNumber", "", _
		"����������� �����", _
		"�������������,������������,������,�������� �����", 4
	rf.WriteLine "			</BaseBoard>"

	rf.WriteLine "			<BIOS>"
	Log "Win32_BIOS", _
		"Manufacturer,Name,SMBIOSBIOSVersion,SerialNumber", "", _
		"BIOS", _
		"�������������,������������,������,�������� �����", 4
	rf.WriteLine "			</BIOS>"

	rf.WriteLine "			<Processor>"
	Log "Win32_Processor", _
		"Name,Caption,CurrentClockSpeed,ExtClock,L2CacheSize,SocketDesignation,UniqueId", "", _
		"���������", _
		"������������,��������,������� (���),������� FSB (���),������ L2-���� (��),������,UID", 4
	rf.WriteLine "			</Processor>"

	rf.WriteLine "			<Memory>"
	Log "Win32_PhysicalMemory", _
		"Capacity,Speed,DeviceLocator", "", _
		"������ ������", _
		"������ (��),�������,����������", 4
	rf.WriteLine "			</Memory>"

	rf.WriteLine "			<DiskDrive>"
	Log "Win32_DiskDrive", _
		"Model,Size,InterfaceType", "InterfaceType <> 'USB'", _
		"����", _
		"������������,������ (��),���������", 4
	rf.WriteLine "			</DiskDrive>"

	rf.WriteLine "			<LogicalDisk>"
	Log "Win32_LogicalDisk", _
		"Name,FileSystem,Size,FreeSpace,VolumeSerialNumber", "DriveType = 3 AND Size IS NOT NULL", _
		"���������� ����", _
		"������������,�������� �������,������ (��),�������� (��),�������� �����", 4
	rf.WriteLine "			</LogicalDisk>"

	rf.WriteLine "			<CDRomDrive>"
	Log "Win32_CDROMDrive", _
		"Name", "", _
		"CD-������", _
		"������������", 4
	rf.WriteLine "			</CDRomDrive>"

	rf.WriteLine "			<VideoController>"
	If build >= 2600 Then 'Windows xp/2003 and >
		Log "Win32_VideoController", _
			"Name,AdapterRAM,VideoProcessor,VideoModeDescription,DriverDate,DriverVersion", "NOT (Name LIKE '%Secondary')", _
			"���������������", _
			"������������,����� ������ (��),��������������,����� ������,���� ��������,������ ��������", 4
	Else 'Windows 2000
		Log "Win32_VideoController", _
			"Name,AdapterRAM,VideoProcessor,VideoModeDescription,DriverDate,DriverVersion", "", _
			"���������������", _
			"������������,����� ������ (��),��������������,����� ������,���� ��������,������ ��������", 4
	End If
	rf.WriteLine "			</VideoController>"

	rf.WriteLine "			<NetworkAdapter>"
	If build >= 2600 Then 'Windows XP/2003 and >
		Log "Win32_NetworkAdapter", _
		"Name,AdapterType,PermanentAddress,MACAddress", "NetConnectionStatus > 0 AND NOT (Name LIKE 'VMware%')", _
		"������� �������", _
		"������������,���,IP-�����,MAC-�����", 4
	Else 'Windows 2000
		Log "Win32_NetworkAdapter", _
		"Name,PermanentAddress,MACAddress", "", _
		"������� �������", _
		"������������,IP-�����,MAC-�����", 4
	End If
	rf.WriteLine "			</NetworkAdapter>"

	rf.WriteLine "			<SoundDevice>"
	Log "Win32_SoundDevice", _
		"Name", "", _
		"�������� ����������", _
		"������������", 4
	rf.WriteLine "			</SoundDevice>"

	rf.WriteLine "			<SCSIController>"
	Log "Win32_SCSIController", _
		"Name", "", _
		"SCSI ����������", _
		"������������", 4
	rf.WriteLine "			</SCSIController>"

	'Windows XP/2003 and >
	rf.WriteLine "			<Printer>"
	If build >= 2600 Then
		Log "Win32_Printer", _
		"Name,PortName,ShareName", "(Local = True OR Network = False) AND (PortName LIKE '%USB%' OR PortName LIKE '%LPT%')", _
		"�������", _
		"������������,����,������� ���", 4
	End If
	rf.WriteLine "			</Printer>"

	rf.WriteLine "			<PortConnector>"
	Log "Win32_PortConnector", _
		"ExternalReferenceDesignator,InternalReferenceDesignator", "", _
		"������ �����", _
		"�������,����������", 4
	rf.WriteLine "			</PortConnector>"

	rf.WriteLine "			<Keyboard>"
	Log "Win32_Keyboard", _
		"Name,Description", "", _
		"����������", _
		"������������,��������", 4
	rf.WriteLine "			</Keyboard>"

	rf.WriteLine "			<PointingDevice>"	
	Log "Win32_PointingDevice", _
		"Name", "", _
		"����", _
		"������������", 4
	rf.WriteLine "			</PointingDevice>"

	rf.WriteLine "		</hardware>"


	rf.WriteLine "	</info>"
	
	rf.Close
End Sub

msgbox "ok"

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

			ElseIf Right(names(i), 4) = "(��)" Then
				value = CStr(Round(value / 1024 ^ 2))
			ElseIf Right(names(i), 4) = "(��)" Then
				value = CStr(Round(value / 1024 ^ 3))

			ElseIf prop.CIMType = 101 Then
				value = ReadableDate(value)
			End If

			value = Trim(Replace(value, ";", "_"))

			If Len(value) > 0 Then rf.WriteLine tab & "<item name=""" & names(i) & """ value=""" & value & """ num=""" & num & """ />"

		Next

		num = num + 1
	Next

End Sub

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