; gdi+ ahk tutorial 3 written by tic (Tariq Porter)
; Requires Gdip.ahk either in your Lib folder as standard library or using #Include
;
; Tutorial to take make a gui from an existing image on disk
; For the example we will use png as it can handle transparencies. The image will also be halved in size

; ---- CURRENTLY BEING USED FOR MOUSE RADIAL MENU ----

centerRadius := 40
outerRadius := 160
r2d := 57.29578
d2r := 0.01745329252
pX := 0
pY := 0
filePathAni := []
filePathRingAni := []
filePathStatic = %A_ScriptDir%\Mouse OSD PNG\MouseOSD_Static.png

filePathEmpty = %A_ScriptDir%\Mouse OSD PNG\Empty.png
filePathRingStatic = %A_ScriptDir%\Mouse OSD PNG\RingStatic_A.png
filePathSelectionStatic = %A_ScriptDir%\Mouse OSD PNG\SelectionStatic_A.png

while ( A_Index <= 360 , i := A_Index - 1 ) {
	filePath = %A_ScriptDir%\Mouse OSD PNG\MouseOSD_
	if ( i < 100 )
		filePath := filePath "0"
	if ( i < 10 )
		filePath := filePath "0"
	
	filePath := filePath i ".png"
	filePathAni[i] := filePath
}

while ( A_Index <= 121 , i := A_Index - 1 ) {
	filePath = %A_ScriptDir%\Mouse OSD PNG\RingAni_B_
	if ( i < 100 )
		filePath := filePath "0"
	if ( i < 10 )
		filePath := filePath "0"
	filePath := filePath i ".png"
	filePathRingAni[i] := filePath
}



; Initialization
{
#SingleInstance, Force
#NoEnv
SetBatchLines, -1

#Include, Gdip_All.ahk
#Include, High_Precision_Sleep.ahk

If !pToken := Gdip_Startup()
{
	MsgBox, 48, gdiplus error!, Gdiplus failed to start. Please ensure you have gdiplus on your system
	ExitApp
}
OnExit, Exit

Gui, 1: -Caption +E0x80000 +LastFound +AlwaysOnTop +ToolWindow +OwnDialogs
Gui, 1: Show, NA
hwnd1 := WinExist()
}



; Setting Up the Graphics
pBitmap := Gdip_CreateBitmapFromFile(filePathEmpty)
{
If !pBitmap
{
	MsgBox, 48, File loading error!, Could not load the image specified
	ExitApp
}

Width := Gdip_GetImageWidth(pBitmap), Height := Gdip_GetImageHeight(pBitmap)
w := Width
h := Height
hbm := CreateDIBSection(Width, Height)
hdc := CreateCompatibleDC()
obm := SelectObject(hdc, hbm)
G := Gdip_GraphicsFromHDC(hdc)
Gdip_SetInterpolationMode(G, 7)
}



return
pBitmap := Gdip_CreateBitmapFromFile(filePathAni[0])
while ( A_Index <= 360 ) {
	Sleep 10
	
	Gdip_DrawImage(G, pBitmap, 0, 0, Width, Height, 0, 0, Width, Height)
	UpdateLayeredWindow(hwnd1, hdc, 683-128, 384-128, Width, Height)
	
	Gdip_GraphicsClear(G)
	Gdip_RotateWorldTransform(G, angle)
	Gdip_TranslateWorldTransform(G, xShift, yShift)
	
}
return


valueShift(valueCurrent,valueTarget,valueStep:=1) {
	if ( abs(valueCurrent-valueTarget) <= valueStep )
		valueCurrent := valueTarget
	if ( valueCurrent < valueTarget )
		valueCurrent += valueStep
	if ( valueCurrent > valueTarget )
		valueCurrent -= valueStep
	return valueCurrent
}

valueEaseQuartic(valueCurrent, valueTarget, duration, valueRange:=1, easeType:=1) {
	valueDifference := abs( valueTarget - valueCurrent )
	t := abs( valueDifference / valueRange ) ** 0.25 - 1 / duration
	if ( t > 0 )
		valueDifferenceNew := t ** 4 * valueRange
	else
		return valueTarget
	if ( valueCurrent > valueTarget )
		valueNew := valueTarget + valueDifferenceNew
	else
		valueNew := valueTarget - valueDifferenceNew
	return valueNew
}



NumpadSub::
CoordMode, Mouse, Screen
MouseGetPos, cX, cY
sX := 100
pX := cX + sX

if WinActive("Alarms & Clock")
	send {Space}
while ( true ) {
	Sleep 3
	Sleep(7)
	
	cX := valueEaseQuartic(cX, pX, 20, sX)
	Click, %cX%, %cY%, 0
	
	if !GetKeyState("NumpadSub", "P")
		break
}
if WinActive("Alarms & Clock")
	send {Space}

KeyWait, NumpadSub
return


NumpadAdd::
ringSizeCurrent := 0
selectionSizeCurrent := 0
ringDuration := 12
selectionDuration := 20
MouseOSD:
CoordMode, Mouse, Screen
MouseGetPos, cX, cY
pX := cX - round(Width/2)
pY := cY - round(Height/2)
selectionLast := 0
selectionCurrent := 0
angleCurrent := 0
angleTarget := 0
angleShift := 0
angleDuration90 := 20
ringSizeTarget := 1
selectionSizeTarget := 0
selectionState := 0


