; LENS DESIGN
; 3 Elements

fMin := 100.0
fStep := 1.025
fAdd := .5
fMax := 99999
pFMax := 9999999
sensorSize := 43.2666
magMax := 1 / 5=
drawing := 1
sLmax := 120

#Include, GDIP\Gdip_All.ahk
SetTimer, GdipStartNOW, -1

Gui, 2: +AlwaysOnTop
Gui, 2: Font, s10, Source Code Pro

; ---- Text
Gui, 2: Add, Text, x10 y10, p1
Gui, 2: Add, Text, x10 y40, p2
Gui, 2: Add, Text, x10 y70, p3
Gui, 2: Add, Text, x10 y100, pA

; ---- Value
Gui, 2: Add, Edit, r1 x32  y7 w36 Limit3 Number vp1Edit gFlushEdit, 200
Gui, 2: Add, Edit, r1 x32 y37 w36 Limit3 Number vp2Edit gFlushEdit, 120
Gui, 2: Add, Edit, r1 x32 y67 w36 Limit3 Number vp3Edit gFlushEdit, 60
Gui, 2: Add, Edit, r1 x32 y97 w36 Limit3 Number vpAEdit gFlushEdit, 160

; ---- Slider Controls
Gui, 2: Add, Slider, x70 y7 w200 Range0-600 Page20 vp1Slider AltSubmit gFlushSlider
Gui, 2: Add, Slider, x70 y37 w200 Range0-600 Page20 vp2Slider AltSubmit gFlushSlider
Gui, 2: Add, Slider, x70 y67 w200 Range0-600 Page20 vp3Slider AltSubmit gFlushSlider
Gui, 2: Add, Slider, x70 y97 w200 Range0-600 Page20 vpASlider AltSubmit gFlushSlider

Gui, 2: Add, Button, x10 y128 w32 gExecute Default, >>
Gui, 2: Add, Button, x10 y158 w32 gQuickExecute, Q
Gui, 2: Add, Button, x10 y188 w32 gReloadProgram, R
Gui, 2: Add, Button, x10 y218 w32 gExitProgram, X

Gui, 2: Add, Edit, x50 y128 w220 r8 ReadOnly vdisplayText, <placeholder>

Gui, 2: Add, Progress, x11 w260 h20 c0088ff vprogressP, 0

Gui, 2: Show, ,GuiWindow
WinMove, GuiWindow, , 1076, 432

Goto, FlushEdit
return


SetWinDelay, -1
SetBatchLines, -1
#SingleInstance force
#NoEnv

