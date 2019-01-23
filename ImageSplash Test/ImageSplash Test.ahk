#SingleInstance force
CoordMode, Mouse, Screen



; SplashImage [, ImageFile, Options, SubText, MainText, WinTitle, FontName]
imageFile := "ImageSplash Test - Mouse Command Ring Test.png"
SplashImageGUI(imageFile, -200, -200, 1000, "M")



^`::suspend
!`::reload
^!`::exitapp
return


; ECE9D8
SplashImageGUI(Picture:="Off", x:=0, y:=0, Duration:=-1, Coordinates:="Screen", Transparent=true, BGcolor:="222222")
{
	if ( Picture == "Off")
		goto DestroySplashGUI
	
	Gui, XPT99:Margin , 0, 0
	Gui, XPT99:Add, Picture,, %Picture%
	Gui, XPT99:Color, %BGcolor%
	Gui, XPT99:+LastFound -Caption +AlwaysOnTop +ToolWindow -Border
	If Transparent
		Winset, TransColor, %BGcolor%
	
	
	pX := 0
	pY := 0
	if ( SubStr(Coordinates,1,1) == "M" ) {
		CoordMode, Mouse, Screen
		MouseGetPos, pX, pY
	}
	else if ( SubStr(Coordinates,1,1) == "W" ) {
		WinGetPos, pX, pY
	}
	x += pX
	y += pY
	Gui, XPT99:Show, x%x% y%y% NoActivate
	
	if ( Duration >= 0 )
		SetTimer, DestroySplashGUI, -%Duration%
	return

	DestroySplashGUI:
	Gui, XPT99:Destroy
	return
}


$F4::
; Example: On-screen display (OSD) via transparent window:

CustomColor = EEAA99  ; Can be any RGB color (it will be made transparent below).
Gui +LastFound +AlwaysOnTop -Caption +ToolWindow  ; +ToolWindow avoids a taskbar button and an alt-tab menu item.
Gui, Color, %CustomColor%
Gui, Font, s32  ; Set a large font size (32-point).
Gui, Add, Text, vMyText cLime, XXXXX YYYYY  ; XX & YY serve to auto-size the window.
; Make all pixels of this color transparent and make the text itself translucent (150):
WinSet, TransColor, %CustomColor% 150
SetTimer, UpdateOSD, 200
Gosub, UpdateOSD  ; Make the first update immediate rather than waiting for the timer.
Gui, Show, x0 y400 NoActivate  ; NoActivate avoids deactivating the currently active window.
return

UpdateOSD:
MouseGetPos, MouseX, MouseY
GuiControl,, MyText, X%MouseX%, Y%MouseY%
return


