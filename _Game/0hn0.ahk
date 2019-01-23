
pX := []
pY := []
blockV := []
number := []								; 2D: Index / 0-x, 1-y, 2-value, 3-state(0-Not Fulfilled, 1-Fulfilled)
numberCount := 0
fulfilledCount := 0
autoRun := 0

; Exam Arrays start from 1, codes write from the highest index to the lowest one
examX := [ 25, 25, 25, 20, 28]
examY := [ 32, 20, 23, 27, 27]
examCode := [ 111, 1, 10111, 11010, 101, 1111, 100, 1101, 0]
whiteThreshold := 0xEA0000

numAvail := []					; 2D: Index / Direction (0-Total, 1-U, 2-R, 3-D, 4-L)
numAvailOther := []		; 2D: Index / Direction (0-Total, 1-U, 2-R, 3-D, 4-L)
numFill := []						; 2D: Index / Direction (0-Total, 1-U, 2-R, 3-D, 4-L)
numMissing := []				; 2D: Index / Direction (0-None, 1-U, 2-R, 3-D, 4-L)
numOther := []					; 2D: Index / Direction (0-None, 1-U, 2-R, 3-D, 4-L)
numComp := []					; 3D: Index / Direction (0-Total, 1-U, 2-R, 3-D, 4-L) / Chain Index
directionX := [ 0, 1, 0, -1]
directionY := [ -1, 0, 1, 0]
chain := []



SetMouseDelay, -1
delay := 40
#SingleInstance force
^`::suspend
!`::reload


F6::						; AUTO RUN - RE-RUNS
autoRun := 2
send {F3}
return

F5::						; AUTO RUN - FIRST
autoRun := 2


F4::						; POSITION SCAN
{
MouseGetPos, MouseX, MouseY
MouseXMove := MouseX - 50
MouseYMove := MouseY
Click, %MouseXMove%, %MouseYMove%, 0

pX[0] := MouseX
pY[0] := MouseY - 50
mY := MouseY

; X Scan
while (A_Index<=9, i:=A_Index-1)
{
	state := 0
	loop, 100
	{
		pX[i] := pX[i] + 1
		PixelGetColor, color, % pX[i] , %mY% , RGB
		if ( state==0 && color==0x222222 )
			state := 1
		if ( state==1 && color<>0x222222 )
			break
		if GetKeyState("Control","p")
			return
	}
	pX[i+1] := pX[i] + 44
	temp := pX[i]
	Click, %temp% , %MouseY% , 0
}

mX := Floor( ( pX[0] + pX[1] ) / 2 ) - 8
pY[0] := pY[0] - 50

; Y Scan
while (A_Index<=9, i:=A_Index-1)
{
	state := 0
	loop, 100
	{
		pY[i] := pY[i] + 1
		PixelGetColor, color, %mX%, % pY[i] , RGB
		if ( state==0 && color==0x222222 )
			state := 1
		if ( state==1 && color<>0x222222 )
			break
		if GetKeyState("Control","p")
			return
	}
	pY[i+1] := pY[i] + 40
	temp := pY[i]
	Click, %mX%, %temp%, 0
}

Click, %MouseXMove%, %MouseYMove%, 0
;PixelGetColor, color, pX[5] + 12 , pY[2] + 25 , RGB
;MsgBox %color%

if ( autoRun > 0 )
	autoRun--
else
	return
}


F3::						; VALUE SCAN
{
tempX := pX[8] + 25
tempY := pY[8] + 60
click, %tempX%, %tempY%, 0

numberCount := 0
; Color Scan
while (A_Index<=9, j:=A_Index-1)
while (A_Index<=9, i:=A_Index-1)
{
	PixelGetColor, color, pX[i] + 12 , pY[j] + 25 , RGB
	if ( color >= 0xd00000 )
		blockV[i, j] := -1
	if ( color >= 0x300000 && color < 0xd00000 )
	{
		code := 0
		value := 0
		while (A_Index<=5, k:=A_Index)
		{
			PixelGetColor, color, pX[i] + examX[k] , pY[j] + examY[k] , RGB
			if ( color >= whiteThreshold )
				code += 10 ** ( k - 1 )
		}
		while (A_Index<=9, k:=A_Index)
		{
			if ( code == examCode[k] )
			{
				value := k
				break
			}
		}
		blockV[i, j] := value
		number[numberCount, 0] := i
		number[numberCount, 1] := j
		number[numberCount, 2] := value
		number[numberCount, 3] := 0
		numberCount++
	}
	if ( color >= 0x2a0000 && color < 0x300000 )
		blockV[i, j] := 0
	
	if GetKeyState("Control","p")
		return
}

tempX := pX[0] + 12
tempY := pY[0] - 25
click, %tempX%, %tempY%, 0


if ( autoRun > 0 )
	autoRun--
else
{
	MapReport()
	return
}
}


