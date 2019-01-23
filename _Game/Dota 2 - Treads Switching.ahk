;Initializations

SetMouseDelay, -1
TState := 1
FlickTState := 2
LastTState := 1
delay := 40
#SingleInstance force
------------------------------------------------------------------------------------------------------------------------
^`::suspend
!`::reload
------------------------------------------------------------------------------------------------------------------------
;Treads Switching :)
;TREADS: 1-Strength, 2-Intel, 3-Agility

^!`:: TState := 1					;Refresh/Reset to Strength
^!1:: FlickTState := 1
^!2:: FlickTState := 2
^!3:: FlickTState := 3

!1:: Switch(TState, 1)
!2:: Switch(TState, 2)
!3:: Switch(TState, 3)


NumpadDel::
LastTState := TState
Switch(TState, FlickTState)
KeyWait, NumpadDel
Switch(TState, LastTState)
return

------------------------------------------------------------------------------------------------------------------------
Switch(ByRef TState, SwitchTo) {
	Loop 2 {
		if (TState = SwitchTo)
			break
		else {
			send {v}				;Treads Switching Key
			if TState = 3
				TState := 1
			else TState++
		}
		GetKeyState, keystate, esc, P
		if keystate = D
			break
	}
}
------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------
