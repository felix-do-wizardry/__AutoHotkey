delay := 60
mouseX := [110,175,240]
mouseY := [688,688,688]
mouseX := [110,175,240]
mouseY := [1030,1030,1030]
code := 18
code_2 := 30
code_seq_0 := "1171 1293 8836 1464 8780 9721 0228 1339 0331 9376 4159 7157 5568 7110 7384 7638 6166 2086 1227 2249 3296 9191 8028 5790 3430 4726 1951 4250 7551 3725 4649 6835 4671 3722 1753 0914 3862 9235 5147 7056"
code_seq := "2053 9126 1508 3264 1350 2571 1972 1327 3701 9834 0065 2459 6523 1945 6684 7351 0937 9159 0551 3425"
SetKeyDelay, -1
;SetMouseDelay, -1
SetDefaultMouseSpeed, 0
SetTitleMatchMode, 2


if not A_IsAdmin
{
   Run *RunAs "%A_ScriptFullPath%"
}


#SingleInstance force
#MaxHotkeysPerInterval 200
#HotkeyInterval 5000


^`::suspend
!`::reload
^!`::ExitApp
return



$F4::
txt = %clipboard%
latex := StrSplit(txt, "`n")
; While (A_Index < latex.Length) {
; 	SetToolTip(latex.A_Index, 2000)
; 	Sleep, 500
; }
For i, v in latex {
	SetToolTip("[" . i . "]   " . v, 2000)
	Sleep, 100
}
return






#IfWinActive, foobar2000


; $F1::Gosub, Foobar_rename
; $F2::
Loop, 5 {
	if (GetKeyState("ESC", "P")) {
		break
	}
	WinWaitActive, foobar2000, , 4
	if (GetKeyState("ESC", "P")) {
		break
	}
	Gosub, Foobar_rename
	if (GetKeyState("ESC", "P")) {
		break
	}
	WinWaitActive, foobar2000, , 4
	if (GetKeyState("ESC", "P")) {
		break
	}
	Sleep, 50
	SendInput, {Down}
}
return
Foobar_rename:
delay := 160
; txt_sample := "Aiobahn feat. Ralph Larenzo - In Your Arms www.my-free-mp3.net .mp3"
txt_link := "www.my-free-mp3.net"
SendInput, {ESC 2}!{Enter}+{Tab}{Right}{Tab}{Down 2}{F2}
Sleep, %delay%
SendInput, ^{c}
Sleep, %delay%
txt = %clipboard%
txt_link_pos := InStr(txt, txt_link)
if (txt_link_pos <= 0) {
	; SendInput, {ESC 3}
	; return
	txt_link_pos := InStr(txt, ".mp3")
}
txt_cut := SubStr(txt, 1, txt_link_pos - 1)
txt_dash_pos := InStr(txt_cut, "-")
txt_0 := Trim(SubStr(txt_cut, 1, txt_dash_pos - 1))
txt_1 := Trim(SubStr(txt_cut, txt_dash_pos + 1))
; SetToolTip(clipboard . "`n" . txt . "`n" . txt_link_pos . "`n" . txt_0 . "`n" . txt_1, 2000)
; return
; Sleep, %delay%
; clipboard = %txt_0%
; Sleep, %delay%
; MsgBox, %clipboard%
; return
SendInput, {ESC}+{Tab}{Left}{Tab}{Down}{F2}
SendInput, ^{c}
if (clipboard != "") {
	SendInput, %txt_0%
}
; SendInput, ^{v}
; Sleep, %delay%
; clipboard = %txt_1%
; Sleep, %delay%
SendInput, {Enter}
SendInput, ^{c}
if (clipboard != "") {
	SendInput, %txt_1%
}
; SendInput, ^{v}
SendInput, !{o}
return

#If



; $F14::
SendInput, {F2}^c
Sleep, 200
clip_rep := StrReplace(clipboard, "trans_")
; SetToolTip(clip_rep)
Sleep, 200
clipboard := clip_rep
Sleep, 200
SendInput, ^v{Enter}{down}
return




; $F5::
return
; $F1::
code_2 += 1
SendInput, {Home}^{f}
Sleep, 200
clipboard := create_code(code_2)
; SetToolTip(clipboard)
; return
SendInput, {Home}+{End}^{v}{Enter}
Sleep, 400
Click, 1216, 412, 1
Sleep, 800
; SendInput, {Tab}{End}+{left 3}^{v}
Click, 580, 400, 1
Sleep, 300
Click, 580, 450, 1
Sleep, 300
SendInput, {Tab 3}20
SendInput, {Tab 3}30/09/2018
SendInput, {Tab 1}11:49 PM
SendInput, {Tab 1}1
Sleep, 800
Click, 680, 680, 1
return
; $F2::
SendInput, {Home}{down}+{End}^{c}
return

