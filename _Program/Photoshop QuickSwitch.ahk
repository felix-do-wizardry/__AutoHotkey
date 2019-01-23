^`::suspend
!`::reload
return

;#IfWinActive DOTA 2
----------------------------------------------------
;SetCapsLockState, alwaysoff


+MButton::SaveInPNG(100)

SaveInPNG(delay){
	sleep %delay%
	sleep %delay%
	send ^+s
	sleep %delay%
	sleep %delay%
	sleep %delay%
	sleep %delay%
	send {tab}{down}{end}{up 4}
	sleep %delay%
	send +{tab}Dock  FULLx64 Complete.png
	sleep %delay%
	send {home}{right 5}
}

----------------------------------------------------
----------------------------------------------------
----------------------------------------------------
----------------------------------------------------

return