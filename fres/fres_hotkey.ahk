

#SingleInstance force
#MaxHotkeysPerInterval 200
SetTitleMatchMode, 2
if not A_IsAdmin
{
   Run *RunAs "%A_ScriptFullPath%"
}

SetMouseDelay, -1
delay := 20
return



^`::suspend
!`::reload
return

SetToolTip(txt="",delay=1000) {
	ToolTip, %txt%
	SetTimer, ResetToolTip, %delay%
}
ResetToolTip:
SetTimer, ResetToolTip, OFF
ToolTip,
return

MouseIsOver(WinTitle,requireActive=false) {
    MouseGetPos,,, Win
	op := WinExist(WinTitle . " ahk_id " . Win)
	if ( requireActive = true )
		op := WinActive(WinTitle . " ahk_id " . Win)
    return op
}
MouseIsOver_Active(WinTitle) {
    return MouseIsOver(WinTitle,true)
}

; ------------ Chrome Tab Controls
#If MouseIsOver_Active("ahk_exe chrome.exe")
$^s::
; MsgBox, "BLAH"
; SetToolTip("^^")
SendInput, ^{c}^{t}
Sleep, 500
SendInput, ^{v}{Enter}
return



#If



