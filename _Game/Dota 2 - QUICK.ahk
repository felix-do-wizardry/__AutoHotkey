+`::suspend
!`::reload
return

;#IfWinActive DOTA 2
------------------------------------------------------------------------------------------------------------------------
;ABILITY PANIC CAST:

;Ability 1-Q, 2-W, 3-E, 4-R, 5-D, 6-F
;AbilityType:
;0 - Passive / No-Cooldown Toggle Active
;1 - No-Target Active / Non-Zero-Cooldown Toggle Active
;2 - Point-Target Active
;3 - Unit-Target Active
;4 - Unit-Target Active (FOR YOURSELF)

setdelay := 80
spraydelay := 25
sprayoffset := 20

$*~^+1::setdelay := 20
$*~^+2::setdelay := 40
$*~^+3::setdelay := 60
$*~^+4::setdelay := 80
$*~^+5::setdelay := 100

$*~q::PanicCast("Q", 1, setdelay)
$*~w::PanicCast("W", 1, setdelay)
$*~e::PanicCast("E", 1, setdelay)
$*~r::PanicCast("R", 1, setdelay)
$*~d::PanicCast("D", 1, setdelay)
$*~f::PanicCast("F", 1, setdelay)


$*~Space::PanicCast(14, 1, setdelay)
;$*~c::PanicCast(15, 1, setdelay)
;$*~v::PanicCast(16, 1, setdelay)
$*~f2::PanicCast(11, 1, setdelay)
$*~f3::PanicCast(12, 1, setdelay)
$*~f4::PanicCast(13, 1, setdelay)


$*~^Space::PanicSpray(14, 2, 1, 20)
;$*~1::PanicSpray(11, 2, 20, 16)


PanicCast(Key, Type, Delay){
state := "D"
time  := 1
if (Type = 4){
	time  := 2
}

Loop 500 {
		
	GetKeyState, EscState, esc, P
	GetKeyState, RBState, RButton, P
	GetKeyState, CapsState, Capslock, T
	
	if (Key = "Q" || Key = 1){
		send {q %time%}
		GetKeyState, State, q, P
	}
	if (Key = "W" || Key = 2){
		send {w %time%}
		GetKeyState, State, w, P
	}
	if (Key = "E" || Key = 3){
		send {e %time%}
		GetKeyState, State, e, P
	}
	if (Key = "R" || Key = 4){
		send {r %time%}
		GetKeyState, State, r, P
	}
	if (Key = "D" || Key = 5){
		send {d %time%}
		GetKeyState, State, d, P
	}
	if (Key = "F" || Key = 6){
		send {f %time%}
		GetKeyState, State, f, P
	}
	
	if (Key = 11){
		send {1 %time%}
		GetKeyState, State, f2, P
	}
	if (Key = 12){
		send {2 %time%}
		GetKeyState, State, f3, P
	}
	if (Key = 13){
		send {3 %time%}
		GetKeyState, State, f4, P
	}
	if (Key = 14){
		send {Space %time%}
		GetKeyState, State, Space, P
	}
	if (Key = 15){
		send {c %time%}
		GetKeyState, State, c, P
	}
	if (Key = 16){
		send {v %time%}
		GetKeyState, State, v, P
	}
	
	
	if (Type = 2 || Type = 3)
		send {LButton}
	
	if (state = "U" || RBState = "D" || EscState = "D" || Type = 0)
		break
	
		
	sleep %delay%
}}


