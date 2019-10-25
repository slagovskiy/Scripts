#include "FileEx.au3"

Local $rarpath
Local $i
Local $fileitem, $filelist

$rarpath = "c:\\Program Files\\WinRAR\\WinRAR.exe"

$filelist = _FileListToArrayEx(@ScriptDir, "*.fb2", 1+4)
$i = 0
For $fileitem In $filelist
   if $i > 0 Then
	  ;MsgBox(1, "1", @ScriptDir & "\" & $fileitem)
	  RunWait($rarpath & ' a -afzip "' & @ScriptDir & '\' & $fileitem & '.zip" "' & @ScriptDir & '\' & $fileitem & '"')
   Else
	  MsgBox(0, "fb2 to zip", "Found " & $fileitem & " file(s).")
   EndIf
   $i = $i + 1
Next
MsgBox(0, "fb2 to zip", "Well done!")
