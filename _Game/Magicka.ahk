`::suspend
;------------------------------------------------------------------------------------------------------------------------

#IfWinActive Magicka

;CAST Type
;0 - Normal Cast
;1 - Surround Cast
;2 - Weapon Cast
;3 - Self Cast
;4 - Magick Cast
;5 - No Cast

1::Cast(4, "Q", "F", "A", "S", "A")
2::Cast(1, "S", "S", "S", "S", "S")
3::Cast(1, "Q", "R", "Q", "R", "S", "S", "S")
4::Cast(4, "F", "Q", "F", "F", "Q", "F", "F", "Q")
5::Element(Q)

Cast(Type:=5, k0:=0, k1:=0, k2:=0, k3:=0, k4:=0, k5:=0, k6:=0, k7:=0, k8:=0, k9:=0){	
delay := 80

Element(k0)
sleep %delay%
Element(k1)
sleep %delay%
Element(k2)
sleep %delay%
Element(k3)
sleep %delay%
Element(k4)
sleep %delay%
Element(k5)
sleep %delay%
Element(k6)
sleep %delay%
Element(k7)
sleep %delay%
Element(k8)
sleep %delay%
Element(k9)
sleep %delay%

if Type = 0
	send {RButton}
if Type = 1
	send +{RButton}
if Type = 2
	send +{LButton}
if Type = 3
	send {MButton}
if Type = 4
	send {Space}
}

Element(k){
delay := 30
if k = 0
	return

if k = q
	send {q down}
if k = w
	send {w down}
if k = e
	send {e down}
if k = r
	send {r down}
if k = a
	send {a down}
if k = s
	send {s down}
if k = d
	send {d down}
if k = f
	send {f down}
	
sleep %delay%

if k = q
	send {q up}
if k = w
	send {w up}
if k = e
	send {e up}
if k = r
	send {r up}
if k = a
	send {a up}
if k = s
	send {s up}
if k = d
	send {d up}
if k = f
	send {f up}

}




------------------------------------------------------------------------------------------------------------------------

