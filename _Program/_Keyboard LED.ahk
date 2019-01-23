initiation()

^`::suspend
!`::reload
return

------------------------------------------------------------------------------------------------------------------------
#SingleInstance force

initiation(){
	delay:= 250
	
	delayReset:=400
	
	delay0:=2000
	delay1:=1000
	delay2:=750
	delay3:=500
	delay4:=400
	delay5:=300
	delay6:=250
	delay7:=200
	delay8:=150
	delay9:=120
	delay10:=100
	delay11:=80
	delay12:=60
	delay13:=50
	delay14:=40
	
	count0:=2
	count1:=3
	count2:=4
	count3:=5
	count4:=8
	RepeatCount := 8
}

---------------------------------------------------------

^[::KeyboardLED("on")
^]::KeyboardLED("off")
^\::KeyboardLED()

^'::LoopKeyboardLED(5,120,7,0)
^/::LoopKeyboardLED(10,25,2,6,4,5,1,3)
^;::LoopKeyboardLED(10,40,2,4,1)
^.::LoopKeyboardLED(5,40,7,0)

^1::LoopKeyboardLED(4,100,2,4,1)
^2::LoopKeyboardLED(4,40,2,6,7,7,7,7,7,5,1,0,0)
^3::LoopKeyboardLED(4,80,2,6,7,7,5,1,0)
^4::LoopKeyboardLED(4,80,2,6,5,1,0,0)

^5::LoopKeyboardLED(2,80,2,6,7,5,1,1,5,7,6,2)
^6::LoopKeyboardLED(4,80,2,6,7,7,6,2,0)
^7::LoopKeyboardLED(4,80,2,2,6,6,7,7,6,2,0)

---------------------------------------------------------

LoopKeyboardLED( count=2, delay=100, set0=7, set1=0, set2=-1, set3=-1, set4=-1, set5=-1, set6=-1, set7=-1, set8=-1, set9=-1, setA=-1, setB=-1, delayReset=250)
{
	loop %count% {
		if (set0 >= 0) {
			KeyboardLED("set", set0)
			sleep %delay%
		}
		if (set1 >= 0) {
			KeyboardLED("set", set1)
			sleep %delay%
		}
		if (set2 >= 0) {
			KeyboardLED("set", set2)
			sleep %delay%
		}
		if (set3 >= 0) {
			KeyboardLED("set", set3)
			sleep %delay%
		}
		if (set4 >= 0) {
			KeyboardLED("set", set4)
			sleep %delay%
		}
		if (set5 >= 0) {
			KeyboardLED("set", set5)
			sleep %delay%
		}
		if (set6 >= 0) {
			KeyboardLED("set", set6)
			sleep %delay%
		}
		if (set7 >= 0) {
			KeyboardLED("set", set7)
			sleep %delay%
		}
		if (set8 >= 0) {
			KeyboardLED("set", set8)
			sleep %delay%
		}
		if (set9 >= 0) {
			KeyboardLED("set", set9)
			sleep %delay%
		}
		if (setA >= 0) {
			KeyboardLED("set", setA)
			sleep %delay%
		}
		if (setB >= 0) {
			KeyboardLED("set", setB)
			sleep %delay%
		}
	}
	KeyboardLED("off")
	sleep %delayReset%
	KeyboardLED()
}


---------------------------------------------------------
return
/*

    Keyboard LED control for AutoHotkey_L
        http://www.autohotkey.com/forum/viewtopic.php?p=468000#468000

    KeyboardLED(LEDvalue, "Cmd", Kbd)
        LEDvalue  - ScrollLock=1, NumLock=2, CapsLock=4
        Cmd       - on/off/switch/set/reset
        Kbd       - index of keyboard (probably 0 or 2)

*/

KeyboardLED(Cmd="reset", LEDvalue=7, Kbd=2)
{
  SetUnicodeStr(fn,"\Device\KeyBoardClass" Kbd)
  h_device:=NtCreateFile(fn,0+0x00000100+0x00000080+0x00100000,1,1,0x00000040+0x00000020,0)
  
  If Cmd= set
   KeyLED:= LEDvalue
   
  If Cmd= reset
   KeyLED:= (GetKeyState("ScrollLock", "T") + 2*GetKeyState("NumLock", "T") + 4*GetKeyState("CapsLock", "T"))
   
  If Cmd= switch
   KeyLED:= LEDvalue ^ (GetKeyState("ScrollLock", "T") + 2*GetKeyState("NumLock", "T") + 4*GetKeyState("CapsLock", "T"))
   
  If Cmd= on
   KeyLED:= LEDvalue | (GetKeyState("ScrollLock", "T") + 2*GetKeyState("NumLock", "T") + 4*GetKeyState("CapsLock", "T"))
   
  If Cmd= off
    {
    LEDvalue:= 7 - LEDvalue
    KeyLED:= LEDvalue & (GetKeyState("ScrollLock", "T") + 2*GetKeyState("NumLock", "T") + 4*GetKeyState("CapsLock", "T"))
    }
  
  success := DllCall( "DeviceIoControl"
              ,  "ptr", h_device
              , "uint", CTL_CODE( 0x0000000b     ; FILE_DEVICE_KEYBOARD
                        , 2
                        , 0             ; METHOD_BUFFERED
                        , 0  )          ; FILE_ANY_ACCESS
              , "int*", KeyLED << 16
              , "uint", 4
              ,  "ptr", 0
              , "uint", 0
              ,  "ptr*", output_actual
              ,  "ptr", 0 )
  
  NtCloseFile(h_device)
  return success
}

CTL_CODE( p_device_type, p_function, p_method, p_access )
{
  Return, ( p_device_type << 16 ) | ( p_access << 14 ) | ( p_function << 2 ) | p_method
}


NtCreateFile(ByRef wfilename,desiredaccess,sharemode,createdist,flags,fattribs)
{
  VarSetCapacity(objattrib,6*A_PtrSize,0)
  VarSetCapacity(io,2*A_PtrSize,0)
  VarSetCapacity(pus,2*A_PtrSize)
  DllCall("ntdll\RtlInitUnicodeString","ptr",&pus,"ptr",&wfilename)
  NumPut(6*A_PtrSize,objattrib,0)
  NumPut(&pus,objattrib,2*A_PtrSize)
  status:=DllCall("ntdll\ZwCreateFile","ptr*",fh,"UInt",desiredaccess,"ptr",&objattrib
                  ,"ptr",&io,"ptr",0,"UInt",fattribs,"UInt",sharemode,"UInt",createdist
                  ,"UInt",flags,"ptr",0,"UInt",0, "UInt")
  return % fh
}

NtCloseFile(handle)
{
  return DllCall("ntdll\ZwClose","ptr",handle)
}


SetUnicodeStr(ByRef out, str_)
{
  VarSetCapacity(out,2*StrPut(str_,"utf-16"))
  StrPut(str_,&out,"utf-16")
}


---------------------------------------------------------
---------------------------------------------------------
---------------------------------------------------------
---------------------------------------------------------
---------------------------------------------------------