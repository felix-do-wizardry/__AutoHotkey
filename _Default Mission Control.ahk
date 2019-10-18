
#SingleInstance force
#MaxHotkeysPerInterval 200
SetTitleMatchMode, 2
if not A_IsAdmin
{
   Run *RunAs "%A_ScriptFullPath%"
}

SetMouseDelay, -1
delay := 20


pi_id_0 := 60
pi_id_1 := 37
pi_ip_prefix := "192.168.137."

; Initializing Varibles
macroActive = false
macroClick := []
macroCount := 0
;macro

; alpha mod
alphaMod := 0
SetTimer, setAlphaModOff, -1

if ( A_TickCount <= 1200000 )
	SetTimer, LaunchStartUp, -20000
else {
	txt := round(A_TickCount / 60000) " mins"
	;MsgBox,,, %txt%, .4
}
return



^+`::suspend
!+`::reload
return



;--------------------------------------------------------- Launcher

+!F1::
WinMove, A, , 200, 200, , 
return

^!+F10::
LaunchStartUp_A:
run %cd%.\Shortcuts\Logitech
return
^!+F11::
LaunchStartUp_B:
run %cd%.\Shortcuts\JDownloader2
return
LaunchStartUp_C:
run %cd%.\Shortcuts\GoogleDrive
return

^!+F12::
SetTimer, LaunchStartUp, OFF
LaunchStartUp:
; SetTimer, LaunchStartUp_A, -1
SetTimer, LaunchStartUp_B, -1
; SetTimer, LaunchStartUp_C, -1
return

^!+F9::
SetTimer, LaunchStartUp, OFF
return

; disable unnecessary
#F1::return
#Space::return

#+c::
run %cd%.\Shortcuts\CAL_fx-570ES_PLUS
run %cd%.\_Default Calculator Pro.ahk
return

#+e::run %cd%.\Shortcuts\Everything

#+n::run %cd%.\Shortcuts\notepad++

#+q::run %cd%.\_QUICK.ahk

#+f::run %cd%.\Custom Fast.ahk

#+d::run %cd%.\Dota 2 - SIMPLE RE-MAP.ahk

#+p::
PSPythonReset:
SendInput, {esc}exit(){enter}
Sleep, 200
SendInput, python{enter}
return

#+o::
PSPythonTFReset:
Gosub, PSPythonReset
Sleep, 500
SendInput, ^{v}
; SendInput, import{Space}tensorflow{Space}as{Space}tf{Enter}
; SendInput, import{Space}numpy{Space}as{Space}np{Enter 2}
return

;#+r::run D:\Software\____Initialization\Windows Backup & ReInitialization.ahk

#+v::run %cd%.\Shortcuts\VSCode

#+F1::run %cd%.\Shortcuts\AutoHotkey
#+F2::run %cd%.\Shortcuts\AU3_Spy

#+w::
ubuntu_ssh:
SendRaw, ssh -p 48248 haidn@42.113.206.201
; SendRaw, hai@123
return

#+x::
SendInput, #{x}
Sleep, 100
SendInput, {a}
WinWait, PowerShell, , 3
Sleep, 400
Gosub, ubuntu_ssh
Sleep, 400
SendInput, {Enter}
Sleep, 400
SendRaw, hai@123
Sleep, 400
SendInput, {Enter}
Sleep, 200
SendInput, clear{Enter}
return


#+a::
#+t::
FormatTime, current_time,, yyMMdd_HHmmss
clipboard := current_time
SetToolTip(current_time . "`n[TimeStamp Coppied]", 1200)
return

^+F12::WinMove, A, , -8, 4, 1366-480+15, 1200
^+F11::WinMove, A, , 0, 30, 1366-480, 768-7
^+F10::WinMove, A, , 1366-496+8, -12, 496, 1200

; ------ Program Specific Scripts
; #+s::
#+g::
if paused = True:
	return
paused := True
;SetTimer, ProgramSpecificScript, -1
ProgramSpecificScript:
IfWinActive, StarCraft II
{
	run %cd%.\_Game\StarCraft2.ahk
	paused := False
	return
}
IfWinActive, Visual Studio Code
{
	; SetToolTip("doing it right", 2000)
	GetTimeStamp(True)
	SendInput, ^+{g}q
	Sleep, 100
	SendInput, {Enter}
	; SetToolTip("",0)
	Sleep, 400
	SendInput, ^{v}{Enter}
	SendInput, ^+{g}w
	; Sleep, 100
	; SendInput, {Enter}
	; Sleep, 1000
	paused := False
	return
}
return

