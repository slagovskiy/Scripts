While 1
   $hRMS = WinGetHandle("������� Yes") ;�������� ���������� ���� � ��������
   $hWnd = WinGetHandle("[ACTIVE]") ;�������� ������� �������� ����
   If $hWnd<>0 and ($hRMS="")  Then
      WinSetOnTop($hWnd, "", 1) ;������ �������� �������� ���� ������ ��������� (����� ������ ���� � ��������)
   EndIf
      If $hRMS<>"" Then
      ControlClick($hRMS, "", "[CLASS:Button;INSTANCE:1]") ;���� ���� ���������, �� ���������� �������� "��" � ������� �� �����...
   EndIf
   Sleep(5000)
WEnd