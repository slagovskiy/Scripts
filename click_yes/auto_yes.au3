While 1
   $hRMS = WinGetHandle("Нажмите Yes") ;Получаем дискриптор окна с вопросом
   $hWnd = WinGetHandle("[ACTIVE]") ;Получаем текущее активное окно
   If $hWnd<>0 and ($hRMS="")  Then
      WinSetOnTop($hWnd, "", 1) ;Делаем текуущее активное окно поверх остальных (Кроме нашего окна с вопросом)
   EndIf
      If $hRMS<>"" Then
      ControlClick($hRMS, "", "[CLASS:Button;INSTANCE:1]") ;Если окно появилось, то быстренько нажимаем "Да" и выходим из цикла...
   EndIf
   Sleep(5000)
WEnd