^`::suspend
!`::reload
^!`::exitapp
return


FlushEdit:
Gui, 2: Submit, NoHide
GuiControl, 2:, p1Slider, %p1Edit%
GuiControl, 2:, p2Slider, %p2Edit%
GuiControl, 2:, p3Slider, %p3Edit%
GuiControl, 2:, pASlider, %pAEdit%
return

FlushSlider:
Gui, 2: Submit, NoHide
GuiControl, 2:, p1Edit, %p1Slider%
GuiControl, 2:, p2Edit, %p2Slider%
GuiControl, 2:, p3Edit, %p3Slider%
GuiControl, 2:, pAEdit, %pASlider%
;if ( A_GuiEvent == "Normal" )
;	Goto, QuickExecute
return


ReloadProgram:
Reload
ExitProgram:
ExitApp
return


QuickExecute:
drawing := 0
Execute:
Gui, 2: Submit, NoHide
p1 := p1Edit
p2 := p2Edit
p3 := p3Edit
pA := pAEdit
;sLmax := sLEdit

dCalcMin := 9999999
dCalcMax := 0.1
fCalcMin := 99999
fCalcMax := 1
ACalcMin := 64
ACalcMax := .125

dThreshold := [40000, 10000000]
MThreshold := [10, .5]

ACalcPara := [.5,4,1]
AValue := []
ACount := floor( 2 * ACalcPara[3] * log(ACalcPara[2]/ACalcPara[1]) / log(2) ) + 1
while (A_Index<=ACount) {
	AValue[A_Index-1] := ACalcPara[1] * 2**( (A_Index-1) / ACalcPara[3] / 2 )
}

fCalcRange := []						; [2D] - Index | Min/Max
fCalcRangeDG := []						; [3D] - Index | Distance Group | Min/Max
while ( A_Index <= 20, i := A_Index-1 ) {
	fCalcRange[ i , 0 ] := 99999
	fCalcRange[ i , 1 ] := 1
	while ( A_Index <= 20, j := A_Index-1 ) {
		fCalcRangeDG[ i , j , 0 ] := 99999
		fCalcRangeDG[ i , j , 1 ] := 1
	}
}

dGraphPara := [100, 1000000]
fGraphPara := [10, 1200]
AGraphPara := [.35, 5.3]

; -- diopXPara [4D]: DMax | DMin | steps | sMax
diop1Para := [20,-20,100,120]
diop2Para := [20,-20,100,100]
diop3Para := [20,-20,100,100]


Gdip_GraphicsClear(G)
if (drawing == 1) {
; ---- Drawing Macro Lines
pBrushMacro := Gdip_BrushCreateSolid(0x80aa00ff)
pBrushMacro5 := Gdip_BrushCreateSolid(0x80ff00ff)
d := 50
while (false) {
	f := d
	dGraph := log(d/100) / log(1.0077)
	fGraph := 600 - log(f/10) / log(1.008)
	Gdip_FillEllipse(G, pBrushMacro, dGraph, fGraph, 4, 4)
	f := d / 3
	fGraph := 600 - log(f/10) / log(1.008)
	Gdip_FillEllipse(G, pBrushMacro5, dGraph, fGraph, 4, 4)
	d *= 1.0077
	if ( d > 1000000 || f > 2000 )
		break
}

pBrushLine := Gdip_BrushCreateSolid(0x66ffffff)
; ---- Drawing Aperture Lines
ATemp := .25
while (true) {
	ATemp *= sqrt(2)
	yTemp := 600 - 600 * log(ATemp/AGraphPara[1]) / log(AGraphPara[2]/AGraphPara[1])
	if ( yTemp < 0 )
		break
	Gdip_FillRectangle(G, pBrushLine, -100, yTemp, 1400, 1)
	Options := "x0 y" round(yTemp)-22 " cffffffff s20"
	txt := round(ATemp,1)
	Gdip_TextToGraphics(G, txt, Options)
}

; ---- Drawing Focal Length Lines
fTemp := 12.5 / 2
while (true) {
	fTemp *= 2
	xTemp := 1200 * log(fTemp/fGraphPara[1]) / log(fGraphPara[2]/fGraphPara[1])
	if ( xTemp > 1200 )
		break
	Gdip_FillRectangle(G, pBrushLine, xTemp, -20, 1, 640)
	Options := "x" round(xTemp)+6 " y10 cffffffff s20"
	txt := round(fTemp,0)
	Gdip_TextToGraphics(G, txt, Options)
}

Gdip_DrawRectangle(G, pPen, 2, 2, 1196, 596)
UpdateLayeredWindow(hwnd1, hdc, 83, 99, Width, Height)
pBrush := Gdip_BrushCreateSolid(0xff00aaff)
pBrushRGB := []
pBrushRGB[0] := Gdip_BrushCreateSolid(0xffff4444)
pBrushRGB[1] := Gdip_BrushCreateSolid(0xff44ff44)
pBrushRGB[2] := Gdip_BrushCreateSolid(0xff4444ff)
}
brushColor := 1

if ( pA > p1 )
	pA := p1
if ( pA < p2 )
	pA := p2

while ( A_Index <= 10000000 , c := A_Index ) {
	
	valueState := valueSetDiop( f1, diop1Para, f2, diop2Para, f3, diop3Para, 2-A_Index )
	if ( valueState > 0 && A_Index > 1 )
		break
	
	if ( mod(A_Index,2400) == 0 ) {
		temp := A_Index / (diop1Para[3]*diop2Para[3]*diop3Para[3]) * 100
		GuiControl, , progressP, %temp%
		if (drawing == 1)
			UpdateLayeredWindow(hwnd1, hdc, 83, 99, Width, Height)
	}
	
	
	lensAdvanced( [p3,f3] , , pT2, sT2, 0, sensorSize, 0)
	lensAdvanced( [p2,f2] , , pT1, sT1, pT2, sT2, 0)
	lensAdvanced( [p1,f1] , , pO, sO, pT1, sT1, 0)
	
	
	if ( sO >= 0 || pO <= p1 )
		continue
	
	; For now pA is between p2 & p1
	pAF := pA
	if ( pA < p1 )
		lensAdvanced( [p1,f1] , , pA, 1, pAF, 1, 1 )
	f := (pO - pAF) / -sO * sensorSize
	if ( pAF > p1 || (p1 - pAF) / (pO - pAF) > 1 / 8 || sT2 < 0 )
		continue
	
	while ( A_Index <= ACount, ATick := A_Index-1 ) {
		
		A := AValue[ATick]
		sAF := f / A
		openingSize( s1, p1, sAF, pAF, sO, pO)
		if ( s1 > diop1Para[4] )
			continue
		lensAdvanced( [p1,f1] , , 1, sA, pAF, sAF, 0 )
		openingSize( s2, p2, sT1, pT1, sA, pA)
		if ( s2 > diop2Para[4] )
			continue
		lensAdvanced( [p2,f2] , [p3,f3] , pA, sA, pAR3, sAR3, 1)
		openingSize( s3, p3, sAR3, pAR3, sA, pA)
		if ( s3 > diop3Para[4] )
			continue
		
		; ---- Set Fmin&max for each distance group
		MReverseTemp := abs( sO / sensorSize )
		distanceGroup := 1
		if ( pO >= dThreshold[1] )
			distanceGroup := 2
		if ( MReverseTemp <= MThreshold[1] )
			distanceGroup := 0
		
		while ( ATick < ACount ) {
			fCalcRangeDG[ATick,distanceGroup,0] := minmaxFirst( fCalcRangeDG[ATick,distanceGroup,0] , f , 0 )
			fCalcRangeDG[ATick,distanceGroup,1] := minmaxFirst( fCalcRangeDG[ATick,distanceGroup,1] , f , 1 )
			ATick++
		}
		
		if (drawing == 1) {
			dTemp := 0
			
			if ( MReverseTemp <= MThreshold[1] ) {
				if ( MReverseTemp <= MThreshold[2] )
					dTemp := -1 - .5
				else
					dTemp := - log(MReverseTemp/MThreshold[1]) / log(MThreshold[2]/MThreshold[1]) - .5
			}
			if ( pO >= dThreshold[1] ) {
				if ( pO >= dThreshold[2] )
					dTemp := 1 + .5
				else
					dTemp := log(pO/dThreshold[1]) / log(dThreshold[2]/dThreshold[1]) + .5
			}
			A := A * 1.1**dTemp
			
			fGraph := log(f/fGraphPara[1]) / log(fGraphPara[2]/fGraphPara[1])
			AGraph := log(A/AGraphPara[1]) / log(AGraphPara[2]/AGraphPara[1])
			
			xGraph := fGraph * 1200
			yGraph := AGraph * - 600 + 600
			Gdip_FillRectangle(G, pBrushRGB[distanceGroup], xGraph-4, yGraph-4, 8, 8)
		}
		
		break
	}
	
}


txt := "<" c-1 ">"
while ( A_Index <= ACount , ATick := A_Index - 1 ) {
	
	fCalcRange[ATick, 0] := fCalcRangeDG[ ATick , 0 , 0 ]
	fCalcRange[ATick, 1] := fCalcRangeDG[ ATick , 0 , 1 ]
	while ( A_Index <= 2, distanceGroup := A_Index ) {
		fCalcRange[ATick,0] := minmaxFirst( fCalcRange[ATick,0] , fCalcRangeDG[ATick,distanceGroup,0 ] , 1 )
		fCalcRange[ATick,1] := minmaxFirst( fCalcRange[ATick,1] , fCalcRangeDG[ATick,distanceGroup,1 ] , 0 )
	}
	
	if ( fCalcRange[ATick, 0] > fCalcRange[ATick, 1] )
		continue
	
	txt := txt "`n"
	txt := txt round(fCalcRange[ATick,0],0) "-" round(fCalcRange[ATick,1],0)
	txt := txt "/" round(AValue[ATick],1)
	txt := txt "  (" round(fCalcRange[ATick,1]/fCalcRange[ATick,0],1) "x)"
}
GuiControl,, displayText, %txt%