F2::													; Algorithm
{
tempX := pX[8] + 25
tempY := pY[8] + 60
click, %tempX%, %tempY%, 0

fulfilledCount := 0
while (A_Index<=numberCount, i:=A_Index-1)
	number[i, 3] := 0


;------ Command 012
i := 0
while ( 1-GetKeyState("Control", "P") )
{
	
	if ( fulfilledCount >= numberCount )
		break
	if ( i >= numberCount )
		i -= numberCount
	if ( number[i, 3] == 1 )
	{
		i++
		continue
	}
	
	;------ NUMBER SCAN
	{
	x0 := number[i, 0]
	y0 := number[i, 1]
	numComp[i, 0, 0] := 0
	numAvail[i, 0] := 0
	while (A_Index<=4, d:=A_Index)
	{
		numOther[i, d] := 0
		numAvailOther[i, d] := 0
	}

	; Number Scan
	while (A_Index<=4, d:=A_Index)
	{
		chain[0] := -1
		chain[1] := -2
		chain[2] := -3
		while (A_Index<=9, s:=A_Index)
		{
			x1 := x0 + s * directionX[d]
			y1 := y0 + s * directionY[d]
			if ( x1<0 || x1>8 || y1<0 || y1>8 )
				break
			if ( blockV[x1, y1] < 0 )
				break
			
			if ( chain[0] == -1 && blockV[x1, y1] <= 0 )
				chain[0] := s - 1
			
			if ( chain[1] == -2 && blockV[x1, y1] <= 0)
				chain[1]++
			if ( chain[1] == -1 && blockV[x1, y1] > 0)
				chain[1] := s - 1
			
			if ( chain[2] == -3 && blockV[x1, y1] <= 0)
				chain[2]++
			if ( chain[2] == -2 && blockV[x1, y1] > 0)
				chain[2]++
			if ( chain[2] == -1 && blockV[x1, y1] <= 0)
				chain[2] := s - 1
			
		}
		s -= 1
		while (A_Index<=3, j:=A_Index-1)
			if ( chain[j] < 0 )
				chain[j] := s
		
		numAvail[i, d] := s
		numAvail[i, 0] += s
		while (A_Index<=3, j:=A_Index-1)
			numComp[i, d, j] := chain[j]
		numComp[i, 0, 0] += chain[0]
		
		while (A_Index<=4, dOther:=A_Index)
			if ( d <> dOther )
			{
				numOther[i, dOther] += chain[0]
				numAvailOther[i, dOther] += s
			}
	}
	}
	
	cont := 0
	;------ Command 0
	{
	while (A_Index<=4, d:=A_Index)
	{
		numMissing[i, d] := number[i, 2] - numAvailOther[i, d] - numComp[i, d, 0]
		if ( numMissing[i, d] > 0 )
		{
			cont := 1
			while (A_Index<=numMissing[i, d] && A_Index<=numComp[i, d, 1]-numComp[i, d, 0], s:=A_Index+numComp[i, d, 0])
			{
				x := number[i, 0] + directionX[d] * s
				y := number[i, 1] + directionY[d] * s
				blockV[x, y] := 1
				BlockClick(x, y, 1)
				if ( GetKeyState("Control", "P") )
					return
			}
		}
	}
	if (cont)
		continue
	}
	
	;------ Command 1
	{
	if ( numComp[i, 0, 0] == number[i, 2] )
	{
		number[i, 3] := 1
		fulfilledCount++
		if ( numAvail[i, 0] > number[i, 2] )
		{
			while (A_Index<=4, d:=A_Index)
			{
				if ( numComp[i, d, 0] < numAvail[i, d] )
				{
					x := number[i, 0] + directionX[d] * ( numComp[i, d, 0] + 1 )
					y := number[i, 1] + directionY[d] * ( numComp[i, d, 0] + 1 )
					blockV[x, y] := -1
					BlockClick(x, y, -1)
				}
			}
			i++
			continue
		}
	}
	}
	
	;------ Command 2
	{
	while (A_Index<=4, d:=A_Index)
	{
	if ( numComp[i, d, 1] - numComp[i, d, 0] == 1 )
		if (numComp[i, d, 2] + numOther[i, d] > number[i, 2])
		{
			cont := 1
			x := number[i, 0] + directionX[d] * numComp[i, d, 1]
			y := number[i, 1] + directionY[d] * numComp[i, d, 1]
			blockV[x, y] := -1
			BlockClick(x, y, -1)
			continue
		}
	}
	if (cont)
		continue
	}
	
	i++
}

;------ Command 3
{
while ( A_Index<=9 && 1-GetKeyState("Control", "P") , x:=A_Index-1)
while ( A_Index<=9 && 1-GetKeyState("Control", "P") , y:=A_Index-1)
{
	if ( blockV[x, y] == 0 )
	{
		blockV[x, y] := -1
		BlockClick(x, y, -1)
	}	
}
}

click, 777, 377, 0

if ( autoRun > 0 )
{
	autoRun--
	while ( A_Index<=80 && 1-GetKeyState("Control", "P") )
		sleep 100
	if (GetKeyState("Control", "P"))
		return
	click
	while ( A_Index<=20 && 1-GetKeyState("Control", "P") )
		sleep 100
	if (GetKeyState("Control", "P"))
		return
	send {F6}
	return
}
MapReport()

return
}


