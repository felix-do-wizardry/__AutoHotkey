


ProAdd := 0x0000
SetFormat, IntegerFast, d
ProAdd += 0
ProAdd .= ""

MemAdd := 0x
;--------------------------------------------------------------------------------------------------
value:=ReadMemory(%MemAdd%)


ReadMemory(MADDRESS)
{

VarSetCapacity(MVALUE,4,0)
ProcessHandle := DllCall("OpenProcess", "Int", 24, "Char", 0, "UInt", %ProAdd%, "UInt")
DllCall("ReadProcessMemory","UInt",ProcessHandle,"UInt",MADDRESS,"Str",MVALUE,"UInt",4,"UInt *",0)

Loop 4
result += *(&MVALUE + A_Index-1) << 8*(A_Index-1)

return, result 
}