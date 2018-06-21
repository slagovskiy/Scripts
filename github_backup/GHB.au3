#include <Crypt.au3>
#include "WinHttp.au3"
#include "Json.au3"
#include "FileEx.au3"


Main()

Func Main()
   Local $username = ""
   Local $gitpath, $rarpath, $gitshow, $rarshow
   Local $url = ""
   Local $name = ""
   Local $rawjson = ""
   Local $json
   Local $i = 0, $j = 0
   Local $filelist, $fileitem, $backuplist, $backupitem
   Local $hash, $hashfile
   Local $onlynew = False, $keep = 0

   DirCreate(@ScriptDir & "\repos\")
   DirCreate(@ScriptDir & "\backup\")

   $username = IniRead(@ScriptDir  & "/config.ini", "github", "username", "")
   $gitpath = IniRead(@ScriptDir  & "/config.ini", "git", "path", "")
   $rarpath = IniRead(@ScriptDir  & "/config.ini", "rar", "path", "")

   If (StringLower(IniRead(@ScriptDir  & "/config.ini", "backup", "only_new", "false")) == "true") Then
	  $onlynew = True
   Else
	  $onlynew = False
   EndIf
;   If (StringLower(IniRead(@ScriptDir  & "/config.ini", "git", "show", "false")) == "false") Then
;	  $gitshow = @SW_HIDE
;   Else
;	  $gitshow = @SW_SHOW
;   EndIf
;   If (StringLower(IniRead(@ScriptDir  & "/config.ini", "rar", "show", "false")) == "false") Then
;	  $rarshow = @SW_HIDE
;   Else
;	  $rarshow = @SW_SHOW
;   EndIf
   $keep = Int(IniRead(@ScriptDir  & "/config.ini", "backup", "keep", "5"))

   $url = "https://api.github.com/users/" & $username & "/repos"

   $rawjson = HttpGet($url)
   $json = Json_Decode($rawjson)

   While 1
	  $j = 0
	  FileChangeDir(@ScriptDir & "\repos\")
	  $url = Json_Get($json, '[' & String($i) & '].html_url')
	  $name = Json_Get($json, '[' & String($i) & '].name')
	  if ($url == "") Then ExitLoop
	  if ($gitpath <> "") Then
		 RunWait($gitpath & " clone " & $url)
		 FileChangeDir(@ScriptDir & "\repos\" & $name)
		 RunWait($gitpath & " pull ");, @WorkingDir, $gitshow)
	  EndIf

	  FileDelete(@ScriptDir & "\repos\" & $name & "_prev.md5")
	  If (FileExists(@ScriptDir & "\repos\" & $name & ".md5")) Then
		 FileMove(@ScriptDir & "\repos\" & $name & ".md5", @ScriptDir & "\repos\" & $name & "_prev.md5")
	  Else
		 $hashfile = FileOpen(@ScriptDir & "\repos\" & $name & "_prev.md5", 2)
		 FileClose($hashfile)
	  EndIf

	  $filelist = _FileListToArrayEx(@ScriptDir & "\repos\" & $name, "*", 1+4)
	  $hashfile = FileOpen(@ScriptDir & "\repos\" & $name & ".md5", 2)
	  For $fileitem In $filelist
		 If ($j > 0) Then
			$hash = _Crypt_HashFile($fileitem, $CALG_MD5)
			FileWriteLine($hashfile, $j & ";" & $fileitem & ";" & $hash)
		 EndIf
		 $j = $j + 1
	  Next
	  FileClose($hashfile)
	  If ((FileRead(@ScriptDir & "\repos\" & $name & "_prev.md5") <> FileRead(@ScriptDir & "\repos\" & $name & ".md5")) Or (Not $onlynew)) Then
		 FileChangeDir(@ScriptDir & "\backup\")
		 RunWait($rarpath & " a -m5 -k -s -rr5 " & $name & "_" & @YEAR & @MON & @MDAY & @HOUR & @MIN & ".rar " & @ScriptDir & "\repos\" & $name);, @WorkingDir, $rarshow)
	  EndIf
	  FileDelete(@ScriptDir & "\repos\" & $name & "_prev.md5")

	  $backuplist = _FileListToArrayEx(@ScriptDir & "\backup\", $name & "_*", 1+4)
	  $j = 0
	  If ($backuplist[0] > $keep) Then
		 MsgBox(0, "", $backuplist[0])
		 For $backupitem In $backuplist
			If (($j > 0) And ($j <= ($backuplist[0] - $keep))) Then
			   FileDelete(@ScriptDir & "\backup\" & $backupitem)
			EndIf
			$j = $j + 1
		 Next
	  EndIf
	  $i = $i + 1
   WEnd

EndFunc