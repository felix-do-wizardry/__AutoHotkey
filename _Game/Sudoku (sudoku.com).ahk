
value := []
set := []
colorT := []
numValue := []
numValueOption := []										; [3D] _ x / y / 0-optionCount, 1~9-availabilityCheck
numPixelV := []
numPixelColor := []
distinctPixelColorCheck := []
distinctPixelColorProperty := []					; [2D] _ index / 0-x, 1-y, 2-color, 3-check
distinctPixelColorCount := 0
blockSpacing := [60,59]
blockSize := [14,17]
cornerTopLeft := [23,21]
pX := []
pY := []
autoScanNumber := 1
whiteThreshold := 0xA00000
blackThreshold := 0x600000
numPixelPlate := []
numPixelComp := []
numPixelCompDiffCount := []
eligiblePixel := []
eligiblePixelCount := 0
distinctPixel := []
distinctPixelCount := 0
id := []
numCode := []
found := 0
codeBitCount := 0
numCount := 9
imageX := 0
imageY := 0
colorBG := [ 0xFFFFFF , 0x000000 , 0xFFFFFF , 0x000000 ]
numScanBlock := []
numScanBlockP := []
colorMargin := 50
sudokuLevel := 3
blockClickOffset := [ 25, 25 ]
optionGroupCount := []

wigglePara := [4,8,20]

SetMouseDelay, -1
delay := 0
#SingleInstance force
^`::suspend
!`::reload
return


; ------ Hotkeys
{
$^0::forceNumber(0)
$^1::forceNumber(1)
$^2::forceNumber(2)
$^3::forceNumber(3)
$^4::forceNumber(4)
$^5::forceNumber(5)
$^6::forceNumber(6)
$^7::forceNumber(7)
$^8::forceNumber(8)
$^9::forceNumber(9)

$^+0::numberPixelScan(0,-1)
$^+1::numberPixelScan(1,-1)
$^+2::numberPixelScan(2,-1)
$^+3::numberPixelScan(3,-1)
$^+4::numberPixelScan(4,-1)
$^+5::numberPixelScan(5,-1)
$^+6::numberPixelScan(6,-1)
$^+7::numberPixelScan(7,-1)
$^+8::numberPixelScan(8,-1)
$^+9::numberPixelScan(9,-1)
}


$\::numberPixelScanAUTO()
numberPixelScanAUTO( report:=1 ) {
	
	global found, numCount
	
	SplashTextOn, 400, 60, SplashWindow,
	WinMove, SplashWindow, , 966, 30
	
	while (A_Index<=numCount, i:=A_Index)
	{
		numberPixelScan(i)
		mouseWiggle()
		Sleep, 20
		if GetKeyState("Control","p") {
			SplashTextOff
			return
		}
	}
	
	ControlSetText, Static1, Reporting, SplashWindow
	Sleep, 200
	SplashTextOff
	
	while (A_Index<=numCount && report==1, i:=A_Index)
	{
		numberPixelReport(i)
		if GetKeyState("Control","p")
			return
	}
	
	numberPixelProcess()
	
	return
	
	numberPixelCode()
	SplashTextOff
	
	MsgBox, FOUND? = %found%
	
}


F8::numberPixelScanFromImageAUTO(0)
numberPixelScanFromImageAUTO( report:=1 ) {
	
	global imageX, imageY, cornerTopLeft, numCount, blockSpacing
	
	SplashTextOn, 400, 60, SplashWindow,
	WinMove, SplashWindow, , 966, 30
	
	MouseGetPos, MouseX, MouseY
	Click, -25, 0, 0, Rel
	tempX := MouseX
	tempY := MouseY

	; ------ Corner Lock-On
	color := 0xFFFFFF
	while ( A_Index<=100 && color > 0x000000 )
	{
		tempX := tempX + 1
		PixelGetColor, color, %tempX% , %tempY% , RGB
		if (GetKeyState("Control", "P") || A_Index == 100)
			return
	}

	while ( A_Index<=100 && color < 0xFFFFFF )
	{
		tempY := tempY - 1
		PixelGetColor, color, %tempX% , %tempY% , RGB
		if (GetKeyState("Control", "P") || A_Index == 100)
			return
	}
	tempY := tempY + 1
	imageX := tempX + cornerTopLeft[1]
	imageY := tempY + cornerTopLeft[2]
	
	while ( A_Index <= numCount, i := A_Index ) {
		tempX := imageX + blockSpacing[1] * ( i - 1 )
		tempY := imageY
		numberPixelScan( i , tempX , tempY )
		mouseWiggle()
		Sleep, 20
		if GetKeyState("Control","p") {
			SplashTextOff
			return
		}
	}
	
	Click, %MouseX%, %MouseY%, 0
	
	ControlSetText, Static1, Reporting, SplashWindow
	Sleep, 200
	SplashTextOff
	
	while (A_Index<=numCount && report==1, i:=A_Index)
	{
		numberPixelReport(i)
		if GetKeyState("Control","p")
			return
	}
	
	numberPixelProcess()
	
	
	
	
	return
	
	numberPixelCode()
	SplashTextOff
	
	MsgBox, FOUND? = %found%
	
}