if (drawing == 1)
	UpdateLayeredWindow(hwnd1, hdc, 83, 99, Width, Height)

drawing := 1
return


lensBasic(ByRef pL, ByRef fL, ByRef pO, ByRef pI, calc:=3) {
	if ( calc < 0 || calc > 3 )
		return -1
	
	; Calculating pI - Image Pos
	if ( calc == 3 ) {
		if ( pO == pL )
			pI := pL
		else
			pI := pL + 1/( 1/(pO-pL) - 1/fL )
	}
	
	; Calculating pO - Object Pos
	if ( calc == 2 ) {
		if ( pI == pL )
			pO := pL
		else
			pO := pL + 1/( 1/(pI-pL) + 1/fL )
	}
	
	; Calculating fL - Lens Focal Length
	if ( calc == 1 ) {
		if ( pI == pO )
			fL := 999999999
		else if ( pI == pL || pO == pL )
			return -1
		else
			fL := 1/( 1/(pO-pL) - 1/(pI-pL) )
	}
	
	; Calculating pL - Lens Pos (UNAVAILABLE)
	if ( calc == 0 ) {
		return 0
		if ( pI == pO ) {
			if ( abs(fL) > 999999 )
				pL := pI
			else
				return -1
		}
		else if ( pI == pL || pO == pL )
			return -1
		else
			return 0
	}
	
	return 1
}

