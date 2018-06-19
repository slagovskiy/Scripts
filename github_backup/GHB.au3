#include "WinHttp.au3"
#Include "Json.au3"


Main()

Func Main()
   Local $username = ""
   Local $gitpath
   Local $rarpath
   Local $url = ""
   Local $name = ""
   Local $rawjson = ""
   Local $json
   Local $i = 0

   DirCreate(@ScriptDir & "/repos")

   $username = IniRead(@ScriptDir  & "/config.ini", "github", "username", "")
   $gitpath = IniRead(@ScriptDir  & "/config.ini", "git", "path", "")
   $rarpath = IniRead(@ScriptDir  & "/config.ini", "rar", "path", "")

   $url = "https://api.github.com/users/" & $username & "/repos"

   $rawjson = HttpGet($url)
   $json = Json_Decode($rawjson)

   While 1
	  FileChangeDir(@ScriptDir & "/repos/")
	  $url = Json_Get($json, '[' & String($i) & '].html_url')
	  $name = Json_Get($json, '[' & String($i) & '].name')
	  if ($url == "") Then ExitLoop
	  RunWait($gitpath & " clone " & $url)
	  FileChangeDir(@ScriptDir & "/repos/" & $name)
	  RunWait($gitpath & " pull ")
	  $i = $i + 1
   WEnd

EndFunc