F12::numberPixelRead()
numberPixelRead( x:=-1 , y:=-1 ) {
	
	global imageX, imageY, cornerTopLeft, numCount, blockSpacing
	global distinctPixelColorProperty, pX, pY
	
	
	
	if ( x<0 && y<0 ) {
		SplashTextOn, 400, 60, SplashWindow,
		WinMove, SplashWindow, , 966, 30
		
		; ------ Choosing Block to Scan
		MouseGetPos, MouseX, MouseY
		while ( A_Index<=numCount-1, x:=A_Index-1 )
			if ( pX[x] + blockSpacing[1] >= MouseX )
				break
		tempX := pX[x]
		while ( A_Index<=numCount-1, y:=A_Index-1 )
			if ( pY[y] + blockSpacing[2] >= MouseY )
				break
		tempY := pY[y]
		
		number := 0
		while ( A_Index <= numCount, i := A_Index ) {
			tempX := pX[x] + distinctPixelColorProperty[i,0]
			tempY := pY[y] + distinctPixelColorProperty[i,1]
			PixelGetColor, color, %tempX% , %tempY% , RGB
			if ( color == distinctPixelColorProperty[i,2] ) {
				number := i
				break
			}
		}
		
		ControlSetText, Static1, %number%, SplashWindow
		Sleep, 1000
		SplashTextOff
	}
	
	
	
}


F9::numberPixelProcess()
numberPixelProcess( report:=1 ) {
	global numPixelV, blockSize, numPixelPlate, numPixelComp, numCount
	global eligiblePixel, eligiblePixelCount, id, distinctPixel, distinctPixelCount
	global numPixelColor, distinctPixelColorCheck, distinctPixelColorProperty
	global distinctPixelColorCount
	eligiblePixelCount := 0
	distinctPixelCount := 0
	distinctPixelColorCount := 0
	while ( A_Index <= numCount , i := A_Index )
		distinctPixelColorProperty[ i , 3 ] := 0
	
	; ------ Processing Pixels
	while ( A_Index<=blockSize[2], y:=A_Index-1 ) {
		while ( A_Index<=blockSize[1], x:=A_Index-1 ) {
			
			numPixelPlate[x,y] := numPixelV[1,x,y]
			
			while (A_Index<=numCount-1, i:=A_Index+1) {
				if ( numPixelV[i,x,y] < 0 )
					numPixelPlate[x,y] := -1
				if ( numPixelPlate[x,y] < 0 )
					break
				numPixelPlate[x,y] += numPixelV[i,x,y]
			}
			
			
			; New Test for Distinct Pixels / On Color Level
			while ( A_Index <= numCount , i := A_Index )
				distinctPixelColorCheck[i,x,y] := 1
			
			while ( A_Index <= numCount - 1 , i := A_Index )
			while ( A_Index <= numCount - i , j := A_Index + i ) {
				if ( numPixelColor[i,x,y] == numPixelColor[j,x,y] ) {
					distinctPixelColorCheck[i,x,y] := 0
					distinctPixelColorCheck[j,x,y] := 0
				}
			}
			j := 0
			txt = Found NEW for :
			while ( A_Index <= numCount , i := A_Index ) {
				if ( distinctPixelColorCheck[i,x,y] > 0 && distinctPixelColorProperty[ i , 3 ] == 0 ) {
					distinctPixelColorProperty[ i , 0 ] := x
					distinctPixelColorProperty[ i , 1 ] := y
					distinctPixelColorProperty[ i , 2 ] := numPixelColor[i,x,y]
					distinctPixelColorProperty[ i , 3 ] := 1
					distinctPixelColorCount++
					
					txt = %txt% %i%
					j += distinctPixelColorCheck[i,x,y]
				}
				
				distinctPixelColorProperty[ i , 3 ]
			}
			if ( j > 0 ) {
				txt = Pixel[ %x% , %y% ]`n%txt%
				txt = %txt%`n%j% NEW numbers in total
				txt = %txt%`n%distinctPixelColorCount%/%numCount% numbers IDENTIFIED
				MsgBox, %txt%
			}
			
			if ( distinctPixelColorCount == numCount ) {
				txt = All %numCount% numbers are IDENTIFIED
				while ( A_Index <= numCount, i := A_Index ) {
					tempX := distinctPixelColorProperty[ i , 0 ]
					tempY := distinctPixelColorProperty[ i , 1 ]
					color := distinctPixelColorProperty[ i , 2 ]
					txt = %txt%`nn(%i%) - pixel[ %tempX% , %tempY% ] - color<%color%>
				}
				MsgBox, %txt%
				return
			}
			
			; New Test for Distinct Pixels
			if ( numPixelPlate[x,y] == 1 || numPixelPlate[x,y] == numCount-1 ) {
				while ( A_Index <= numCount , i := A_Index ) {
					if ( numPixelPlate[x,y] == 1 && numPixelV[i,x,y] >= 1 ) {
						distinctPixel[distinctPixelCount] := i
						break
					}
					if ( numPixelPlate[x,y] > 1 && numPixelV[i,x,y] <= 0 ) {
						distinctPixel[distinctPixelCount] := i
						break
					}
				}
				distinctPixelCount++
			}
			
			
			if ( numPixelPlate[x,y] >= numCount )
				numPixelPlate[x,y] := 0
			numPixelV[0,x,y] := numPixelPlate[x,y]
			
			if ( numPixelPlate[x,y] >= 1 ) {
				eligiblePixel[ eligiblePixelCount , 0 ] := x
				eligiblePixel[ eligiblePixelCount , 1 ] := y
				
				eligiblePixelCount++
			}
			
			if GetKeyState("Control","p")
				return
		}
		
	}
	
	txt = %eligiblePixelCount% Eligible Pixels`n
	txt = %txt%%distinctPixelCount% Distinct Pixels`n
	while ( A_Index <= distinctPixelCount, i := A_Index - 1 ) {
		j := distinctPixel[i]
		txt = %txt%-%j% 
	}
	MsgBox, %txt%
	
	if ( report == 1 )
		numberPixelReport(0)
	
}

