^`::suspend
--------------------------------------------------------------------------------------------------------

;Visual Studio CODING:

^1::     ;FOR - i
send {;} i < {space}
send {home}for (i = 
send {end}{;} i{+}{+}){{}

return

^+1::    ;FOR - int i
send {;} i < {space}
send {home}for (int i = 
send {end}{;} i{+}{+}){{}

return

--------------------------------------------------------------------------------------------------------
^2::     ;FOR - Custom					//Using Clipboard
send ^c
send {=}^v{;}
send {home}for (
send ^+{right}^c
send {end}^{left}^v{<}{space}
send {end}{;}^v{+}{+}){{}

return

^+2::     ;FOR - Custom INT				//Using Clipboard
send ^c
send {=}^v{;}
send {home}for (int{space}
send ^+{right}^c
send {end}^{left}^v{<}{space}
send {end}{;}^v{+}{+}){{}

return

--------------------------------------------------------------------------------------------------------
^3::     ;PRINTF
send ){;}
send {home}printf("
send {end}{left 2}"
send {left 1}

return

^+3::     ;PRINTF - With Number
send ",{space}{end}){;}
send {home}printf("`%
send {left 1}

return

--------------------------------------------------------------------------------------------------------
^4::     ;SWITCH						//Using Clipboard
send +{end}^x
send {home}switch(
send {end}){{}{Enter 2}
send default:{;}{up}
send case ^v: {;} break{;}{left 8}{space}

return

--------------------------------------------------------------------------------------------------------


--------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------