delay := 40
SetMouseDelay, -1

^`::suspend
!`::reload
return

------------------------------------------------------------------------------------------------------------------------
#SingleInstance force
#IfWinActive VINACAL fx-570ES PLUS

;Row & Column start at 0
;Area:
;0 - Numpad (Bottom) [56, 440] + [45, 40]
;1 - Science (Middle) [50, 305] + [38, 32] -> [240, 400]
;2 - Control (Top)
;4+ - 2-Click (SHIFT / ALPHA)


;$::ButtonClick(0, , )

---------------------------------------------------------
;Area 0 - Numpad (Bottom)

$0::ButtonClick(0, 0, 3)
$1::ButtonClick(0, 0, 2)
$2::ButtonClick(0, 1, 2)
$3::ButtonClick(0, 2, 2)
$4::ButtonClick(0, 0, 1)
$5::ButtonClick(0, 1, 1)
$6::ButtonClick(0, 2, 1)
$7::ButtonClick(0, 0, 0)
$8::ButtonClick(0, 1, 0)
$9::ButtonClick(0, 2, 0)
$.::ButtonClick(0, 1, 3)
$e::ButtonClick(0, 2, 3)

$m::ButtonClick(0, 0, 3)
$j::ButtonClick(0, 0, 2)
$k::ButtonClick(0, 1, 2)
$l::ButtonClick(0, 2, 2)
$u::ButtonClick(0, 0, 1)
$i::ButtonClick(0, 1, 1)
$o::ButtonClick(0, 2, 1)

$Enter::ButtonClick(0, 4, 3)
$Esc::ButtonClick(0, 4, 0)
$F5::ButtonClick(0, 4, 0)
$BS::ButtonClick(0, 3, 0)
$=::ButtonClick(0, 3, 2)
$+::ButtonClick(0, 3, 2)
$-::ButtonClick(0, 4, 2)
$/::ButtonClick(0, 4, 1)
$x::ButtonClick(0, 3, 1)
$^p::ButtonClick(0, 3, 1)
$^8::ButtonClick(0, 3, 1)
$^e::ButtonClick(0, 2, 3)
$^n::ButtonClick(0, 3, 3)

---------------------------------------------------------
;Area 1 - Science (Middle)

$^c::ButtonClick(1, 0, 0)
$Space::ButtonClick(1, 0, 0)
$^/::ButtonClick(1, 4, 0)
$^6::ButtonClick(1, 3, 1)
$^2::ButtonClick(1, 2, 1)
$s::ButtonClick(1, 1, 1)
$r::ButtonClick(1, 1, 1)
$^.::ButtonClick(1, 1, 1)
$^,::ButtonClick(1, 1, 1)
$\::ButtonClick(1, 0, 1)
$^f::ButtonClick(1, 3, 2)
$^g::ButtonClick(1, 4, 2)
$^h::ButtonClick(1, 5, 2)
$[::ButtonClick(1, 2, 3)
$]::ButtonClick(1, 3, 3)
$q::ButtonClick(1, 1, 3)
$w::ButtonClick(1, 4, 3)
;$^e::ButtonClick(1, 1, 3)


---------------------------------------------------------
;Area 2 - Control (Top)
;Column 0: The 4 keys around
;	x = 46, 86, 204, 244;	y = 256
;Column 1: Up, Left, Right, Down
;	x = 120, 146, 172;	y = 256, 276, 296

$Shift::ButtonClick(2, 0, 0)
$Alt::ButtonClick(2, 0, 1)
$F1::ButtonClick(2, 0, 0)
$F2::ButtonClick(2, 0, 1)

$^o::ButtonClick(2, 0, 2)
$^r::ButtonClick(2, 0, 3)
$F3::ButtonClick(2, 0, 2)
$F4::ButtonClick(2, 0, 3)

$Up::ButtonClick(2, 1, 0)
$Left::ButtonClick(2, 1, 1)
$Right::ButtonClick(2, 1, 2)
$Down::ButtonClick(2, 1, 3)


---------------------------------------------------------
;Area 4 - SHIFT + Area 0
; Const Conv Pi +=

$^q::ButtonClick(4, 0, 0)
$^w::ButtonClick(4, 1, 0)
$^Enter::ButtonClick(4, 4, 3)


---------------------------------------------------------
;Area 5 - SHIFT + Area 1
;% , ! ^3 Abs

$^5::ButtonClick(5, 2, 3)
$,::ButtonClick(5, 3, 3)
$^1::ButtonClick(5, 4, 0)
$^3::ButtonClick(5, 2, 1)
$^a::ButtonClick(5, 2, 2)


---------------------------------------------------------
;Area 6 - ALPHA + Area 1
;Column 0 - AB CD EF XY =

$a::ButtonClick(6, 0, 2)
$b::ButtonClick(6, 1, 2)
$c::ButtonClick(6, 2, 2)
$d::ButtonClick(6, 3, 2)
;$e::ButtonClick(6, 4, 2)
$f::ButtonClick(6, 5, 2)
;$x::ButtonClick(6, 3, 3)
$y::ButtonClick(6, 4, 3)
$^=::ButtonClick(6, 0, 0)
$;::ButtonClick(6, 1, 0)


---------------------------------------------------------


ButtonClick(Area, Column, Row){
	MouseGetPos, xPos, yPos

	if (Area = 0){
		xDef := 56
		yDef := 440
		xSpace := 45
		ySpace := 40
		
		xFinal := xDef + xSpace * Column
		yFinal := yDef + ySpace * Row
		
		click %xFinal% %yFinal%
	}
	if (Area = 1){
		xDef := 50
		yDef := 305
		xSpace := 38
		ySpace := 32
		
		xFinal := xDef + xSpace * Column
		yFinal := yDef + ySpace * Row
		
		click %xFinal% %yFinal%
	}
	if (Area = 2){
		
		;Column 0: The 4 keys around
		;	x = 46, 86, 204, 244;	y = 256
		;Column 1: Up, Left, Right, Down
		;	x = 120, 146, 172;	y = 256, 276, 296
		
		
		if (Column = 0){
			yFinal := 256
			
			if (Row = 0)
				xFinal := 46
			if (Row = 1)
				xFinal := 86
			if (Row = 2)
				xFinal := 204
			if (Row = 3)
				xFinal := 244
		}
		if (Column = 1){
			
			if (Row = 0){
				xFinal := 146
				yFinal := 256
			}
			if (Row = 1){
				xFinal := 120
				yFinal := 276
			}
			if (Row = 2){
				xFinal := 172
				yFinal := 276
			}
			if (Row = 3){
				xFinal := 146
				yFinal := 296
			}
		}
		
		click %xFinal% %yFinal%
	}
	
	click %xPos% %yPos% 0
}

return