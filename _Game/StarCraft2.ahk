;AHK for StarCraft2


slot_x := 1120 + 6
slot_y := 720 + 12
slot_w := 6
slot_h := 4
slot_space_x := 50
slot_space_y := -50
pixelColor := 0xFFFFFF
slotColor := [] ; 2D
setColor := []
setCount := 0
displayIndex := 0
coord := []
SetTimer, initProfile_0, -1

if not A_IsAdmin
{
   Run *RunAs "%A_ScriptFullPath%"
}
#SingleInstance force
#MaxHotkeysPerInterval 200

!`::reload

#IfWinActive, StarCraft II

; disable hotkeys
LWin::return
!F4::return
^Esc::return

; ------ set up lobby
$\::
clickCoord:=[[516,153],[516,220],[594,151],[593,204],[1108,82],[360,240],[360,380],[440,240]]
while ( A_Index <= clickCoord.length() ) {
    if ( GetKeyState("ESC","P") )
        break
    tempX := clickCoord[A_Index,1]
    tempY := clickCoord[A_Index,2]
    click, %tempX%, %tempY%, 1
    sleep, 250
}
return

; $\::
; get coordinates
MouseGetPos, mouseX, mouseY
coord.push({x:mouseX,y:mouseY})
return
; $]::
; display coordinates
if ( coord.length() < 1 ) {
    return
}
txt := ""
while ( A_Index <= coord.length() ) {
    txt := % txt coord[A_Index].x . "," . coord[A_Index].y . "`n"
}
MsgBox, %txt%
return


;abilities
;start pos 1115, 719
;end pos 1213, 717
; x = 1120 (+50)
; y = 720
; w = h = 12

getColor(px=0,py=0) {
    global pixelColor
    PixelGetColor, pixelColor, %px% , %py% , RGB
}
scanSlot(sx=0,sy=0) {
    ; sx,sy is the position of the ability (0-3),(0)
    global pixelColor, slotColor
    global slot_x, slot_y, slot_w, slot_h
    global slot_space_x, slot_space_y
    px := slot_x + slot_space_x * sx
    py := slot_y + slot_space_y * sy
    ; use the mouse coord
    ; MouseGetPos, mouseX, mouseY
    ; px := mouseX
    ; py := mouseY
    ; nx := mouseX + slot_w + 6
    ; ny := mouseY + slot_h + 6
    ; click, %nx%, %ny%, 0
    while ( A_Index <= slot_w, x := A_Index - 1 ) {
    while ( A_Index <= slot_h, y := A_Index - 1 ) {
        getColor(px + x, py + y)
        slotColor[x,y] := pixelColor
    }}
}
addNewSet(sx=0,sy=0) {
    ; sx, sy is the position of the ability (0-3), (0)
    global pixelColor, slotColor, setColor, setCount
    global slot_x, slot_y, slot_w, slot_h
    global slot_space_x, slot_space_y
    scanSlot(sx,sy)
    while ( A_Index <= slot_w, x := A_Index - 1 ) {
    while ( A_Index <= slot_h, y := A_Index - 1 ) {
        setColor[setCount,x,y] := slotColor[x,y]
        ; setColor.push( slotColor[x,y] )
    }}
    setCount++
}

