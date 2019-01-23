delay := 60
tempMult := 6
alphaMod := 0
KeyboardLED("reset")
SetKeyDelay, -1
;SetMouseDelay, -1
SetDefaultMouseSpeed, 0

#SingleInstance force
#MaxHotkeysPerInterval 200
#HotkeyInterval 5000


^`::suspend
!`::reload
return

------------------------------------------------------------------------------------------------------------------------

---------------------------------------------------------

;$F1::
loop 40
{
	send {LButton down}
	sleep 50
	send {LButton up}
	sleep 100
}
return



distance := 50
Loop 1 {
	MouseMove, -%distance%, -%distance%, , R
	sleep %delay%
	MouseMove, %distance%, 0, , R
	sleep %delay%
	MouseMove, %distance%, 0, , R
	sleep %delay%
	MouseMove, 0, %distance%, , R
	sleep %delay%
	MouseMove, 0, %distance%, , R
	sleep %delay%
	MouseMove, -%distance%, 0, , R
	sleep %delay%
	MouseMove, -%distance%, 0, , R
	sleep %delay%
	MouseMove, 0, -%distance%, , R
	sleep %delay%
	MouseMove, %distance%, 0, , R
	sleep %delay%
}
KeyWait, F1, T.1
return



;$Pause::
SetScrollLockState, On
SplashTextOn, 400, 60, SplashWindow, The clipboard contains:`n%clipboard%
WinMove, SplashWindow, , 966, 30
Keywait, Pause
SetScrollLockState, Off
SplashTextOff
return

$NumpadMult::
;KeyboardLED("set", 1)
alphaMod := 1
Keywait, NumpadMult
alphaMod := 0
;KeyboardLED("reset")
return


---------------------------------------------------------
#If alphaMod = 1


---- Mouse Manipulation
$Right::
timeMult := 2
Loop 1000 {
	;sleep, 12 / timeMult
	MouseMove, 2, 0, , R
	state := GetKeyState("Right", "P")
	if state = 0
		break
}
Keywait, Right, T.1
return



----


$Space::
Loop 1000 {
	send {XButton2}
	state := GetKeyState("Space", "P") * GetKeyState("NumpadMult", "P")
	if state = 0
		break
	sleep 20
}
Keywait, Space, T.1
return

$q::
Loop 1000 {
	send !{q}
	state := GetKeyState("q", "P") * GetKeyState("NumpadMult", "P")
	if state = 0
		break
	sleep 20
}
Keywait, q, T.1
return

$w::
Loop 1000 {
	send !{w}
	state := GetKeyState("w", "P") * GetKeyState("NumpadMult", "P")
	if state = 0
		break
	sleep 20
}
Keywait, w, T.1
return

$e::
Loop 1000 {
	send !{e}
	state := GetKeyState("e", "P") * GetKeyState("NumpadMult", "P")
	if state = 0
		break
	sleep 20
}
Keywait, e, T.1
return

$r::
Loop 1000 {
	send !{r}
	state := GetKeyState("r", "P") * GetKeyState("NumpadMult", "P")
	if state = 0
		break
	sleep 20
}
Keywait, r, T.1
return

WheelUp::Volume_Up
WheelDown::Volume_Down
MButton::Volume_Mute

return
#If

---------------------------------------------------------
;---- AltMouse - Link Grabber/Define

;$NumpadAdd::
click 2
Keywait, NumpadAdd, T10
GetKeyState, state, ESC
if state = D
	return
;clipTemp := clipboard

send ^c
sleep %delay%
send ^t
sleep %delay%
send define{Space}^v{Enter}
sleep %delay%
sleep %delay%

clipboard = %clipTemp%
return


$NumpadSub::
Keywait, NumpadSub, T10
loop 5
{
	send {AppsKey}
	sleep %delay%
	send {e}
	sleep %delay%
	send {Tab}
	sleep %delay%
}
return

---------------------------------------------------------
---------------------------------------------------------
---------------------------------------------------------
---------------------------------------------------------
---------------------------------------------------------
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