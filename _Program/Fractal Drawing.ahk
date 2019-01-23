
#Include, GDIP\Gdip_All.ahk
SetTimer, GdipStartNOW, -1
Sleep, 400

pPen := Gdip_CreatePen(0xaa888888, 4)
pBrush := Gdip_BrushCreateSolid(0x8800aaff)
pBrushS := Gdip_BrushCreateSolid(0xff0099ff)
pBrushRed := Gdip_BrushCreateSolid(0xffff0044)
pBrushRGB := []

if (true) {
colorCount := 120
colorA := 0xff
colorE := []
colorTrans := []
colorTrans[0] := [2,-1,0,0,1,2]
colorTrans[1] := [1,2,2,-1,0,0]
colorTrans[2] := [0,0,1,2,2,-1]
while( A_Index <= colorCount ) {
	i := A_Index - 1
	h := 6 * (A_Index - 1) / colorCount
	hZone := floor(h) + 1
	hRemain := h - floor(h)
	
	colorC := colorA * 0x1000000
	while ( A_Index <= 3, j := A_Index - 1 ) {
		colorE[j] := colorTrans[ j, hZone ] * hRemain
		if ( colorTrans[ j, hZone ] < 0 )
			colorE[j] += 1
		if ( colorTrans[ j, hZone ] >= 2 )
			colorE[j] := 1
		colorE[j] := round( colorE[j] * 0xff )
		colorC += colorE[j] * (0x100**(2-j))
	}
	txt := colorC
	;MsgBox, %txt%
	pBrushRGB[i] := Gdip_BrushCreateSolid(colorC)
}
}

if (false) {
colorCount := 12
while( A_Index <= colorCount+1 ) {
	i := A_Index - 1
	colorA := 0xff
	colorR := round( ( i / colorCount ) * 0xff )
	colorB := round( ( 1 - i / colorCount ) * 0xff )
	
	colorC := 0x1000000 * colorA + 0x10000 * colorR + colorB
	
	pBrushRGB[i] := Gdip_BrushCreateSolid(colorC)
}
}

;SetTimer, FractalShape, -1
SetTimer, FractalSpiral, -1
;SetTimer, MouseTrail, -1
return



MouseTrail:
{
CoordMode, Mouse, Screen
MouseGetPos, mX, mY
mD := 0
while ( A_Index <= 10000 ) {
	;Sleep, 5
	mtX := mX
	mtY := mY
	MouseGetPos, mX, mY
	
	mtD := mD
	mD := 3*sqrt( (mX - mtX)**2 + (mY - mtY)**2 )
	
	gY := (2*mD+mtD)/3
	if ( gY > 400 )
		colorI := colorCount
	else
		colorI := floor( gY / 400 * colorCount )
	
	;Gdip_FillEllipse(G, pBrush, mX-83-1, mY-99-1, 2, 2)
	;Gdip_TranslateWorldTransform(G, -.8, 0)
	;Gdip_RotateWorldTransform(G, 1)
	Gdip_FillEllipse(G, pBrushRGB[colorI], A_Index/10-2, 594-gY, 4, 4)
	
	;if ( mod(A_Index,5) == 0 )
		UpdateLayeredWindow(hwnd1, hdc, 83, 99, Width, Height)
}
return
}


FractalShape:
{
pointCount := 5
moveRatio := .5

point := []
point[0] := [540,20]
point[1] := [20,550]
point[2] := [1050,590]
point[3] := [1080,110]
point[4] := [120,160]
pointCurrent := []
pointCurrent := [100,460]
;pointCurrent := [300,462]
pointNext := []

txt := point[2,1]
;MsgBox, %txt%

while ( A_Index <= pointCount , i := A_Index-1 ) {
	Gdip_FillEllipse(G, pBrushRed, point[i,1]-8, point[i,2]-8, 16, 16)
}
UpdateLayeredWindow(hwnd1, hdc, 83, 99, Width, Height)

sum := 0
vCount := [0,0]
vCount[0] := 0
pCtxt := "0 , " pointCount - 1
while ( A_Index <= 1000000 , i := A_Index ) {
	Random, rd, 0, pointCount-1
	
	while ( A_Index <= 2 , j := A_Index ) {
		pointNext[j] := pointCurrent[j]*(1-moveRatio) + point[rd,j]*moveRatio
		pointCurrent[j] := pointNext[j]
	}
	
	Gdip_FillEllipse(G, pBrush, pointNext[1]-1, pointNext[2]-1, 2, 2)
	
	
	if ( mod(i,200) == 0 )
		UpdateLayeredWindow(hwnd1, hdc, 83, 99, Width, Height)
}
UpdateLayeredWindow(hwnd1, hdc, 83, 99, Width, Height)
MsgBox, done
return
}


FractalSpiral:
{

r := 0
aX := 600
aY := 300
while (A_Index<=100000) {
	i := A_Index - 1
	r := i * .04
	a := r * 2 * 3.14159 / 40
	pX := aX + r * sin(a)
	pY := aY + r * -cos(a)
	c := mod( floor(a / 2 / 3.14159 * colorCount + .5) , colorCount )
	Gdip_FillEllipse(G, pBrushRGB[c], pX-2, pY-2, 4, 4)
	;Gdip_FillEllipse(G, pBrush, pX-2, pY-2, 4, 4)
	
	if ( mod(A_Index,60) == 0 )
		UpdateLayeredWindow(hwnd1, hdc, 83, 99, Width, Height)
}

UpdateLayeredWindow(hwnd1, hdc, 83, 99, Width, Height)
return
}


SetWinDelay, -1
SetBatchLines, -1
#SingleInstance force
#NoEnv

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
Gdip_SetSmoothingMode(G, 4)


return
Exit:
Gdip_Shutdown(pToken)
ExitApp
}