GetTimeStamp(copy_to_clipboard=False) {
	FormatTime, current_time,, yyMMdd_HHmmss
	txt := current_time
	if (copy_to_clipboard = True) {
		clipboard := current_time
		txt := txt . "`ncoppied"
	}
	; SetToolTip(txt, 1600)
	return 1
}

return
;--------------------------------------------------------- Main Hotkeys

;Volume Control
+!WheelUp::Volume_Up
+!WheelDown::Volume_Down
+!MButton::Volume_Mute
;Individual Volume Control
;^!WheelUp::run D:\Software\_Portable Tools\NirCmd x64\nircmd.exe changeappvolume focused 0.1
;^!WheelDown::run D:\Software\_Portable Tools\NirCmd x64\nircmd.exe changeappvolume focused -0.1
;^!MButton::run D:\Software\_Portable Tools\NirCmd x64\nircmd.exe muteappvolume focused 2

<#WheelUp::ShiftAltTab
<#WheelDown::AltTab
; <#MButton::Tab

<#F14::^#Left
<#F13::^#Right

+!Up::click 0 -1 0 rel
+!Down::click 0 1 0 rel
+!Left::click -1 0 0 rel
+!Right::click 1 0 0 rel

+!Enter::
if GetKeyState("LButton") {
	sendinput, {LButton up}
}
else {
	sendinput, {LButton down}
}
return
Release_LButton:

return

; ------------ Raspberry Pi Hotkeys

; #![::rasp_pi_putty(pi_id_0)
; #!]::rasp_pi_putty(pi_id_1)

; #+[::rasp_pi_remote(pi_id_0)
; #+]::rasp_pi_remote(pi_id_1)

; #+,::rasp_pi_mosq_sub(pi_id_0)
; #+.::rasp_pi_mosq_pub(pi_id_0)

; #+[::rasp_pi_remote(106, 103)
; #+]::rasp_pi_remote(117, 103)

rasp_pi_remote(pi_ip_id=0, host_ip_id=0) {
	global pi_ip_prefix
	if rasp_pi_putty(pi_ip_id, host_ip_id) <= 0 {
		return -1
	}
	if rasp_pi_putty_x11vnc(pi_ip_id, host_ip_id) <= 0 {
		return -1
	}
	if rasp_pi_tightvnc(pi_ip_id, host_ip_id) <= 0 {
		return -1
	}
	return 1
}

rasp_pi_putty(pi_ip_id=0, host_ip_id=0) {
	global pi_ip_prefix
	pi_ip := pi_ip_prefix pi_ip_id
	host_ip := pi_ip_prefix host_ip_id
	run %cd%.\Shortcuts\PuTTY
	WinWait, PuTTY Configuration, , 5
	if ErrorLevel {
		return -1
	}
	Sleep, 250
	SendInput, %pi_ip%
	SendInput, {Enter}
	WinWait, PuTTY Security Alert, , 2
	if ErrorLevel {
		; return -1
	}
	else {
		; MsgBox, FOUND ALERT
		SendInput, {y}
		; return -1
	}
	WinWait, %pi_ip% - PuTTY, , 2
	if ErrorLevel {
		return -1
	}
	Sleep, 200
	SendInput, pi
	SendInput, {Enter}
	Sleep, 400
	SendInput, tube@99@
	SendInput, {Enter}
	Sleep, 800
	SendInput, clear
	SendInput, {Enter}
	return 1
}

rasp_pi_putty_x11vnc(pi_ip_id=0, host_ip_id=0) {
	global pi_ip_prefix
	pi_ip := pi_ip_prefix pi_ip_id
	host_ip := pi_ip_prefix host_ip_id
	; WinWait, PuTTY Configuration, , 5
	; if ErrorLevel {
	; 	return -1
	; }
	Sleep, 250
	; cmd_x11vnc := "x11vnc -display :0 -usepw -listen " pi_ip " -allow " host_ip
	; cmd_x11vnc := "x11vnc -display :0 -usepw -listen " pi_ip
	cmd_x11vnc := "x11vnc -display :0 -usepw"
	; cmd_x11vnc := "x11vnc -display :1 -usepw"
	SendInput, %cmd_x11vnc%
	SendInput, {Enter}
	return 1
}