pBMRingStatic := Gdip_CreateBitmapFromFile(filePathRingStatic)
pBMSelectionStatic := Gdip_CreateBitmapFromFile(filePathSelectionStatic)
pBMEmpty := Gdip_CreateBitmapFromFile(filePathEmpty)

Gdip_GraphicsClear(G)
Gdip_ResetWorldTransform(G)
Gdip_DrawImage(G, pBMEmpty, 0, 0, Width, Height, 0, 0, Width, Height)
UpdateLayeredWindow(hwnd1, hdc, pX, pY, Width, Height)

; MAIN LOOP
while ( A_Index <= 1200 ) {
	
	; Handling Mouse Selection
	{
	MouseGetPos, sX, sY
	sX -= cX
	sY -= cY
	sD := sqrt( sX*sX + sY*sY )
	
	if ( sD < centerRadius ) {
		selectionLast := selectionCurrent
		selectionCurrent := 0
	}
	else {
		selectionLast := selectionCurrent
		if ( sY >= sX && sY >= -sX )
			selectionCurrent := 3
		if ( sY >= sX && sY < -sX )
			selectionCurrent := 4
		if ( sY < sX && sY >= -sX )
			selectionCurrent := 2
		if ( sY < sX && sY < -sX )
			selectionCurrent := 1
	}
	}
	
	; Setting New Target Values
	if ( selectionCurrent == 0 ) {
		selectionSizeTarget := 0
	}
	else {
		selectionSizeTarget := 1
		angleTarget := 90 * selectionCurrent - 90
		if ( selectionSizeCurrent == 0 )
			angleCurrent := angleTarget
	}
	
	; Calculating New Angle Values
	while ( angleCurrent >= angleTarget + 180 )
		angleCurrent -= 360
	while ( angleCurrent <  angleTarget - 180 )
		angleCurrent += 360
	
	; Shifting Current Values
	angleCurrent := valueEaseQuartic(angleCurrent, angleTarget, angleDuration90, 90)
	ringSizeCurrent := valueEaseQuartic(ringSizeCurrent, ringSizeTarget, ringDuration)
	selectionSizeCurrent := valueEaseQuartic(selectionSizeCurrent, selectionSizeTarget, selectionDuration)
	;valueEaseQuartic(valueCurrent, valueTarget, duration, valueRange:=1, easeType:=1)
	
	
	; Clear & Reset the Graphics
	Gdip_GraphicsClear(G)
	Gdip_ResetWorldTransform(G)
	
	; Drawing
	
	s := ringSizeCurrent * .5 + .5
	o := ringSizeCurrent
	dW := ceil(w*s/2)*2
	dH := ceil(h*s/2)*2
	dX := (w-dW)/2
	dY := (h-dH)/2
	Gdip_DrawImage(G, pBMRingStatic, dX, dY, dW, dH, 0, 0, w, h, o)
	
	
	if ( selectionCurrent > 0 )
	{
	dShift := ( sqrt(Width*Width+Height*Height) - sqrt(2) ) / 2
	xShift := dShift * ( cos( 45 *d2r ) - cos( (45+angleCurrent) *d2r ) )
	yShift := dShift * ( sin( 45 *d2r ) - sin( (45+angleCurrent) *d2r ) )
	Gdip_TranslateWorldTransform(G, xShift, yShift)
	Gdip_RotateWorldTransform(G, angleCurrent)
	
	s := selectionSizeCurrent * .5 + .5
	o := selectionSizeCurrent
	dW := ceil(w*s/2)*2
	dH := ceil(h*s/2)*2
	dX := (w-dW)/2
	dY := (h-dH)/2
	Gdip_DrawImage(G, pBMSelectionStatic, dX, dY, dW, dH, 0, 0, w, h, o)
	}
	
	
	UpdateLayeredWindow(hwnd1, hdc, pX, pY, Width, Height)
	
	
	
	
	if ( sD > outerRadius || !GetKeyState("NumpadAdd", "P") ) && selectionState == 0
	{
		selectionState := 1
		ringSizeTarget := 0
		if ( selectionCurrent > 0 ) {
			Progress, b w246 x1120 y737 cb00CCFF ct4488FF cw505050 zh0,,SpaceHolder,,Source Code Pro
			Progress,,,Item %selectionCurrent% Selected
			SetTimer, DestroyProgress, -2000
		}
	}
	if ( selectionState == 1 && ringSizeCurrent == 0 )
		break
	if ( GetKeyState("NumpadAdd", "P") && selectionState == 1 )
		goto MouseOSD
	
	Sleep 1
	;Sleep(7)
}

KeyWait, NumpadAdd
;KeyWait, NumpadSub
Gdip_GraphicsClear(G)
UpdateLayeredWindow(hwnd1, hdc, pX, pY, Width, Height)
return
DestroyProgress:
Progress, OFF
return



; Cleaning Up
{
SelectObject(hdc, obm)
DeleteObject(hbm)
DeleteDC(hdc)
Gdip_DeleteGraphics(G)
Gdip_DisposeImage(pBitmap)
Return
}

;#######################################################################

Exit:
; gdi+ may now be shutdown on exiting the program
Gdip_Shutdown(pToken)
ExitApp
Return

^`::suspend
!`::reload
^!`::exitapp
return