F10::numberPixelCode()
numberPixelCode() {
	global numPixelV, eligiblePixel, eligiblePixelCount, codeBitCount, id, found, numCount
	codeBitCount := 5
	found := 0
	skip := 0
	count := 0
	txt = Coding Pixels`n
	SplashTextOn, 400, 60, SplashWindow,
	WinMove, SplashWindow, , 966, 30
	ControlSetText, Static1, %txt%, SplashWindow
	
	while ( A_Index <= eligiblePixelCount - codeBitCount + 1 , id[0] := A_Index - 1 )
	while ( A_Index <= eligiblePixelCount - codeBitCount - id[0] + 1 , id[1] := A_Index + id[0] )
	while ( A_Index <= eligiblePixelCount - codeBitCount - id[1] + 2 , id[2] := A_Index + id[1] )
	while ( A_Index <= eligiblePixelCount - codeBitCount - id[2] + 3 , id[3] := A_Index + id[2] )
	while ( A_Index <= eligiblePixelCount - codeBitCount - id[3] + 4 , id[4] := A_Index + id[3] )
	{
		skip := 0
		while ( A_Index <= numCount && skip == 0 , i := A_Index )
		{
			numCode[ i ] := 0
			while ( A_Index <= codeBitCount , k := A_Index - 1 )
				if ( numPixelV[ i , eligiblePixel[ id[ k ] , 0 ] , eligiblePixel[ id[ k ] , 1 ] ] > 0 )
					numCode[ i ] += 2**j
			
			while ( A_Index <= i - 1 && skip == 0 , j := A_Index )
				if ( numCode[ i ] == numCode[ j ] )
					skip := 1
		}
		
		if ( skip == 0 ) {
			found := 1
			return
		}
		if GetKeyState("Control","p") {
			found := -1
			return
		}
		
		count++
		if ( count >= 10000 ) {
			count := 0
			txt = %txt%.
			ControlSetText, Static1, %txt%, SplashWindow
		}
		
	}
	SplashTextOff
}



numberPixelScan(n, bX:=-1, bY:=-1 ) {
	KeyWait, Control
	
	global pX, pY, blockSize, blockSpacing, numPixelV, numCount
	global whiteThreshold, blackThreshold, numPixelColor
	
	if ( bX < 0 && bY < 0 ) {
	; ------ Choosing Block to Scan
	MouseGetPos, MouseX, MouseY
	while ( A_Index<=numCount-1, i:=A_Index-1 )
		if ( pX[i] + blockSpacing[1] >= MouseX )
			break
	tempX := pX[i]
	while ( A_Index<=numCount-1, i:=A_Index-1 )
		if ( pY[i] + blockSpacing[2] >= MouseY )
			break
	tempY := pY[i]
	}
	else {
		tempX := bX
		tempY := bY
	}
	
	
	; ------ Color Polling
	while ( A_Index<=blockSize[2], y:=A_Index-1 ) {
		while ( A_Index<=blockSize[1], x:=A_Index-1 ) {
			PixelGetColor, color, tempX + x , tempY + y , RGB
			numPixelColor[n,x,y] := color
			if ( color >= whiteThreshold )
				numPixelV[n,x,y] := 0
			else if ( color <= blackThreshold )
				numPixelV[n,x,y] := 1
			else
				numPixelV[n,x,y] := -1
			
			if GetKeyState("Control","p")
				return
		}
		
		txt = Scanning Block %n%`n
		while ( A_Index<=y+1)
			txt = %txt%X
		while ( A_Index<=blockSize[2]-y-1)
			txt = %txt%=
		ControlSetText, Static1, %txt%, SplashWindow
		
	}
}