NumberScan(index)
{
	x0 := number[index, 0]
	y0 := number[index, 1]
	numComp[index, 0, 0] := 0
	numAvail[index, 0] := 0
	while (A_Index<=4, d:=A_Index)
	{
		numOther[index, d] := 0
		numAvailOther[index, d] := 0
	}
	
	while (A_Index<=4, d:=A_Index)
	{
		chain[0] := -1
		chain[1] := -2
		chain[2] := -3
		while (A_Index<=9, s:=A_Index)
		{
			x1 := x0 + s * directionX[d]
			y1 := y0 + s * directionY[d]
			if ( x1<0 || x1>8 || y1<0 || y1>8 )
				break
			if ( blockV[x1, y1] < 0 )
				break
			
			if ( chain[0] == -1 && blockV[x1, y1] <= 0 )
				chain[0] := s - 1
			
			if ( chain[1] == -2 && blockV[x1, y1] <= 0)
				chain[1]++
			if ( chain[1] == -1 && blockV[x1, y1] > 0)
				chain[1] := s - 1
			
			if ( chain[2] == -3 && blockV[x1, y1] <= 0)
				chain[2]++
			if ( chain[2] == -2 && blockV[x1, y1] > 0)
				chain[2]++
			if ( chain[2] == -1 && blockV[x1, y1] <= 0)
				chain[2] := s - 1
			
		}
		s -= 1
		while (A_Index<=3, j:=A_Index-1)
			if ( chain[j] < 0 )
				chain[j] := s
		
		numAvail[index, d] := s
		numAvail[index, 0] += s
		while (A_Index<=3, j:=A_Index-1)
			numComp[index, d, j] := chain[j]
		numComp[index, 0, 0] += chain[0]
		
		while (A_Index<=4, dOther:=A_Index)
			if ( d <> dOther )
			{
				numOther[index, dOther] += chain
				numAvailOther[index, dOther] += s
			}
	}
}


BlockClick(x, y, state:=1)
{
	global pX, pY
	
	if ( state < -1 || state > 1)
		return
	PixelGetColor, color, pX[x] + 12 , pY[y] + 25 , RGB
	if ( color >= 0xd00000 )
		value := -1
	if ( color >= 0x300000 && color < 0xd00000 )
		value := 1
	if ( color >= 0x2a0000 && color < 0x300000 )
		value := 0
	difference := state - value
	if ( difference < 0 )
		difference += 3
	tempX := pX[x] + 36
	tempY := pY[y] + 25
	click, %tempX%, %tempY%, 0
	while (A_Index<=difference)
	{
		if ( GetKeyState("Control", "P") )
			return
		sleep 25
		click
	}
	click, 5, 0, 0, Rel
}


MapReport()
{
global blockV
txt = Map Report`n
while (A_Index<=9, j:=A_Index-1)
{
	while (A_Index<=9, i:=A_Index-1)
	{
		if (blockV[i, j] < 0)
			blockName := "X"
		if (blockV[i, j] > 0)
			blockName := blockV[i, j]
		if (blockV[i, j] == 0)
			blockName := "*"
		txt = %txt%   %blockName% 
		
		if GetKeyState("Control","p")
			return
	}
	txt = %txt%`n
}
MsgBox %txt%
}