; MAIN SCAN
; $\::
sleep, 250
; create setColor profile
setColor := []
setCount := 0
while ( A_Index <= 24, i := A_Index - 1 ) {
    addNewSet(0,0)
    sleep, 20
    send, {Tab}
    sleep, 30
    ; compare last set with first set
    firstAgain := true
    while ( A_Index <= slot_w, x := A_Index - 1 ) {
        if ( i = 0 ) {
            firstAgain := false
            break
        }
    while ( A_Index <= slot_h, y := A_Index - 1 ) {
        if ( setColor[i,x,y] != setColor[0,x,y] ) {
            if ( i = 19 ) {
                tempColorA := setColor[0,x,y]
                tempColorB := setColor[i,x,y]
                MsgBox, [%x%,%y%] %tempColorA% %tempColorB%
            }
            firstAgain := false
            break
        }
    }
        if ( firstAgain = false ) {
            break
        }
    }
    if ( firstAgain = true ) {
        setColor.Pop()
        setCount--
        send, +{Tab}
        break
    }
}
if ( setCount != setColor.length() ) {
    len := setColor.length()
    MsgBox, pop not working? %setCount%!=%len%
}
; MsgBox, %setCount%
; process setColor to find the most useful pixel
finalPixelFound := false
fpx := -1
fpy := -1
txt := ""
while ( A_Index <= slot_w, x := A_Index - 1 ) {
while ( A_Index <= slot_h, y := A_Index - 1 ) {
    ; mirror to an array
    ; + look for identical pixel
    currentPixelSet := []
    identicalPixelFound := false
    while ( A_Index <= setCount, i := A_Index - 1 ) {
        currentPixelSet[i] := setColor[i,x,y]
        while ( A_Index <= i, j := A_Index - 1 ) {
            if ( currentPixelSet[i] == currentPixelSet[j] ) {
                identicalPixelFound := true
                cA := currentPixelSet[i]
                cB := currentPixelSet[j]
                txt = %txt%%i%=%j% %cA%=%cB%`n
                break
            }
        }
        if ( identicalPixelFound == true ) {
            break
        }
    }
    if ( identicalPixelFound == false ) {
        ; NO identical pixel found
        ; this pixel is usable
        finalPixelFound := true
        fpx := x
        fpy := y
        break
    }
}}
MsgBox, [%setCount%] %finalPixelFound% %fpx% %fpy%`n%txt%
return


; $]::
; [18] 1 5 0
; x = 1125, y = 720
Sleep, 120
finalPixelProfile := []
finalPixelProfileCount := 0
txt := ""
while ( A_Index <= 24, i := A_Index - 1 ) {
    getColor(1125,720)
    finalPixelProfile[i] := pixelColor
    Sleep, 20
    Send, {Tab}
    Sleep, 30
    if ( i > 0 ) {
    if ( finalPixelProfile[i] = finalPixelProfile[0] ) {
        ; same as first
        finalPixelProfile.Pop()
        Send, +{Tab}
        break
    }}
    txt = %txt%`n%pixelColor%
    finalPixelProfileCount++
}
MsgBox, [%finalPixelProfileCount%]%txt%
return

; $[::
initProfile_0:
; [18]
; MS HT STR ORC PN VR DR
; WP STK AD DT CR (TP) CLS
; [(ARC)]
; IMT ZL OBS
; [PR]
profile_0_1125_720 := []
profile_0_1125_720.Push(0x4B3E00,0x0056A3,0x2D799D,0xACF8FD,0x0B32D0,0x98F0FD)
profile_0_1125_720.Push(0xFB9209,0x9A9578,0x51C0DA,0x1D84DA,0x1382D2,0x494949)
profile_0_1125_720.Push(0x020202,0xCAAC54,0x2C4C7A,0x2669AC,0x27241D,0x182B53)
profile_0_name := []
profile_0_name.Push("MS", "HT", "STR", "ORC", "PN", "VR", "DR")
profile_0_name.Push("WP", "STK", "AD", "DT", "CR", "TP/ARC", "CLS")
profile_0_name.Push("IMT", "ZL", "OBS", "PR")
profile_0_x := 1125
profile_0_y := 720
txt := ""
while (true) {
    if ( A_Index > profile_0_1125_720.length() ) {
        break
    }
    if ( A_Index > profile_0_name.length() ) {
        break
    }
    currentColor := profile_0_1125_720[A_Index]
    currentName := profile_0_name[A_Index]
    txt = %txt%`n%currentName% - %currentColor%
}
return
MsgBox, working?
MsgBox, % profile_0_name.length() " - " profile_0_1125_720.length() txt
return

; NumpadSub::
Select_Sub_Sentry:
SelectSubGroup(3,0,true)
return
; select sentry sub-group
SelectSubGroup(index:=3,autoCast:=-1,returnToFirst:=false) {
    global profile_0_1125_720, profile_0_x, profile_0_y
    subIndex := 0
    subFound := false
    while ( A_Index <= 12, i := A_Index - 1 ) {
        subIndex := i
        PixelGetColor, pixelColor, %profile_0_x% , %profile_0_y% , RGB
        if ( profile_0_1125_720[index] = pixelColor ) {
            subFound := true
            break
        }
        if ( i = -2 ) {
            ; debugging
            proColor := profile_0_1125_720[index]
            MsgBox, found: %pixelColor%`nprofile: %proColor%
            break
        }
        send, {Tab}
        sleep, 32
    }
    ; do something here
    ; quick-cast Q
    if ( subFound = true ) {
    if ( autoCast >= 0 ) {
        Send, {q}
        Click, 1
    }}
    if ( returnToFirst = true ) {
    while ( A_Index <= subIndex ) {
        send, +{Tab}
    }}
    return
}

; NumpadAdd::
while ( A_Index <= 10 ) {
    Send, {Tab %A_Index%}
    SetTimer, Select_Sub_Sentry, -1
    Sleep, 3200
}
return

; ^Space::
; display next set
; SplashTextOn, 600, 120, SplashWindow,
; WinMove, SplashWindow, , 0, 30
txtPiece := "000000"
txt := ""
txtSpace := "_"
scanSlot(0)
; create simplified table
; & turn scanSet to codeSet
codeTable := []
codeCount := 0
codeSet := []
while ( A_Index <= slot_h, y := A_Index - 1 ) {
    if ( y > 0 ) {
        txt = %txt%`n
    }
while ( A_Index <= slot_w, x := A_Index - 1 ) {
    codeIndex := codeCount
    while ( A_Index <= codeCount, i := A_Index - 1 ) {
        if ( codeTable[i] == slotColor[x,y] ) {
            codeIndex := i
            break
        }
    }
    codeTable[codeIndex] := slotColor[x,y]
    if ( codeIndex >= codeCount ) {
        codeCount++
    }
    codeSet[x,y] := codeIndex
    if ( slotColor[x,y] == 0x1E1E1E ) {
        txt = %txt%-
    } else {
        txt = %txt%O
    }
    continue
    if ( x > 0 ) 
        txt = %txt%%txtSpace%
    if ( codeIndex < 10 )
        txt = %txt%%0%
    txt = %txt%%codeIndex%
}}
Progress, fm8 b w240 h180 x0 y30 cb00CCFF ct4488FF cw505050,, %txt%,,Source Code Pro
MsgBox, %codeCount%
txt := ""
while ( A_Index <= slot_h, y := A_Index - 1 ) {
    if ( y > 0 ) {
        txt = %txt%`n
    }
    while ( A_Index <= slot_w, x := A_Index - 1 ) {
        ; getColor(slot_x+slot_space_x*sx+x, slot_y+slot_space_y*sy+y)
        ; slotColor[x,y] := pixelColor
        if ( x > 0 ) {
            txt = %txt%%txtSpace%
        }
        txtPiece := SubStr(slotColor[x,y], 3)
        ; txt = %txt%%pixelColor%
        txt = %txt%%txtPiece%
    }
}
; ControlSetText, Static1, %txt%, SplashWindow
; Progress,,, %txt%
displayIndex++
displayIndex := Mod(displayIndex, setCount)
return
; +Space::Progress, OFF

; NumpadAdd::
MouseGetPos, mouseX, mouseY
nx := mouseX + 12
ny := mouseY + 12
Click, %nx%, %ny%, 0
Sleep, 10
PixelGetColor, tempColor, %mouseX%, %mouseY%, Slow
Click, %mouseX%, %mouseY%, 0
if ( tempColor == 0x000000 ) {
    MsgBox, something's wrong with this`n%tempColor%
} else {
    MsgBox, it's working fine?`n%tempColor%
}
return
; XButton1:: ; mouse back
return
; XButton2:: ; mouse forward
return
#If
