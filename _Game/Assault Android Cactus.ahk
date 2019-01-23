^`::suspend
!`::reload
return

------------------------------------------------------------------------------------------------------------------------
#SingleInstance force
#IfWinActive Assault Android Cactus


delay := 40

$q::send {LButton down}
$z::send {LButton down}
$x::send {LButton up}
$MButton::send {LButton up}{LButton 50}{LButton down}