;Currently for {Space} ONLY
PanicSpray(Key, Type, Delay, Offset){
SetMouseDelay, -1
stopCheck := 0
;state := "D"

Loop 10 {
MouseGetPos, xPos, yPos
i := 0
Loop 10 {
	
	xOff := 0
	yOff := 0
	
	if (i = 7){
		xOff := -Offset
	}
	if (i = 3){
		xOff := Offset
	}
	if (i = 6 || i = 8){
		xOff := -Offset * 3/4
	}
	if (i = 2 || i = 4){
		xOff := Offset * 3/4
	}
	
	if (i = 1){
		yOff := -Offset
	}
	if (i = 5){
		yOff := Offset
	}
	if (i = 2 || i = 8){
		yOff := -Offset * 3/4
	}
	if (i = 4 || i = 6){
		yOff := Offset * 3/4
	}
	
	xM = %xPos%
	yM = %yPos%
	xM += %xOff%
	yM += %yOff%
	
	
	
	if (Key = 11){
		send {1}
		GetKeyState, State, 1, P
	}
	if (Key = 12){
		send {2}
		GetKeyState, State, 2, P
	}
	if (Key = 13){
		send {3}
		GetKeyState, State, 3, P
	}
	if (Key = 14){
		send {Space}
		GetKeyState, State, Space, P
	}
	
	click %xM% %yM% 1
	
	if (state = "U"){
		click %xPos% %yPos% 0
		stopCheck = 1
		break
	}
	
	i += 1
}
	
	GetKeyState, EscState, esc, P
	if (stopCheck = 1 || EscState = "D")
		break
	
	sleep %Delay%
}}


HorizontalSpray(Delay, Offset){
SetMouseDelay, -1
MouseGetPos, xPos, yPos
xOff := 0
yOff := 0
Loop 10 {
	
	xOff += 20
	
	xM = %xPos%
	yM = %yPos%
	xM += %xOff%
	yM += %yOff%
	
	send {Space}
	click %xM% %yM% 0
	
	i += 1
	sleep %delay%
}}



KeySendAndState(Key, ByRef State, Time){
	if (Key = "Q" || Key = 1){
		send {q %time%}
		GetKeyState, State, q, P
	}
	if (Key = "W" || Key = 2){
		send {w %time%}
		GetKeyState, State, w, P
	}
	if (Key = "E" || Key = 3){
		send {e %time%}
		GetKeyState, State, e, P
	}
	if (Key = "R" || Key = 4){
		send {r %time%}
		GetKeyState, State, r, P
	}
	if (Key = "D" || Key = 5){
		send {d %time%}
		GetKeyState, State, d, P
	}
	if (Key = "F" || Key = 6){
		send {f %time%}
		GetKeyState, State, f, P
	}
}


------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------
;Treads Switching :)
;TREADS: 1-Strength, 2-Intel, 3-Agility

;!`:: TState := 1					;Refresh/Reset to Strength
;!1:: Switch(TState, 1)
;!2:: Switch(TState, 2)
;!3:: Switch(TState, 3)

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

;Item Dropping and Picking
;Item Coordinates X = 1065, 1120, 1175
;Item Coordinates Y = 685, 730
;Middle Coordinates = 683, 344
delay := 20

;$~!Q:: ManaHpTrick(6, 2, 3, 0)
;$~!W:: ManaHpTrick(3, 1, 2, 0)


ManaHpTrick(Activate, Drop0, Drop1, Drop2) {
	
	send x
	sleep %delay%
	send {F1 2}
	
	DropItem(0, Drop0)
	DropItem(1, Drop1)
	DropItem(2, Drop2)

	if Activate = 1
		send x{1 2}
	if Activate = 2
		send x{2 2}
	if Activate = 3
		send x{3 2}
	if Activate = 4
		send x{Space 2}
	if Activate = 5
		send x{c 2}
	if Activate = 6
		send x{v 2}
	
	;sleep %delay%
	
	click 683 344 0
	send x{F1 2}x
	
	if Drop0 > 0
		click right 683 344
	if Drop1 > 0
		click right 653 344
	if Drop2 > 0
		click right 713 344

}

DropItem(DropOrder, DropSlot) {
	
	click 1065 685 0
	if (DropSlot > 0) {
		send x
		if DropSlot = 1
			click down 1065 685
		if DropSlot = 2
			click down 1120 685
		if DropSlot = 3
			click down 1175 685
		if DropSlot = 4
			click down 1065 730
		if DropSlot = 5
			click down 1120 730
		if DropSlot = 6
			click down 1175 730
		
		;sleep %delay%
		
		send x
		if DropOrder = 0
			click up 683 344
		if DropOrder = 1
			click up 653 344
		if DropOrder = 2
			click up 713 344
	}
}

