
if not A_IsAdmin
{
   Run *RunAs "%A_ScriptFullPath%"
}

temp:=1

^`::suspend
!`::reload
^!`::exitapp
return

;------------------------
#SingleInstance force
;------------------------

^+F11::WinMove, A, , 0, 30, 1366-480, 768-7
^+F10::WinMove, A, , 1366-496+8, -12, 496, 1000


+F12::
while ( A_Index <= 10 ) {
	SetTimer, Duplicate_html, -1
	Sleep, 100
}
return

$\::
Duplicate_html:
b := floor( temp / 10 )
a := mod(temp, 10)
send, ^{v}{home 2}{up 2}{right 10}{delete}
if ( temp >= 10 )
	printDigit(b)
printDigit(a)
send, {down}{home}{right 11}{delete}
if ( temp >= 10 )
	printDigit(b)
printDigit(a)
send, {down}{end}
temp++
return

printDigit(a=0) {
	if ( a < 0 || a >= 10 )
		return
	if (a==0)
		send, {0}
	if (a==1)
		send, {1}
	if (a==2)
		send, {2}
	if (a==3)
		send, {3}
	if (a==4)
		send, {4}
	if (a==5)
		send, {5}
	if (a==6)
		send, {6}
	if (a==7)
		send, {7}
	if (a==8)
		send, {8}
	if (a==9)
		send, {9}
}

click 2
send, ^{c}{esc}
send, ^+{s}
sleep, 1200
send, ^{v}{tab}{down}{end}{up 4}{Enter}
sleep, 1200
send, {Enter}
sleep, 1200
send, {Enter}

return


return

