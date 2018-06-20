#include <Crypt.au3>
#include "WinHttp.au3"
#include "Json.au3"
#include "FileEx.au3"


Main()

Func Main()
   Local $username = ""
   Local $gitpath
   Local $rarpath
   Local $url = ""
   Local $name = ""
   Local $rawjson = ""
   Local $json
   Local $i = 0, $j = 0
   Local $filelist, $fileitem
   Local $hash, $hashfile

   DirCreate(@ScriptDir & "/repos")

   $username = IniRead(@ScriptDir  & "/config.ini", "github", "username", "")
   $gitpath = IniRead(@ScriptDir  & "/config.ini", "git", "path", "")
   $rarpath = IniRead(@ScriptDir  & "/config.ini", "rar", "path", "")

   $url = "https://api.github.com/users/" & $username & "/repos"

   $rawjson = HttpGet($url)
   $json = Json_Decode($rawjson)

   While 1
	  $j = 0
	  FileChangeDir(@ScriptDir & "/repos/")
	  $url = Json_Get($json, '[' & String($i) & '].html_url')
	  $name = Json_Get($json, '[' & String($i) & '].name')
	  if ($url == "") Then ExitLoop
	  if ($gitpath <> "") Then
		 RunWait($gitpath & " clone " & $url)
		 FileChangeDir(@ScriptDir & "/repos/" & $name)
		 RunWait($gitpath & " pull ")
	  EndIf

	  $filelist = _FileListToArrayEx(@ScriptDir & "/repos/" & $name, "*", 1+4+8)
	  $hashfile = FileOpen(@ScriptDir & "/repos/" & $name & ".md5", 2)
	  For $fileitem In $filelist
		 If ($j > 0) Then
			$hash = _Crypt_HashFile($fileitem, $CALG_MD5)
			FileWriteLine($hashfile, $j & ";" & $fileitem & ";" & $hash)
		 EndIf
		 $j = $j + 1
	  Next
	  ;If FileRead("file1.ext") == FileRead("file2.ext") Then
	  $i = $i + 1
   WEnd

EndFunc