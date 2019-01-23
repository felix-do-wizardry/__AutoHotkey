`::suspend

----------------------------------------------------


;BASTION
;#IfWinActive Bastion
$*q::
Loop
{
    GetKeyState, state, q, P
    if state = U
		break
	GetKeyState, state, w, P
    if state = D
		break
	send {z down}
	sleep 5
	send {z up}
	send {z down}
	sleep 5
	send {z up}
	send {z down}
	sleep 5
	send {z up}
	send {z down}
	sleep 5
	send {z up}
}
return

$*w::
send {x down}
sleep 1800
send {x up}

return

Loop
{
    GetKeyState, state, w, P
    if state = U
		break
	GetKeyState, state, q, P
    if state = D
		break
	send {x down}
	sleep 5
	send {x up}
	send {x down}
	sleep 5
	send {x up}
	send {x down}
	sleep 5
	send {x up}
	send {x down}
	sleep 5
	send {x up}
}
return


;sleep 900    ;breaker's bow