; GUI CONTROL

if not A_IsAdmin
{
   Run *RunAs "%A_ScriptFullPath%"
}


CoordMode, Mouse, Screen
SetWinDelay, -1

SplashTextOn, 400, 60, SplashWindow,
WinMove, SplashWindow, , 966, 682

loop {
	SplashTextOff
	break
	MouseGetPos, mouseX, mouseY
	WinMove, SplashWindow, , mouseX+20, mouseY+20
}



wiggleCount := 6
wiggleMoveX := 3

Gui, Add, Edit, r1 w120 y6 Limit32 vCommandLine ,
Gui, Add, Button, Default y5 gExecute, >>
Gui, Show, ,Terminal
WinMove, Terminal, , 1188, 707

loop
{
	Sleep, 20
	Gui, Submit, NoHide
	if ( InStr( CommandLine , "q" ) == 1 ) {
		WinGetPos, winX, winY, , ,Terminal
		
		; ---- OLD Wiggler
		if (0)
		while ( A_Index <= 4 * wiggleCount ) {
			if ( mod( A_Index , 4 ) <= 1 )
				winX += wiggleMoveX
			else
				winX -= wiggleMoveX
			WinMove, Terminal, , winX, winY
		}
		
		; ---- NEW Wiggler
		while ( A_Index <= wiggleCount ) {
			if ( mod( A_Index , 2 ) == 1 )
				WinMove, Terminal, , winX + wiggleMoveX, winY
			else
				WinMove, Terminal, , winX - wiggleMoveX, winY
		}
		WinMove, Terminal, , winX, winY
		
	}
	
}


#SingleInstance force
^`::suspend
!`::reload
^!`::exitapp
return



Execute:
Gui, Submit, NoHide

if ( InStr( CommandLine , "r" ) == 1 )
	reload

WinGetPos, winX, winY
if ( InStr( CommandLine , "w" ) == 1 )
	winY--
if ( InStr( CommandLine , "a" ) == 1 )
	winX--
if ( InStr( CommandLine , "s" ) == 1 )
	winY++
if ( InStr( CommandLine , "d" ) == 1 )
	winX++
WinMove, Terminal, , winX, winY

GuiControl,, CommandLine,
return

$#Space::
Gui, Show
return
