

; ------ Initialization
{
value := []
set := []
colorT := []
numValue := []
numValueBegin := []
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
colorBG := [ 0xF9F9FF , 0x666699 , 0xFFFFFF , 0x000000 ]
numScanBlock := []
numScanBlockP := []
colorMargin := 10
sudokuLevel := 3
blockClickOffset := [ 25, 25 ]
wigglePara := [4,8,20]
outputPos := []
output2D := []
output3D := []
misalignment := []
mouseP := []
optionGroupCount := []
combinationOutput := []
emptyCellProperty := []
checkCell := []
checkCellOption := []
emptyCellCount := 0



}



SetMouseDelay, -1
delay := 0
#SingleInstance force
^`::suspend
!`::reload
^!`::ExitApp
return


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

mouseWiggle(){
	return
}

colorPicker(x,y) {
	PixelGetColor, color, %x% , %y% , RGB
	
	temp0 := round( (color - mod( color , 0x10000 )) / 0x10000 )
	temp1 := round( (mod( color , 0x10000 ) - mod( color , 0x100 )) / 0x100 )
	temp2 := mod( color , 0x100 )
	color := temp0 + temp1 + temp2
	return color
	
}

setValue(x,y,n:=-1) {
	global pX, pY, blockClickOffset, numValue, solvedBlockCount
	solvedBlockCount++
	
	if ( n < 0 )
		n := numValue[x,y]
	tempX := pX[x] + 10
	tempY := pY[y] + 10
	Click, %tempX%, %tempY%, 1
	Sleep, 20
	
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
	
	Sleep, 20
}

optionCheck() {
	global numCount, numValue, numValueOption, sudokuLevel
	
	while ( A_Index <= numCount , x := A_Index - 1 ) {
	while ( A_Index <= numCount , y := A_Index - 1 ) {
		
		if ( numValue[x, y] > 0 ) {
			while ( A_Index <= numCount + 1 , k := A_Index - 1 )
				numValueOption[ x, y, k ] := 0
			continue
		}
		
		numValueOption[ x, y, 0 ] := 0
		while ( A_Index <= numCount , k := A_Index ) {
			numValueOption[ x, y, k ] := 1
		}
		
		while ( A_Index <= numCount , xy0 := A_Index - 1 ) {
			numValueOption[ x, y, numValue[ xy0, y ] ] := 0
			numValueOption[ x, y, numValue[ x, xy0 ] ] := 0
		}
		
		while ( A_Index <= sudokuLevel , x0 := x - mod( x, sudokuLevel ) + A_Index - 1 ) {
		while ( A_Index <= sudokuLevel , y0 := y - mod( y, sudokuLevel ) + A_Index - 1 ) {
			numValueOption[ x, y, numValue[ x0, y0 ] ] := 0
		}
		}
		
		numValueOption[ x, y, 0 ] := 0
		while ( A_Index <= numCount , k := A_Index )
			numValueOption[ x, y, 0 ] += numValueOption[ x, y, k ]
		
	}
	}
	
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

positionLockOn(xS, yS, d:=1, colorLevel:=4, colorLookup:=-1) {
	global colorBG, scanRange, outputPos
	
	if ( colorLookup < 0 )
		colorLookup := colorBG[ colorLevel ]
	
	found := 0
	while ( A_Index <= scanRange[1] && found == 0 , y := yS + d*A_Index ) {
		while ( A_Index <= scanRange[0] && found == 0 , x := xS + d*A_Index ) {
			PixelGetColor, color, %x% , %y% , RGB
			if ( colorLevel == 4 && color == colorLookup )
				found := 1
			if ( colorLevel == 3 && color <> colorLookup )
				found := 1
		}
	}
	outputPos[1] := y - d
	
	found := 0
	while ( A_Index <= scanRange[0] && found == 0 , x := xS + d*A_Index ) {
		while ( A_Index <= scanRange[1] && found == 0 , y := yS + d*A_Index ) {
			PixelGetColor, color, %x% , %y% , RGB
			if ( colorLevel == 4 && color == colorLookup )
				found := 1
			if ( colorLevel == 3 && color <> colorLookup )
				found := 1
		}
	}
	outputPos[0] := x - d
	
}

txtBoardReport(progressDisplay:=-2, emptyChar:=" ", spaceChar:=" ", errorChar:="X") {
	global numValue, numCount, sudokuLevel
	vLine := "|"
	hLine := "-"
	newLine := "`n"
	txt := ""
	while ( A_Index <= numCount , y := A_Index - 1 ) {
		while ( A_Index <= numCount , x := A_Index - 1 ) {
			
			if ( numValue[x,y] >= numCount + 1 )
				txt := txt errorChar
			else if ( numValue[x,y] <= 0 )
				txt := txt emptyChar
			else
				txt := txt numValue[x,y]
			
			if ( x == numCount - 1 )
				txt := txt newLine
			else if ( mod( x , sudokuLevel ) + 1 == sudokuLevel )
				txt := txt spaceChar vLine spaceChar
			else
				txt := txt spaceChar
			
		}
		if ( mod( y , sudokuLevel ) + 1 == sudokuLevel && y < numCount - 1 ) {
			while ( A_Index <= sudokuLevel + (sudokuLevel) * StrLen(spaceChar) )
				txt := txt hLine
			txt := txt vLine
			while ( A_Index <= sudokuLevel + (sudokuLevel+1) * StrLen(spaceChar) )
				txt := txt hLine
			txt := txt vLine
			while ( A_Index <= sudokuLevel + (sudokuLevel) * StrLen(spaceChar) )
				txt := txt hLine
			txt := txt newLine
		}
	}
	
	if ( progressDisplay >= 0 ) {
		temp0 := numCount**2
		Progress, %progressDisplay%,,`n%txt%
	}
	return %txt%
}


optionCheckAdvanced(x:=-1, y:=-1, reset:=0) {
	global numCount, numValue, numValueOption, sudokuLevel
	
	if ( x < 0 || x >= numCount || y < 0 || y >= numCount ) {
		while ( A_Index <= numCount , x := A_Index - 1 ) {
		while ( A_Index <= numCount , y := A_Index - 1 ) {
			optionCheckAdvanced(x,y,reset)
		}
		}
	}
	else {
		
		if ( numValue[x, y] > 0 ) {
			while ( A_Index <= numCount + 1 , k := A_Index - 1 )
				numValueOption[ x, y, k ] := 0
			return
		}
		
		
		while ( A_Index <= numCount && reset == 1 , k := A_Index ) {
			numValueOption[ x, y, k ] := 1
		}
		
		while ( A_Index <= numCount , xy0 := A_Index - 1 ) {
			numValueOption[ x, y, numValue[ xy0, y ] ] := 0
			numValueOption[ x, y, numValue[ x, xy0 ] ] := 0
		}
		
		while ( A_Index <= sudokuLevel , x0 := x - mod( x, sudokuLevel ) + A_Index - 1 ) {
		while ( A_Index <= sudokuLevel , y0 := y - mod( y, sudokuLevel ) + A_Index - 1 ) {
			numValueOption[ x, y, numValue[ x0, y0 ] ] := 0
		}
		}
		
		numValueOption[ x, y, 0 ] := 0
		while ( A_Index <= numCount , k := A_Index )
			numValueOption[ x, y, 0 ] += numValueOption[ x, y, k ]
		
	}
	
}


updateCheckAdvanced() {
	return
}


F4::						; Initialization REMADE For WebSudoku.com
{

initialPos := []											; [2D]  Index: 0-TL0, 1-TL1, 2-BR1 / 0-x, 1-y
initialBlock := []
scanRange := []
lockOnPos := []
initialBlock[0, 0] := 0
initialBlock[0, 1] := 0
initialBlock[1, 0] := 0
initialBlock[1, 1] := 0

temp0 := numCount
Progress, b w400 x966 y712 cb00CCFF ct4488FF cw505050  R0-3 P0,, Starting
Progress, , ,Mouse on the Top Left block

txt := "[ " initialBlock[0, 0] " , " initialBlock[0, 1] " ]"
Progress, , ,%txt%

i := -1
while ( i <= 2 ) {
	Sleep, 25
	
	if ( GetKeyState("LButton","p") || i == -1 ) {
		i++
		MouseGetPos, mouseX, mouseY
		initialPos[i, 0] := mouseX
		initialPos[i, 1] := mouseY
		KeyWait, LButton
	}
	
	tempX := 0
	tempY := 0
	if GetKeyState("W","p")
		tempY := -1
	if GetKeyState("A","p")
		tempX := -1
	if GetKeyState("S","p")
		tempY := 1
	if GetKeyState("D","p")
		tempX := 1
	
	if ( tempX <> 0 || tempY <> 0 ) {
		if ( i == 0 ) {
		
		if ( initialBlock[0,0] + tempX >= 0 && initialBlock[0,0] + tempX <= numCount-1 )
			initialBlock[0,0] += tempX
		if ( initialBlock[0,1] + tempY >= 0 && initialBlock[0,1] + tempY <= numCount-1 )
			initialBlock[0,1] += tempY
		
		}
		else {
		
		if (initialBlock[1,0]+tempX>=-initialBlock[0,0] && initialBlock[1,0]+tempX<=numCount-1-initialBlock[0,0])
			initialBlock[1,0] += tempX
		if (initialBlock[1,1]+tempY>=-initialBlock[0,1] && initialBlock[1,1]+tempY<=numCount-1-initialBlock[0,1])
			initialBlock[1,1] += tempY
		
		}
	}
	
	txt := "[ " initialBlock[0,0] " , " initialBlock[0,1] " ]"
	if ( i >= 1 )
		txt := txt "  +  [ " initialBlock[1,0] " , " initialBlock[1,1] " ]"
	Progress, %i%, ,%txt%
	
	KeyWait, W
	KeyWait, A
	KeyWait, S
	KeyWait, D
}

; ------ Locking On The Blocks
Progress, b w400 x966 y712 cb00CCFF ct4488FF cw505050  R0-3 P0,, Scanning 1st Pass

scanRange[0] := initialPos[2, 0] - initialPos[1, 0]
scanRange[1] := initialPos[2, 1] - initialPos[1, 1]
;MsgBox, % "scanRange = " scanRange[0] " , " scanRange[1]
PixelGetColor, color, initialPos[0,0] , initialPos[0,1] , RGB
colorBG[3] := color

positionLockOn( initialPos[0, 0] , initialPos[0, 1] , 1 , 3 )
lockOnPos[0, 0] := outputPos[0]
lockOnPos[0, 1] := outputPos[1]
Progress, 1, ,

positionLockOn( initialPos[1, 0] , initialPos[1, 1] , 1 , 3 )
lockOnPos[1, 0] := outputPos[0]
lockOnPos[1, 1] := outputPos[1]
Progress, 2, ,

; ---- blockSize: 1-x, 2-y
positionLockOn( initialPos[2, 0] , initialPos[2, 1] , -1 , 3 )
blockSize[1] := outputPos[0] - lockOnPos[1, 0] + 1
blockSize[2] := outputPos[1] - lockOnPos[1, 1] + 1
Progress, 3, ,


; ------ Checking For Discrepancy
if false {

tempA := blockSize[2] * blockSize[1]
Progress, b w400 x966 y712 cb00CCFF ct4488FF cw505050  R0-%tempA% P0,, Checking For Discrepancy

tempA := 0
discrepancy := 0
while ( A_Index <= blockSize[2] && discrepancy == 0 , y := A_Index - 1 ) {
	while ( A_Index <= blockSize[1] && discrepancy == 0 , x := A_Index - 1 ) {
		tempX := lockOnPos[0, 0] + x
		tempY := lockOnPos[0, 1] + y
		PixelGetColor, color0, %tempX% , %tempY% , RGB
		tempX := lockOnPos[1, 0] + x
		tempY := lockOnPos[1, 1] + y
		PixelGetColor, color1, %tempX% , %tempY% , RGB
		if ( color0 <> color1 )
			discrepancy++
		
		tempA++
		Progress, %tempA%
	}
}
if ( discrepancy == 0 )
	MsgBox, Discrepancy - None
else 
	MsgBox, Discrepancy - FOUND!!!

}




tempX := lockOnPos[1,0] - lockOnPos[0,0]
tempY := lockOnPos[1,1] - lockOnPos[0,1]

tempX += floor( initialBlock[0,0] / sudokuLevel )
tempX -= floor( (initialBlock[0,0]+initialBlock[1,0]) / sudokuLevel )
misalignment[0] := mod(tempX, initialBlock[1,0])
misalignment[1] := mod(tempY, initialBlock[1,1])

txt := "Reporting_2`n"
txt := txt "Corrected Pixel Difference = [ " tempX " , " tempY "]`n"
txt := txt "Over Block Difference = [ " initialBlock[1,0] " , " initialBlock[1,1] " ]`n"
txt := txt "Block Separation = [ " tempX / initialBlock[1,0] " , " tempY / initialBlock[1,1] " ]`n"
txt := txt "Mod = [ " misalignment[0] " , " misalignment[1] " ]`n"
if ( misalignment[0] <> 0 || misalignment[1] <> 0 )
	txt := txt "MISALIGNMENT STILL PERSISTED!!!!"
;MsgBox, %txt%
if ( misalignment[0] <> 0 || misalignment[1] <> 0 ) {
	Progress, , ,MISALIGNMENT DETECTED!!!!
	return
}


; ------ Flushing Coordinates
; ---- blockSpacing: 1-x, 2-y
blockSpacing[1] := round( tempX / initialBlock[1,0] )
blockSpacing[2] := round( tempY / initialBlock[1,1] )
pX[0] := lockOnPos[0,0] - initialBlock[0,0] * blockSpacing[1] - floor( initialBlock[0,0] / sudokuLevel )
pY[0] := lockOnPos[0,1] - initialBlock[0,1] * blockSpacing[2]

while ( A_Index <= numCount - 1 , i := A_Index ) {
	pX[i] := pX[0] + blockSpacing[1] * i + floor( i / sudokuLevel )
	pY[i] := pY[0] + blockSpacing[2] * i
}

Progress, , , Done Flushing Coordinates
Sleep, 500


;Progress,OFF
;return
}