F1:: 					; TEST
{
i := 18
if (1)
{
x0 := number[i, 0]
y0 := number[i, 1]
numComp[i, 0, 0] := 0
numAvail[i, 0] := 0
while (A_Index<=4, d:=A_Index)
{
	numOther[i, d] := 0
	numAvailOther[i, d] := 0
}

; Number Scan
while (A_Index<=4, d:=A_Index)
{
	chain[0] := -1
	chain[1] := -2
	chain[2] := -3
	while (A_Index<=9, s:=A_Index)
	{
		x1 := x0 + s * directionX[d]
		y1 := y0 + s * directionY[d]
		if ( x1<0 || x1>8 || y1<0 || y1>8 )
			break
		if ( blockV[x1, y1] < 0 )
			break
		
		if ( chain[0] == -1 && blockV[x1, y1] <= 0 )
			chain[0] := s - 1
		
		if ( chain[1] == -2 && blockV[x1, y1] <= 0)
			chain[1]++
		if ( chain[1] == -1 && blockV[x1, y1] > 0)
			chain[1] := s - 1
		
		if ( chain[2] == -3 && blockV[x1, y1] <= 0)
			chain[2]++
		if ( chain[2] == -2 && blockV[x1, y1] > 0)
			chain[2]++
		if ( chain[2] == -1 && blockV[x1, y1] <= 0)
			chain[2] := s - 1
		
	}
	s -= 1
	while (A_Index<=3, j:=A_Index-1)
		if ( chain[j] < 0 )
			chain[j] := s
	
	numAvail[i, d] := s
	numAvail[i, 0] += s
	while (A_Index<=3, j:=A_Index-1)
		numComp[i, d, j] := chain[j]
	numComp[i, 0, 0] += chain[0]
	
	while (A_Index<=4, dOther:=A_Index)
		if ( d <> dOther )
		{
			numOther[i, dOther] += chain[0]
			numAvailOther[i, dOther] += s
		}
	
	MsgBox % "direction - " d "`nc0 - " chain[0] "`nc1 - " chain[1] "`nc2 - " chain[2]
}
}

while (A_Index<=4, d:=A_Index)
	numMissing[i, d] := number[i, 2] - numAvailOther[i, d] - numComp[i, d, 0]

if (0)
{
MsgBox % "NumOther`nno1 - " numOther[i, 1] "`nno2 - " numOther[i, 2] "`nno3 - " numOther[i, 3] "`nno4 - " numOther[i, 4]
return	
MsgBox % numComp[i, 0, 0] " - Comp [0]`n" numComp[i, 1, 0] "`n" numComp[i, 2, 0] "`n" numComp[i, 3, 0] "`n" numComp[i, 4, 0]

MsgBox % numComp[i, 0, 1] " - Comp [1]`n" numComp[i, 1, 1] "`n" numComp[i, 2, 1] "`n" numComp[i, 3, 1] "`n" numComp[i, 4, 1]

MsgBox % numComp[i, 0, 2] " - Comp [2]`n" numComp[i, 1, 2] "`n" numComp[i, 2, 2] "`n" numComp[i, 3, 2] "`n" numComp[i, 4, 2]

MsgBox % numAvail[i, 0] " - Avail [0]`n" numAvail[i, 1] "`n" numAvail[i, 2] "`n" numAvail[i, 3] "`n" numAvail[i, 4]

MsgBox % numAvailOther[i, 1] " - Avail Other [1]`n" numAvailOther[i, 2] "`n" numAvailOther[i, 3] "`n" numAvailOther[i, 4]

MsgBox % numMissing[i, 1] " - Missing [1]`n" numMissing[i, 2] "`n" numMissing[i, 3] "`n" numMissing[i, 4]

}

;-- TESTING Command 2
while (A_Index<=4, d:=A_Index)
	if ( numComp[i, d, 1] - numComp[i, d, 0] == 1 )
	if (numComp[i, d, 2] + numOther[i, d] > number[i, 2])
	{
		x := number[i, 0] + directionX[d] * numComp[i, d, 1]
		y := number[i, 1] + directionY[d] * numComp[i, d, 1]
		blockV[x, y] := -1
		BlockClick(x, y, -1)
		;continue
	}

return
; Map Report
txt = Filled for N-%i% `n`n
while (A_Index<=9, j:=A_Index-1)
{
	while (A_Index<=9, i:=A_Index-1)
	{
		if (blockV[i, j] < 0)
			blockName := "X"
		if (blockV[i, j] > 0)
			blockName := blockV[i, j]
		if (blockV[i, j] == 0)
			blockName := "*"
		txt = %txt%   %blockName% 
		
		if GetKeyState("Control","p")
			return
	}
	txt = %txt%`n
}
MsgBox %txt%

return
}


\:: 						; Gatling Mouse
{

while ( 1-GetKeyState("Control","p") && A_Index<=100 )
{
	click
	sleep 50
}

return
}