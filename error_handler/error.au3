Global $oMyError = ObjEvent("AutoIt.Error","MyErrFunc")

Func MyErrFunc()
Local $HexNumber
Local $strMsg

$HexNumber = Hex($oMyError.Number, 8)
$strMsg = "Error Number: " & $HexNumber & @CRLF
$strMsg &= "WinDescription: " & $oMyError.WinDescription & @CRLF
$strMsg &= "Script Line: " & $oMyError.ScriptLine & @CRLF
MsgBox(0, "ERROR", $strMsg)
SetError(1)
Endfunc