sleep 4000
lc:=0

Loop
{
	fn:=ReadMemory(0x242E0100)
	
	if fn < 19
	{
    		lc:=lc+1
		if lc < 6
		{
			send {8}
		}
		if lc = 6
		{
			fn:=36
		}
		
	}


	if fn > 18
	{
    		lc:=0
		send {9}
		sleep 400
	}

	sleep 1200
}

^e::
suspend
pause
return
^w::suspend
^q::pause

;---------------- Double and Spin
8:: click 440, 640

;---------------- Bet "19 to 36"
9::    
;click 220, 280
;sleep 300

click 340, 640
sleep 400
        
click 876, 540
sleep 400
        
click 540, 640

return





ReadMemory(MADDRESS)
{
VarSetCapacity(MVALUE,4,0)
ProcessHandle := DllCall("OpenProcess", "Int", 24, "Char", 0, "UInt", 1944, "UInt")
DllCall("ReadProcessMemory","UInt",ProcessHandle,"UInt",MADDRESS,"Str",MVALUE,"UInt",4,"UInt *",0)

Loop 4
result += *(&MVALUE + A_Index-1) << 8*(A_Index-1)

return, result 
}