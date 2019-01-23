^`::suspend
return
----------------------------------------------------


----------------------------------------------------


$*\::
Loop 8
{
	Loop 20
	{
		
		send {Enter}
		;send {Enter up} down
		sleep 0
	}
	send {down}
}
return



$*Enter::
Loop 200
{
    GetKeyState, state, Enter, P
    if state = U
		break
	send {Enter}
	;send {Enter up} down
	sleep 2
}
return