; $F8::
code_seq = %clipboard%
code_seq := StrReplace(code_seq, " ", "0")
; code_seq := StrReplace(code_seq, "`r`n", "`r`n0930FRAMGIA_")
code_seq := "'" . StrReplace(code_seq, "`r`n", "`r`n'")
; code_seq := "0930FRAMGIA_" . code_seq
clipboard = %code_seq%
SetToolTip(code_seq)
return
; $F9::
; code += 1
; codec := SubStr(code_seq, 5 * (code-1) + 1, 4)
; SetToolTip(codec)
; return

; $F4::
; $F14::
set_new_code:
code += 1
codec := create_code(code)
clipboard = %codec%
SetToolTip(codec)
SendInput, {End}
Sleep, 200
SendInput, {PgUp}
Sleep, 500
Click, 860, 460, 1
Sleep, 800
SendInput, {Tab}
Sleep, 400
SendInput, {Home}+{End}^v
Sleep, 400
Click, 680, 680, 1
return

; $F3::
; $F13::
create_code_mass(10)
return

; $F5::SetToolTip(create_code(26))

create_code_mass(count) {
	loop, %count% {
		Gosub, set_new_code
		Sleep, 6000
	}
}

get_code_no(id) {
	global code_seq
	return SubStr(code_seq, 5 * (id-1) + 1, 4)
}

create_code(id) {
	code := "0930FRAMGIA_" . get_code_no(id)
	return code
}

#IfWinActive, Adobe Audition
;$F14::SendInput, ^+s{Tab 6}{Space}+{Tab 4}{End}{up 1}+{Tab 2}
#If

;$F13::
SendInput, {F2}^{a}^{c}
Sleep, 100
clip = %clipboard%
clip_replaced := StrReplace(clip, ".m4a", ".m4r")
; SetToolTip(clip_replaced)
clipboard = %clip_replaced%
Sleep, 50
SendInput, ^{v}{Enter}
Sleep, 200
SendInput, {Enter}
Sleep, 50
SendInput, {down}
return

SendInput, {Tab}{down}{End}{up 4}{Enter}+{Tab}
return

;$F13::
;SendInput, output\PS_m00_v03_
;SendInput, output\BS_Santander_01_
;SendInput, PS_OG_00
;SendInput, PS_m01_0_HL{left 3}
SendInput, BS_HSBC_v05_00_OG{left 3}
return

;$F1::
SendInput, {F2}{Home}{right 15}^v{Enter}
return

; 
; $F1::
SendInput, !{Enter}{down}
SendInput, {F2}^{x}{Enter}
SendInput, {Home}^{v}+{End}^{x}{Enter}
SendInput, {ESC}{Home}{F2}^{v}{Enter}
SendInput, !{o}
; SendInput, 
return


; $F2::
SendInput, {RButton}{down 9}{Enter}
SendInput, {Tab 3}{Home}{Enter}
return

; $F1::
main_macro:
SendInput, ^+{s}
Sleep, 1400
SendInput, {Tab}{Down}{End}{Up 4}{Enter 2}
Sleep, 1600
SendInput, {Enter}
return
; 
SendInput, {F2}^{c}{ESC}
Sleep, 200
clip = %clipboard%
clip_replaced := StrReplace(clip, "www.my-free-mp3.net", "")
; SetToolTip(clip_replaced)
clipboard = %clip_replaced%
Sleep, 200
SendInput, {F2}^{v}{Enter}
; SendInput, 
return

; $F4::
while (A_Index <= 5) {
	Gosub, main_macro
	SendInput, {down}
	Sleep, 100
}
return


; $F1::
txt = %clipboard%
cutout := "the"
firstFind := InStr(txt, cutout)
; if (firstFind > 0)
txt := "sub: [" . SubStr(txt, 1, firstFind-1) . "]"
; txt := firstFind
SetToolTip(txt)
return



removeFromString(haystack, needle) {
	len := StrLen(needle)
	startPos := InStr(haystack, needle)
	if (startPos > 0) {
		
	}
}

; ---------------------------------------------------------
; rename multiple files
; $F1::
UniqueID := WinExist("Settings")
WinGetPos, wx, wy, , , Settings
; txt := wx " "
SetToolTip("" . wx . ", " . wy, 2000)
; WinActivate 
; IfWinExist, Settings
;     WinActivate ; use the window found above
return

SetToolTip(txt="",delay=1000) {
	ToolTip, %txt%
	SetTimer, ResetToolTip, %delay%
}
ResetToolTip:
SetTimer, ResetToolTip, OFF
ToolTip,
return


