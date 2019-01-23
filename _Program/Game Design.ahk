; GAME DESIGN 101
; Simple "Run-of-the-mill" Match-3 Game (AB Blast Clone)


SetWinDelay, -1
SetBatchLines, -1
#SingleInstance force
#NoEnv
#Include, GDIP\Gdip_All.ahk
Gosub, GdipStartNOW
Gosub, AutoRun
^`::suspend
!`::reload
^!`::exitapp
return


GdipStartNOW:
Width :=1200, Height := 600
{

If !pToken := Gdip_Startup()
{
	MsgBox, 48, gdiplus error!, Gdiplus failed to start. Please ensure you have gdiplus on your system
	ExitApp
}
OnExit, Exit
Gui, Gdip: -Caption +E0x80000 +LastFound +AlwaysOnTop +ToolWindow +OwnDialogs
Gui, Gdip: Show, NA

hwnd1 := WinExist()
hbm := CreateDIBSection(Width, Height)
hdc := CreateCompatibleDC()
obm := SelectObject(hdc, hbm)
G := Gdip_GraphicsFromHDC(hdc)
;Gdip_SetSmoothingMode(G, 4)

return
Exit:
Gdip_Shutdown(pToken)
ExitApp
}

AutoRun:

value := []
valueOff := []
valueSelect := []
pieceCount := 4
boardSize := [8,8]
posAnchor := [34,85]
posSpace :=  [20,20]
posAdj := []
posAdj[0] := [0,1,0,-1]
posAdj[1] := [-1,0,1,0]
mHover := []
mHover[0] := 0
mHover[1] := 0
xy := []
trigger := 0
lastTriggerPoint := 0
valueSelectCount := 0
totalPoint := 0
drawAnchor := [880,0]
slotSize := [40,40]
blockSize := [20,20]
blockSizeScale := [.6,.75]

pBrush := Gdip_BrushCreateSolid(0xffffffff)
pBrushBG := Gdip_BrushCreateSolid(0xaa222222)
pBrushHL0 := Gdip_BrushCreateSolid(0x88ffffff)

pBrushHL := []
pBrushRGB := []
colorHSLA := [24,.92,.53,1]
while (A_Index<=colorHSLA[1],i:=A_Index-1) {
	colorCode := HSL_ToRGB(i * 360/colorHSLA[1],colorHSLA[2],colorHSLA[3])
	colorCode += ( ceil( colorHSLA[4] * 0xff ) - 1 )* 0x1000000
	pBrushRGB[i] := Gdip_BrushCreateSolid(colorCode)
	colorCode := HSL_ToRGB(i * 360/colorHSLA[1],colorHSLA[2]* .5,colorHSLA[3]* 0.6+0.4)
	colorCode += ( ceil( colorHSLA[4] * 0xff * .4 ) - 1 )* 0x1000000
	pBrushHL[i] := Gdip_BrushCreateSolid(colorCode)
}
blockColor := [0,8,16,4,12,20,7,8,9,10,11,12]


; GuiWindow
{
Gui, 2: +AlwaysOnTop
Gui, 2: Font, s12, Source Code Pro

Gui, 2: Add, Edit, w200 ReadOnly vdisplayText2, 0 1 2 3 4 5 6 7
Gui, 2: Add, Edit, r8 w200 ReadOnly vdisplayText, 0 1 2 3 4 5 6 7

Gui, 2: Add, Button, x222 y6  w36 h32 gExecute Default, >>
Gui, 2: Add, Button, x222 y46 w36 h32 gReloadProgram, R
Gui, 2: Add, Button, x222 y86 w36 h32 gExitProgram, X

;Gui, 2: Add, Progress, x11 w260 h20 c0088ff vprogressP, 0

Gui, 2: Show, ,GuiWindow
WinMove, GuiWindow, , 1076, 432
}

Gosub, BoardInitializing
SetTimer, MainPersistentThread, 16

return



MainPersistentThread:
{
CoordMode, Mouse, Screen
guiWinActive := 0
if ( WinActive("GuiWindow") || true ) {
	guiWinActive := 1
	MouseGetPos, mX, mY
	;mHover[0] := round( (mX - posAnchor[1]) / posSpace[1] )
	;mHover[1] := round( (mY - posAnchor[2]) / posSpace[2] )
	
	mX := mX - 83 - drawAnchor[1]
	mY := mY - 99 - drawAnchor[2]
	
	mHover[0] := floor( mX / slotSize[1] )
	mHover[1] := floor( mY / slotSize[2] )
	
	mHoverOutRange := 0
	if ( mHover[0] < 0 || mHover[0] >= boardSize[1] )
		mHoverOutRange := 1
	if ( mHover[1] < 0 || mHover[1] >= boardSize[2] )
		mHoverOutRange := 1
	
	while (A_Index<=boardSize[1], x:=A_Index-1) {
	while (A_Index<=boardSize[2], y:=A_Index-1) {
		valueSelect[x,y] := 0
	}}
	
	valueSelectCount := 0
	
	if ( mHoverOutRange == 1 ) {
		mHover[0] := -1
		mHover[1] := -1
	} else {
		valueSelect[mHover[0],mHover[1]] := 2
		
		rescanCheck := 1
		while ( rescanCheck == 1 && A_Index <= boardSize[1]*boardSize[2]) {
			rescanCheck := 0
			while (A_Index<=boardSize[1], x:=A_Index-1) {
			while (A_Index<=boardSize[2], y:=A_Index-1) {
				if ( valueSelect[x,y] > 1 ) {
					while (A_Index<=4) {
						x1 := x + posAdj[0,A_Index]
						y1 := y + posAdj[1,A_Index]
						if ( x1 < 0 || x1 >= boardSize[1] )
							continue
						if ( y1 < 0 || y1 >= boardSize[2] )
							continue
						if ( value[x1,y1] == value[x,y] && valueSelect[x1,y1] == 0 )
							valueSelect[x1,y1] := 2
					}
					valueSelect[x,y] := 1
					valueSelectCount++
					rescanCheck := 1
				}
			}}
		}
		valueSelect[mHover[0],mHover[1]] := 1
	}
}

if ( trigger == 1 ) {
	if ( valueSelectCount <= 1 )
		trigger := 0
	else {
		lastTriggerPoint := valueSelectCount
		totalPoint += lastTriggerPoint
		while (A_Index<=boardSize[1], x:=A_Index-1) {
		while (A_Index<=boardSize[2], y:=A_Index-1) {
			if ( valueSelect[x,y] > 0 )
				value[x,y] := 0
		}}
	}
}

txt := "point = " totalPoint
GuiControl, 2:, displayText2, %txt%
Gosub, BoardFillEmptySlot
Gosub, DisplayRefresh
trigger := 0
return
}


DisplayRefresh:
{
Gosub, TextDisplayRefresh
Gosub, GdipDisplayRefresh
return
}


GdipDisplayRefresh:
{
Gdip_GraphicsClear(G)
bX := slotSize[1] * boardSize[1]
bY := slotSize[2] * boardSize[2]
Gdip_FillRectangle(G, pBrushBG, drawAnchor[1], drawAnchor[2], bX, bY)
while (A_Index<=boardSize[2], y:=A_Index-1) {
while (A_Index<=boardSize[1], x:=A_Index-1) {
	
	if ( valueSelectCount > 1 && valueSelect[x,y] > 0 ) {
		pX := drawAnchor[1] + x * slotSize[1]
		pY := drawAnchor[2] + y * slotSize[2]
		Gdip_FillRectangle(G, pBrushHL[blockColor[value[x,y]]], pX, pY, slotSize[1], slotSize[2])
	}
	
	bX := round( slotSize[1] * blockSizeScale[valueSelect[x,y]+1] / 2 ) * 2
	bY := round( slotSize[2] * blockSizeScale[valueSelect[x,y]+1] / 2 ) * 2
	
	pX := round( drawAnchor[1] + (x + .5) * slotSize[1] - bX / 2 )
	pY := round( drawAnchor[2] + (y + .5) * slotSize[2] - bY / 2 )
	
	Gdip_FillRectangle(G, pBrushRGB[blockColor[value[x,y]]], pX, pY, bX, bY)
}}
UpdateLayeredWindow(hwnd1, hdc, 83, 99, Width, Height)
return
}


TextDisplayRefresh:
{
txt := ""
while (A_Index<=boardSize[2], y:=A_Index-1) {
	if ( y > 0 )
		txt := txt "`n"