lensAdvanced(paraL1:=0, paraL2:=0, ByRef pO:=0, ByRef sO:=0, ByRef pI:=0, ByRef sI:=0, calc:=1) {
	
	; Calculating pI & sI - Image Pos & Size
	if ( calc >= 1 ) {
		; Lens 1
		if ( paraL1.MaxIndex() !>= 1 || pO == paraL1[1] ) {
			pI := pO
			sI := sO
		}
		else {
			pL := paraL1[1]
			fL := paraL1[2]
			pI := pL + 1/( 1/(pO-pL) - 1/fL )
			sI := sO * (pI-pL)/(pO-pL)
		}
		; Lens 2
		if ( paraL2.MaxIndex() !>= 1 )
			return 1
		pL := paraL2[1]
		fL := paraL2[2]
		pO1 := pI
		sO1 := sI
		if ( pO1 == pL )
			return 1
		else {
			pI := pL + 1/( 1/(pO1-pL) - 1/fL )
			sI := sO1 * (pI-pL)/(pO1-pL)
		}
	}
	; Calculating pO & sO - Object Pos & Size
	if ( calc <= 0 ) {
		; Lens 2
		if ( paraL2.MaxIndex() !>= 1 || pI == paraL2[1] ) {
			pO := pI
			sO := sI
		}
		else {
			pL := paraL2[1]
			fL := paraL2[2]
			pO := pL + 1/( 1/(pI-pL) + 1/fL )
			sO := sI * (pO-pL)/(pI-pL)
		}
		; Lens 1
		if ( paraL1.MaxIndex() !>= 1 )
			return 1
		pL := paraL1[1]
		fL := paraL1[2]
		pI1 := pO
		sI1 := sO
		if ( pI1 == pL )
			return 1
		else {
			pO := pL + 1/( 1/(pI1-pL) + 1/fL )
			sO := sI1 * (pO-pL)/(pI1-pL)
		}
	}
	return 1
}

valueSet(ByRef v0, ByRef v1, ByRef v2, vBegin:=0, vEnd:=100, mul:=1, inc:=0) {
	if ( v2.MaxIndex() >= 1 )
		return 0
	v2 := v2 * mul + inc
	if ( (v2-vBegin)*(v2-vEnd) <= 0 )
		return 1
	
	if ( v1.MaxIndex() >= 1 )
		return 0
	v2 := vBegin
	v1 := v1 * mul + inc
	if ( (v1-vBegin)*(v1-vEnd) <= 0 )
		return 1
	
	if ( v0.MaxIndex() >= 1 )
		return 0
	v1 := vBegin
	v0 := v0 * mul + inc
	if ( (v0-vBegin)*(v0-vEnd) <= 0 )
		return 1
	else
		return 0
}


valueSetDiop( ByRef f1:=0, diop1Para:=0, ByRef f2:=0, diop2Para:=0, ByRef f3:=0, diop3Para:=0, resetC:=0 ) {
	
	if ( diop1Para == 0 || valueSetDiopSingle( f1, diop1Para, resetC ) == 0 )
		return 0
	
	if ( diop2Para == 0 || valueSetDiopSingle( f2, diop2Para, resetC ) == 0 )
		return 0
	
	if ( diop3Para == 0 || valueSetDiopSingle( f3, diop3Para, resetC ) == 0 )
		return 0
	
	return 1
}

valueSetDiopSingle( ByRef f:=0, diopPara:=0, resetC:=0 ) {
	outRange := false
	
	if ( resetC == 1 ) {
		if ( diopPara[1] == 0 )
			f := 9999999
		else
			f := 1000 / diopPara[1]
		return 1
	}
	
	if ( f == 0 )
		return 0
	diop := 1000/ f
	diop += ( diopPara[2] - diopPara[1] ) / diopPara[3]
	if ( (diop-diopPara[1])*(diop-diopPara[2]) > 0 ) {
		outRange := true
		diop := diopPara[1]
	}
	if ( diop == 0 )
		f := 9999999
	else
		f := 1000/ diop
	
	if (outRange)
		return 1
	else
		return 0
}