rasp_pi_tightvnc(pi_ip_id=0, host_ip_id=0) {
	global pi_ip_prefix
	pi_ip := pi_ip_prefix pi_ip_id
	host_ip := pi_ip_prefix host_ip_id
	run %cd%.\Shortcuts\TightVNCViewer
	Sleep, 4000
	WinWait, New TightVNC Connection, , 5
	if ErrorLevel {
		return -1
	}
	; SendInput, %pi_ip%:0
	SendInput, %pi_ip%:1
	SendInput, {Enter}
	WinWait, Vnc Authentication, , 5
	if ErrorLevel {
		return -1
	}
	Sleep, 250
	SendInput, tube@99@
	SendInput, {Enter}
	return 1
}

rasp_pi_mosq_sub(pi_ip_id=0, pi_topic="rpi_topic") {
	global pi_ip_prefix
	pi_ip := pi_ip_prefix pi_ip_id
	pi_cmd := "mosquitto_sub -h " pi_ip " -t " pi_topic
	SendInput, %pi_cmd%
	return 1
}

rasp_pi_mosq_pub(pi_ip_id=0, pi_topic="rpi_topic", msg="") {
	global pi_ip_prefix
	pi_ip := pi_ip_prefix pi_ip_id
	pi_cmd := "mosquitto_pub -h " pi_ip " -t " pi_topic " -m " msg
	SendInput, %pi_cmd%
	return 1
}


; ------------ Mouse Over Window/Object Hotkeys
; ------------------------ Over TaskBar Controls

#If MouseIsOver("ahk_class Shell_TrayWnd")

$WheelUp::Volume_Up
$WheelDown::Volume_Down
$XButton1::Media_Prev
$XButton2::Media_Next

#If
; TESTING
; #If MouseIsOver("ahk_class EVERYTHING")
; WheelUp::Send {Volume_Up}
; WheelDown::Send {Volume_Down}
; #If

MouseIsOver(WinTitle,requireActive=false) {
    MouseGetPos,,, Win
	op := WinExist(WinTitle . " ahk_id " . Win)
	if ( requireActive = true )
		op := WinActive(WinTitle . " ahk_id " . Win)
    return op
}
MouseIsOver_Active(WinTitle) {
    return MouseIsOver(WinTitle,true)
}

; ------------ Chrome Tab Controls
#If MouseIsOver_Active("ahk_exe chrome.exe")
; $F13::SendInput, +^{Tab}
; $F14::SendInput, ^{Tab}
#If MouseIsOverChromeTabs(true)
; $WheelUp::SendInput, +^{Tab}
; $WheelDown::SendInput, ^{Tab}
#If

; very specific function for Chrome (Tab)
MouseIsOverChromeTabs(requireActive=false) {
	MouseGetPos,,, opWin, opControl
	correctWin := MouseIsOver("ahk_exe chrome.exe",requireActive)
	correctCtr := (opControl = "Intermediate D3D Window1")
	return (correctWin && correctCtr)
}

; "Intermediate D3D Window1"

SetToolTip(txt="",delay=1000) {
	ToolTip, %txt%
	SetTimer, ResetToolTip, %delay%
}
ResetToolTip:
SetTimer, ResetToolTip, OFF
ToolTip,
return



; ------------ Invoke Special Keys

; with ScrollLock on,
; F1-F12 triggers F13-F24, after a delay
#If GetKeyState("ScrollLock","T")
$F1::
$F2::
$F3::
$F4::
$F5::
$F6::
$F7::
$F8::
$F9::
$F10::
$F11::
$F12::
f_key_txt := A_ThisHotkey
f_key_num := SubStr(A_ThisHotkey,3)
; MsgBox, %f_key_num%
invoke_F_Keys(f_key_num+12,1000)
return



#If

invoke_F_Keys(num=1,delay=0) {
    if num is not integer
        return
    if ( num < 1 or num > 24 )
        return
    Sleep, %delay%
    key_name := "F" + num
    SendInput, {%key_name%}
}


; ------------ Mouse Flick Quick Actions

;$NumpadAdd::
MouseGetPos, x0, y0
Keywait, NumpadAdd
MouseGetPos, x1, y1
r := FlickCalc(4, 200, 0, 0, x0, y0, x1, y1)
if (r = 0)
	send #{Tab}
if (r = 1)
	send ^{Tab}
if (r = 2)
	send !{ESC}{Alt up}
if (r = 3)
	send ^+{Tab}

return