; ---------------------------------------------------------
; rename multiple files
; $F1::
txt := genRandCode(6)
clipboard = img0_%txt%
; MsgBox, %txt%
SendInput, {F2}^{v}{Enter}{down}
return

genRandCode(digitCount:=6) {
	txt := ""
	while ( A_Index <= digitCount ) {
		Random, rand, 0, 9
		txt := txt . rand
	}
	return txt
}


; ---------------------------------------------------------
; rename multiple files
; $F14::
SendInput, {RButton}
SendInput, {down 9}{Enter}
return

; ---------------------------------------------------------

; Google Docs Edit

; remove start time
; $F1::
SendInput, {F2}^{left 2}{left 3}+{end}{delete}{enter}
return
SendInput, {F2}^{left 2}+{home}{delete}{enter}
return

; $F1::
SendInput, {F2}{right}{left}^{v}{Enter}{down}
return
SendInput, {F2}{up 2}{home}^{v}{Enter}{down}
return
SendInput, {F2}{right}{left}
SendInput, {shift down}{up 5}{home}{right 14}{shift up}{BS}
SendInput, {left 2}{shift down}{up 2}{home}{shift up}{BS}{Enter}{right}
return


#IfWinActive, Adobe Audition CC

; $F13::
$F1::
MouseGetPos, MouseX0, MouseY0
; Selection Start
sleepDelay := 20

click, 110, 1030, 1
; click, mouseX%1%, mouseY%1%, 1
SendInput, ^{c}{esc}
sleep, %sleepDelay%
clipStart := clipboard

click, 180, 1030, 1
; click, mouseX%2%, mouseY%2%, 1
SendInput, ^{c}{esc}
sleep, %sleepDelay%
clipFinish := clipboard
clipDuration := clipboard
; return
click, %MouseX0%, %MouseY0%, 0

clipStart := processClip_Time(clipStart,true)
clipFinish := processClip_Time(clipFinish,true)
clipDuration := processClip_Time(clipDuration)
; MsgBox, %clipStart% ~ %clipFinish%
; return
clip := processTimeOutput(clipStart,clipDuration)
clip := "_" . clipStart . "_" . clipFinish
filename := "friends_S02_E15" . clip
clipboard = _%clip%
clipboard = %filename%
; MsgBox, %clipboard%
; MsgBox, %clipStart%`n%clipDuration%`n%clipboard%
; return

sleep, %sleepDelay%
SendInput, ^!{s}
; SendInput, {right}{left}+{left 3}
SendInput, ^{v}
SendInput, {Tab 2}{End}{up}
SendInput, {Tab 4}{Space}
SendInput, {Enter}
; sleep, %sleepDelay%
; MsgBox, %clip%
return


$F2::
; return
fileNames := []
Loop Files, C:\_English_Audio\_Audio\MKBHD\Clip\*.mp3 ;, R  ; Recurse into subfolders.
{
    ; MsgBox, 4, , Filename = %A_LoopFileFullPath%`n`nContinue?
	timeCode := SubStr(A_LoopFileName,26,-4)
	fileNames[A_Index] := timeCode
	timeCode := StrSplit(timeCode, "+")
	time_start_arr := StrSplit(timeCode[1], ".")
	time_duration_arr := StrSplit(timeCode[2], ".")
	time_start_s := stringToNum(time_start_arr[1]) * 60
	time_start_s += stringToNum(time_start_arr[2])
	time_start_s += stringToNum(time_start_arr[3]) / 10
	time_duration_s := stringToNum(time_duration_arr[1])
	time_duration_s += stringToNum(time_duration_arr[2]) / 10
	time_end_s := time_start_s + time_duration_s
	time_start_s := Round(time_start_s, 1)
	time_duration_s := Round(time_duration_s, 1)
	time_end_s := Round(time_end_s, 1)
	txt := "Filename = " . fileNames[A_Index]
	txt .= "`nStart:       `t" . time_start_s
	txt .= "`nDuration: `t" . time_duration_s
	txt .= "`nEnd:           `t" . time_end_s
	txt .= "`n`nContinue?"

	sleep, 100
	clipboard := time_start_s
	Click(mouseX[1], mouseY[1], 1)
	SendInput, ^{v}{Enter}
	sleep, 100
	clipboard := time_duration_s
	Click(mouseX[3], mouseY[3], 1)
	SendInput, ^{v}{Enter}
	SendInput, {m}

	; if ( A_Index >= 10 )
	; 	break
	; continue
	If ( GetKeyState("ESC", "P") = 1 )
		break
	continue
    MsgBox, 4, , %txt%
    ; MsgBox, 4, , Filename = %A_Index%`n`nContinue?
    IfMsgBox, No
        break
}
MsgBox, done
return