F3::						; Number Scan
{

; ------ Getting Digit Locations
{

Progress, b w400 x966 y712 cb00CCFF ct4488FF cw505050  R0-%numCount% P0,,Getting Digit Locations
while ( A_Index <= numCount + 1 , i := A_Index - 1 ) {
	MouseGetPos, mouseX, mouseY
	mouseP[i,0] := mouseX
	mouseP[i,1] := mouseY
	if ( i < numCount )
		Progress, %i%,, Now <click> on a %A_Index% block
	else
		Progress, %i%,, Now <click> OUTSIDE the board
	
	KeyWait, LButton, D
	KeyWait, LButton
}

}


; ------ Locking Scan Positions
{

Progress, b w400 x966 y712 cb00CCFF ct4488FF cw505050  R0-%numCount% P0,, Locking Scan Positions
while ( A_Index <= numCount + 1 , i := A_Index - 1 ) {
	
	while ( A_Index <= numCount - 1 , x := A_Index - 1 )
		if ( pX[x] + blockSpacing[1] > mouseP[i,0] )
			break
	while ( A_Index <= numCount - 1 , y := A_Index - 1 )
		if ( pY[y] + blockSpacing[2] > mouseP[i,1] )
			break
	
	numScanBlock[i,0] := x
	numScanBlock[i,1] := y
	numScanBlockP[i,0] := pX[x]
	numScanBlockP[i,1] := pY[y]
	Progress, %A_Index%
}

}


; ------ Scanning Numbers - Polling Colors and Looking For Distinct Pixels
{

txt = Scanning Numbers
temp0 := numCount + 1
Progress, b w400 x966 y712 cb00CCFF ct4488FF cw505050  R0-%temp0% P0, 0/%temp0%,%txt%
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
	Sleep, 1000
	Progress,OFF
	return
}

}
Progress,,, Ready to Solve
;return
Progress,,, Auto Solve
Sleep 500
}