numberPixelReport(n) {
	global numPixelV, blockSize, numCount
	txt = Number Pixel Report - %n%`n
	while ( A_Index<=blockSize[2], y:=A_Index-1 ) {
		while ( A_Index<=blockSize[1], x:=A_Index-1 ) {
			if ( numPixelV[n,x,y] > 0 )
				blockTxt := "O"
			else if ( numPixelV[n,x,y] == 0 )
				blockTxt := "..."
			else
				blockTxt := ",,,"
			txt = %txt%  %blockTxt% 
		}
		txt = %txt%`n
	}
	MsgBox %txt%
}

mouseWiggle() {
	global wigglePara
	tempX0 := wigglePara[2]
	tempX1 := -wigglePara[2]
	delay := wigglePara[3]
	while (A_Index<=wigglePara[1]) {
		Click, %tempX0%, 0, 0, Rel
		Sleep, %delay%
		Click, %tempX1%, 0, 0, Rel
		Sleep, %delay%
		Click, %tempX1%, 0, 0, Rel
		Sleep, %delay%
		Click, %tempX0%, 0, 0, Rel
		Sleep, %delay%
	}
}


colorPicker(x,y) {
	PixelGetColor, color, %x% , %y% , RGB
	
	temp0 := round( (color - mod( color , 0x10000 )) / 0x10000 )
	temp1 := round( (mod( color , 0x10000 ) - mod( color , 0x100 )) / 0x100 )
	temp2 := mod( color , 0x100 )
	color := temp0 + temp1 + temp2
	return color
	
	if ( color <= 12 )
		color := 0
	else if ( color >= 755)
		color := 1000
	else
		color := 500
	
	return color
}

forceNumber(n) {
	global numCount, pX, pY, blockSpacing, numValue
	
	MouseGetPos, MouseX, MouseY
	while ( A_Index<=numCount-1, x:=A_Index-1 )
		if ( pX[x] + blockSpacing[1] > mouseX )
			break
	while ( A_Index<=numCount-1, y:=A_Index-1 )
		if ( pY[y] + blockSpacing[2] > mouseY )
			break
	
	numValue[x,y] := n
	
	mouseWiggle()
}


setValue(x,y,n:=-1) {
	global pX, pY, blockClickOffset, numValue, solvedBlockCount
	solvedBlockCount++
	
	if ( n < 0 )
		n := numValue[x,y]
	tempX := pX[x]
	tempY := pY[y]
	Click, %tempX%, %tempY%, 1
	Sleep, 50
	
	if ( n == 1 )
		send, {1}
	else if ( n == 2 )
		send, {2}
	else if ( n == 3 )
		send, {3}
	else if ( n == 4 )
		send, {4}
	else if ( n == 5 )
		send, {5}
	else if ( n == 6 )
		send, {6}
	else if ( n == 7 )
		send, {7}
	else if ( n == 8 )
		send, {8}
	else if ( n == 9 )
		send, {9}
	
	Sleep, 50
}

optionCheck(x,y) {
	global numCount, numValue, numValueOption, sudokuLevel
	if ( numValue[x, y] > 0 ) {
		while ( A_Index <= numCount + 1 , k := A_Index - 1 )
			numValueOption[ x, y, k ] := 0
		return
	}
	
	while ( A_Index <= numCount , k := A_Index )
		numValueOption[ x, y, k ] := 1
	
	while ( A_Index <= numCount , xy0 := A_Index - 1 ) {
		if ( numValue[ xy0, y ] > 0 )
			numValueOption[ x, y, numValue[ xy0, y ] ] := 0
		if ( numValue[ x, xy0 ] > 0 )
			numValueOption[ x, y, numValue[ x, xy0 ] ] := 0
	}
	
	while ( A_Index <= sudokuLevel , x0 := x - mod( x, sudokuLevel ) + A_Index - 1 )
	while ( A_Index <= sudokuLevel , y0 := y - mod( y, sudokuLevel ) + A_Index - 1 )
	{
		if ( numValue[ x0, y0 ] > 0 )
			numValueOption[ x, y, numValue[ x0, y0 ] ] := 0
	}
	
	numValueOption[ x, y, 0 ] := 0
	while ( A_Index <= numCount , k := A_Index )
		numValueOption[ x, y, 0 ] += numValueOption[ x, y, k ]
}

