^`::suspend
!`::reload
return

----------------------------------------------------
;$`::macro2()
;$+`::macro2()

;$a::macro5()
;$q::macro6()
;$w::reset()

;$^s::send {w up}

;$^+c::clipprocess()
;$F6::clipprocess3()

;RControl::Proc()

;RShift::
Proc()
Proc()
Proc()
Proc()
return

+!1::UltraQuick()
\::OneTimeQuick()


----------------------------------------------------
OneTimeQuick()
{
send {f2}{end}{bs}{r}{Enter 2}{down}
}


----------------------------------------------------
UltraQuick()
{
	send 0{down}{left}1{down}{left}2{down}{left}3{down}{left}4{down}{left}5{down}{left}6{down}{left}7{down}{left}8{down 2}{left}
}

----------------------------------------------------
Proc()
{
	click 1446 110
	send n
	send {Space}Dark Light
	send {Alt down}nlbrs{Alt up}{end}
	
	;Send, {F2}{Home}{Right 12}{Delete 3}{Enter}{Home}
}


----------------------------------------------------
clipprocess()
{
	cSave := ClipboardAll
	Clipboard =	
	Send, {F2}
	Send, ^a
	Send, ^c
	ClipWait,10
	Loop, parse, clipboard, `n,`r
	{	
		cliptmp := RegExReplace(A_LoopField, "&amp;", "&")
		cliptmp := RegExReplace(cliptmp, "feat.", "ft.")
		cliptmp := RegExReplace(cliptmp, "-", " - ")
		cliptmp := RegExReplace(cliptmp, " www.myfreemp3.re ", "")
		
		
	}
	Clipboard = %cliptmp%
	;MsgBox,%clippart%
	;MsgBox,%Clipboard%
	Send, ^v
	Clipboard := cSave
}

----------------------------------------------------
clipprocess2()
{
	cSave := ClipboardAll
	Clipboard =	
	
	Send, ^c
	;ClipWait,10
	cBody := Clipboard
	Clipboard =	
	
	Send, {delete 2}{home}+{end}^c
	;ClipWait,10
	cSub := Clipboard
	Clipboard =	
	
	Send, {up}{home}+{end}^c
	;ClipWait,10
	cPre := Clipboard
	Clipboard =	
	
	Send, {down}{home}
	clippart=
	
	Loop, parse, cBody, `n,`r
	{
		;cliptmp := A_LoopField
		;cliptmp := RegExReplace(cliptmp, "`n", cPre . "`n" . cSub)
		cliptmp := cPre . A_LoopField . cSub
		
		clippart .= cliptmp . "`n"
	}
	Clipboard = %clippart%
	;MsgBox,%cliptmp% . "`n" . %Clipboard%
	Send, ^v
	Clipboard := cSave
}

----------------------------------------------------
clipprocess3()
{
	cSave := ClipboardAll
	Clipboard =	
	
	Send, ^c
	;ClipWait,10
	cBody := Clipboard
	Clipboard =	
	
	Send, {delete 2}{home}+{end}^c
	;ClipWait,10
	cSub := Clipboard
	Clipboard =	
	
	Send, {up}{home}+{end}^c
	;ClipWait,10
	cPre := Clipboard
	Clipboard =	
	
	Send, {down}{home}
	clippart=
	
	
	Position := InStr(line, "<\b>")
	if Position > 0
	
	
	
	Loop, parse, cBody, `n,`r
	{
		;cliptmp := A_LoopField
		;cliptmp := RegExReplace(cliptmp, "`n", cPre . "`n" . cSub)
		cliptmp := cPre . A_LoopField . cSub
		
		clippart .= cliptmp . "`n"
	}
	Clipboard = %clippart%
	;MsgBox,%cliptmp% . "`n" . %Clipboard%
	Send, ^v
	Clipboard := cSave
}




----------------------------------------------------
macro0()
{
	MouseGetPos, xpos, ypos
	Y = %ypos%
	send {Control down}
	
	loop 8
	{
		click %xpos% %ypos%
		ypos += 48
	}
	send {Control up}
	send {Wheeldown 16}
	click %xpos% %Y% 0
}

----------------------------------------------------

macro1()
{
	pause := 100
	sleep 500
	loop 40
	{
		stop = 0
		
		click right 400 200
		sleep %pause%
		;click 500 460
		send n
		sleep %pause%
		click right 500 580
		sleep %pause%
		;click 600 480
		send o{Enter}
		sleep %pause%
		;click 35 20
		send ^1
		sleep %pause%
		click 1000 100
		send {right}
		
		loop 20
		{
			GetKeyState, state, control, P
			if state = D
				stop = 1
			sleep %pause%
		}
		
		if stop = 1
			break
		
	}
}


----------------------------------------------------
macro2()
{
	pause := 50
	sleep 500
	loop
	{
		stop := 0
		
		send {appskey}
		sleep %pause%
		send v
		
		loop 40
		{
			GetKeyState, state, control, P
			if state = D
				stop := 1
			sleep %pause%
		}
		sleep 600
		send {Enter}
		
		loop 10
		{
			GetKeyState, state, control, P
			if state = D
				stop := 1
			sleep %pause%
		}
		send ^{PgUp}
		
		
		loop 10
		{
			GetKeyState, state, control, P
			if state = D
				stop := 1
			sleep %pause%
		}
		
		if stop = 1
			break
		
	}
}


----------------------------------------------------
macro3()
{
	send {F2}{right 4}
	send +{End}
	send {delete}{Enter 2}
	send {down}
}

----------------------------------------------------
macro4()
{
	send ^+s
	sleep 200
	send busy
	send {Tab}
	send {down}{home}{down 9}{enter}
	send +{Tab}{right}{left 4}
}
----------------------------------------------------

reset()
{
	l = -1
	r = -1
}

macro5()
{
	yStep := 23
	yLi := 670
	x := 1030
	l := -1
	r := -1
	
	click 1030 543 0
	
	loop 6
	{
		l = -1
		loop 6
		{
			sleep 200
			click
			
			sleep 200
			click 0 -23 rel
			
			send ^+s
			sleep 300
			
			macro5_sub(l)
			macro5_sub(r)
			sleep 200
			
			send {Tab}
			send {down}{home}{down 9}{enter}
			sleep 300
			
			;send +{Tab}{right}{left 4}
			send {enter}
			sleep 400
			send {enter}
			
			
			l += 1
		}
		
		click
		
		y := 682 - (r+1) * 23
		click 1030 %y%
		click 0 -23 rel
		
		click 1030 543
		
		r += 1
	}
}

macro6()
{
	l := -1
	r := -1
	
	loop 6
	{
		r = -1
		loop 6
		{
			send {End}{Home}{right 4}
			macro5_sub(l)
			macro5_sub(r)
			sleep 200
			
			send {End}{left 7}
			macro5_sub(l)
			macro5_sub(r)
			send {down}
			sleep 200
			r += 1
		}
		l += 1
	}
}

macro7()
{
	l := -1
	r := -1
	
	loop 6
	{
		r = -1
		send Icon
		
		loop 6
		{
			send {space}icon
			macro5_sub(l)
			macro5_sub(r)
			send {,}
			
			sleep 100
			
			r += 1
		}
		
		send {bs}{;}{Enter}
		
		l += 1
	}
}

macro5_sub(number)
{
	if number = 0
		send 0
	if number = 1
		send 1
	if number = 2
		send 2
	if number = 3
		send 3
	if number = 4
		send 4
	if number = -1
		send i
}


macro8()
{
	send {End}{Home}{right 4}
	send [{right}][{right}]
	send {down}
}


