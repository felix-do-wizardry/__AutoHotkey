
#SingleInstance force
#MaxHotkeysPerInterval 200
if not A_IsAdmin
{
   Run *RunAs "%A_ScriptFullPath%"
}

state := 0

!`::reload

#IfWinActive, Cuphead

$^f::
send {f down}
return

#If