F2::						; Number Read
{
; ------ Reading The Board
{

txt = Report`n`n
temp0 := numCount**2
Progress, b w400 x966 y712 cb00CCFF ct4488FF cw505050  R0-%temp0% P0,,Reading
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
			txt = %txt% X
		else if ( i <= 0 )
			txt = %txt% _
		else
			txt = %txt% %i%
		
		temp0 := y * numCount + x
		Progress, %temp0%
		
		if GetKeyState("Control","p")
			return
	}
	txt = %txt%`n
}
numValueBegin := numValue
Progress,,,Done -> Reporting
txt := txtBoardReport()
Progress, b w246 x1120 y520 cb00CCFF ct4488FF cw505050 R0-1 P0,,`n%txt%,,Source Code Pro
}


;Progress,OFF
Sleep, 100
}


F1::						; SOLVING
{

; ------ Counting Blocks & Initializing numValueOption
solvedBlockCount := 0
while ( A_Index <= numCount , y := A_Index - 1 ) {
while ( A_Index <= numCount , x := A_Index - 1 ) {
	if ( numValue[x, y] > 0 )
		solvedBlockCount++
}
}


temp0 := numCount**2
txt1 = %solvedBlockCount%/%temp0%
;Progress, b w400 x966 y692 cb00CCFF ct4488FF cw505050  R0-%temp0% P0,%txt1%, Solving
txt := txtBoardReport()
Progress, b w246 x1120 y520 cb00CCFF ct4488FF cw505050 R0-%temp0% P0,,Solving`n%txt%,,Source Code Pro
Progress, %solvedBlockCount%
Sleep, 1000
advancedCheck := 1

; ------ Initial Option Check
optionCheckAdvanced(-1, -1, 1)

; ------ Repeating Solving Steps
while ( solvedBlockCount < numCount**2 , solveLoop := A_Index ) {
	
	;Progress, %solvedBlockCount%, %solvedBlockCount%/%temp0%
	
	txt := txtBoardReport()
	Progress, %solvedBlockCount%,,Solving - %solveLoop%`n%txt%
	;Sleep, 1000
	
	; ------ Set IF Only 1 Option
	{
	optionCheckAdvanced()
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
					optionCheckAdvanced()
					;optionRemoveFromOthers(x,y)
				}
			}
			
		}
	}
	if GetKeyState("Control","p")
		return
	}
	
	; ------ Set Missing Numbers For Rows, Columns & Squares
	; ------ Rows
	{
	optionCheckAdvanced()
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
						optionCheckAdvanced()
						;optionRemoveFromOthers(x,y)
					}
			}
			else if ( optionGroupCount[ i ] > 1 && advancedCheck == 1 ) {
				; found more than 1
				; check if they belong in 1 block {compare First & Last}
				xF := numCount - 1
				xL := 0
				while ( A_Index <= numCount , x := A_Index - 1 ) {
					if ( numValueOption[ x, y, i ] == 1 && xF > x )
						xF := x
					if ( numValueOption[ x, y, i ] == 1 && xL < x )
						xL := x
				}
				if ( floor( xF / sudokuLevel ) == floor( xL / sudokuLevel ) ) {
					; they are in the same Block
					; remove other numValueOption in that Block
					while ( A_Index <= sudokuLevel , yB := y - mod(y, sudokuLevel) + A_Index - 1 ) {
						if ( yB <> y ) {
						while ( A_Index <= sudokuLevel , xB := xF - mod(xF, sudokuLevel) + A_Index - 1 )
							numValueOption[ xB, yB, i ] := 0
						}
					}
					txt := "Advanced Check`nRow [" y "]`nNum <" i ">`nxF = " xF "`nxL = " xL
					;MsgBox, %txt%
				}
			}
		}
	}
	if GetKeyState("Control","p")
		return
	}
	
	; ------ Columns
	{
	optionCheckAdvanced()
	while ( A_Index <= numCount , x := A_Index - 1 ) {
		while ( A_Index <= numCount , i := A_Index )
			optionGroupCount[i] := 0
		
		while ( A_Index <= numCount , y := A_Index - 1 ) {
			if ( numValue[ x, y ] == 0 ) {
				while ( A_Index <= numCount , i := A_Index )
					optionGroupCount[ i ] += numValueOption[ x, y, i ]
			}
		}
		while ( A_Index <= numCount , i := A_Index ) {
			if ( optionGroupCount[ i ] == 1 ) {
				while ( A_Index <= numCount , y := A_Index - 1 )
					if ( numValueOption[ x, y, i ] == 1 ) {
						numValue[ x, y ] := i
						setValue( x, y, i )
						optionCheckAdvanced()
						;optionRemoveFromOthers(x,y)
					}
			}
			else if ( optionGroupCount[ i ] > 1 && advancedCheck == 1 ) {
				; found more than 1
				; check if they belong in 1 block {compare First & Last}
				yF := numCount - 1
				yL := 0
				while ( A_Index <= numCount , y := A_Index - 1 ) {
					if ( numValueOption[ x, y, i ] == 1 && yF > y )
						yF := y
					if ( numValueOption[ x, y, i ] == 1 && yL < y )
						yL := y
				}
				if ( floor( yF / sudokuLevel ) == floor( yL / sudokuLevel ) ) {
					; they are in the same Block
					; remove other numValueOption in that Block
					while ( A_Index <= sudokuLevel , xB := x - mod(x, sudokuLevel) + A_Index - 1 ) {
						if ( xB <> x ) {
						while ( A_Index <= sudokuLevel , yB := yF - mod(yF, sudokuLevel) + A_Index - 1 )
							numValueOption[ xB, yB, i ] := 0
						}
					}
				}
			}
		}
	}
	if GetKeyState("Control","p")
		return
	}
	
	; ------ Squares
	{
	optionCheckAdvanced()
	while ( A_Index <= sudokuLevel , xK := A_Index - 1 ) {
	while ( A_Index <= sudokuLevel , yK := A_Index - 1 ) {
		
		while ( A_Index <= numCount , i := A_Index ) {
			optionGroupCount[i] := 0
		}
		
		while ( A_Index <= sudokuLevel , x := sudokuLevel * xK + A_Index - 1 ) {
		while ( A_Index <= sudokuLevel , y := sudokuLevel * yK + A_Index - 1 ) {
			if ( numValue[x, y] == 0 ) {
				while ( A_Index <= numCount , i := A_Index )
					optionGroupCount[ i ] += numValueOption[ x, y, i ]
			}
		}
		}
		
		while ( A_Index <= numCount , i := A_Index ) {
			if ( optionGroupCount[ i ] == 1 ) {
				while ( A_Index <= sudokuLevel , x := sudokuLevel * xK + A_Index - 1 ) {
				while ( A_Index <= sudokuLevel , y := sudokuLevel * yK + A_Index - 1 ) {
					if ( numValueOption[ x, y, i ] == 1 ) {
						numValue[ x, y ] := i
						setValue( x, y, i )
						optionCheckAdvanced()
						;optionRemoveFromOthers(x,y)
					}
				}
				}
			}
			else if ( optionGroupCount[ i ] > 1 && advancedCheck == 1 ) {
				; found more than 1
				; check if they line up / compare First & Last
				xF := numCount - 1
				xL := 0
				yF := numCount - 1
				yL := 0
				while ( A_Index <= sudokuLevel , x := sudokuLevel * xK + A_Index - 1 ) {
				while ( A_Index <= sudokuLevel , y := sudokuLevel * yK + A_Index - 1 ) {
					if ( numValueOption[ x, y, i ] == 1 ) {
						if ( xF > x )
							xF := x
						if ( xL < x )
							xL := x
						if ( yF > y )
							yF := y
						if ( yL < y )
							yL := y
					}
				}
				}
				
				if ( xF == xL ) {
					; they are in the same Column
					while ( A_Index <= numCount , y := A_Index - 1 ) {
						if ( y < yF || y > yL )
							numValueOption[ xF, y, i ] := 0
					}
				}
				if ( yF == yL ) {
					; they are in the same Row
					while ( A_Index <= numCount , x := A_Index - 1 ) {
						if ( x < xF || x > xL )
							numValueOption[ x, yF, i ] := 0
					}
				}
				
			}
		}
	}
	}
	if GetKeyState("Control","p")
		return
	}
	
	optionCheckAdvanced()
	; ------ Advanced Algorithms for Evil Boards (once every 5 loops)
	if ( mod( solveLoop , 5 ) == 0 ) {
		; Looking for filled groups of cells
		
		; Going through Boxes
		while ( A_Index <= sudokuLevel , xK := A_Index - 1 ) {
		while ( A_Index <= sudokuLevel , yK := A_Index - 1 ) {
			
			; Counting emptyCellCount & Populating emptyCell & emptyCellProperty
			emptyCellCount := 0
			while ( A_Index <= sudokuLevel , x := xK * sudokuLevel + A_Index - 1 ) {
			while ( A_Index <= sudokuLevel , y := yK * sudokuLevel + A_Index - 1 ) {
				if ( numValue[x,y] == 0 ) {
					emptyCellProperty[emptyCellCount,0] := x
					emptyCellProperty[emptyCellCount,1] := y
					emptyCellCount++
				}
			}
			}
			; Going though group sizes
			while ( A_Index <= emptyCellCount - 1 , checkCellCount := A_Index + 1 ) {
				; Generating a combination of cells
				while ( combinationGenerator(emptyCellCount,checkCellCount,A_Index-1) > 0 ) {
					checkCell := combinationOutput
					while ( A_Index <= numCount + 1 , j := A_Index - 1 )
						checkCellOption[j] := 0
					; add the number of each option
					while ( A_Index <= checkCellCount , i := A_Index - 1 ) {
						x := emptyCellProperty[checkCell[i],0]
						y := emptyCellProperty[checkCell[i],1]
						while ( A_Index <= numCount , j := A_Index )
							checkCellOption[j] += numValueOption[x,y,j]
					}
					; count the total number of options
					while ( A_Index <= numCount , j := A_Index ) {
						if ( checkCellOption[j] > 0 )
							checkCellOption[0]++
					}
					; check if the number of options is the same as the number of check cells
					if ( checkCellOption[0] == checkCellCount ) {
						; FOUND -> Remove values from options of other cells in same box
						while ( A_Index <= sudokuLevel , x := xK * sudokuLevel + A_Index - 1 ) {
						while ( A_Index <= sudokuLevel , y := yK * sudokuLevel + A_Index - 1 ) {
							; avoid the cells being checked
							skip := 0
							while ( A_Index <= checkCellCount && skip == 0, i := A_Index - 1 ) {
								x0 := emptyCellProperty[checkCell[i],0]
								y0 := emptyCellProperty[checkCell[i],1]
								if ( x == x0 && y == y0 )
									skip := 1
							}
							if ( skip > 0 || numValue[x,y] > 0 )
								continue
							; set numValueOption of other cells
							numValueOption[x,y,0] := 0
							while ( A_Index <= numCount , j := A_Index ) {
								if ( checkCellOption[j] > 0 )
									numValueOption[x,y,j] := 0
								numValueOption[x,y,0] += numValueOption[x,y,j]
							}
						}
						}
					}
				}
			}
		}
		}
		; Going through Rows
		while ( A_Index <= numCount , y := A_Index - 1 ) {
			; Counting emptyCellCount & Populating emptyCell & emptyCellProperty
			emptyCellCount := 0
			while ( A_Index <= numCount , x := A_Index - 1 ) {
				if ( numValue[x,y] == 0 ) {
					emptyCellProperty[emptyCellCount,0] := x
					emptyCellProperty[emptyCellCount,1] := y
					emptyCellCount++
				}
			}
			; Going though group sizes
			while ( A_Index <= emptyCellCount - 1 , checkCellCount := A_Index + 1 ) {
				; Generating a combination of cells
				while ( combinationGenerator(emptyCellCount,checkCellCount,A_Index-1) > 0 ) {
					checkCell := combinationOutput
					while ( A_Index <= numCount + 1 , j := A_Index - 1 )
						checkCellOption[j] := 0
					; add the number of each option
					while ( A_Index <= checkCellCount , i := A_Index - 1 ) {
						x := emptyCellProperty[checkCell[i],0]
						y := emptyCellProperty[checkCell[i],1]
						while ( A_Index <= numCount , j := A_Index )
							checkCellOption[j] += numValueOption[x,y,j]
					}
					; count the total number of options
					while ( A_Index <= numCount , j := A_Index ) {
						if ( checkCellOption[j] > 0 )
							checkCellOption[0]++
					}
					; check if the number of options is the same as the number of check cells
					if ( checkCellOption[0] == checkCellCount ) {
						; FOUND -> set numValueOption of other cells
						i := 0
						while ( A_Index <= numCount , x := A_Index - 1 ) {
							if ( x == emptyCellProperty[checkCell[i],0] ) {
								i++
								if ( i >= checkCellCount )
									i := 0
								continue
							}
							numValueOption[x,y,0] := 0
							while ( A_Index <= numCount , j := A_Index ) {
								if ( checkCellOption[j] > 0 )
									numValueOption[x,y,j] := 0
								numValueOption[x,y,0] += numValueOption[x,y,j]
							}
						}
					}
				}
			}
		}
		; Going through Columns
		while ( A_Index <= numCount , x := A_Index - 1 ) {
			; Counting emptyCellCount & Populating emptyCell & emptyCellProperty
			emptyCellCount := 0
			while ( A_Index <= numCount , y := A_Index - 1 ) {
				if ( numValue[x,y] == 0 ) {
					emptyCellProperty[emptyCellCount,0] := x
					emptyCellProperty[emptyCellCount,1] := y
					emptyCellCount++
				}
			}
			; Going though group sizes
			while ( A_Index <= emptyCellCount - 1 , checkCellCount := A_Index + 1 ) {
				; Generating a combination of cells
				while ( combinationGenerator(emptyCellCount,checkCellCount,A_Index-1) > 0 ) {
					checkCell := combinationOutput
					while ( A_Index <= numCount + 1 , j := A_Index - 1 )
						checkCellOption[j] := 0
					; add the number of each option
					while ( A_Index <= checkCellCount , i := A_Index - 1 ) {
						x := emptyCellProperty[checkCell[i],0]
						y := emptyCellProperty[checkCell[i],1]
						while ( A_Index <= numCount , j := A_Index )
							checkCellOption[j] += numValueOption[x,y,j]
					}
					; count the total number of options
					while ( A_Index <= numCount , j := A_Index ) {
						if ( checkCellOption[j] > 0 )
							checkCellOption[0]++
					}
					; check if the number of options is the same as the number of check cells
					if ( checkCellOption[0] == checkCellCount ) {
						; FOUND -> set numValueOption of other cells
						i := 0
						while ( A_Index <= numCount , y := A_Index - 1 ) {
							if ( y == emptyCellProperty[checkCell[i],1] ) {
								i++
								if ( i >= checkCellCount )
									i := 0
								continue
							}
							numValueOption[x,y,0] := 0
							while ( A_Index <= numCount , j := A_Index ) {
								if ( checkCellOption[j] > 0 )
									numValueOption[x,y,j] := 0
								numValueOption[x,y,0] += numValueOption[x,y,j]
							}
						}
					}
				}
			}
		}
		
	}
	
	
	
	; ---- DEBUGGING - Blow up numValueOption - Square[2]
	if ( solveLoop >= 200 ) {
		xK := 2
		yK := 0
		
		txt := "Square[2] [2,0]`n D "
		while ( A_Index <= numCount , i := A_Index )
			txt := txt i " "
		txt := txt "`nN  "
		while ( A_Index <= numCount , i := A_Index )
			txt := txt "| "
		txt := txt "`n"
		
		while ( A_Index <= numCount , i := A_Index )
			optionGroupCount[i] := 0
		
		temp0 := 0
		while ( A_Index <= sudokuLevel , y := sudokuLevel * yK + A_Index - 1 ) {
		while ( A_Index <= sudokuLevel , x := sudokuLevel * xK + A_Index - 1 ) {
			txt := txt temp0 "- "
			while ( A_Index <= numCount , i := A_Index )
				txt := txt numValueOption[ x, y, i ] " "
			txt := txt "`n"
			temp0++
			
			if ( numValue[x, y] == 0 ) {
				while ( A_Index <= numCount , i := A_Index )
					optionGroupCount[ i ] += numValueOption[ x, y, i ]
			}
			
		}
		}
		txt := txt " T "
		while ( A_Index <= numCount , i := A_Index )
			txt := txt optionGroupCount[i] " "
		
		Progress, b w246 x1120 y520 cb00CCFF ct4488FF cw505050 R0-400 P0,,%txt%,,Source Code Pro
		while ( A_Index <= 400) {
			Sleep, 50
			Progress, %A_Index%
		}
		
	}
	
}

txt := txtBoardReport()
Progress, %solvedBlockCount%,,Solving - %solveLoop%`n%txt%

return
}


combinationGenerator(n,r,seed) {
	global combinationOutput
	if ( seed < 0 || n < 0 || r < 0 || n < r )
		return -1
	
	;calculating the total amount = n! / r! / (n-r)!
	result := 1
	temp := n
	while ( temp > r ) {
		result *= temp
		temp--
	}
	temp := n - r
	while ( temp > 0 ) {
		result /= temp
		temp--
	}
	
	if ( seed >= result )
		return 0
	
	while ( A_Index <= 25 , i := A_Index - 1 ) {
		if ( i < r)
			combinationOutput[i] := i
		else
			combinationOutput[i] := -1
	}
	
	while ( A_Index <= seed ) {
		; adding 1 to the last one
		combinationOutput[r - 1]++
		; checking
		while ( A_Index <= r - 1 , i := r - A_Index ) {
			if ( combinationOutput[i] > n - r + i ) {
				combinationOutput[i - 1]++
				while ( A_Index <= r - i )
					combinationOutput[i - 1 + A_Index ] := combinationOutput[i - 1] + A_Index
			}
		}
	}
	
	return 1
}



