;SetMouseDelay, -1
delay := 40


xP := Object()
xP[0]:=200

testA%0% := 400

color := Object()
color[0] := 0xfd0405
color[1] := 0x0b65d7
color[2] := 0x0afe0d
color[3] := 0xfff522
color[4] := 0xfdbf07

X1:=364
Y1:=200		;166
X2:=1000
Y2:=522


^`::suspend
!`::reload

return

------------------------------------------------------------------------------------------------------------------------

#SingleInstance force

;------------------------------------------------------------------------------------------------------------------

;fd0405 - 0-Red
;0b65d7 - 1-Blue
;0afe0d - 2-Green
;fff522 - 3-Yellow
;fdbf07 - 4-Orange

;k-color-shape: 0-Red--, 1-Blue-|, 2-Green-^, 3-Yellow-V, 4-Orange-Z

^1::Draw(0)
^2::Draw(1)
^3::Draw(2)
^4::Draw(3)
^5::Draw(4)


#If (GetKeyState("Scrolllock", "T") = 1)

	;TEST
;\::
testVar:=testA%0%
testVar:=xP[0]
click, %testVar%, 100, 0
return

\::
loop 100
{
		;Get Pos
	n := 0
	loop 5 {
		cTemp := color[n]
		PixelSearch, xTemp, , %X1%, %Y1%, %X2%, %Y2%, cTemp , 1, Fast RGB
		if ( xTemp < 1 )
			xTemp := X2 + 200
		xP[n] := xTemp
		n := n + 1
	}
	
	if (GetKeyState("Escape", "P")=1)
		return
	
		;Calculate
	xMin := xP[0]
	nFound := 0
	n := 1
	loop 4 {
		if ( xMin > xP[n] )
		{
			xMin := xP[n]
			nFound := n
		}
		n := n + 1
	}
	
	Draw(nFound)
	if (GetKeyState("Escape", "P")=1)
		return
	sleep, 400
}
return



;\::
n:=0
loop 100
{
	Draw(n)
	if (GetKeyState("Escape", "P")=1)
		return
	;sleep 250
	n:=n+1
	if (n>4)
		n:=0
}
return

#If

Draw(k)
{
	click 683 356 0
	if (k=0)
	{
		MouseMove, -100, 0, 0, R
		Send, {LButton down}
		MouseMove, 200, 0, 2, R
	}
	
	if (k=1)
	{
		MouseMove, 0, -100, 0, R
		Send, {LButton down}
		MouseMove, 0, 200, 2, R
	}
	
	if (k=2)
	{
		MouseMove, -100, 100, 0, R
		Send, {LButton down}
		MouseMove, 100, -200, 2, R
		MouseMove, 100, 200, 2, R
	}
	
	if (k=3)
	{
		MouseMove, -100, -100, 0, R
		Send, {LButton down}
		MouseMove, 100, 200, 2, R
		MouseMove, 100, -200, 2, R
	}
	
	if (k=4)
	{
		MouseMove, -100, -100, 0, R
		Send, {LButton down}
		MouseMove, 200, 0, 2, R
		MouseMove, -200, 200, 2, R
		MouseMove, 200, 0, 2, R
	}
	
	Send, {LButton up}
	click 683 356 0
}

#If