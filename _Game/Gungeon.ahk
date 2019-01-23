SetMouseDelay, -1
delay := 40
#SingleInstance force

^`::suspend
!`::reload

F4::suspend

;----------------------------------------------------

;Gungeon
;#IfWinActive Enter the Gungeon
#If GetKeyState("CapsLock", "T") = 0 and GetKeyState("Tab", "P") = 0 and WinActive("Enter the Gungeon")

x::LButton
$*LButton::
Loop 200
{
	send {LButton}
	
    GetKeyState, state, LButton, P
    if state = U
		break
	GetKeyState, state, esc, P
    if state = D
		break
	sleep %delay%
    GetKeyState, state, LButton, P
    if state = U
		break
	sleep %delay%
}
return

;$*w::
send {x down}
sleep 1800
send {x up}

return