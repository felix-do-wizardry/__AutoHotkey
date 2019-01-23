
#SingleInstance force
#MaxHotkeysPerInterval 200
#InstallKeybdHook

if not A_IsAdmin
{
   Run *RunAs "%A_ScriptFullPath%"
}

macro_arr := []
key_state_last := []
key_state_current := []
key_found := False
key_code := "sc000"
key_num := 0
key_state := False
macro_is_recording := False

interval_count := 0

^`::suspend
!`::reload
return

; ------------ Invoke Special Keys

; with ScrollLock being on,
; F1-F12 triggers F13-F24, after a delay
#If GetKeyState("ScrollLock","T")
; F1::
; F2::
; F3::
; F4::
F5::
F6::
F7::
F8::
F9::
F10::
F11::
F12::
f_key_txt := A_ThisHotkey
f_key_num := SubStr(A_ThisHotkey,2)
; MsgBox, %f_key_num%
invoke_F_Keys(f_key_num+12,1000)
return


; $F4::return
; $F4 up::macro_record()

ST_macro_scan_for_keys:
interval_count++
macro_scan_for_keys()
return



macro_scan_for_keys() {
    global macro_is_recording, macro_arr
    global key_state_last, key_state_current
    global interval_count
    While ( A_Index <= 0x100, i := A_Index ) {
        key_code := "sc" . Format("{:X}", i)
        key_state := GetKeyState(key_code,"P")
        ; MsgBox, %key_code%`n%key_state%
        ; return
        key_state_last[i] := key_state_current[i]
        key_state_current[i] := key_state

        if ( key_state_current[i] <> "" ) {
        if ( key_state_last[i] <> key_state_current[i] ) {
            ; state of the key changed
            macro_arr.push({ code: key_code, state: key_state })
            ; MsgBox, % key_code . " - " . key_state
            ; return
        }}
    }
}

macro_record() {
    ; record macro
    global macro_is_recording, macro_arr
    global key_state_last, key_state_current
    if ( macro_is_recording ) {
        macro_is_recording := False
        SetTimer, ST_macro_scan_for_keys, OFF
        return
    }
    else {
        macro_is_recording := True
    }
    macro_arr := []
    key_state_last := []
    key_state_current := []
    While ( A_Index <= 0x100, i := A_Index ) {
        key_state_last[i] := 0
        key_state_current[i] := 0
    }
    SetTimer, ST_macro_scan_for_keys, 1
    return
}
return

; $F3::return
; $F3 up::
While ( A_Index <= macro_arr.length(), i := A_Index ) {
    tempCode := macro_arr[i].code
    tempState := macro_arr[i].state
    tempSend := "{" . tempCode . " "
    if ( tempState )
        tempSend .= "down"
    else
        tempSend .= "up"
    tempSend .= "}"
    SendInput, %tempSend%
}
return

; $F2::return
; $F2 up::
txt := macro_arr.length() . "`n"
While ( A_Index <= macro_arr.length(), i := A_Index ) {
    tempCode := macro_arr[i].code
    tempState := macro_arr[i].state
    tempName := GetKeyName(tempCode)
    txt := % txt tempName . " - " . tempCode . " - " . tempState . "`n"
}
MsgBox, %txt%
return


; $F1 up::
Sleep, 20
; SetFormat, IntegerFast, hex
While ( A_Index <= 20 ) {
    While ( A_Index <= 0x100, i := A_Index ) {
        key_num := i
        key_code := "sc"
        if ( i < 0x10 )
            key_code .= "0"
        if ( i < 0x100 )
            key_code .= "0"
        ; key_code .= key_num
        key_code .= Format("{:X}", i)
        key_state := GetKeyState(key_code,"P")
        ; MsgBox, %key_code%`n%key_state%
        ; return
        if ( key_state ) {
            txt := key_code . " is being pressed down"
            MsgBox, %txt%
            return
        }
    }
    Sleep, 50
}
MsgBox, not a single key was pressed down
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


; ------------ Window Size/Pos Manipulation

shrinkNotepadPP(direction=1,shrinkR=.8,shrinkD=.1) {
	if ( shrinkR <= 0 ) {
		shrinkR := 1
	}
	if ( direction < 0 ) {
		shrinkR := 1 / shrinkR
	}
	currentWindow := "ahk_class Notepad++"
	IfWinExist, %currentWindow%
	{
		WinShrink(currentWindow, shrinkR, shrinkD)
	}
}
return

WinShrink(WinTitle="A",shrinkRatio=.5,duration=.2) {
    WinGetPos, fX, fY, fW, fH, %WinTitle%
	SetWinDelay, -1
	tX := fX + (1-shrinkRatio) * (fW/2)
	tY := fY + (1-shrinkRatio) * (fH/2)
	tW := fW * shrinkRatio
	tH := fH * shrinkRatio
	tickCount := duration * 60
	while (A_Index < tickCount) {
		cX := fX + (tX - fX) * A_Index / tickCount
		cY := fY + (tY - fY) * A_Index / tickCount
		cW := fW + (tW - fW) * A_Index / tickCount
		cH := fH + (tH - fH) * A_Index / tickCount
		WinMove, %WinTitle%,, cX, cY, cW, cH
		;Sleep, 10
	}
	WinMove, %WinTitle%,, tX, tY, tW, tH
	return
}

return

; ------------ END