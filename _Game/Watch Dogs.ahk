`::suspend

----------------------------------------------------


;BASTION
#IfWinActive watch_dogs
$*q::
send {q down}
sleep 50
send {q up}

return

$*1::
send {Tab down}
MouseGetPos, x, y
click, %x%+0, %y%-40, 0
sleep 100
send {Tab up}

return

