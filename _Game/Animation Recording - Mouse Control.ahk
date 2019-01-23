
setdelay := 800

+`::suspend
!`::reload

return


$*~^+1::setdelay := 40
$*~^+2::setdelay := 80
$*~^+3::setdelay := 120
$*~^+4::setdelay := 200
$*~^+5::setdelay := 400
$*~^+6::setdelay := 800
$*~^+7::setdelay := 1200

$\::MousePan(100, 2, setdelay)
$]::MousePan(15, 200, setdelay)
$[::MousePan(15, -200, setdelay)
$'::click 688 426 right


MousePan(Cl, Off, Delay){
SetMouseDelay, -1
sleep 400
send {Alt down}
hFinal := 683 + off
sleep 1000
loop %cl% {
	;click %off% 0 0 Rel
	click %hFinal% 384 0
	sleep %delay%
}
send {Alt up}
}

MouseDetour(Cl, Off, Delay){
SetMouseDelay, -1
total := -1 * Cl * Off
sleep 400
loop %cl% {
	mousemove, %off%, 0, 0, R
	sleep %delay%
}
mousemove, %total%, 0, 0, R
}