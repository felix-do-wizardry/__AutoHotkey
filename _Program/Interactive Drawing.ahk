; Interactive Elements Drawing Session


CoordMode, Mouse, Screen
SetWinDelay, -1
SetBatchLines, -1
#SingleInstance force
#NoEnv
#Include, GDIP\Gdip_All.ahk
SetTimer, GdipStartNOW, -1

^`::suspend
!`::reload
^!`::exitapp
return

AutoRun:

pPen := Gdip_CreatePen(0xaa888888, 4)
pBrush := Gdip_BrushCreateSolid(0x8800aaff)
pBrushS := Gdip_BrushCreateSolid(0xff0099ff)
pBrushBlack := Gdip_BrushCreateSolid(0xff000000)
pBrushRed := Gdip_BrushCreateSolid(0xffff0044)

point := []
pointMoveID := []
pointMoveCount := 0
pointCount := 20
pointGroupCount := 3
;generateRandomSeed(rs)
;Random, , rs
sX := 1200
sY := 600
pixelCount := sX * sY
while (A_Index<=pointCount,i:=A_Index-1) {
	Random, rd, 0, pixelCount-1
	point[i,0] := mod(rd, sX)
	point[i,1] := round( (rd - point[i,0]) / sX )
	
	Random, rd, 0, 359
	point[i,2] := rd
	
	Random, rd, 5, 40
	point[i,3] := rd / 10
}

while (A_Index<=pointCount,i:=A_Index-1) {
	gFillCircleDouble( point[i,0] , point[i,1] , 4 , 6 , pBrushS )
	if ( point[i,0] < 0 || point[i,0] > sX || point[i,1] < 0 || point[i,1] > sY ) {
		txt := "Out Of Range!!!!`npoint[" i "] = " point[i,0] " , " point[i,1]
		MsgBox, %txt%
	}
}
UpdateLayeredWindow(hwnd1, hdc, 83, 99, Width, Height)

attractRange := 480

firstRun := 1
SetTimer, MainLoop, 8

MainLoop:
{
Gdip_GraphicsClear(G)
MouseGetPos, mX, mY
mX -= 83
mY -= 99
while (A_Index<=pointCount,i:=A_Index-1) {
	
	point[i,0] += point[i,3] *  sin( point[i,2] * 0.0174532925 )
	point[i,1] += point[i,3] * -cos( point[i,2] * 0.0174532925 )
	
	attraction := 1 - sqrt( (point[i,0]-mX)**2 + (point[i,1]-mY)**2 ) / attractRange
	if ( attraction < 0 )
		attraction := 0
	else if ( attraction >= 1-1/attractRange )
		attraction := 1
	else
		attraction := attraction ** 10 / 3.2
	attraction := -attraction
	point[i,0] := point[i,0] * (1-attraction) + mX * attraction
	point[i,1] := point[i,1] * (1-attraction) + mY * attraction
	
	if ( point[i,0] < 0 ) {
		point[i,0] := 0
		point[i,2] := 360 - point[i,2]
	}
	if ( point[i,0] > sX ) {
		point[i,0] := sX
		point[i,2] := 360 - point[i,2]
	}
	if ( point[i,1] < 0 ) {
		point[i,1] := 0
		point[i,2] := 540 - point[i,2]
	}
	if ( point[i,1] > sY ) {
		point[i,1] := sY
		point[i,2] := 540 - point[i,2]
	}
	
	pointGroup := floor(i/pointGroupCount)
	while ( mod(i+A_Index,pointGroupCount) > 0 ) {
		j := i + A_Index
		Gdip_DrawLine(G, pPen, point[i,0], point[i,1], point[j,0], point[j,1])
	}
	
	gFillCircleDouble( point[i,0] , point[i,1] , 4 , 6 , pBrushS )
}
if ( firstRun == 1 )
	SetTimer, UpdateLoop, 8
firstRun := 0
return
}

UpdateLoop:
UpdateLayeredWindow(hwnd1, hdc, 83, 99, Width, Height)
return



gFillCircleDouble( x:=600, y:=300, r0:=2, r1:=3, pB0:=-1, pB1:=-1 ) {
	global pBrush, pBrushBlack, G
	if ( pB1 < 0 )
		pB1 := pBrushBlack
	gFillCircle( x, y, r1, pB1 )
	gFillCircle( x, y, r0, pB0 )
	return 1
}

gFillCircle( x:=600, y:=300, r:=2, pB:=-1 ) {
	global pBrush, G
	if ( pB < 0 )
		pB := pBrush
	Gdip_FillEllipse(G, pB, x-r, y-r, 2*r, 2*r)
	return 1
}

generateRandomSeed(ByRef v := 0) {
	r := 0
	r += A_MM	* -69
	r += A_DD	* 420
	r += A_Hour	* 6425
	r += A_Min	* -591
	r += A_Sec	* 715
	r += A_MSec	* -8261
	r := mod( abs(r) , 4294967295 )
	v := r
	return r
}


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

SetTimer, AutoRun, -1
return
Exit:
Gdip_Shutdown(pToken)
ExitApp
}