optionRemoveFromOthers(x,y) {
	global numCount, numValue, numValueOption, sudokuLevel
	if ( numValue[x, y] <= 0 )
		return
	
	while ( A_Index <= numCount , xy0 := A_Index - 1 ) {
		if ( numValueOption[ xy0, y, numValue[ x, y ] ] > 0 ) {
			numValueOption[ xy0, y, numValue[ x, y ] ] := 0
			numValueOption[ xy0, y, 0 ]--
		}
		if ( numValueOption[ x, xy0, numValue[ x, y ] ] > 0 ) {
			numValueOption[ x, xy0, numValue[ x, y ] ] := 0
			numValueOption[ x, xy0, 0 ]--
		}
	}
	
	while ( A_Index <= sudokuLevel , x0 := x - mod( x, sudokuLevel ) + A_Index - 1 )
	while ( A_Index <= sudokuLevel , y0 := y - mod( y, sudokuLevel ) + A_Index - 1 )
	{
		if ( numValueOption[ x0, y0, numValue[ x, y ] ] > 0 ) {
			numValueOption[ x0, y0, numValue[ x, y ] ] := 0
			numValueOption[ x0, y0, 0 ]--
		}
	}
	
}


F6::						; POSITION SCAN & TEXT VALUE TEST
{
MouseGetPos, MouseX, MouseY
Click, -50, 0, 0, Rel
tempX := MouseX
tempY := MouseY

; ------ Corner Lock-On
color := 0xFFFFFF
while ( A_Index<=100 && color > 0x000000 )
{
	tempX := tempX + 1
	PixelGetColor, color, %tempX% , %tempY% , RGB
	if (GetKeyState("Control", "P") || A_Index == 100)
		return
}

while ( A_Index<=100 && color < 0xFFFFFF )
{
	tempY := tempY - 1
	PixelGetColor, color, %tempX% , %tempY% , RGB
	if (GetKeyState("Control", "P") || A_Index == 100)
		return
}
tempY := tempY + 1

pX[0] := tempX + cornerTopLeft[1]
pY[0] := tempY + cornerTopLeft[2]
while ( A_Index<=10, i:=A_Index )
{
	pX[i] := pX[0] + blockSpacing[1] * i
	pY[i] := pY[0] + blockSpacing[2] * i
	tempX := pX[i]
	tempY := pY[i]
	Click, %tempX%, %tempY%, 0
}

tempX := pX[0] + 20
tempY := pY[0] + 20
Click, %tempX%, %tempY%, 0

return
}


