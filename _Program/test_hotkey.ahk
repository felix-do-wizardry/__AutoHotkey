;test AHK hotkeys

if not A_IsAdmin
{
   Run *RunAs "%A_ScriptFullPath%"
}

#SingleInstance force
#MaxHotkeysPerInterval 200

!`::reload

$F1::
sleep, 2000
send, {F24}
;MsgBox, did it
return