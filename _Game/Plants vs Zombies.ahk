SetMouseDelay, -1
delay := 40
#SingleInstance force

^`::suspend
!`::reload
return

#IfWinActive Plants vs. Zombies

--------------------------
;120 + 60x, 60 (FullScreen)
;70 + 35x, 60

$1::QuickPlant(1)
$2::QuickPlant(2)
$3::QuickPlant(3)
$4::QuickPlant(4)
$5::QuickPlant(5)
$6::QuickPlant(6)
$7::QuickPlant(7)
$8::QuickPlant(8)
$9::QuickPlant(9)
$0::QuickPlant(10)

$q::QuickPlant(6)
$w::QuickPlant(7)
$e::QuickPlant(8)
$r::QuickPlant(9)
$t::QuickPlant(10)

$x::QuickPlant(11)


QuickPlant(Num)
{
	MouseGetPos, xpos, ypos
	PlantXPos := 52 * Num + 50
	PlantYPos := 80
	click, %PlantXPos%, %PlantYPos%, 1
	GetKeyState, keystate, Capslock, T
	if keystate = U
		click, %xpos%, %ypos%, 1
	else
		click, %xpos%, %ypos%, 0
}


----------------------------------------------------