; set mouse click positions
$F5:: ; time start
$F6:: ; time end
$F7:: ; time duration
keyIndex := stringToNum(SubStr(A_ThisHotkey,0)) - 4
; MsgBox, %keyIndex%
; return
MouseGetPos, mx, my
mouseX[keyIndex] := mx
mouseY[keyIndex] := my
return

processTimeOutput(clipStart,clipDuration) {
	clip = %clipStart%+%clipDuration%
	; clip = clipStart%s+%clipDuration%s
	return clip
}

processClip_to_ms(clip) {
	clip := "000000000000" . clip
	time_h := stringToNum(SubStr(clip, 1, -10))
	time_m := stringToNum(SubStr(clip, -8, 2))
	time_s := stringToNum(SubStr(clip, -5, 2))
	time_ms := stringToNum(SubStr(clip, -2, 3))
	total_ms := time_ms + time_s*1000 + time_m*60000 + time_h*3600000
	; txt := ""
	; txt .= "h:  " . time_h  . "`n"
	; txt .= "m:  " . time_m  . "`n"
	; txt .= "s:  " . time_s  . "`n"
	; txt .= "ms: " . time_ms . "`n"
	; txt .= "total_ms: " . total_ms
	; MsgBox, %txt%
	return total_ms
}

processClip_Time(clip,include_minute:=false) {

	total_ms := processClip_to_ms(clip)
	count_m := floor(total_ms/60000)
	count_s := floor(total_ms/1000)
	time_s := floor(mod(total_ms,60000)/1000)
	time_ms := mod(total_ms,1000)
	op := ""
	op := "000000" . mod(round(time_ms/1),1000)
	; op := "000000" . mod(round(time_ms/100),10)
	op := SubStr(op, -2)
	if ( include_minute = true ) {
		op := "000000" . time_s . "." . op
		op := SubStr(op, -5)
		; op := SubStr(op, -3)
		op := "000000" . count_m . "." . op
		op := SubStr(op, -8)
		; op := SubStr(op, -7)
	}
	else {
		op := "000000" . count_s . "." . op
		op := SubStr(op, -3)
	}
	; MsgBox, %total_ms%`n%op%
	return op
}


stringToNum(string="") {
	; does not support decimal point
	; non-digit characters are considered to be 0
	num := 0
	while ( A_Index <= StrLen(string) && A_Index <= 64 ) {
		index := A_Index - 1
		dig := charToNum(SubStr(string, -index, 1))
		num += dig * (10 ** index)
	}
	return num
}
charToNum(char="") {
	code := Asc(char)
	num := code - 48
	if ( num >= 0 && num <= 9 )
		return num
	else
		return 0
}

#If

; $F2::
; txt := stringToNum("534.654")
; MsgBox, %txt%
; return

; $F3::
; processClip_to_ms("4:56.789")
; return

; ---------------------------------------------------------

Click(x:=0,y:=0,clickCount:=1) {
	if ( clickCount < 1 ) {
		click, %x%, %y%, 0
	}
	else {
		clickCount := Round(clickCount, 0)
		click, %x%, %y%, %clickCount%
	}
}

; ---------------------------------------------------------

; $F3::
send {Enter}
sleep 600
send {Tab}{Home}{Right 11}
send ^+{Right}
send field{Space}
send {Tab 10}
send {2}
send {Enter}{Down}

return

; ---------------------------------------------------------

; $F4::
send {Enter}
sleep 600
send {Tab 7}{End}
send ^+{Left}
send Bottom
send {Enter}{Down 3}
return

; $F5::
m0:=0
s0:=3
m1:=0
s1:=0

loop 60
{
	send {End}+{Left 3}
	writeDigit(m0)
	send, :
	writeDigit(s0)
	
	send {Tab}{End}+{Left 3}
	writeDigit(m1)
	send, :
	writeDigit(s1)
	
	send !{a}
	
	s0:=s0+1
	s1:=s1+1
	if s0 > 5
	{
		s0:=0
		m0:=m0+1
	}
	if s1 > 5
	{
		s1:=0
		m1:=m1+1
	}
	
	if m0 > 9
		return
	
	GetKeyState, state, esc, P
    if state = D
		return
	sleep 200
	GetKeyState, state, esc, P
    if state = D
		return
}

return

writeDigit(n)
{
	if n = 0
		send {0}
	if n = 1
		send {1}
	if n = 2
		send {2}
	if n = 3
		send {3}
	if n = 4
		send {4}
	if n = 5
		send {5}
	if n = 6
		send {6}
	if n = 7
		send {7}
	if n = 8
		send {8}
	if n = 9
		send {9}
}


; F6::
while (A_Index<=25, i:=A_Index-1)
{
send f+9
if (i>=10)
	writeDigit(floor(i/10))
writeDigit(mod(i,10))
send +0{down}
}

return



