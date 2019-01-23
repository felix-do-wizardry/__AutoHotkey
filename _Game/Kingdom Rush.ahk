`::suspend
------------------------------------------------------------------------------------------------------------------------

#IfWinActive Adobe Flash Player 10



q::Build(0,0)
w::Build(1,0)
a::Build(0,1)
s::Build(1,1)

Build(xP,yP){
delay := 60
MouseGetPos, x, y
xBuild := x + 40*(2*xP-1)
yBuild := y + 40*(2*yP-1)
yTop := y - 46

click, 1
sleep %delay%
click, %xBuild%, %yBuild%, 1
sleep 5*delay
click, %x%, %y%, 1
sleep %delay%
click, %x%, %yTop%, 1
sleep %delay%
click, %x%, %y%, 1
sleep %delay%
click, %x%, %yTop%, 1
click, %x%, %y%, 0
}


z::Upgrade(0)
x::Upgrade(1)

Upgrade(xP){
delay := 40
MouseGetPos, x, y
xRight := x + 40
xLeft  := x - 40
xUp := x + 40*(2*xP-1)
yUp := y - 40
yTop := y - 46

click, 1
sleep %delay%
click, %xUp%, %yUp%, 1
sleep %delay%
click, %x%, %y%, 1
sleep %delay%
click, %xRight%, %yUp%, 3
sleep %delay%
click, %xLeft%, %yUp%, 3
sleep %delay%
click, %x%, %yTop%, 3
click, %x%, %y%, 0
}

2::
send 2
click, 1

return

c::
loop{
click, 666, 620
sleep 200
GetKeyState, state, c, P
if state = D
	break
}

Space::
MouseGetPos, xpos, ypos
click, 666, 620
click, %xpos%, %ypos%, 0

return

------------------------------------------------------------------------------------------------------------------------

