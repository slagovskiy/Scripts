#include <String.au3>
#include <Date.au3>
#include <Misc.au3>

$sFilePath = "prom_monitor.log"
Global $oMyError = ObjEvent("AutoIt.Error","MyErrFunc")

If _Singleton("prom_monitor", 1) = 0 Then
   FileWrite($sFilePath, "[" & _NowDate() & " " & _NowTime(5) & "] prom monitor is already running" & @CRLF)
   Exit
EndIf
While 1
   Do
	  $oHTTP = ObjCreate("WinHttp.WinHttpRequest.5.1")
	  $oHTTP.Open("GET", "http://prom-siu.ranepa.ru/")
	  $oHTTP.Send()
	  $oHTTP.WaitForResponse
	  $iResult = $oHTTP.ResponseText
	  if $iResult == "<html><head><title>Error</title></head><body>Ïëîõîé êëþ÷." & @CRLF & "</body></html>" Then
		 FileWrite($sFilePath, "[" & _NowDate() & " " & _NowTime(5) & "] key not found - do restart" & @CRLF)
		 ProcessClose("w3wp.exe")
		 RunWait("net stop w3svc", @SW_HIDE)
		 Sleep(1000)
		 RunWait("net start w3svc", @SW_HIDE)
		 FileWrite($sFilePath, "[" & _NowDate() & " " & _NowTime(5) & "] restart finished" & @CRLF)
	  EndIf
	  Sleep(10000)
   Until True
WEnd


Func MyErrFunc()
   FileWrite($sFilePath, "[" & _NowDate() & " " & _NowTime(5) & "] http request error" & @CRLF)
   SetError(1)
Endfunc