while (A_Index<=boardSize[1], x:=A_Index-1) {
	if ( valueSelect[x,y] > 0 )
		txt := txt ">" value[x,y]
	else 
		txt := txt " " value[x,y]
}}
GuiControl, 2:, displayText, %txt%
return
}

BoardInitializing:
{
while (A_Index<=boardSize[1], x:=A_Index-1) {
while (A_Index<=boardSize[2], y:=A_Index-1) {
	value[x,y] := 0
	Random, rd, 1, pieceCount
	valueOff[x,y] := rd
}}
Gosub, BoardFillEmptySlot
return
}

BoardFillEmptySlot:
{
while (A_Index<=boardSize[1], x:=A_Index-1) {
while (A_Index<=boardSize[2], y:=A_Index-1) {
	if ( value[x,y] <  0 )
		break
	if ( value[x,y] == 0 ) {
		while (A_Index<=y, y1:=y-A_Index)
			value[x,y1+1] := value[x,y1]
		value[x,0] := valueOff[x,0]
		Random, rd, 1, pieceCount
		valueOff[x,0] := rd
	}
}}
return
}



Execute:
Gosub, TextDisplayRefresh
return

ReloadProgram:
reload
ExitProgram:
exitapp



;#IfWinActive GuiWindow
~$LButton::
trigger := 1
return
#If