F4::						; Initialization REMADE
{
	
	;SplashTextOn, 400, 60, SplashWindow,
	;WinMove, SplashWindow, , 966, 30
	difference := 0
	temp0 := numCount + 1
	temp1 := 1
	temp2 := 2
	
	; ------ Getting Locations
	Progress, b w400 x966 y30 cb00CCFF ct4488FF cw505050  R0-%numCount% P0,, Starting
	mouseP := []
	while ( A_Index <= numCount + 1 , i := A_Index - 1 ) {
		MouseGetPos, mouseX, mouseY
		mouseP[i,0] := mouseX
		mouseP[i,1] := mouseY
		
		
		if ( i == numCount )
			Progress, %i%,, Now CLICK outside the board
		else
			Progress, %i%,, Now CLICK on %A_Index%
		
		KeyWait, LButton, D
		KeyWait, LButton
	}
	
	
	; ------ Corner Lock-On
	Progress, b w400 x966 y30 cb00CCFF ct4488FF cw505050  R0-2 P0,, Corner Lock-On
	;ControlSetText, Static1, Locking On The TL Corner, SplashWindow
	tempX := mouseP[0,0]
	tempY := mouseP[0,1]
	currentPixel := 3
	while ( A_Index <= 120 && 1 - GetKeyState("Control","p") ) {
		PixelGetColor, color, %tempX% , %tempY% , RGB
		if ( color == colorBG[currentPixel-1] )
			currentPixel--
		if ( currentPixel == 3 )
			tempY -= 2
		if ( currentPixel == 2 )
			tempY--
		if ( currentPixel == 1 ) {
			tempY++
			currentPixel := 2
			Progress, 1
			break
		}
	}
	while ( A_Index <= 120 && 1 - GetKeyState("Control","p") ) {
		PixelGetColor, color, %tempX% , %tempY% , RGB
		if ( color == colorBG[currentPixel-1] )
			currentPixel--
		if ( currentPixel == 2 )
			tempX -= 10
		if ( currentPixel == 1 ) {
			while ( A_Index <= 10 ) {
				tempX++
				PixelGetColor, color, %tempX% , %tempY% , RGB
				if ( color == colorBG[currentPixel+1] )
					break
			}
			Progress, 2
			break
		}
	}
	
	
	; ------ Flushing Coordinates
	temp0 := numCount + 1
	Progress, b w400 x966 y30 cb00CCFF ct4488FF cw505050  R0-%temp0% P0,, Flushing Coordinates
	;ControlSetText, Static1, Flushing Coordinates, SplashWindow
	pX[0] := tempX + cornerTopLeft[1]
	pY[0] := tempY + cornerTopLeft[2]
	while ( A_Index<=10, i:=A_Index )
	{
		pX[i] := pX[0] + blockSpacing[1] * i
		pY[i] := pY[0] + blockSpacing[2] * i
		Progress, %i%
	}
	tempX := pX[8] - cornerTopLeft[1] + 72
	tempY := pY[0] - cornerTopLeft[2] + 12
	Click, %tempX%, %tempY%, 0
	
	
	; ------ Locking Scan Positions
	Progress, b w400 x966 y30 cb00CCFF ct4488FF cw505050  R0-%temp0% P0,, Locking Scan Positions
	;ControlSetText, Static1, Locking Scan Positions, SplashWindow
	while ( A_Index<=numCount+1, i:=A_Index-1 ) {
		
		while ( A_Index<=numCount-1, x:=A_Index-1 )
			if ( pX[x] + blockSpacing[1] > mouseP[i,0] )
				break
		while ( A_Index<=numCount-1, y:=A_Index-1 )
			if ( pY[y] + blockSpacing[2] > mouseP[i,1] )
				break
		
		numScanBlock[i,0] := x
		numScanBlock[i,1] := y
		numScanBlockP[i,0] := pX[x]
		numScanBlockP[i,1] := pY[y]
		Progress, %A_Index%
	}
	
	
	; ------ Scanning Numbers - Polling Colors and Looking For Distinct Pixels
	txt = Scanning Numbers
	temp0 := numCount + 1
	Progress, b w400 x966 y30 cb00CCFF ct4488FF cw505050  R0-%temp0% P0, 0/%temp0%,%txt%
	SplashTextOff
	txt1 = Identified =
	txt2 = Looking For Distinct Pixels
	
	while ( A_Index <= numCount + 1 , i := A_Index - 1 )
		distinctPixelColorProperty[ i , 3 ] := 0
	
	distinctPixelColorCount := 0
	while ( A_Index<=blockSize[2], y:=A_Index-1 ) {
		while ( A_Index<=blockSize[1], x:=A_Index-1 ) {
			
			
			; ------ Polling Colors
			while ( A_Index <= numCount + 1 , i := A_Index - 1 ) {
				tempX := numScanBlockP[i,0] + x
				tempY := numScanBlockP[i,1] + y
				numPixelColor[i,x,y] := colorPicker( tempX , tempY )
				
				distinctPixelColorCheck[i,x,y] := 1
			}
			if GetKeyState("Control","p") {
				SplashTextOff
				Progress,OFF
				return
			}
			
			; ------ Looking For Distinct Pixels
			while ( A_Index <= numCount , i := A_Index - 1 )
			while ( A_Index <= numCount - i , j := A_Index + i ) {
				difference := abs( numPixelColor[i,x,y] - numPixelColor[j,x,y] )
				if ( difference <= colorMargin ) {
					distinctPixelColorCheck[i,x,y] := 0
					distinctPixelColorCheck[j,x,y] := 0
				}
			}
			j := 0
			while ( A_Index <= numCount + 1 , i := A_Index - 1 ) {
				if ( distinctPixelColorCheck[i,x,y] > 0 && distinctPixelColorProperty[ i , 3 ] == 0 ) {
					distinctPixelColorProperty[ i , 0 ] := x
					distinctPixelColorProperty[ i , 1 ] := y
					distinctPixelColorProperty[ i , 2 ] := numPixelColor[i,x,y]
					distinctPixelColorProperty[ i , 3 ] := 1
					distinctPixelColorCount++
					
					txt1 = %txt1% %i%
					j += distinctPixelColorCheck[i,x,y]
				}
			}
			txt = [ %x% , %y% ]
			Progress, %distinctPixelColorCount%, %txt1%, %txt%
			
			if ( distinctPixelColorCount >= numCount + 1 ) {
				txt = All %numCount% numbers are IDENTIFIED (+BG)
				while ( A_Index <= numCount + 1 , i := A_Index - 1 ) {
					tempX := distinctPixelColorProperty[ i , 0 ]
					tempY := distinctPixelColorProperty[ i , 1 ]
					color := distinctPixelColorProperty[ i , 2 ]
					txt = %txt%`nn(%i%) - pixel[ %tempX% , %tempY% ] - color<%color%>
				}
				Progress, %distinctPixelColorCount%,, All Numbers Are Identified
				break
			}
			
			if GetKeyState("Control","p") {
				SplashTextOff
				Progress,OFF
				return
			}
		}
		if ( distinctPixelColorCount >= numCount + 1 )
			break
	}
	if ( distinctPixelColorCount < numCount + 1 ) {
		txt = Could NOT Identify :
		while (A_Index<=numCount+1,i:=A_Index-1)
			if ( distinctPixelColorProperty[ i , 3 ] == 0 )
				txt = %txt% %i%
		Progress, %distinctPixelColorCount%,, %txt%
		Sleep, 2000
		Progress,OFF
		return
	}
	
	
	; ------ Number Constant Identifier [OLD]
	if (0)
	while ( 1 - GetKeyState("Control","p") ) {
		Sleep, 250
		MouseGetPos, mouseX, mouseY
		while ( A_Index<=numCount-1, x:=A_Index-1 )
			if ( pX[x] + blockSpacing[1] > mouseX )
				break
		while ( A_Index<=numCount-1, y:=A_Index-1 )
			if ( pY[y] + blockSpacing[2] > mouseY )
				break
		
		while ( A_Index <= numCount + 1 , i := A_Index - 1 ) {
			tempX := pX[x] + distinctPixelColorProperty[i,0]
			tempY := pY[y] + distinctPixelColorProperty[i,1]
			color := colorPicker( tempX , tempY )
			if ( color == distinctPixelColorProperty[i,2] )
				break
		}
		tempX := pX[x]
		tempY := pY[y]
		
		ControlSetText, Static1, [%x% %y%] = <%i%>`np[%tempX% %tempY%] , SplashWindow
		
	}
	
	; ------ Reading The Board
	txt = Report`n
	temp0 := numCount**2
	Progress, b w400 x966 y30 cb00CCFF ct4488FF cw505050  R0-%temp0% P0,,Reading
	;ControlSetText, Static1, Reading The Board`n[=========], SplashWindow
	while ( A_Index <= numCount , y := A_Index - 1 ) {
		while ( A_Index <= numCount , x := A_Index - 1 ) {
			
			while ( A_Index <= numCount + 1 , i := A_Index - 1 ) {
				tempX := pX[x] + distinctPixelColorProperty[i,0]
				tempY := pY[y] + distinctPixelColorProperty[i,1]
				color := colorPicker( tempX , tempY )
				difference := abs( color - distinctPixelColorProperty[i,2] )
				if ( difference <= colorMargin )
					break
			}
			numValue[x,y] := i
			if ( i >= 10 )
				txt = %txt%    %X%
			else if ( i == 0 )
				txt = %txt%    ..
			else
				txt = %txt%    %i%
			
			temp0 := y * numCount + x
			Progress, %temp0%
			
		}
		txt = %txt%`n
		;ControlSetText, Static1,%txt1%, SplashWindow
	}
	Progress, ,,Done -> Reporting
	MsgBox, %txt%
	SplashTextOff
	Progress,OFF
	
	
return
}


; ------------ Some Functions/Test Commands
{
F3::						; Report the State
txt = RE-REPORT`n
while ( A_Index <= numCount , y := A_Index - 1 ) {
	while ( A_Index <= numCount , x := A_Index - 1 ) {
		i := numValueOption[ x, y, 0 ]
		txt = %txt%    %i%
	}
	txt = %txt%`n
}
MsgBox, %txt%
return

F2::						; RE-REPORT
txt = RE-REPORT`n
while ( A_Index <= numCount , y := A_Index - 1 ) {
	while ( A_Index <= numCount , x := A_Index - 1 ) {
		i := numValue[x,y]
		if ( i >= 10 )
				txt = %txt%    %X%
			else if ( i == 0 )
				txt = %txt%    ..
			else
				txt = %txt%    %i%
	}
	txt = %txt%`n
}
MsgBox, %txt%
return
}


F1::						; SOLVING
{
Progress,OFF

; ------ (1) FIRST PASS - Counting Blocks & Check Options
solvedBlockCount := 0
while ( A_Index <= numCount , y := A_Index - 1 ) {
	while ( A_Index <= numCount , x := A_Index - 1 ) {
		if ( numValue[x, y] == 0 )
			optionCheck(x,y)
		else {
			solvedBlockCount++
			while ( A_Index <= numCount + 1 , i := A_Index - 1 )
				numValueOption[ x, y, i ] := 0
		}
	}
}


; ------ Repeating Solving Steps
temp0 := numCount**2
txt1 = %solvedBlockCount%/%temp0%
Progress, b w400 x966 y30 cb00CCFF ct4488FF cw505050  R0-%temp0% P0,%txt1%, Solving
while ( solvedBlockCount < numCount**2 ) {
	txt1 = %solvedBlockCount%/%temp0%
	Progress, %solvedBlockCount%, %txt1%
	
	; ------ RE-SCAN
	while ( A_Index <= numCount , y := A_Index - 1 ) {
		while ( A_Index <= numCount , x := A_Index - 1 ) {
			optionCheck(x,y)
		}
	}
	
	
	; ------ Set IF Only 1 Option
	while ( A_Index <= numCount , y := A_Index - 1 ) {
		while ( A_Index <= numCount , x := A_Index - 1 ) {
			
			if ( numValue[ x, y ] > 0 )
				continue
			
			if ( numValueOption[ x, y, 0 ] > 1 )
				continue
			
			while ( A_Index <= numCount , k := A_Index ) {
				if ( numValueOption[ x, y, k ] == 1 ) {
					numValue[x,y] := k
					setValue( x, y, k )
					;optionRemoveFromOthers(x,y)
					break
				}
			}
			
		}
	}
	if GetKeyState("Control","p")
		return
	
	; ------ Set Missing Numbers For Rows, Columns & Squares
	; ------ Rows
	while ( A_Index <= numCount , y := A_Index - 1 ) {
		while ( A_Index <= numCount , i := A_Index )
			optionGroupCount[i] := 0
		
		while ( A_Index <= numCount , x := A_Index - 1 ) {
			if ( numValue[ x, y ] == 0 ) {
				while ( A_Index <= numCount , i := A_Index )
					optionGroupCount[ i ] += numValueOption[ x, y, i ]
			}
		}
		while ( A_Index <= numCount , i := A_Index ) {
			if ( optionGroupCount[ i ] == 1 ) {
				while ( A_Index <= numCount , x := A_Index - 1 )
					if ( numValueOption[ x, y, i ] == 1 ) {
						numValue[ x, y ] := i
						setValue( x, y, i )
						;optionRemoveFromOthers(x,y)
						break
					}
			}
		}
	}
	if GetKeyState("Control","p")
		return
	
	; ------ Columns
	while ( A_Index <= numCount , x := A_Index - 1 ) {
		while ( A_Index <= numCount , i := A_Index )
			optionGroupCount[i] := 0
		
		while ( A_Index <= numCount , y := A_Index - 1 )
			if ( numValue[ x, y ] == 0 )
				while ( A_Index <= numCount , i := A_Index )
					optionGroupCount[ i ] += numValueOption[ x, y, i ]
				
		while ( A_Index <= numCount , i := A_Index ) {
			if ( optionGroupCount[ i ] == 1 ) {
				while ( A_Index <= numCount , y := A_Index - 1 )
					if ( numValueOption[ x, y, i ] == 1 ) {
						numValue[ x, y ] := i
						setValue( x, y, i )
						;optionRemoveFromOthers(x,y)
						break
					}
			}
		}
	}
	if GetKeyState("Control","p")
		return
	
	; ------ Squares
	while ( A_Index <= sudokuLevel , xK := A_Index - 1 ) {
	while ( A_Index <= sudokuLevel , yK := A_Index - 1 ) {
		
		while ( A_Index <= numCount , i := A_Index )
			optionGroupCount[i] := 0
		
		while ( A_Index <= sudokuLevel , x := sudokuLevel * xK + A_Index - 1 ) {
		while ( A_Index <= sudokuLevel , y := sudokuLevel * yK + A_Index - 1 ) {
			if ( numValue[x,y] == 0 ) {
				while ( A_Index <= numCount , i := A_Index )
					optionGroupCount[ i ] += numValueOption[ x, y, i ]
			}
		}
		}
		
		while ( A_Index <= numCount , i := A_Index ) {
			if ( optionGroupCount[ i ] == 1 ) {
				while ( A_Index <= sudokuLevel , x := sudokuLevel * xK + A_Index - 1 ) {
				while ( A_Index <= sudokuLevel , y := sudokuLevel * yK + A_Index - 1 ) {
					if ( numValueOption[ x, y, i ] >= 1 ) {
						numValue[ x, y ] := i
						setValue( x, y, i )
						;optionRemoveFromOthers(x,y)
						break
					}
				}
				}
			}
		}
	}
	}
	
	if GetKeyState("Control","p")
		return
	
}


return
}