FlickCalc(option, range, offset, errorMargin, x0, y0, x1, y1) {
	if (option <= 0)
		option := 1
	xD := x1 - x0
	yD := y0 - y1
	dist := sqrt(xD*xD + yD*yD)
	if (dist < range)
		return -1
	
	if (xD = 0)
		angle := ( 1 - abs(yD)/yD ) * 90.0
	else {
		angle := ( 90 - ATan(yD/xD) * abs(xD)/xD * 57.2958 ) * abs(xD)/xD + 180 * ( 1 - abs(xD)/xD )
	}
	angle := angle + 180/option + offset
	
	while (angle >= 360)
		angle := angle - 360
	while (angle < 0)
		angle := angle + 360
	
	if (angle < 90)
		r := 1
	r := floor(angle * option / 360)
	return r
}


;--------------------------------------------------------- Mouse Wiggle
;Disabled

;!+\::
wiggleX:=20
send {LButton down}
Loop 200
{
	state := GetKeyState("esc", "P")
	if state = 1
	{
		send {LButton up}
		return
	}
	MouseMove, %wiggleX%, 0, 100, R
	wiggleX := -wiggleX
}
send {LButton up}
return

;--------------------------------------------------------- Alpha Modifier (for Default AHK)
*$F24::
alphaMod := 1
SetTimer, setAlphaModOff, -120000
return
*$F24 Up::
setAlphaModOff:
SetTimer, setAlphaModOff, OFF
alphaMod := 0
return


#If alphaMod = 1



$1::
; SetToolTip("got here?")
; copy program name
WinGetTitle, title, A
SetToolTip(title, 2000)
Sleep, 200
clipboard = %title%
return


return
SendInput, {RButton}
Sleep, 100
SendInput, {v}
windowFound := false
Loop, 100
{
	WinGetActiveTitle, activeTitle
	if ( activeTitle = "Save As" ) {
		windowFound := true
		break
	}
	Sleep, 20
}
; MsgBox, %windowFound%
if ( windowFound ) {
	SendInput, {Enter}
}
return

$F14::^#Left
$F13::^#Right

$WheelUp::Volume_Up
$WheelDown::Volume_Down
$MButton::Volume_Mute
$XButton1::Media_Prev
$XButton2::Media_Next
$NumpadSub::Media_Prev
$NumpadAdd::Media_Next

$^Left::win_move(-1,0)
$^Right::win_move(1,0)
$^Up::win_move(0,-1)
$^Down::win_move(0,1)
$^+Left::win_move(-5,0)
$^+Right::win_move(5,0)
$^+Up::win_move(0,-5)
$^+Down::win_move(0,5)
$^Enter::win_center()

win_center() {
	WinGetPos, , , ww, wh, A
	tx := A_ScreenWidth / 2 - ww / 2
	ty := A_ScreenHeight / 2 - wh / 2
	WinMove, A, , %tx%, %ty%
}
win_move(mx=0,my=0) {
	WinGetPos, wx, wy, , , A
	tx := wx + Round(mx)
	ty := wy + Round(my)
	WinMove, A, , %tx%, %ty%
}

; Macro Recorder
; $F1::macroNew(true,1)
; $F2::macroNew(true,0)
; $F3::macroNew(false,1)
; $F4::macroNew(false,0)
macroNew(getPos,clickCount)
{
	global macroClick, macroCount, macroActive
	MouseGetPos, tempX, tempY
	macroClick[ macroCount, 0 ] := tempX
	macroClick[ macroCount, 1 ] := tempY
	macroClick[ macroCount, 2 ] := clickCount
	macroClick[ macroCount, 3 ] := getPos
	macroCount++
	macroActive := true
	;MsgBox, working? - %macroCount%
}

; $F5:: ;reset
macroActive := false
macroCount := 0
return
; $F6:: ;show coordinates
txt := ""
while ( A_Index <= macroCount && macroActive, i := A_Index - 1 ) {
	if ( i >= 100 )
		break
	MouseX := macroClick[ i, 0 ]
	MouseY := macroClick[ i, 1 ]
	MouseCount := macroClick[ i, 2 ]
	if ( MouseCount <= 0 )
		MouseCount := 0
	if ( MouseCount >= 12 )
		MouseCount := 12
	MouseCoord := macroClick[ i, 3 ]
	; MsgBox, [%MouseX%,%MouseY%]
	; sleep, 20
	txt := txt MouseX " " MouseY " " MouseCount "`n"
}
if ( macroCount >= 1 ) {
	MsgBox, %txt%
}
return
`:: ;execute
MouseGetPos, xO, yO
while ( A_Index <= macroCount && macroActive, i := A_Index - 1 ) {
	if ( i >= 100 )
		break
	MouseX := macroClick[ i, 0 ]
	MouseY := macroClick[ i, 1 ]
	MouseCount := macroClick[ i, 2 ]
	if ( MouseCount <= 0 )
		MouseCount := 0
	if ( MouseCount >= 12 )
		MouseCount := 12
	if ( macroClick[ i, 3 ] = true )
		click, %MouseX%, %MouseY%, %MouseCount%
	else
		click, %xO%, %yO%, %MouseCount%
	;MsgBox, [%MouseX%,%MouseY%]
	sleep, 20
}
click, %xO%, %yO%, 0
;MsgBox, %macroCount%`n%macroActive%
return


