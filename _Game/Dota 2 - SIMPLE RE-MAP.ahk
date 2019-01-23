^`::suspend
!`::reload
return

;#IfWinActive DOTA 2
----------------------------------------------------
;SetCapsLockState, alwaysoff
*CapsLock::Return
LWin::LAlt

Capslock & q::send 1
Capslock & w::send 2
Capslock & e::send 3
Capslock & r::send 4
Capslock & a::send 5
Capslock & s::send 6
Capslock & d::send 7
Capslock & f::send 8



Capslock & z::LobbyCreate(1000)
Capslock & x::LobbySetup(500)


LobbyCreate(delay){
click 1366 768
sleep %delay%
click 1200 736
sleep %delay%
click 1200 292
sleep %delay%
click 1200 690
sleep %delay%
click 686 686
}

LobbySetup(delay){
click 960 140
sleep %delay%

click 1300 140
sleep %delay%
click 0 210 Rel
sleep %delay%
click 0 -175 Rel
sleep %delay%
click 0 210 Rel
sleep %delay%
click 0 -175 Rel
sleep %delay%
click 0 210 Rel
sleep %delay%
click 0 -175 Rel
sleep %delay%
click 0 210 Rel
sleep %delay%
click 0 -175 Rel
sleep %delay%
click 0 210 Rel

sleep %delay%
click 1200 736 0
}

----------------------------------------------------
----------------------------------------------------
----------------------------------------------------
----------------------------------------------------

return