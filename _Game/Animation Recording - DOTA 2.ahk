
setdelay := 250

+`::suspend
!`::reload

return


$*~^+1::setdelay := 40
$*~^+2::setdelay := 80
$*~^+3::setdelay := 120
$*~^+4::setdelay := 200
$*~^+5::setdelay := 400

$\::MouseMv(5, 200, setdelay)
$]::MouseMv(5, 200, setdelay)
$[::MouseMv(5, -200, setdelay)
$'::MouseDetour(20, 5, setdelay)

$/::HeroMove(20, 0, 200)


MouseMv(Cl, Off, Delay){
	sleep 20
	click 683 341 0
	sleep 20
	click %off% 0 0 Rel
	loop %cl% {
		sleep %delay%
		send {Space}
	}
}

HeroMove(Cl, Off, Delay){
	sleep 20
	loop %cl% {
		click 683 0 0
		sleep 20
		click 683 341 0
		sleep 20
		click 0 %off% 0 Rel
		send {RButton}
		sleep %delay%
	}
}

MouseDetour(Cl, Off, Delay){
	loop %cl% {
		MouseMv(1, Off, Delay)
		MouseMv(1, -Off, Delay)
	}
}