;F1::
SplashTextOn, 400, 60, SplashWindow, color=
WinMove, SplashWindow, , 966, 30
While GetKeyState("F1","p") {
	MouseGetPos, MouseX, MouseY
	PixelGetColor, color, %MouseX%, %MouseY%, RGB
	ControlSetText, Static1, %color%, SplashWindow
	sleep 250
}
SplashTextOff
return

;F2::
value:=30
;Progress, %value% , , %value%`%, ProgressWindow
WinMove, ProgressWindow, , 969, 30, 400, 85
Keywait, F2
Progress, Off
return


; $F1::Gosub, KeyTest
$F1::Gosub, ClipboardTooltip

ClipboardTooltip:
SetToolTip(clipboard, 2000)
return
KeyTest:
commands_txt := "{1 2}{Space 3}{y 1}"
SetToolTip(commands_txt)
SendInput, %commands_txt%
return

;============ Key Auto-Repeater

;$RButton::
While GetKeyState("RButton","p") {
	Send ^{RButton}
	Sleep 20
}
return

; $1::
; While GetKeyState("1","p")
; 	Send {1}
; return

; $2::
; While GetKeyState("2","p")
; 	Send {2}
; return

; $3::
; While GetKeyState("3","p")
; 	Send {3}
; return

; $c::
; While GetKeyState("c","p")
; 	Send {c}
; return

; $v::
; While GetKeyState("v","p")
; 	Send {v}
; return

; $Space::
; While GetKeyState("Space","p")
; 	Send {Space}
; return


;$::
While GetKeyState("","p")
	Send {}
return



#If
;---------------------------------------------------------







#IfWinActive, StarCraft II

$Enter::return
$Capslock::`

$F14::KeyRepeater("F14", "{LButton}", 0, 20)

$F13::KeyRepeater("F13", "{RButton}", 0, 20)


KeyRepeater(keyTrigger, keySend, checkstate=1, delay=100, statetype="p") {
	Loop, 1000 {
		if KeyStateResponse(keyTrigger, checkstate, delay) {
			break
		}
		SendInput, %keySend%
	}
	return True
}

KeyStateResponse(key, checkstate=1, timeout=1000, statetype="p", autostop=True) {
	check_interval := 1
	tickcount_start := A_TickCount
	output := False
	While True {
		tickcount_current := A_TickCount
		if tickcount_current - tickcount_start >= timeout
			break
		if GetKeyState(key, statetype) = checkstate {
			output := True
			if autostop {
				break
			}
		}
		; Sleep, %check_interval%
	}
	return output
}

#If

return
;$NumpadAdd::
reading := ReadMemory(0x0C677C8C)

CoordMode, Mouse, Screen
MouseGetPos, currentX, currentY 
SplashTextOn, 400, 120, SplashWindow, The clipboard contains:`n%clipboard%`n%reading% C
WinMove, SplashWindow, , %currentX%, %currentY%
Keywait, NumpadAdd
SplashTextOff
CoordMode, Mouse, Window
return

; ---------------------------------------------------------
; ---------------------------------------------------------
; ---------------------------------------------------------
; ---------------------------------------------------------
; ---------------------------------------------------------
; ---------------------------------------------------------

ProAdd := 18E4
SetFormat, IntegerFast, d

MemAdd := 0x
;--------------------------------------------------------------------------------------------------
value:=ReadMemory(%MemAdd%)

ReadMemory(MADDRESS)
{

ProAdd += 0
ProAdd .= ""

VarSetCapacity(MVALUE,4,0)
ProcessHandle := DllCall("OpenProcess", "Int", 24, "Char", 0, "UInt", 18E4, "UInt")
DllCall("ReadProcessMemory","UInt",ProcessHandle,"UInt",MADDRESS,"Str",MVALUE,"UInt",4,"UInt *",0)

Loop 4
result += *(&MVALUE + A_Index-1) << 8*(A_Index-1)

return, result 
}