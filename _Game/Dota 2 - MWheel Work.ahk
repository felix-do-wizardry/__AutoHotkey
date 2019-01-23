#NoEnv
SendMode Input
SetWorkingDir %A_ScriptDir%
#InstallKeybdHook
#UseHook
#KeyHistory 0
#SingleInstance force
#MaxHotKeysPerInterval 10000
#IfWinactive, DOTA 2
{
WheelUp::Send {k}
WheelDown::Send {l}

$^d::
sleep 100
send {Enter}-createhero  enemy{Left}{Left}{Left}{Left}{Left}{Left}
return

$^f::send {Enter}-refresh{Enter}

}
^`::suspend