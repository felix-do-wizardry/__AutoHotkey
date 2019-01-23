; Clipboard Manipulation

if not A_IsAdmin
{
   Run *RunAs "%A_ScriptFullPath%"
}

#SingleInstance force
;#Persistent
CoordMode, Mouse, Screen
;SetWinDelay, -1
;OnClipboardChange("ClipChanged", -1)

lastClip := clipboard
savedClip := []
savedClip[0] := clipboard
savedClipDisplay := []
savedClipCount := 1
maxCount := 10
maxLength := 20
;Progress, b w246 x1120 y520 cb00CCFF ct4488FF cw505050 R0-%temp0% P0,,Starting,,Source Code Pro
Progress, b w246 h248 x1120 y520 cb00CCFF ct4488FF cw505050 zh0,,Starting`nAAA,,
;Progress, b w246 x1120 y520 cb00CCFF ct4488FF cw505050 zh0,,Starting,,Source Code Pro
Sleep 2000
while ( A_Index <= 100 ) {
	txt := "12345`nXYZ"
	Progress, , ,%txt%`nABC
	MsgBox, %txt%`nABC
	Sleep 1000
}


^`::suspend
!`::reload
^!`::exitapp
return

;ClipChanged(Type) {
	global lastClip, savedClip, savedClipCount, savedClipDisplay, maxCount
	
	if ( prevClipCount < maxCount )
		prevClipCount++
	;while ( A_Index <= prevClipCount , )
	
	displayUpdate()
;}

displayUpdate() {
	global lastClip, savedClip, savedClipCount, savedClipDisplay
	global maxCount, maxLength
	
	while ( A_Index <= savedClipCount , i := A_Index - 1 ) {
		savedClipDisplay[i] := savedClip[i]
		firstLineLength := InStr( savedClipDisplay[i] , "`n" ) - 1
		if ( firstLineLength > maxLength - 3 )
			break
	}
	
	tempClip := clipboard
	lengthA := StrLen( tempClip )
	length0 := InStr( tempClip , "`n" ) - 1
	txt = %clipboard%
	;txt := txt "`nlengthA = " lengthA "length0 = " length0
	Progress,,,`n%txt%
}



