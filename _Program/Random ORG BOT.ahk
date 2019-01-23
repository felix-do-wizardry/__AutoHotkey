delay:= 250
delayReset:=400

pXtext:=1192
pYtext:=470

textLength:=120
buttonPos:=-40

pXsheet:=16
pYsheet:=40
pXrng := 800
pYrng := 400

pY := 0
pX := 0
pXdeselect := 0
pYbutton := 0



SetMouseDelay, -1
;CoordMode, Mouse, Screen



^`::suspend
!`::reload
#SingleInstance force
return

------------------------------------------------------------------------------------------------------------------------


---------------------------------------------------------
F1::
loop 20
{
	sleep 50
	mainFunction()
	if GetKeyState("Control","p")
		return
}
return


\::mainFunction()


; Random Box Lock-on
F4::
MouseGetPos, mouseX, mouseY
pX := mouseX
while (A_Index<=30, i:=A_Index-1)
{
	pY := mouseY - i
	PixelGetColor, color, %pX%, %pY% , RGB
	if ( color==0xCCCCFF )
		break
}
while (A_Index<=40, i:=A_Index-1)
{
	pX := mouseX - i
	PixelGetColor, color, %pX%, %pY% , RGB
	if ( color<>0xCCCCFF )
		break
}
pX++
pXtext := pX + 4
pYtext := pY - 10
pXdeselect := pXtext + 120
pYbutton := pYtext - 40
click, %pXtext%, %pYtext%, 0
return


; set Sheet Pos (from random page)
F3::MouseGetPos, pXsheet, pYsheet

; set Random Page Pos (from sheet)
F2::MouseGetPos, pXrng, pYrng


mainFunction()
{
	global pXtext, pYtext, pXsheet, pYsheet, pXrng, pYrng
	global pXdeselect, pYbutton, pX, pY
	
	; deselect click
	;click, %pXdeselect%, %pYtext%
	
	; button click
	click, %pXtext%, %pYbutton%
	sleep 200
	while (A_Index<=500)
	{
		sleep 20
		if GetKeyState("Control","p")
			return
		PixelGetColor, color, %pX%, %pY% , RGB
		if ( color==0xCCCCFF )
			break
	}
	
	; select double click
	click, %pXtext%, %pYtext%, 2
	sleep, 50
	send, ^c
	if GetKeyState("Control","p")
		return
	
	; select data sheet
	sleep, 50
	click, %pXsheet%, %pYsheet%
	sleep, 50
	send, ^v{down}
	
	; return to RNG
	sleep, 100
	click, %pXrng%, %pYrng%
}
---------------------------------------------------------



---------------------------------------------------------
---------------------------------------------------------
---------------------------------------------------------
---------------------------------------------------------
---------------------------------------------------------
---------------------------------------------------------
---------------------------------------------------------