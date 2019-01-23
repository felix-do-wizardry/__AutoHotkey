^`::suspend
!`::reload
return

------------------------------------------------------------------------------------------------------------------------
#SingleInstance force
#IfWinActive Shadowrun


delay := 200

$^q::
loop 10 {
	sleep 79
	click
	sleep 40
	click
	sleep 79
	click 50 0 0 Rel
	sleep 79
}
return

$^w::
loop 10 {
	click
	sleep 79
}
return