openingSize( ByRef s0, p0, s1, p1, s2, p2) {
	if ( (p0-p1)*(p0-p2) <= 0 )
		s0 := (abs(s2) - abs(s1)) * (p0 - p1) / (p2 - p1)
	else
		s0 := (abs(s2) + abs(s1)) * (p0 - p1) / (p2 - p1)
	s0 := abs(s0)
	return 1
}


minmaxValue( a:=0, b:="E", c:="E", d:="E" ) {
	; max: "U" / "H" / "B"
	; min: "D" / "L" / "S"
	direction := 1
	mmV := a
	if ( b == "D" || b == "L" || b == "S" )
		direction := 0
	if ( c == "D" || c == "L" || c == "S" )
		direction := 0
	if ( d == "D" || d == "L" || d == "S" )
		direction := 0
	
	minmaxFirst( mmV , b , direction )
	minmaxFirst( mmV , c , direction )
	minmaxFirst( mmV , d , direction )
	
	return mmV
}

minmaxFirst( ByRef a, b:="E" , direction:=1 ) {
	if ( b == "E" )
		return a
	if ( direction == 0 )
		direction := -1
	if ( (a - b) * direction < 0 )
		a := b
	return a
}



GdipStartNOW:

; Start gdi+
If !pToken := Gdip_Startup()
{
	MsgBox, 48, gdiplus error!, Gdiplus failed to start. Please ensure you have gdiplus on your system
	ExitApp
}
OnExit, Exit

; Set the width and height we want as our drawing area, to draw everything in. This will be the dimensions of our bitmap
Width :=1200, Height := 600

; Create a layered window (+E0x80000 : must be used for UpdateLayeredWindow to work!) that is always on top (+AlwaysOnTop), has no taskbar entry or caption
Gui, 1: -Caption +E0x80000 +LastFound +AlwaysOnTop +ToolWindow +OwnDialogs

; Show the window
Gui, 1: Show, NA

; Get a handle to this window we have created in order to update it later
hwnd1 := WinExist()

; Create a gdi bitmap with width and height of what we are going to draw into it. This is the entire drawing area for everything
hbm := CreateDIBSection(Width, Height)

; Get a device context compatible with the screen
hdc := CreateCompatibleDC()

; Select the bitmap into the device context
obm := SelectObject(hdc, hbm)

; Get a pointer to the graphics of the bitmap, for use with drawing functions
G := Gdip_GraphicsFromHDC(hdc)

; Set the smoothing mode to antialias = 4 to make shapes appear smother (only used for vector drawing and filling)
Gdip_SetSmoothingMode(G, 4)

; Create a fully opaque red brush (ARGB = Transparency, red, green, blue) to draw a circle
pBrush := Gdip_BrushCreateSolid(0xaa00aaff)
pPen := Gdip_CreatePen(0xaa888888, 4)

return
; Fill the graphics of the bitmap with an ellipse using the brush created
; Filling from coordinates (100,50) an ellipse of 200x300
Gdip_FillEllipse(G, pBrush, 100, 500, 200, 300)

; Delete the brush as it is no longer needed and wastes memory
Gdip_DeleteBrush(pBrush)

; Create a slightly transparent (66) blue brush (ARGB = Transparency, red, green, blue) to draw a rectangle
pBrush := Gdip_BrushCreateSolid(0x660000ff)

; Fill the graphics of the bitmap with a rectangle using the brush created
; Filling from coordinates (250,80) a rectangle of 300x200
Gdip_FillRectangle(G, pBrush, 250, 80, 300, 200)

; Delete the brush as it is no longer needed and wastes memory
Gdip_DeleteBrush(pBrush)


; Update the specified window we have created (hwnd1) with a handle to our bitmap (hdc), specifying the x,y,w,h we want it positioned on our screen
; So this will position our gui at (0,0) with the Width and Height specified earlier
UpdateLayeredWindow(hwnd1, hdc, 83, 99, Width, Height)


; Select the object back into the hdc
SelectObject(hdc, obm)

; Now the bitmap may be deleted
DeleteObject(hbm)

; Also the device context related to the bitmap may be deleted
DeleteDC(hdc)

; The graphics may now be deleted
Gdip_DeleteGraphics(G)
Return

;#######################################################################

Exit:
; gdi+ may now be shutdown on exiting the program
Gdip_Shutdown(pToken)
ExitApp
Return