swap(ByRef a, ByRef b) {
	c := a
	a := b
	b := c
	return 1
}

generateRandomSeed(ByRef v := 0) {
	r := 0
	r += A_DD	* 42
	r += A_Hour	* 62
	r += A_Min	* 761
	r += A_Sec	* -71
	r += A_MSec	* -821
	v := r
	return r
}

HSL_ToRGB( hue=0, sat=1, lum=0.5 ) { ; Function by [VxE]. See > http://www.wikipedia.org/wiki/HSV_color_space
; Converts a hue/sat/lum into a 24-bit RGB color code. Input: 0 <= hue <= 360, 0 <= sat <= 1, 0 <= lum <= 1. 

	Static i24 := 0xFFFFFF, i40 := 0xFFFFFF0000, hx := "0123456789ABCDEF"

; Transform the decimal inputs into 24-bit integers. Integer arithmetic is nice..
	sat := ( sat * i24 ) & i24
	lum := ( lum * i24 ) & i24
	hue := ( hue * 0xB60B60 >> 8 ) & i24 ; conveniently, 360 * 0xB60B60 = 0xFFFFFF00

; Determine the chroma value and put it in the 'sat' var since the saturation value is not used after this.

	sat := lum + Round( sat * ( i24 - Abs( i24 - lum - lum ) ) / 0x1FFFFFE )

; Calculate the base values for red and blue (green's base value is the hue)
	red := hue < 0xAAAAAA ? hue + 0x555555 : hue - 0xAAAAAA
	blu := hue < 0x555555 ? hue + 0xAAAAAA : hue - 0x555555

; Run the blue value through the cases
	If ( blu < 0x2AAAAB )
		blu := sat + 2 * ( i24 - 6 * blu ) * ( lum - sat ) / i24 >> 16
	Else If ( blu < 0x800000 )
		blu := sat >> 16
	Else If ( blu < 0xAAAAAA )
		blu := sat + 2 * ( i24 - 6 * ( 0xAAAAAA - blu ) ) * ( lum - sat ) / i24 >> 16
	Else
		blu := 2 * lum - sat >> 16

; Run the red value through the cases
	If ( red < 0x2AAAAB )
		red := sat + 2 * ( i24 - 6 * red ) * ( lum - sat ) / i24 >> 16
	Else If ( red < 0x800000 )
		red := sat >> 16
	Else If ( red < 0xAAAAAA )
		red := sat + 2 * ( i24 - 6 * ( 0xAAAAAA - red ) ) * ( lum - sat ) / i24 >> 16
	Else
		red := 2 * lum - sat >> 16

; Run the green value through the cases
	If ( hue < 0x2AAAAB )
		hue := sat + 2 * ( i24 - 6 * hue ) * ( lum - sat ) / i24 >> 16
	Else If ( hue < 0x800000 )
		hue := sat >> 16
	Else If ( hue < 0xAAAAAA )
		hue := sat + 2 * ( i24 - 6 * ( 0xAAAAAA - hue ) ) * ( lum - sat ) / i24 >> 16
 	Else
		hue := 2 * lum - sat >> 16

; Return the values in RGB as a hex integer
	Return "0x" SubStr( hx, ( red >> 4 ) + 1, 1 ) SubStr( hx, ( red & 15 ) + 1, 1 )
			. SubStr( hx, ( hue >> 4 ) + 1, 1 ) SubStr( hx, ( hue & 15 ) + 1, 1 )
			. SubStr( hx, ( blu >> 4 ) + 1, 1 ) SubStr( hx, ( blu & 15 ) + 1, 1 )
} ; END - HSL_ToRGB( hue, sat, lum )


